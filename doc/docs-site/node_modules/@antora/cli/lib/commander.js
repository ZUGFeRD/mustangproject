'use strict'

const commander = require('commander')
require('./commander/options-from-convict')
require('./commander/track-options')

module.exports = commander
