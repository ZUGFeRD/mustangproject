'use strict'

const { posix: path } = require('path')

module.exports = (to, { data }) => {
  if (!to) return '#'
  if (to.charAt() !== '/') return to
  const from = data.root.page.url
  if (!from) return (data.root.site.path || '') + to
  let hash = ''
  const hashIdx = to.indexOf('#')
  if (~hashIdx) {
    hash = to.substr(hashIdx)
    to = to.substr(0, hashIdx)
  }
  return to === from
    ? hash || (isDir(to) ? './' : path.basename(to))
    : (path.relative(path.dirname(from + '.'), to) || '.') + (isDir(to) ? '/' + hash : hash)
}

function isDir (str) {
  return str.charAt(str.length - 1) === '/'
}
