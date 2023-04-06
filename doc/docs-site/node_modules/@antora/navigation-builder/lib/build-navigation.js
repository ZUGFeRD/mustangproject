'use strict'

const NavigationCatalog = require('./navigation-catalog')

const LINK_RX = /<a href="([^"]+)"(?: class="([^"]+)")?>(.+?)<\/a>/

/**
 * Builds a {NavigationCatalog} from files in the navigation family that are
 * stored in the content catalog.
 *
 * Queries the content catalog for files in the navigation family. Then uses
 * the AsciiDoc Loader component to parse the source of each file into an
 * Asciidoctor Document object. It then looks in each file for one or more nested
 * unordered lists, which are used to build the navigation trees. It then
 * combines those trees in sorted order as a navigation set, which gets
 * stored in the navigation catalog by component/version pair.
 *
 * @memberof navigation-builder
 *
 * @param {ContentCatalog} [contentCatalog=undefined] - The content catalog
 *   that provides access to the virtual files in the site.
 * @param {Object} [asciidocConfig={}] - AsciiDoc processor configuration options. Extensions are not propagated.
 *   Sets the relativizeResourceRefs option to false before passing to the loadAsciiDoc function.
 * @param {Object} [asciidocConfig.attributes={}] - Shared AsciiDoc attributes to assign to the document.
 *
 * @returns {NavigationCatalog} A navigation catalog built from the navigation files in the content catalog.
 */
function buildNavigation (contentCatalog, siteAsciiDocConfig = {}) {
  const { loadAsciiDoc = require('@antora/asciidoc-loader') } = this ? this.getFunctions(false) : {}
  const navCatalog = new NavigationCatalog()
  const navAsciiDocConfig = { doctype: 'article', extensions: [], relativizeResourceRefs: false }
  contentCatalog
    .findBy({ family: 'nav' })
    .reduce((accum, navFile) => {
      const { component, version } = navFile.src
      const key = version + '@' + component
      const val = accum.get(key)
      if (val) return new Map(accum).set(key, Object.assign({}, val, { navFiles: [...val.navFiles, navFile] }))
      const componentVersion = contentCatalog.getComponentVersion(component, version)
      const asciidocConfig = Object.assign({}, componentVersion.asciidoc || siteAsciiDocConfig, navAsciiDocConfig)
      return new Map(accum).set(key, { component, version, componentVersion, asciidocConfig, navFiles: [navFile] })
    }, new Map())
    .forEach(({ component, version, componentVersion, asciidocConfig, navFiles }) => {
      const trees = navFiles.reduce((accum, navFile) => {
        accum.push(...loadNavigationFile(loadAsciiDoc, navFile, contentCatalog, asciidocConfig))
        return accum
      }, [])
      componentVersion.navigation = navCatalog.addNavigation(component, version, trees)
    })
  return navCatalog
}

function loadNavigationFile (loadAsciiDoc, navFile, contentCatalog, asciidocConfig) {
  const lists = loadAsciiDoc(navFile, contentCatalog, asciidocConfig).blocks.filter((b) => b.getContext() === 'ulist')
  if (!lists.length) return []
  const index = navFile.nav.index
  return lists.map((list, idx) => {
    const tree = buildNavigationTree(list.getTitle(), list.getItems())
    tree.root = true
    tree.order = idx ? parseFloat((index + idx / lists.length).toFixed(4)) : index
    return tree
  })
}

function getChildListItems (listItem) {
  const blocks = listItem.getBlocks()
  const candidate = blocks[0]
  if (candidate) {
    if (blocks.length === 1 && candidate.getContext() === 'ulist') {
      return candidate.getItems()
    } else {
      let context
      return blocks.reduce((accum, block) => {
        if (
          (context = block.getContext()) === 'ulist' ||
          (context === 'open' && (block = block.getBlocks()[0]) && block.getContext() === 'ulist')
        ) {
          accum.push(...block.getItems())
        }
        return accum
      }, [])
    }
  } else {
    return []
  }
}

function buildNavigationTree (formattedContent, items) {
  const entry = formattedContent ? partitionContent(formattedContent) : {}
  if (items.length) entry.items = items.map((item) => buildNavigationTree(item.getText(), getChildListItems(item)))
  return entry
}

// atomize? distill? decompose?
function partitionContent (content) {
  if (~content.indexOf('<a')) {
    const match = content.match(LINK_RX)
    if (match) {
      const [, url, role, content] = match
      let roles
      if (role && role.includes(' ') && (roles = role.split(' ')).includes('xref')) {
        const hashIdx = url.indexOf('#')
        if (~hashIdx) {
          if (roles.includes('unresolved')) {
            return { content, url, urlType: 'internal', unresolved: true }
          } else {
            return { content, url, urlType: 'internal', hash: url.substr(hashIdx) }
          }
        } else {
          return { content, url, urlType: 'internal' }
        }
      } else if (url.charAt() === '#') {
        return { content, url, urlType: 'fragment', hash: url }
      } else {
        return { content, url, urlType: 'external' }
      }
    }
  }
  return { content }
}

module.exports = buildNavigation
