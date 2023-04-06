'use strict'

const File = require('vinyl')
const versionCompare = require('@antora/content-classifier/util/version-compare-desc')

const XML_DECL = '<?xml version="1.0" encoding="UTF-8"?>'
const SITEMAPS_NS = 'http://www.sitemaps.org/schemas/sitemap/0.9'
const SITEMAP_STEM = 'sitemap'
const SITEMAP_PREFIX = 'sitemap-'

/**
 * Maps the site by creating sitemap files.
 *
 * Iterates over the specified pages and creates sitemap files that list the
 * URLs for these pages. If there's only one component, all the entries are
 * added to a sitemap.xml file that gets published to the root of the site. If
 * there's more than one component, the sitemaps are partitioned into separate
 * files by component (e.g., sitemap-component-name.xml). The URL of those
 * component sitemaps are listed in the sitemap.xml index file that gets
 * published to the root of the site.
 *
 * The entries are listed in alphabetical order by URL. URLs with newer
 * versions are listed before URLs of older versions according to the semantic
 * versioning-based sorting algorithm used in Antora.
 *
 * The sitemaps are only created if a url for the site has been defined to
 * the site.url property in the playbook.
 *
 * If the site.robots key is set in the playbook, this function generates a
 * robots.txt file from that value. If the value matches the string 'allow' the
 * function creates a robots.txt file that allows access from all user agents
 * to all paths. If the value matches the string 'disallow', the function
 * creates a robots.txt file that disallows access from all user agents to all
 * paths. Otherwise, if the value is non-empty (i.e., a custom string), the
 * function creates a robots.txt file using that value.
 *
 * @memberof site-mapper
 *
 * @param {Object} playbook - The configuration object for Antora.
 * @param {Object} playbook.site - Site-related configuration data.
 * @param {String} playbook.site.url - The base URL of the site.
 * @param {Array<File>} pages - The publishable pages to to map.
 * @returns {Array<File>} An array of File objects that represent the sitemaps.
 */
function mapSite (playbook, pages) {
  let siteUrl = playbook.site.url
  if (!(siteUrl && pages.length)) return []
  const robots = playbook.site.robots
  if (siteUrl.charAt() === '/') return robots ? [createRobotsExclusionFile(robots)] : []
  if (siteUrl.charAt(siteUrl.length - 1) === '/') siteUrl = siteUrl.substr(0, siteUrl.length - 1)
  const lastmodISO = new Date().toISOString()
  let sitemaps = pages.reduce((accum, file) => {
    const componentSitemap = getSitemapForComponent(siteUrl, accum, file.src.component)
    const version = file.src.version
    componentSitemap.entries.push({
      url: file.pub.url,
      version,
      lastmodISO,
    })
    componentSitemap.versions.add(version)
    return accum
  }, new Map())
  sitemaps = [...sitemaps.keys()]
    .sort((a, b) => a.localeCompare(b))
    .map((component) => {
      const sitemap = sitemaps.get(component)
      let sitemapEntries = sitemap.entries
      delete sitemap.entries
      sitemapEntries.sort((a, b) => a.url.localeCompare(b.url))
      if (sitemap.versions.size > 1) sitemapEntries.sort((a, b) => versionCompare(a.version, b.version))
      delete sitemap.versions
      sitemapEntries = sitemapEntries.map(createUrlElement.bind(null, siteUrl))
      sitemap.contents = Buffer.from(createSitemapDocument(sitemapEntries) + '\n')
      return sitemap
    })
  let sitemapIndex
  if (sitemaps.length > 1) {
    const sitemapIndexEntries = sitemaps.map(createSitemapElement.bind(null, siteUrl))
    sitemapIndex = new File({ contents: Buffer.from(createSitemapIndexDocument(sitemapIndexEntries) + '\n') })
    sitemaps.unshift(sitemapIndex)
  } else {
    sitemapIndex = sitemaps[0]
  }
  const basename = SITEMAP_STEM + '.xml'
  sitemapIndex.out = { path: basename }
  sitemapIndex.pub = { url: '/' + basename }
  return robots ? [...sitemaps, createRobotsExclusionFile(robots)] : sitemaps
}

function getSitemapForComponent (siteUrl, sitemaps, component) {
  if (sitemaps.has(component)) {
    return sitemaps.get(component)
  } else {
    const basename = `${SITEMAP_PREFIX}${component}.xml`
    const componentSitemap = new File({
      entries: [],
      out: { path: basename },
      pub: { url: '/' + basename },
      versions: new Set(),
    })
    sitemaps.set(component, componentSitemap)
    return componentSitemap
  }
}

function createSitemapElement (siteUrl, sitemap) {
  return `<sitemap>
<loc>${siteUrl}${escapeHtml(sitemap.pub.url)}</loc>
</sitemap>`
}

function createSitemapIndexDocument (entries) {
  return `${XML_DECL}
<sitemapindex xmlns="${SITEMAPS_NS}">
${entries.join('\n')}
</sitemapindex>`
}

function createUrlElement (siteUrl, entry) {
  return `<url>
<loc>${siteUrl}${escapeHtml(entry.url)}</loc>
<lastmod>${entry.lastmodISO}</lastmod>
</url>`
}

function createSitemapDocument (entries) {
  return `${XML_DECL}
<urlset xmlns="${SITEMAPS_NS}">
${entries.join('\n')}
</urlset>`
}

function createRobotsExclusionFile (robots) {
  if (robots === 'allow') {
    robots = 'User-agent: *\nAllow: /'
  } else if (robots === 'disallow') {
    robots = 'User-agent: *\nDisallow: /'
  } else {
    robots = robots.trimRight()
  }
  return new File({
    out: { path: 'robots.txt' },
    pub: { url: '/robots.txt' },
    contents: Buffer.from(robots + '\n'),
  })
}

function escapeHtml (str) {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;')
}

module.exports = mapSite
