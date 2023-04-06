'use strict'

const { posix: path } = require('path')

/**
 * Computes the shortest relative path between two URLs.
 *
 * This function takes into account directory index URLs and extensionless
 * URLs. It assumes it's working with root-relative URLs, not qualified URLs
 * with potentially different hosts.
 *
 * @memberof asciidoc-loader
 *
 * @param {String} from - The root-relative start URL.
 * @param {String} to - The root-relative target URL.
 * @param {String} [hash=''] - The URL hash to append to the URL (not #).
 *
 * @returns {String} The shortest relative path to travel from the start URL to the target URL.
 */
function computeRelativeUrlPath (from, to, hash = '') {
  if (to.charAt() === '/') {
    return to === from
      ? hash || (isDir(to) ? './' : path.basename(to))
      : (path.relative(path.dirname(from + '.'), to) || '.') + (isDir(to) ? '/' + hash : hash)
  } else {
    return to + hash
  }
}

function isDir (str) {
  return str.charAt(str.length - 1) === '/'
}

module.exports = computeRelativeUrlPath
