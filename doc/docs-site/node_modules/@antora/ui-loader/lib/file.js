'use strict'

const { Readable } = require('stream')
const { Stats } = require('fs')
const Vinyl = require('vinyl')

const DEFAULT_FILE_MODE = 0o100666 & ~process.umask()

class File extends Vinyl {
  get path () {
    return this.history[this.history.length - 1]
  }

  set path (path_) {
    this.history.push(path_)
  }

  get relative () {
    return this.history[this.history.length - 1]
  }

  isDot () {
    return ('/' + this.history[this.history.length - 1]).indexOf('/.') > -1
  }
}

class MemoryFile extends File {
  constructor (file) {
    const contents = file.contents || Buffer.alloc(0)
    const stat = Object.assign(new Stats(), { mode: DEFAULT_FILE_MODE, mtime: undefined, size: contents.length })
    super(Object.assign({}, file, { contents, stat }))
  }
}

class ReadableFile extends Readable {
  constructor (file) {
    super({ objectMode: true })
    this._file = file
  }

  _read () {
    this.push(this._file)
    this.push((this._file = null))
  }
}

module.exports = { File, MemoryFile, ReadableFile }
