'use strict'

const { compile: bracesToGroup } = require('braces')
const { createHash } = require('crypto')
const expandPath = require('@antora/expand-path-helper')
const { File, MemoryFile, ReadableFile } = require('./file')
const { promises: fsp } = require('fs')
const { concat: get } = require('simple-get')
const getCacheDir = require('cache-directory')
const globStream = require('glob-stream')
const ospath = require('path')
const { posix: path } = ospath
const picomatch = require('picomatch')
const posixify = ospath.sep === '\\' ? (p) => p.replace(/\\/g, '/') : undefined
const { pipeline, Transform, Writable } = require('stream')
const forEach = (write, final) => new Writable({ objectMode: true, write, final })
const map = (transform) => new Transform({ objectMode: true, transform })
const UiCatalog = require('./ui-catalog')
const yaml = require('js-yaml')
const vzip = require('gulp-vinyl-zip')

const STATIC_FILE_MATCHER_OPTS = {
  expandRange: (begin, end, step, opts) => bracesToGroup(opts ? `{${begin}..${end}..${step}}` : `{${begin}..${end}}`),
  fastpaths: false,
  nobracket: true,
  noquantifiers: true,
  regex: false,
  strictSlashes: true,
}
const { UI_CACHE_FOLDER, UI_DESC_FILENAME, UI_SRC_GLOB, UI_SRC_OPTS } = require('./constants')
const URI_SCHEME_RX = /^https?:\/\//
const EXT_RX = /\.[a-z]{2,3}$/

/**
 * Loads the files in the specified UI bundle (zip archive) into a UiCatalog,
 * first downloading the bundle if necessary.
 *
 * Looks for UI bundle at the path specified in the ui.bundle.url property of
 * the playbook. If the path is a URI, it downloads the file and caches it at a
 * unique path to avoid this step in future calls. It then reads all the files
 * from the bundle into memory, skipping any files that fall outside of the
 * start path specified in the ui.startPath property of the playbook. Finally,
 * it classifies the files and adds them to a UiCatalog, which is then
 * returned.
 *
 * @memberof ui-loader
 * @param {Object} playbook - The configuration object for Antora.
 * @param {Object} playbook.dir - The working directory of the playbook.
 * @param {Object} playbook.runtime - The runtime configuration object for Antora.
 * @param {String} [playbook.runtime.cacheDir=undefined] - The base cache directory.
 * @param {Boolean} [playbook.runtime.fetch=false] - Forces the bundle to be
 * retrieved if configured as a snapshot.
 * @param {Object} playbook.network - The network configuration object for Antora.
 * @param {String} [playbook.network.httpProxy=undefined] - The URL of the proxy to use for HTTP URLs.
 * @param {String} [playbook.network.httpsProxy=undefined] - The URL of the proxy to use for HTTPS URLs.
 * @param {String} [playbook.network.noProxy=undefined] - The list of domains and IPs that should not be proxied.
 * @param {Object} playbook.ui - The UI configuration object for Antora.
 * @param {String} playbook.ui.bundle - The UI bundle configuration.
 * @param {String} playbook.ui.bundle.url - The path (relative or absolute) or URL
 * of the UI bundle to use.
 * @param {String} [playbook.ui.bundle.startPath=''] - The path inside the bundle from
 * which to start reading files.
 * @param {Boolean} [playbook.ui.bundle.snapshot=false] - Whether to treat the
 * bundle URL as a snapshot (i.e., retrieve again if playbook.runtime.fetch is
 * true).
 * @param {Array} [playbook.ui.supplementalFiles=undefined] - An array of
 * additional files to overlay onto the files from the UI bundle.
 * @param {String} [playbook.ui.outputDir='_'] - The path relative to the site root
 * where the UI files should be published.
 *
 * @returns {UiCatalog} A catalog of UI files which were read from the bundle.
 */
async function loadUi (playbook) {
  const startDir = playbook.dir || '.'
  const { bundle, supplementalFiles: supplementalFilesSpec, outputDir } = playbook.ui
  const bundleUrl = bundle.url
  let resolveBundle
  if (isUrl(bundleUrl)) {
    const { cacheDir, fetch } = playbook.runtime || {}
    resolveBundle = ensureCacheDir(cacheDir, startDir).then((absCacheDir) => {
      const cachePath = ospath.join(absCacheDir, `${sha1(bundleUrl)}.zip`)
      return fetch && bundle.snapshot
        ? downloadBundle(bundleUrl, cachePath, createAgent(bundleUrl, playbook.network || {}))
        : fsp.stat(cachePath).then(
          (stat) => new File({ path: cachePath, stat }),
          () => downloadBundle(bundleUrl, cachePath, createAgent(bundleUrl, playbook.network || {}))
        )
    })
  } else {
    const localPath = expandPath(bundleUrl, { dot: startDir })
    resolveBundle = fsp.stat(localPath).then(
      (stat) => new File({ path: localPath, stat }),
      () => {
        throw new Error(
          `Specified UI ${path.extname(localPath) ? 'bundle' : 'directory'} does not exist: ` +
            (bundleUrl === localPath ? bundleUrl : `${localPath} (resolved from url: ${bundleUrl})`)
        )
      }
    )
  }
  const files = await Promise.all([
    resolveBundle.then((bundleFile) =>
      new Promise((resolve, reject) =>
        bundleFile.isDirectory()
          ? srcFs(ospath.join(bundleFile.path, bundle.startPath || '', '.')).then(resolve, reject)
          : vzip
            .src(bundleFile.path)
            .on('error', (err) => reject(Object.assign(err, { message: `not a valid zip file; ${err.message}` })))
            .pipe(selectFilesStartingFrom(bundle.startPath))
            .pipe(bufferizeContents())
            .on('error', reject)
            .pipe(collectFiles(resolve))
      ).catch((err) => {
        const errWrapper = new Error(
          `Failed to read UI ${bundleFile.isDirectory() ? 'directory' : 'bundle'}: ` +
            (bundleUrl === bundleFile.path ? bundleUrl : `${bundleFile.path} (resolved from url: ${bundleUrl})`)
        )
        errWrapper.stack += `\nCaused by: ${err.stack || 'unknown'}`
        throw errWrapper
      })
    ),
    srcSupplementalFiles(supplementalFilesSpec, startDir),
  ]).then(([bundleFiles, supplementalFiles]) => mergeFiles(bundleFiles, supplementalFiles))
  const config = loadConfig(files, outputDir)
  const catalog = new UiCatalog()
  files.forEach((file) => classifyFile(file, config) && catalog.addFile(file))
  return catalog
}

function isUrl (string) {
  return ~string.indexOf('://') && URI_SCHEME_RX.test(string)
}

function sha1 (string) {
  const shasum = createHash('sha1')
  shasum.update(string)
  return shasum.digest('hex')
}

/**
 * Resolves the content cache directory and ensures it exists.
 *
 * @param {String} customCacheDir - The custom base cache directory. If the value is undefined,
 *   the user's cache folder is used.
 * @param {String} startDir - The directory from which to resolve a leading '.' segment.
 *
 * @returns {Promise<String>} A promise that resolves to the absolute ui cache directory.
 */
function ensureCacheDir (customCacheDir, startDir) {
  // QUESTION should fallback directory be relative to cwd, playbook dir, or tmpdir?
  const baseCacheDir =
    customCacheDir == null
      ? getCacheDir('antora' + (process.env.NODE_ENV === 'test' ? '-test' : '')) || ospath.resolve('.antora/cache')
      : expandPath(customCacheDir, { dot: startDir })
  const cacheDir = ospath.join(baseCacheDir, UI_CACHE_FOLDER)
  return fsp.mkdir(cacheDir, { recursive: true }).then(
    () => cacheDir,
    (err) => {
      throw Object.assign(err, { message: `Failed to create UI cache directory: ${cacheDir}; ${err.message}` })
    }
  )
}

function createAgent (url, { httpProxy, httpsProxy, noProxy }) {
  if ((httpsProxy || httpProxy) && noProxy !== '*') {
    const { HttpProxyAgent, HttpsProxyAgent } = require('hpagent')
    const shouldProxy = require('should-proxy')
    const proxy = url.startsWith('https:')
      ? { Agent: HttpsProxyAgent, url: httpsProxy }
      : { Agent: HttpProxyAgent, url: httpProxy }
    if (proxy.url && shouldProxy(url, { no_proxy: noProxy })) return new proxy.Agent({ proxy: proxy.url })
  }
}

function downloadBundle (url, to, agent) {
  return new Promise((resolve, reject) => {
    get({ url, agent }, (err, response, contents) => {
      if (err) reject(err)
      if (response.statusCode !== 200) {
        const message = `Response code ${response.statusCode} (${response.statusMessage})`
        return reject(Object.assign(new Error(message), { name: 'HTTPError' }))
      }
      new ReadableFile(new MemoryFile({ path: ospath.basename(to), contents }))
        .pipe(vzip.src())
        .on('error', (err) =>
          reject(Object.assign(err, { message: `not a valid zip file; ${err.message}`, summary: 'Invalid UI bundle' }))
        )
        .on('finish', () =>
          fsp
            .mkdir(ospath.dirname(to), { recursive: true })
            .then(() => fsp.writeFile(to, contents))
            .then(() => resolve(new File({ path: to, stat: { isDirectory: () => false } })))
        )
    })
  }).catch((err) => {
    const errWrapper = new Error(`${err.summary || 'Failed to download UI bundle'}: ${url}`)
    errWrapper.stack += `\nCaused by: ${err.stack || 'unknown'}`
    throw errWrapper
  })
}

function selectFilesStartingFrom (startPath) {
  if (!startPath || (startPath = path.join('/', startPath + '/')) === '/') {
    return map((file, _, next) => {
      if (file.isNull()) {
        next()
      } else {
        next(
          null,
          new File({ path: posixify ? posixify(file.path) : file.path, contents: file.contents, stat: file.stat })
        )
      }
    })
  } else {
    startPath = startPath.substr(1)
    const startPathOffset = startPath.length
    return map((file, _, next) => {
      if (file.isNull()) {
        next()
      } else {
        const path_ = posixify ? posixify(file.path) : file.path
        if (path_.length > startPathOffset && path_.startsWith(startPath)) {
          next(null, new File({ path: path_.substr(startPathOffset), contents: file.contents, stat: file.stat }))
        } else {
          next()
        }
      }
    })
  }
}

function bufferizeContents () {
  return map((file, _, next) => {
    // NOTE gulp-vinyl-zip automatically converts the contents of an empty file to a Buffer
    if (file.isStream()) {
      const buffer = []
      pipeline(
        file.contents,
        forEach((chunk, _, done) => buffer.push(chunk) && done()),
        (err) => (err ? next(err) : next(null, Object.assign(file, { contents: Buffer.concat(buffer) })))
      )
    } else {
      next(null, file)
    }
  })
}

function collectFiles (resolve, files = new Map()) {
  return forEach(
    (file, _, done) => {
      files.set(file.path, file)
      done()
    },
    (done) => done() || resolve(files)
  )
}

function srcSupplementalFiles (filesSpec, startDir) {
  if (!filesSpec) return new Map()
  let cwd
  return (
    Array.isArray(filesSpec)
      ? Promise.all(
        filesSpec.reduce((accum, { path: path_, contents: contents_ }) => {
          if (!path_) {
            return accum
          } else if (contents_) {
            if (~contents_.indexOf('\n') || !EXT_RX.test(contents_)) {
              accum.push(new MemoryFile({ path: path_, contents: Buffer.from(contents_) }))
            } else {
              contents_ = expandPath(contents_, { dot: startDir })
              accum.push(
                fsp
                  .stat(contents_)
                  .then((stat) =>
                    fsp.readFile(contents_).then((contents) => new File({ path: path_, contents, stat }))
                  )
              )
            }
          } else {
            accum.push(new MemoryFile({ path: path_ }))
          }
          return accum
        }, [])
      ).then((files) => files.reduce((accum, file) => accum.set(file.path, file) && accum, new Map()))
      : fsp.access((cwd = expandPath(filesSpec, { dot: startDir }))).then(() => srcFs(cwd))
  ).catch((err) => {
    const dir = cwd ? filesSpec + (filesSpec === cwd ? '' : ` (resolved to ${cwd})`) : undefined
    if (err.code === 'ENOENT' && err.path === cwd) {
      throw new Error(`Specified ui.supplemental_files directory does not exist: ${dir}`)
    } else {
      const errWrapper = new Error(`Failed to read ui.supplemental_files ${cwd ? `directory: ${dir}` : 'entry'}`)
      errWrapper.stack += `\nCaused by: ${err.stack || 'unknown'}`
      throw errWrapper
    }
  })
}

function mergeFiles (files, supplementalFiles) {
  if (supplementalFiles.size) supplementalFiles.forEach((file) => files.set(file.path, file))
  return files
}

function loadConfig (files, outputDir) {
  const configFile = files.get(UI_DESC_FILENAME)
  if (configFile) {
    files.delete(UI_DESC_FILENAME)
    const config = camelCaseKeys(yaml.load(configFile.contents.toString()))
    const staticFiles = config.staticFiles
    if (staticFiles && staticFiles.length) config.isStaticFile = picomatch(staticFiles, STATIC_FILE_MATCHER_OPTS)
    if (outputDir !== undefined) config.outputDir = outputDir
    return config
  } else {
    return { outputDir }
  }
}

function camelCaseKeys (o) {
  if (Array.isArray(o)) return o.map(camelCaseKeys)
  if (o == null || o.constructor !== Object) return o
  const accum = {}
  for (const [k, v] of Object.entries(o)) {
    accum[k.toLowerCase().replace(/[_-]([a-z0-9])/g, (_, l, idx) => (idx ? l.toUpperCase() : l))] = camelCaseKeys(v)
  }
  return accum
}

function classifyFile (file, config) {
  if (config.isStaticFile && config.isStaticFile(file.path)) {
    file.type = 'static'
    file.out = resolveOut(file, '')
  } else if (file.isDot()) {
    file = undefined
  } else if ((file.type = resolveType(file)) === 'asset') {
    file.out = resolveOut(file, config.outputDir)
  }
  return file
}

function resolveType (file) {
  const firstPathSegment = file.path.split('/', 1)[0]
  if (firstPathSegment === 'layouts') return 'layout'
  if (firstPathSegment === 'helpers') return 'helper'
  if (firstPathSegment === 'partials') return 'partial'
  return 'asset'
}

function resolveOut (file, outputDir = '_') {
  let dirname = path.join(outputDir, file.dirname)
  if (dirname.charAt() === '/') dirname = dirname.substr(1)
  const basename = file.basename
  return { dirname, basename, path: path.join(dirname, basename) }
}

function srcFs (cwd) {
  return new Promise((resolve, reject, cache = Object.create(null), files = new Map(), relpathStart = cwd.length + 1) =>
    pipeline(
      globStream(UI_SRC_GLOB, Object.assign({ cache, cwd }, UI_SRC_OPTS)),
      forEach(({ path: abspathPosix }, _, done) => {
        if ((cache[abspathPosix] || {}).constructor === Array) return done() // detects some directories
        const abspath = posixify ? ospath.normalize(abspathPosix) : abspathPosix
        const relpath = abspath.substr(relpathStart)
        symlinkAwareStat(abspath).then(
          (stat) => {
            if (stat.isDirectory()) return done() // detects directories that slipped through cache check
            const relpathPosix = posixify ? posixify(relpath) : relpath
            fsp.readFile(abspath).then(
              (contents) => {
                files.set(relpathPosix, new File({ cwd, path: relpathPosix, contents, stat, local: true }))
                done()
              },
              (readErr) => {
                done(Object.assign(readErr, { message: readErr.message.replace(`'${abspath}'`, relpath) }))
              }
            )
          },
          (statErr) => {
            done(
              Object.assign(statErr, {
                message: statErr.symlink
                  ? (statErr.code === 'ELOOP' ? 'ELOOP: symbolic link cycle, ' : 'ENOENT: broken symbolic link, ') +
                    `${relpath} -> ${statErr.symlink}`
                  : statErr.message.replace(`'${abspath}'`, relpath),
              })
            )
          }
        )
      }),
      (err) => (err ? reject(err) : resolve(files))
    )
  )
}

function symlinkAwareStat (path_) {
  return fsp.lstat(path_).then((lstat) => {
    if (!lstat.isSymbolicLink()) return lstat
    return fsp.stat(path_).catch((statErr) =>
      fsp
        .readlink(path_)
        .catch(() => undefined)
        .then((symlink) => {
          throw Object.assign(statErr, { symlink })
        })
    )
  })
}

module.exports = loadUi
