'use strict'

const $files = Symbol('files')

class SiteCatalog {
  constructor () {
    this[$files] = []
  }

  addFile (file) {
    this[$files].push(file)
  }

  addFiles (files) {
    this[$files].push(...files)
  }

  removeFile (file) {
    let removed = false
    const outPath = (file.out || {}).path
    if (!outPath) return false
    this[$files] = this[$files].filter((it) => (removed || (it.out || {}).path !== outPath ? true : !(removed = true)))
    return removed
  }

  getFiles () {
    return this[$files].slice()
  }
}

/**
 * @deprecated superceded by getFiles(); scheduled to be removed in Antora 4
 */
SiteCatalog.prototype.getAll = SiteCatalog.prototype.getFiles

module.exports = SiteCatalog
