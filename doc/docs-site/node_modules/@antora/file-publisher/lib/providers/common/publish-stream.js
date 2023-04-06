'use strict'

/**
 * Pipes the stream of files to the specified Vinyl destination adapter.
 *
 * Pipes a stream of virtual files to the specified Vinyl destination adapter
 * (a stream transform function) and returns a Promise that resolves when the
 * stream ends.
 *
 * @memberof file-publisher
 *
 * @param {Function} destAdapter - A Vinyl destination adapter, preconfigured to
 *   write to a destination (e.g., `require('vinyl-fs').dest('path/to/dir')`).
 * @param {Readable<File>} files - A Readable stream of virtual files to publish.
 * @returns {Promise} A promise that resolves when the stream has ended.
 */
function publishStream (destAdapter, files) {
  return new Promise((resolve, reject) => files.pipe(destAdapter).on('error', reject).on('end', resolve))
}

module.exports = publishStream
