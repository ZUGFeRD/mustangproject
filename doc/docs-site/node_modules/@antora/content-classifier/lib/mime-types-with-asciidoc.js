'use strict'

const mimeTypes = require('mime-types')

mimeTypes.types.adoc = 'text/asciidoc'
mimeTypes.extensions['text/asciidoc'] = ['adoc']

module.exports = mimeTypes
