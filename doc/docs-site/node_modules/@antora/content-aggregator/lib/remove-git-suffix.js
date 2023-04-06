'use strict'

const GIT_SUFFIX_RX = /(?:(?:(?:\.git)?\/)?\.git|\/)$/

function removeGitSuffix (url) {
  return url.replace(GIT_SUFFIX_RX, '')
}

module.exports = removeGitSuffix
