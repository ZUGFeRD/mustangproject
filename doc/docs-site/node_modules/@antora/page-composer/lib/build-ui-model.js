'use strict'

const { posix: path } = require('path')

const { DEFAULT_LAYOUT_NAME } = require('./constants')
const { version: VERSION } = require('../package.json')

function buildBaseUiModel (playbook, contentCatalog) {
  const contentCatalogModel = contentCatalog.exportToModel()
  return {
    antoraVersion: VERSION,
    contentCatalog: contentCatalogModel,
    env: playbook.env,
    site: buildSiteUiModel(playbook, contentCatalogModel),
  }
}

function buildUiModel (baseUiModel, file, contentCatalog, navigationCatalog) {
  const siteUiModel = baseUiModel.site
  const siteRootPath = file.pub.rootPath || siteUiModel.path || ''
  const uiRootPath = siteRootPath + siteUiModel.ui.url
  return Object.assign({}, baseUiModel, {
    page: buildPageUiModel(siteUiModel, file, contentCatalog, navigationCatalog),
    siteRootPath,
    uiRootPath,
  })
}

function buildSiteUiModel (playbook, contentCatalog) {
  const model = { title: playbook.site.title }

  let siteUrl = playbook.site.url
  if (siteUrl) {
    if (siteUrl === '/') {
      model.url = siteUrl
      model.path = ''
    } else {
      if (siteUrl.charAt(siteUrl.length - 1) === '/') siteUrl = siteUrl.substr(0, siteUrl.length - 1)
      if (siteUrl.charAt() === '/') {
        model.path = siteUrl
      } else if ((model.path = new URL(siteUrl).pathname) === '/') {
        model.path = ''
      }
      model.url = siteUrl
    }
  }

  const startPage = contentCatalog.getSiteStartPage()
  if (startPage) model.homeUrl = startPage.pub.url

  model.components = contentCatalog.getComponentsSortedBy('title').reduce((map, it) => (map[it.name] = it) && map, {})
  // NOTE: duplicate site.keys since original is frozen
  model.keys = Object.assign({}, playbook.site.keys)

  const uiConfig = playbook.ui
  model.ui = {
    url: path.resolve('/', uiConfig.outputDir),
    defaultLayout: uiConfig.defaultLayout || DEFAULT_LAYOUT_NAME,
  }

  return model
}

function buildPageUiModel (siteUiModel, file, contentCatalog, navigationCatalog) {
  const src = file.src
  // QUESTION should attributes be scoped to AsciiDoc, or should this work regardless of markup language? file.data?
  const asciidoc = file.asciidoc || {}
  const attributes = asciidoc.attributes || {}
  const pageAttributes = {}
  Object.entries(attributes).forEach(([name, val]) => {
    if (name.startsWith('page-')) pageAttributes[name.substr(5)] = val
  })
  if (src.stem === '404' && !('component' in src)) {
    return { 404: true, attributes: pageAttributes, layout: '404', title: file.title }
  }

  const { component: component_, version, module: module_, relative: relativeSrcPath, origin, editUrl, fileUri } = src
  const component = contentCatalog.getComponent(component_)
  const componentVersion = contentCatalog.getComponentVersion(component, version)
  const title = file.title || asciidoc.doctitle
  const url = file.pub.url
  // QUESTION can we cache versions on file.rel so only computed once per page version lineage?
  const versions = component.versions.length > 1 ? getPageVersions(file, component, contentCatalog) : undefined
  const model = {
    contents: file.contents,
    layout: pageAttributes.layout || siteUiModel.ui.defaultLayout,
    title,
    url,
    author: attributes.author,
    description: attributes.description,
    keywords: attributes.keywords,
    role: attributes.docrole,
    attributes: pageAttributes,
    component,
    version,
    displayVersion: componentVersion.displayVersion,
    componentVersion,
    module: module_,
    relativeSrcPath,
    origin,
    versions,
    editUrl,
    fileUri,
  }
  if (url === siteUiModel.homeUrl) model.home = true
  if (navigationCatalog) attachNavProperties(model, url, title, navigationCatalog.getNavigation(component_, version))
  if (versions) {
    Object.defineProperty(model, 'latest', {
      get () {
        return this.versions.find((candidate) => candidate.latest)
      },
    })
  }
  // NOTE site URL has already been normalized at this point
  const siteUrl = siteUiModel.url
  if (siteUrl && siteUrl.charAt() !== '/') {
    if (versions) {
      let latestReached
      // NOTE latest not guaranteed to match latest component version since the page may be missing in that version
      const latest = versions.find((it) => (latestReached || (latestReached = it.latest)) && !it.missing)
      // NOTE latest can be undefined if page is only in prerelease and the prerelease version is not the latest version
      if (latest && !latest.prerelease) {
        let canonicalUrl = latest.url
        if (canonicalUrl === url || canonicalUrl.charAt() === '/') canonicalUrl = siteUrl + canonicalUrl
        model.canonicalUrl = file.pub.canonicalUrl = canonicalUrl
      }
    } else if (!componentVersion.prerelease) {
      model.canonicalUrl = file.pub.canonicalUrl = siteUrl + url
    }
  }

  return model
}

// QUESTION should this function go in ContentCatalog?
function getPageVersions (page, component, contentCatalog) {
  let basePageId = page.src
  const componentVersions = component.versions
  const pageVersion = basePageId.version
  const thisVersionIdx = componentVersions.findIndex(({ version }) => version === pageVersion)
  const thisVersion = componentVersions[thisVersionIdx]
  const newerVersions = componentVersions.slice(0, thisVersionIdx)
  const olderVersions = componentVersions.slice(thisVersionIdx + 1)
  const latestVersion = component.latest
  let pageVersions = newerVersions
    .reverse()
    .reduce((accum, componentVersion) => {
      let relPage
      const relPageId = Object.assign({}, basePageId, { version: componentVersion.version })
      if (
        !(relPage = contentCatalog.getById(relPageId)) &&
        (relPage = (contentCatalog.getById((relPageId.family = 'alias') && relPageId) || {}).rel)
      ) {
        // NOTE: don't follow alias that falls outside of component version
        if (relPage.src.version === relPageId.version && relPage.src.component === relPageId.component) {
          // NOTE: keep searching from target of alias
          basePageId = relPage.src
        } else {
          // QUESTION: should we mark the page as missing or link outside the component version?
          //relPage = undefined
        }
      }
      accum.push(
        Object.assign(
          componentVersion === latestVersion ? { latest: true } : {},
          componentVersion,
          relPage ? { url: relPage.pub.url } : { missing: true }
        )
      )
      return accum
    }, [])
    .reverse()
  pageVersions.push(
    Object.assign(thisVersion === latestVersion ? { latest: true } : {}, thisVersion, { url: page.pub.url })
  )
  basePageId = page.src
  let prevPage = page
  pageVersions = olderVersions.reduce((accum, componentVersion) => {
    let relPage
    let primaryAliasSrc
    const relPageId = Object.assign({}, basePageId, { version: componentVersion.version })
    if ((relPage = contentCatalog.getById(relPageId))) {
      prevPage = relPage
    } else if (
      prevPage &&
      (primaryAliasSrc = (prevPage.rel || {}).src) &&
      // NOTE: if alias is located in different component or version, it doesn't give us any useful information
      primaryAliasSrc.version === prevPage.src.version &&
      primaryAliasSrc.component === prevPage.src.component
    ) {
      relPageId.module = primaryAliasSrc.module
      relPageId.relative = primaryAliasSrc.relative
      if ((relPage = contentCatalog.getById(relPageId))) {
        // NOTE: keep searching from target of alias
        basePageId = (prevPage = relPage).src
      } else if ((relPage = (contentCatalog.getById((relPageId.family = 'alias') && relPageId) || {}).rel)) {
        // NOTE: don't follow alias that falls outside of component version
        if (relPage.src.version === relPageId.version && relPage.src.component === relPageId.component) {
          // NOTE: keep searching from target of alias
          basePageId = (prevPage = relPage).src
        } else {
          // QUESTION: should we update version on prevPage so older versions can continue to follow it?
          prevPage = undefined
          // QUESTION: should we mark the page as missing or link outside the component version?
          //relPage = undefined
        }
      }
    }
    accum.push(
      Object.assign(
        componentVersion === latestVersion ? { latest: true } : {},
        componentVersion,
        relPage ? { url: relPage.pub.url } : { missing: true }
      )
    )
    return accum
  }, pageVersions)
  return pageVersions
}

function attachNavProperties (model, currentUrl, title, navigation = []) {
  if (!(model.navigation = navigation).length) return
  const startPageUrl = model.componentVersion.url
  const { match, ancestors, previous, next } = findNavItem({ ancestors: [], seekNext: true, currentUrl }, navigation)
  if (match) {
    // QUESTION should we filter out component start page from the breadcrumbs?
    const breadcrumbs = ancestors.filter((item) => 'content' in item).reverse()
    const parent = breadcrumbs.find((item) => item.urlType === 'internal')
    breadcrumbs.reverse().push(match)
    model.breadcrumbs = breadcrumbs
    if (parent) model.parent = parent
    if (previous) {
      model.previous = previous
    } else if (currentUrl !== startPageUrl) {
      model.previous = { content: model.componentVersion.title, url: startPageUrl, urlType: 'internal', discrete: true }
    }
    if (next) model.next = next
  } else {
    const orphan = { content: title, url: currentUrl, urlType: 'internal', discrete: true }
    if (title) model.breadcrumbs = [orphan]
    if (currentUrl === startPageUrl) {
      const { next: first } = findNavItem({ ancestors: [], match: orphan, seekNext: true, currentUrl }, navigation)
      if (first) model.next = first
    }
  }
}

function findNavItem (correlated, siblings, root = true, siblingIdx = 0, candidate = undefined) {
  if (!(candidate = candidate || siblings[siblingIdx])) {
    return correlated
  } else if (correlated.match) {
    if (candidate.urlType === 'internal' && !matchesPage(candidate, correlated.currentUrl)) {
      correlated.next = candidate
      return correlated
    }
  } else if (candidate.urlType === 'internal') {
    if (matchesPage(candidate, correlated.currentUrl)) {
      correlated.match = candidate
      if (!correlated.seekNext) return correlated
    } else if (!(correlated.previous && matchesPage(candidate, correlated.previous.url, correlated.previous.hash))) {
      correlated.previous = candidate
    }
  }
  const children = candidate.items || []
  if (children.length) {
    const ancestors = correlated.ancestors
    correlated = findNavItem(
      correlated.match ? correlated : Object.assign({}, correlated, { ancestors: [...ancestors, candidate] }),
      children,
      false
    )
    if (correlated.match) {
      if (!correlated.seekNext || correlated.next) return correlated
    } else {
      correlated.ancestors = ancestors
    }
  }
  if (++siblingIdx < siblings.length) {
    correlated = findNavItem(correlated, siblings, root, siblingIdx)
  } else if (root && !correlated.match) {
    delete correlated.previous
  }
  return correlated
}

function matchesPage (candidate, url, hash = undefined) {
  return candidate.url === (hash ? url.substr(0, url.length - hash.length) : url) + (candidate.hash || '')
}

module.exports = { buildBaseUiModel, buildSiteUiModel, buildPageUiModel, buildUiModel }
