'use strict'

const ContentCatalog = require('./content-catalog')
const collateAsciiDocAttributes = require('@antora/asciidoc-loader/config/collate-asciidoc-attributes')

/**
 * Organizes the raw aggregate of virtual files into a {ContentCatalog}.
 *
 * @memberof content-classifier
 *
 * @param {Object} playbook - The configuration object for Antora.
 * @param {Object} playbook.site - Site-related configuration data.
 * @param {String} playbook.site.startPage - The start page for the site; redirects from base URL.
 * @param {Object} playbook.urls - URL settings for the site.
 * @param {String} playbook.urls.htmlExtensionStyle - The style to use when computing page URLs.
 * @param {Object} aggregate - The raw aggregate of virtual file objects to be classified.
 * @param {Object} [siteAsciiDocConfig={}] - Site-wide AsciiDoc processor configuration options.
 * @returns {ContentCatalog} A structured catalog of content components and virtual content files.
 */
function classifyContent (playbook, aggregate, siteAsciiDocConfig = {}) {
  const contentCatalog = new ContentCatalog(playbook)
  aggregate
    .reduce((accum, componentVersionData) => {
      // drop files since they aren't needed to register component version
      // drop startPage to defer registration of start page
      const { name, version, files, startPage, ...descriptor } = Object.assign({}, componentVersionData, {
        asciidoc: resolveAsciiDocConfig(siteAsciiDocConfig, componentVersionData),
      })
      return new Map(accum).set(
        contentCatalog.registerComponentVersion(name, version, descriptor),
        componentVersionData
      )
    }, new Map())
    .forEach((componentVersionData, componentVersion) => {
      const { name, version } = componentVersion
      const { files, nav, startPage } = componentVersionData
      componentVersionData.files = undefined // clean up memory
      files.forEach((file) => allocateSrc(file, name, version, nav) && contentCatalog.addFile(file))
      contentCatalog.registerComponentVersionStartPage(name, componentVersion, startPage)
    })
  contentCatalog.registerSiteStartPage(playbook.site.startPage)
  return contentCatalog
}

function allocateSrc (file, component, version, nav) {
  const extname = file.src.extname
  const filepath = file.path
  const navInfo = nav && getNavInfo(filepath, nav)
  const pathSegments = filepath.split('/')
  if (navInfo) {
    if (extname !== '.adoc') return // ignore file
    file.nav = navInfo
    file.src.family = 'nav'
    if (pathSegments[0] === 'modules' && pathSegments.length > 2) {
      file.src.module = pathSegments[1]
      // relative to modules/<module>
      file.src.relative = pathSegments.slice(2).join('/')
      file.src.moduleRootPath = calculateRootPath(pathSegments.length - 3)
    } else {
      // relative to root
      file.src.relative = filepath
    }
  } else if (pathSegments[0] === 'modules') {
    let familyFolder = pathSegments[2]
    switch (familyFolder) {
      case 'pages':
        // pages/_partials location for partials is @deprecated; special designation scheduled to be removed in Antora 4
        if (pathSegments[3] === '_partials') {
          file.src.family = 'partial'
          // relative to modules/<module>/pages/_partials
          file.src.relative = pathSegments.slice(4).join('/')
        } else if (extname === '.adoc') {
          file.src.family = 'page'
          // relative to modules/<module>/pages
          file.src.relative = pathSegments.slice(3).join('/')
        } else {
          return // ignore file
        }
        break
      case 'assets':
        switch ((familyFolder = pathSegments[3])) {
          case 'attachments':
          case 'images':
            if (!extname) return // ignore file
            file.src.family = familyFolder.substr(0, familyFolder.length - 1)
            // relative to modules/<module>/assets/<family>s
            file.src.relative = pathSegments.slice(4).join('/')
            break
          default:
            return // ignore file
        }
        break
      case 'attachments':
      case 'images':
        if (!extname) return
        file.src.family = familyFolder.substr(0, familyFolder.length - 1)
        // relative to modules/<module>/<family>s
        file.src.relative = pathSegments.slice(3).join('/')
        break
      case 'examples':
      case 'partials':
        file.src.family = familyFolder.substr(0, familyFolder.length - 1)
        // relative to modules/<module>/<family>s
        file.src.relative = pathSegments.slice(3).join('/')
        break
      default:
        return // ignore file
    }
    file.src.module = pathSegments[1]
    file.src.moduleRootPath = calculateRootPath(pathSegments.length - 3)
  } else {
    return // ignore file
  }
  file.src.component = component
  file.src.version = version
  return true
}

/**
 * Return navigation properties if this file is registered as a navigation file.
 *
 * @param {String} filepath - The path of the virtual file to match.
 * @param {Array} nav - The array of navigation entries from the component descriptor.
 *
 * @returns {Object} An object of properties, which includes the navigation
 * index, if this file is a navigation file, or undefined if it's not.
 */
function getNavInfo (filepath, nav) {
  const index = nav.findIndex((candidate) => candidate === filepath)
  if (~index) return { index }
}

function resolveAsciiDocConfig (siteAsciiDocConfig, { asciidoc, origins = [] }) {
  const scopedAttributes = (asciidoc || {}).attributes
  if (scopedAttributes) {
    const initial = siteAsciiDocConfig.attributes
    const mdc = { file: { path: 'antora.yml', origin: origins[origins.length - 1] } }
    const attributes = collateAsciiDocAttributes(scopedAttributes, { initial, mdc, merge: true })
    if (attributes !== initial) siteAsciiDocConfig = Object.assign({}, siteAsciiDocConfig, { attributes })
  }
  return siteAsciiDocConfig
}

function calculateRootPath (depth) {
  return depth ? Array(depth).fill('..').join('/') : '.'
}

module.exports = classifyContent
