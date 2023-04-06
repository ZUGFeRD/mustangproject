'use strict'

const convertImageRef = require('./../image/convert-image-ref')
const convertResourceRef = require('./../xref/convert-resource-ref')
const defineHtml5Converter = require('./html5')

/**
 * Creates an HTML5 converter instance with Antora enhancements.
 *
 * @memberof asciidoc-loader
 *
 * @param {File} file - The virtual file whose contents is an AsciiDoc source document.
 * @param {ContentCatalog} contentCatalog - The catalog of all virtual content files in the site.
 * @param {Object} config - AsciiDoc processor configuration options.
 * @param {Boolean} [config.relativizeResourceRefs=true] - Configures the converter to generate relative resource
 * references (relative to the current page) instead of root relative (relative to the site root).
 *
 * @returns {Converter} An enhanced instance of Asciidoctor's built-in HTML 5 converter.
 */
function createConverter (file, contentCatalog, config) {
  const relativizeResourceRefs = config.relativizeResourceRefs !== false
  return defineHtml5Converter().$new('html5', undefined, {
    onImageRef: (imageSpec) => convertImageRef(imageSpec, file, contentCatalog),
    onResourceRef: (resourceSpec, content) =>
      convertResourceRef(resourceSpec, content, file, contentCatalog, relativizeResourceRefs),
  })
}

module.exports = createConverter
