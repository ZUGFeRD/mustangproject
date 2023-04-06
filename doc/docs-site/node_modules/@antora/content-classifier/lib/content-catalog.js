'use strict'

const File = require('./file')
const invariably = { void: () => undefined }
const logger = require('./logger')
const { lookup: resolveMimeType } = require('./mime-types-with-asciidoc')
const parseResourceId = require('./util/parse-resource-id')
const { posix: path } = require('path')
const resolveResource = require('./util/resolve-resource')
const versionCompare = require('./util/version-compare-desc')

const { ROOT_INDEX_ALIAS_ID, ROOT_INDEX_PAGE_ID } = require('./constants')
const SPACE_RX = / /g
const LOG_WRAP = '\n    '

const $components = Symbol('components')
const $files = Symbol('files')

class ContentCatalog {
  constructor (playbook = {}) {
    this[$components] = new Map()
    this[$files] = new Map()
    const urls = playbook.urls || {}
    this.htmlUrlExtensionStyle = urls.htmlExtensionStyle || 'default'
    this.urlRedirectFacility = urls.redirectFacility || 'static'
    this.latestVersionUrlSegment = urls.latestVersionSegment
    this.latestPrereleaseVersionUrlSegment = urls.latestPrereleaseVersionSegment
    if (this.latestVersionUrlSegment == null && this.latestPrereleaseVersionUrlSegment == null) {
      this.latestVersionUrlSegmentStrategy = undefined
    } else {
      this.latestVersionUrlSegmentStrategy = urls.latestVersionSegmentStrategy || 'replace'
      if (this.latestVersionUrlSegmentStrategy === 'redirect:from') {
        if (!this.latestVersionUrlSegment) this.latestVersionUrlSegment = undefined
        if (!this.latestPrereleaseVersionUrlSegment) {
          this.latestPrereleaseVersionUrlSegment = undefined
          if (!this.latestVersionUrlSegment) this.latestVersionUrlSegmentStrategy = undefined
        }
      }
    }
  }

  /**
   * Registers a new component version with the content catalog. Also registers the component if it does not yet exist.
   *
   * @param {String} name - The name of the component to which this component version belongs.
   * @param {String} version - The version of the component to register.
   * @param {Object} [descriptor={}] - The configuration data for the component version.
   * @param {Object} [descriptor.asciidoc=undefined] - The AsciiDoc configuration for this component version.
   * @param {String} [descriptor.displayVersion=version] - The display version for this component version.
   * @param {Boolean|String} [descriptor.prerelease=undefined] - The prerelease flag for this version. If the value
   * is a String, it implies true and is appended to the display version, separated if necessary by a space.
   * @param {Boolean|String} [descriptor.startPage=undefined] - The page specifier for the start page. The start page
   * is only registered if this property is truthy. A String value will be used to resolve a start page within this
   * component version. A true value is a special case to tell this method to register the default start page and is
   * intended for testing.
   * @param {String} [descriptor.title=name] - The title for this component version.
   *
   * @returns {Object} The constructed component version object.
   */
  registerComponentVersion (name, version, descriptor = {}) {
    const { asciidoc, displayVersion, prerelease, startPage: startPageSpec, title } = descriptor
    const componentVersion = { displayVersion: displayVersion || version || 'default', title: title || name, version }
    Object.defineProperty(componentVersion, 'name', { value: name, enumerable: true })
    if (prerelease) {
      componentVersion.prerelease = prerelease
      if (!displayVersion && prerelease.constructor === String) {
        if (version) {
          const ch0 = prerelease.charAt()
          componentVersion.displayVersion = `${version}${ch0 === '-' || ch0 === '.' ? '' : ' '}${prerelease}`
        } else {
          componentVersion.displayVersion = prerelease
        }
      }
    }
    if (asciidoc) componentVersion.asciidoc = asciidoc
    const component = this[$components].get(name)
    if (component) {
      const componentVersions = component.versions
      if (componentVersions.find(({ version: candidate }) => candidate === version)) {
        throw new Error(`Duplicate version detected for component ${name}: ${version}`)
      }
      let lastVerdict
      const insertIdx = version
        ? componentVersions.findIndex(({ version: candidateVersion, prerelease: candidatePrerelease }) => {
          return (lastVerdict = versionCompare(candidateVersion, version)) > 1
            ? !!prerelease === !!candidatePrerelease
            : lastVerdict > 0 || (lastVerdict < -1 && prerelease && !candidatePrerelease)
        })
        : prerelease
          ? -1
          : ~(~componentVersions.findIndex(({ prerelease: candidatePrerelease }) => !candidatePrerelease) || -1)
      if (~insertIdx) {
        componentVersions.splice(insertIdx, 0, componentVersion)
      } else if (lastVerdict === -1 || !prerelease) {
        componentVersions.push(componentVersion)
      } else {
        componentVersions.unshift(componentVersion)
      }
      if ((component.latest = componentVersions.find((candidate) => !candidate.prerelease))) {
        if (componentVersions[0] !== component.latest) component.latestPrerelease = componentVersions[0]
      } else {
        component.latest = componentVersions[0]
      }
    } else {
      this[$components].set(
        name,
        Object.defineProperties(
          { name, latest: componentVersion, versions: [componentVersion] },
          {
            asciidoc: {
              get () {
                return this.latest.asciidoc
              },
            },
            title: {
              get () {
                return this.latest.title
              },
            },
            url: {
              get () {
                return this.latest.url
              },
            },
          }
        )
      )
    }
    if (startPageSpec) {
      this.registerComponentVersionStartPage(name, componentVersion, startPageSpec === true ? undefined : startPageSpec)
    }
    return componentVersion
  }

  addFile (file) {
    const src = file.src
    let family = src.family
    let filesForFamily = this[$files].get(family)
    if (!filesForFamily) this[$files].set(family, (filesForFamily = new Map()))
    const key = generateKey(src)
    if (filesForFamily.has(key)) {
      if (family === 'alias') {
        throw new Error(`Duplicate alias: ${generateResourceSpec(src)}`)
      } else {
        const details = [filesForFamily.get(key), file]
          .map((it, idx) => `${idx + 1}: ${getFileLocation(it)}`)
          .join(LOG_WRAP)
        if (family === 'nav') {
          throw new Error(`Duplicate nav in ${src.version}@${src.component}: ${file.path}${LOG_WRAP}${details}`)
        } else {
          throw new Error(`Duplicate ${family}: ${generateResourceSpec(src)}${LOG_WRAP}${details}`)
        }
      }
    }
    // NOTE: if the path property is not set, assume the src likely needs to be prepared
    // another option is to assume that if the file is not a vinyl object, the src likely needs to be prepared
    // a vinyl object is one indication the file was created and prepared by the content aggregator
    //if (!src.path) prepareSrc(src)
    //if (!File.isVinyl(file)) file = new File(file)
    if (!File.isVinyl(file)) {
      prepareSrc(src)
      file = new File(file)
    }
    if (family === 'alias') {
      src.mediaType = 'text/asciidoc'
      file.mediaType = 'text/html'
      // NOTE: an alias masquerades as the target file
      family = file.rel.src.family
      // QUESTION: should we preserve the mediaType property on file if already defined?
    } else if (!(file.mediaType = src.mediaType) && !('mediaType' in src)) {
      file.mediaType = src.mediaType = resolveMimeType(src.extname) || (family === 'page' ? 'text/asciidoc' : undefined)
    }
    let publishable
    let versionSegment
    if (file.out) {
      publishable = true
    } else if ('out' in file) {
      delete file.out
    } else if (
      (family === 'page' || family === 'image' || family === 'attachment') &&
      ('/' + src.relative).indexOf('/_') < 0
    ) {
      publishable = true
      versionSegment = computeVersionSegment.call(this, src.component, src.version)
      file.out = computeOut(src, family, versionSegment, this.htmlUrlExtensionStyle)
    }
    if (!file.pub && (publishable || family === 'nav')) {
      if (versionSegment == null) versionSegment = computeVersionSegment.call(this, src.component, src.version)
      file.pub = computePub(src, file.out, family, versionSegment, this.htmlUrlExtensionStyle)
    }
    filesForFamily.set(key, file)
    return file
  }

  removeFile (file) {
    const src = file.src
    const filesForFamily = this[$files].get(src.family)
    return filesForFamily ? filesForFamily.delete(generateKey(src)) : false
  }

  findBy (criteria) {
    const criteriaEntries = Object.entries(criteria)
    const family = criteria.family
    if (criteriaEntries.length === 1 && family) {
      const filesForFamily = this[$files].get(family)
      return filesForFamily ? [...filesForFamily.values()] : []
    }
    const accum = []
    for (const filesForFamily of this[$files].values()) {
      for (const candidate of filesForFamily.values()) {
        const candidateSrc = candidate.src
        if (criteriaEntries.every(([key, val]) => candidateSrc[key] === val)) accum.push(candidate)
      }
    }
    return accum
  }

  getById (id) {
    return (this[$files].get(id.family) || { get: invariably.void }).get(generateKey(id))
  }

  getByPath ({ component, version, path: path_ }) {
    for (const filesForFamily of this[$files].values()) {
      for (const it of filesForFamily.values()) {
        if (it.path === path_ && it.src.component === component && it.src.version === version) return it
      }
    }
  }

  getComponent (name) {
    return this[$components].get(name)
  }

  getComponentVersion (component, version) {
    return (component.versions || (this.getComponent(component) || {}).versions || []).find(
      ({ version: candidate }) => candidate === version
    )
  }

  getComponents () {
    return [...this[$components].values()]
  }

  getComponentsSortedBy (property) {
    return this.getComponents().sort((a, b) => a[property].localeCompare(b[property]))
  }

  getFiles () {
    const accum = []
    for (const filesForFamily of this[$files].values()) {
      for (const file of filesForFamily.values()) accum.push(file)
    }
    return accum
  }

  getPages (filter) {
    const candidates = this[$files].get('page')
    if (!candidates) return []
    if (filter) {
      const accum = []
      for (const candidate of candidates.values()) filter(candidate) && accum.push(candidate)
      return accum
    } else {
      return [...candidates.values()]
    }
  }

  // TODO add `follow` argument to control whether alias is followed
  getSiteStartPage () {
    return this.getById(ROOT_INDEX_PAGE_ID) || (this.getById(ROOT_INDEX_ALIAS_ID) || {}).rel
  }

  registerComponentVersionStartPage (name, componentVersion, startPageSpec = undefined) {
    let version = componentVersion.version
    if (version == null) {
      // QUESTION: should we warn or throw error if component version cannot be found?
      if (!(componentVersion = this.getComponentVersion(name, componentVersion))) return
      version = componentVersion.version
    }
    let startPage
    let startPageSrc
    const indexPageId = Object.assign({}, ROOT_INDEX_PAGE_ID, { component: name, version })
    if (startPageSpec) {
      if (
        (startPage = this.resolvePage(startPageSpec, indexPageId)) &&
        (startPageSrc = startPage.src).component === name &&
        startPageSrc.version === version
      ) {
        if (!this.getById(indexPageId)) {
          const indexAliasId = Object.assign({}, ROOT_INDEX_ALIAS_ID, { component: name, version })
          const indexAlias = this.getById(indexAliasId)
          indexAlias
            ? indexAlias.synthetic && Object.assign(indexAlias, { rel: startPage })
            : this.addFile({ src: indexAliasId, rel: startPage, synthetic: true })
        }
      } else {
        // TODO pass componentVersion as logObject
        logger.warn(
          'Start page specified for %s@%s %s: %s',
          version,
          name,
          startPage === false ? 'has invalid syntax' : 'not found',
          startPageSpec
        )
        startPage = this.getById(indexPageId)
      }
    } else {
      startPage = this.getById(indexPageId)
    }
    if (startPage) {
      componentVersion.url = startPage.pub.url
    } else {
      // QUESTION: should we warn if the default start page cannot be found?
      const versionSegment = computeVersionSegment.call(this, name, version)
      componentVersion.url = computePub(
        (startPageSrc = prepareSrc(Object.assign({}, indexPageId, { family: 'page' }))),
        computeOut(startPageSrc, startPageSrc.family, versionSegment, this.htmlUrlExtensionStyle),
        startPageSrc.family,
        versionSegment,
        this.htmlUrlExtensionStyle
      ).url
    }

    const symbolicVersionAlias = createSymbolicVersionAlias(
      name,
      version,
      computeVersionSegment.call(this, name, version, 'alias'),
      this.latestVersionUrlSegmentStrategy
    )
    if (symbolicVersionAlias) this.addFile(symbolicVersionAlias)
  }

  registerSiteStartPage (startPageSpec) {
    if (!startPageSpec) return
    const rel = this.resolvePage(startPageSpec)
    if (rel) {
      if (this.getById(ROOT_INDEX_PAGE_ID)) return
      const rootIndexAlias = this.getById(ROOT_INDEX_ALIAS_ID)
      if (rootIndexAlias) return rootIndexAlias.synthetic ? Object.assign(rootIndexAlias, { rel }) : undefined
      if (rel.pub.url === (this.htmlUrlExtensionStyle === 'default' ? '/index.html' : '/')) return
      const src = Object.assign({}, ROOT_INDEX_ALIAS_ID)
      return this.addFile({ src, rel, synthetic: true }, { version: src.version })
    } else if (rel === false) {
      logger.warn('Start page specified for site has invalid syntax: %s', startPageSpec)
    } else if (startPageSpec.lastIndexOf(':') > startPageSpec.indexOf(':')) {
      logger.warn('Start page specified for site not found: %s', startPageSpec)
    } else {
      logger.warn('Missing component name in start page for site: %s', startPageSpec)
    }
  }

  // QUESTION should this be addPageAlias?
  registerPageAlias (spec, target) {
    // adding .adoc file extension to page alias if missing is @deprecated; scheduled to be removed in Antora 4
    const inferredSpec = spec.endsWith('.adoc') ? undefined : spec + '.adoc'
    const src = parseResourceId(inferredSpec || spec, target.src, 'page', ['page'])
    // QUESTION should we throw an error if alias is invalid?
    if (!src || (inferredSpec && src.relative === '.adoc')) return
    const component = this.getComponent(src.component)
    if (component) {
      // NOTE version is not set when alias specifies a component, but not a version
      if (src.version == null) src.version = component.latest.version
      const existingPage = this.getById(src)
      if (existingPage) {
        throw new Error(
          existingPage === target
            ? `Page cannot define alias that references itself: ${generateResourceSpec(src)}` +
              ` (specified as: ${spec})${LOG_WRAP}source: ${getFileLocation(existingPage)}`
            : `Page alias cannot reference an existing page: ${generateResourceSpec(src)} (specified as: ${spec})` +
              `${LOG_WRAP}source: ${getFileLocation(target)}` +
              `${LOG_WRAP}existing page: ${getFileLocation(existingPage)}`
        )
      }
    } else if (src.version == null) {
      // QUESTION should we skip registering alias in this case?
      src.version = ''
    }
    src.family = 'alias'
    const existingAlias = this.getById(src)
    if (existingAlias) {
      throw new Error(
        `Duplicate alias: ${generateResourceSpec(src)} (specified as: ${spec})` +
          `${LOG_WRAP}source: ${getFileLocation(target)}`
      )
    }
    // NOTE the redirect producer will populate contents when the redirect facility is 'static'
    const alias = this.addFile({ src, rel: target })
    // NOTE record the first alias this target claims as the preferred one
    if (!target.rel) target.rel = alias
    return alias
  }

  /**
   * Attempts to resolve a string contextual page ID spec to a file in the catalog.
   *
   * Parses the specified contextual page ID spec into a page ID object, then attempts to lookup a
   * file with this page ID in the catalog. If a component is specified, but not a version, the
   * latest version of the component stored in the catalog is used. If a page cannot be resolved,
   * the search is attempted again for an "alias". If neither a page or alias can be resolved, the
   * function returns undefined. If the spec does not match the page ID syntax, this function throws
   * an error.
   *
   * @param {String} spec - The contextual page ID spec (e.g., version@component:module:topic/page.adoc).
   * @param {ContentCatalog} catalog - The content catalog in which to resolve the page file.
   * @param {Object} [ctx={}] - The context to use to qualified the contextual page ID.
   *
   * @returns {File} The virtual file to which the contextual page ID spec refers, or undefined if the
   * file cannot be resolved.
   */
  resolvePage (spec, context = {}) {
    return this.resolveResource(spec, context, 'page', ['page'])
  }

  resolveResource (spec, context = {}, defaultFamily = undefined, permittedFamilies = undefined) {
    return resolveResource(spec, this, context, defaultFamily, permittedFamilies)
  }

  exportToModel () {
    return [
      this.findBy,
      { name: 'getAll', bind: (to) => this.getAll.bind(to) },
      this.getById,
      this.getComponent,
      this.getComponentVersion,
      this.getComponents,
      this.getComponentsSortedBy,
      this.getFiles,
      this.getPages,
      this.getSiteStartPage,
      this.resolvePage,
      this.resolveResource,
    ].reduce((proxy, method) => (proxy[method.name] = method.bind(this)) && proxy, new (class ContentCatalogProxy {})())
  }
}

/**
 * @deprecated superceded by getFiles(); scheduled to be removed in Antora 4
 */
ContentCatalog.prototype.getAll = ContentCatalog.prototype.getFiles

function generateKey ({ component, version, module: module_, relative }) {
  return `${version}@${component}:${module_}:${relative}`
}

function generateResourceSpec ({ component, version, module: module_, family, relative }, shorthand = true) {
  return (
    `${version}@${component}:${shorthand && module_ === 'ROOT' ? '' : module_}:` +
    (family === 'page' || family === 'alias' ? '' : `${family}$`) +
    relative
  )
}

function prepareSrc (src) {
  let { basename, extname, stem } = src
  let update
  if (basename == null) {
    update = true
    basename = path.basename(src.relative)
  }
  if (stem == null) {
    update = true
    if (extname == null) {
      if (~(extname = basename.lastIndexOf('.'))) {
        stem = basename.substr(0, extname)
        extname = basename.substr(extname)
      } else {
        stem = basename
        extname = ''
      }
    } else {
      stem = basename.substr(0, basename.length - extname.length)
    }
  } else if (extname == null) {
    update = true
    extname = basename.substr(stem.length)
  }
  return update ? Object.assign(src, { basename, extname, stem }) : src
}

function computeOut (src, family, version, htmlUrlExtensionStyle) {
  let { component, module: module_, basename, extname, relative, stem } = src
  if (component === 'ROOT') component = ''
  if (module_ === 'ROOT') module_ = ''
  let indexifyPathSegment = ''
  let familyPathSegment = ''

  if (family === 'page') {
    if (stem !== 'index' && htmlUrlExtensionStyle === 'indexify') {
      basename = 'index.html'
      indexifyPathSegment = stem
    } else if (extname === '.adoc') {
      basename = stem + '.html'
    }
  } else if (family === 'image') {
    familyPathSegment = '_images'
  } else if (family === 'attachment') {
    familyPathSegment = '_attachments'
  }

  const modulePath = path.join(component, version, module_)
  const dirname = path.join(modulePath, familyPathSegment, path.dirname(relative), indexifyPathSegment)
  const path_ = path.join(dirname, basename)
  const moduleRootPath = path.relative(dirname, modulePath) || '.'
  const rootPath = path.relative(dirname, '') || '.'

  return { dirname, basename, path: path_, moduleRootPath, rootPath }
}

function computePub (src, out, family, version, htmlUrlExtensionStyle) {
  const pub = {}
  let url
  if (family === 'nav') {
    const component = src.component || 'ROOT'
    const urlSegments = component === 'ROOT' ? [] : [component]
    if (version) urlSegments.push(version)
    const module_ = src.module || 'ROOT'
    if (module_ !== 'ROOT') urlSegments.push(module_)
    if (urlSegments.length) urlSegments.push('')
    // an artificial URL used for resolving page references in navigation model
    url = '/' + urlSegments.join('/')
    pub.moduleRootPath = '.'
  } else if (family === 'page') {
    const urlSegments = out.path.split('/')
    const lastUrlSegmentIdx = urlSegments.length - 1
    if (htmlUrlExtensionStyle === 'drop') {
      // drop just the .html extension or, if the filename is index.html, the whole segment
      const lastUrlSegment = urlSegments[lastUrlSegmentIdx]
      urlSegments[lastUrlSegmentIdx] =
        lastUrlSegment === 'index.html' ? '' : lastUrlSegment.substr(0, lastUrlSegment.length - 5)
    } else if (htmlUrlExtensionStyle === 'indexify') {
      urlSegments[lastUrlSegmentIdx] = ''
    }
    url = '/' + urlSegments.join('/')
  } else {
    if ((url = '/' + out.path) === '/.') url = '/'
    if (family === 'alias' && !src.relative) pub.splat = true
  }

  pub.url = ~url.indexOf(' ') ? url.replace(SPACE_RX, '%20') : url

  if (out) {
    pub.moduleRootPath = out.moduleRootPath
    pub.rootPath = out.rootPath
  }

  return pub
}

function computeVersionSegment (name, version, mode) {
  // special designation for master verson is @deprecated; special designation scheduled to be removed in Antora 4
  if (mode === 'original') return !version || version === 'master' ? '' : version
  const strategy = this.latestVersionUrlSegmentStrategy
  if (!version || version === 'master') {
    if (mode !== 'alias') return ''
    if (strategy === 'redirect:to') return
  }
  if (strategy === 'redirect:to' || strategy === (mode === 'alias' ? 'redirect:from' : 'replace')) {
    const component = this.getComponent(name)
    const componentVersion = component && this.getComponentVersion(component, version)
    if (componentVersion) {
      const segment =
        componentVersion === component.latest
          ? this.latestVersionUrlSegment
          : componentVersion === component.latestPrerelease
            ? this.latestPrereleaseVersionUrlSegment
            : undefined
      return segment == null ? version : segment
    }
  }
  return version
}

function createSymbolicVersionAlias (component, version, symbolicVersionSegment, strategy) {
  if (symbolicVersionSegment == null || symbolicVersionSegment === version) return
  const family = 'alias'
  const baseVersionAliasSrc = { component, module: 'ROOT', family, relative: '', basename: '', stem: '', extname: '' }
  const symbolicVersionAliasSrc = Object.assign({}, baseVersionAliasSrc, { version: symbolicVersionSegment })
  const symbolicVersionAlias = {
    src: symbolicVersionAliasSrc,
    pub: computePub(
      symbolicVersionAliasSrc,
      computeOut(symbolicVersionAliasSrc, family, symbolicVersionSegment),
      family
    ),
  }
  const originalVersionAliasSrc = Object.assign({}, baseVersionAliasSrc, { version })
  const originalVersionSegment = computeVersionSegment(component, version, 'original')
  const originalVersionAlias = {
    src: originalVersionAliasSrc,
    pub: computePub(
      originalVersionAliasSrc,
      computeOut(originalVersionAliasSrc, family, originalVersionSegment),
      family
    ),
  }
  return strategy === 'redirect:to'
    ? Object.assign(originalVersionAlias, { out: undefined, rel: symbolicVersionAlias })
    : Object.assign(symbolicVersionAlias, { out: undefined, rel: originalVersionAlias })
}

function getFileLocation ({ path: path_, src: { abspath, origin } }) {
  if (!origin) return abspath || path_
  const { url, gitdir, worktree, refname, tag, reftype = tag ? 'tag' : 'branch', remote, startPath } = origin
  let details = `${reftype}: ${refname}`
  if ('worktree' in origin) details += worktree ? ' <worktree>' : remote ? ` <remotes/${remote}>` : ''
  if (startPath) details += ` | start path: ${startPath}`
  return `${abspath || path.join(startPath, path_)} in ${'worktree' in origin ? worktree || gitdir : url} (${details})`
}

module.exports = ContentCatalog
