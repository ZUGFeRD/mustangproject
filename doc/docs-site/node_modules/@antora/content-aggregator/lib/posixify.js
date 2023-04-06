'use strict'

module.exports = require('path').sep === '\\' ? (p) => p.replace(/\\/g, '/') : undefined
