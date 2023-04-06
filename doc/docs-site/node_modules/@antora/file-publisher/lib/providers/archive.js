'use strict'

const expandPath = require('@antora/expand-path-helper')
const publishStream = require('./common/publish-stream')
const { dest: vzipDest } = require('gulp-vinyl-zip')

const { DEFAULT_DEST_ARCHIVE } = require('../constants.js')

// FIXME right now we're assuming the archive is a zip
function publishToArchive (config, files, playbook) {
  const destFile = config.path || DEFAULT_DEST_ARCHIVE
  const absDestFile = expandPath(destFile, { dot: playbook.dir })
  const report = { provider: 'archive', path: destFile, resolvedPath: absDestFile }
  return publishStream(vzipDest(absDestFile), files).then(() => report)
}

module.exports = publishToArchive
