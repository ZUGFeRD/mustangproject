'use strict'

const Vinyl = require('vinyl')

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
}

module.exports = File
