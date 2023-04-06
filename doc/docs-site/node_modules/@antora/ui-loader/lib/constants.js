'use strict'

module.exports = Object.freeze({
  UI_CACHE_FOLDER: 'ui',
  UI_DESC_FILENAME: 'ui.yml',
  UI_SRC_GLOB: '**/*[!~]',
  UI_SRC_OPTS: {
    dot: true,
    follow: true,
    ignore: ['.git/**'],
    nomount: true,
    nosort: true,
    nounique: true,
    strict: false,
  },
})
