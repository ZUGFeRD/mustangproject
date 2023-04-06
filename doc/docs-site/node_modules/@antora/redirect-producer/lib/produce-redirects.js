'use strict'

const File = require('vinyl')
const { posix: path } = require('path')

const ENCODED_SPACE_RX = /%20/g

/**
 * Produces redirects (HTTP redirections) for registered page aliases.
 *
 * Iterates over the aliases (or files in the alias family from the content catalog) and creates
 * artifacts that define redirects from the URL of each alias to the target URL. The artifact
 * produced depends on the redirect facility specified. If the redirect facility is static (the
 * default), this function populates the contents of the alias file with an HTML redirect page
 * (i.e., bounce page). If the redirect facility is nginx, this function creates and returns an
 * nginx configuration file that contains rewrite rules for each alias. If the redirect facility is
 * netlify or gitlab, this function creates and returns a Netlify redirect file that contains
 * rewrite rules for each alias. If the redirect facility is disabled, this function unpublishes the
 * alias files by removing the out property on each alias file.
 *
 * @memberof redirect-producer
 *
 * @param {Object} playbook - The configuration object for Antora.
 * @param {Object} playbook.site - Site-related configuration data.
 * @param {String} playbook.site.url - The base URL of the site.
 * @param {String} playbook.urls - URL-related configuration data.
 * @param {String} playbook.urls.redirectFacility - The redirect facility for
 *   which redirect configuration is being produced.
 * @param {Array<File>} aliases - An array of virtual files in the alias family
 *   that define the redirect mappings. If aliases is a content catalog, the virtual
 *   files in the alias family will be retrieved from it using the findBy method.
 * @returns {Array<File>} An array of File objects that contain rewrite configuration for the web server.
 */
function produceRedirects (playbook, aliases) {
  if ('findBy' in aliases) aliases = aliases.findBy({ family: 'alias' }) // @deprecated remove in Antora 4
  if (!aliases.length) return []
  let siteUrl = playbook.site.url
  if (siteUrl) siteUrl = stripTrailingSlash(siteUrl, '')
  const directoryRedirects = (playbook.urls.htmlExtensionStyle || 'default') !== 'default'
  switch (playbook.urls.redirectFacility) {
    case 'gitlab':
      return createNetlifyRedirects(aliases, extractUrlPath(siteUrl), !directoryRedirects, false)
    case 'httpd':
      return createHttpdHtaccess(aliases, extractUrlPath(siteUrl), directoryRedirects)
    case 'netlify':
      return createNetlifyRedirects(aliases, extractUrlPath(siteUrl), !directoryRedirects)
    case 'nginx':
      return createNginxRewriteConf(aliases, extractUrlPath(siteUrl))
    case 'static':
      return populateStaticRedirectFiles(
        aliases.filter((it) => it.out),
        siteUrl
      )
    default:
      return unpublish(aliases)
  }
}

function extractUrlPath (url) {
  if (url) {
    if (url.charAt() === '/') return url
    const urlPath = new URL(url).pathname
    return urlPath === '/' ? '' : urlPath
  } else {
    return ''
  }
}

function createHttpdHtaccess (files, urlPath, directoryRedirects = false) {
  const rules = files.reduce((accum, file) => {
    delete file.out
    let fromUrl = file.pub.url
    fromUrl = ~fromUrl.indexOf('%20') ? `'${urlPath}${fromUrl.replace(ENCODED_SPACE_RX, ' ')}'` : urlPath + fromUrl
    let toUrl = file.rel.pub.url
    toUrl = ~toUrl.indexOf('%20') ? `'${urlPath}${toUrl.replace(ENCODED_SPACE_RX, ' ')}'` : urlPath + toUrl
    // see https://httpd.apache.org/docs/current/en/mod/mod_alias.html#redirect
    // NOTE: redirect rule for directory prefix does not require trailing slash
    if (file.pub.splat) {
      accum.push(`Redirect 302 ${fromUrl} ${stripTrailingSlash(toUrl)}`)
    } else if (directoryRedirects) {
      accum.push(`RedirectMatch 301 ^${regexpEscape(fromUrl)}$ ${stripTrailingSlash(toUrl)}`)
    } else {
      accum.push(`Redirect 301 ${fromUrl} ${toUrl}`)
    }
    return accum
  }, [])
  return [new File({ contents: Buffer.from(rules.join('\n') + '\n'), out: { path: '.htaccess' } })]
}

// NOTE: a trailing slash on the pathname will be ignored
// see https://docs.netlify.com/routing/redirects/redirect-options/#trailing-slash
// however, we keep it when generating the rules for clarity
function createNetlifyRedirects (files, urlPath, addDirectoryRedirects = false, useForceFlag = true) {
  const rules = files.reduce((accum, file) => {
    delete file.out
    const fromUrl = urlPath + file.pub.url
    const toUrl = urlPath + file.rel.pub.url
    const forceFlag = useForceFlag ? '!' : ''
    if (file.pub.splat) {
      accum.push(`${fromUrl}/* ${ensureTrailingSlash(toUrl)}:splat 302${forceFlag}`)
    } else {
      accum.push(`${fromUrl} ${toUrl} 301${forceFlag}`)
      if (addDirectoryRedirects && fromUrl.endsWith('/index.html')) {
        accum.push(`${fromUrl.substr(0, fromUrl.length - 10)} ${toUrl} 301${forceFlag}`)
      }
    }
    return accum
  }, [])
  return [new File({ contents: Buffer.from(rules.join('\n') + '\n'), out: { path: '_redirects' } })]
}

function createNginxRewriteConf (files, urlPath) {
  const rules = files.map((file) => {
    delete file.out
    let fromUrl = file.pub.url
    fromUrl = ~fromUrl.indexOf('%20') ? `'${urlPath}${fromUrl.replace(ENCODED_SPACE_RX, ' ')}'` : urlPath + fromUrl
    let toUrl = file.rel.pub.url
    toUrl = ~toUrl.indexOf('%20') ? `'${urlPath}${toUrl.replace(ENCODED_SPACE_RX, ' ')}'` : urlPath + toUrl
    if (file.pub.splat) {
      const toUrlWithTrailingSlash = ensureTrailingSlash(toUrl)
      return `location ^~ ${fromUrl}/ { rewrite ^${regexpEscape(fromUrl)}/(.*)$ ${toUrlWithTrailingSlash}$1 redirect; }`
    } else {
      return `location = ${fromUrl} { return 301 ${toUrl}; }`
    }
  })
  return [new File({ contents: Buffer.from(rules.join('\n') + '\n'), out: { path: '.etc/nginx/rewrite.conf' } })]
}

function populateStaticRedirectFiles (files, siteUrl) {
  files.forEach((file) => (file.contents = Buffer.from(createStaticRedirectContents(file, siteUrl) + '\n')))
  return []
}

function createStaticRedirectContents (file, siteUrl) {
  const targetUrl = file.rel.pub.url
  let linkTag
  let to = targetUrl.charAt() === '/' ? computeRelativeUrlPath(file.pub.url, targetUrl) : undefined
  let toText = to
  if (to) {
    if (siteUrl && siteUrl.charAt() !== '/') {
      linkTag = `<link rel="canonical" href="${(toText = siteUrl + targetUrl)}">\n`
    }
  } else {
    linkTag = `<link rel="canonical" href="${(toText = to = targetUrl)}">\n`
  }
  return `<!DOCTYPE html>
<meta charset="utf-8">
${linkTag || ''}<script>location="${to}"</script>
<meta http-equiv="refresh" content="0; url=${to}">
<meta name="robots" content="noindex">
<title>Redirect Notice</title>
<h1>Redirect Notice</h1>
<p>The page you requested has been relocated to <a href="${to}">${toText}</a>.</p>`
}

function unpublish (files) {
  files.forEach((file) => delete file.out)
  return []
}

function computeRelativeUrlPath (from, to) {
  if (to === from) return to.charAt(to.length - 1) === '/' ? './' : path.basename(to)
  return (path.relative(path.dirname(from + '.'), to) || '.') + (to.charAt(to.length - 1) === '/' ? '/' : '')
}

function ensureTrailingSlash (str) {
  return str.charAt(str.length - 1) === '/' ? str : str + '/'
}

function stripTrailingSlash (str, root = '/') {
  if (str === '/') return root
  const lastIdx = str.length - 1
  return str.charAt(lastIdx) === '/' ? str.substr(0, lastIdx) : str
}

function regexpEscape (str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') // don't escape "-" since it's meaningless in a literal
}

module.exports = produceRedirects
