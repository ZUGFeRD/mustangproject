'use strict'

const { Readable } = require('stream')
const Vinyl = require('vinyl')

class File extends Vinyl {
  get relative () {
    return this.path
  }
}

class ReadableOutputFileArray extends Readable {
  constructor (array, cloneStreams) {
    super({ objectMode: true })
    this._array = array.map((it) => toOutputFile(it, cloneStreams)).reverse()
  }

  _read (size) {
    const array = this._array
    while (size--) {
      const next = array.pop()
      if (next === undefined) break
      this.push(next)
    }
    if (size > -1) this.push(null)
  }
}

// Q: do we also need to clone stat?
function toOutputFile (file, cloneStreams) {
  const contents = file.contents
  const outputFile = new File({ contents, path: file.out.path, stat: file.stat })
  if (cloneStreams && outputFile.isStream()) {
    const outputFileContents = outputFile.contents
    if (outputFileContents !== contents) {
      // NOTE: workaround for @antora/lunr-extension <= 1.0.0-alpha.8
      if (!('get' in (Object.getOwnPropertyDescriptor(file, 'contents') || {}))) file.contents = outputFileContents
    }
    // NOTE: even the last occurrence must be cloned when using vinyl-fs even though cloneable-readable claims otherwise
    outputFile.contents = outputFileContents.clone()
  }
  return outputFile
}

module.exports = ReadableOutputFileArray
