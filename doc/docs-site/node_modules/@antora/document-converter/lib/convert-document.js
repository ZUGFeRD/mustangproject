'use strict'

/**
 * Converts the contents on the specified file from AsciiDoc to embedded HTML.
 *
 * This function first delegates to the AsciiDoc loader to load the AsciiDoc contents on the
 * specified virtual file to a Document object. If the asciidoc property is not set on the virtual
 * file, it then extracts the metadata from that document and assigns it to the asciidoc property.
 * This metadata includes the document attributes, doctitle, xreftext, and navtitle. If the
 * keepSource option on the AsciiDoc config is true or the page-partial attributes is set, it backs
 * up the AsciiDoc source to the src.contents property. It then converts the Document to embedded
 * HTML, wraps it in a Buffer, and assigns it to the contents property on the file. Finally, it
 * updates the mediaType property on the file to 'text/html'.
 *
 * @memberof document-converter
 *
 * @param {File} file - The virtual file whose contents is an AsciiDoc source document.
 * @param {ContentCatalog} [contentCatalog=undefined] - The catalog of all virtual content files in the site.
 * @param {Object} [asciidocConfig={}] - AsciiDoc processor configuration options specific to this file.
 *
 * @returns {File} The virtual file that was converted.
 */
function convertDocument (file, contentCatalog = undefined, asciidocConfig = {}) {
  const {
    extractAsciiDocMetadata = requireAsciiDocLoader().extractAsciiDocMetadata,
    loadAsciiDoc = requireAsciiDocLoader(),
  } = this ? this.getFunctions(false) : {}
  const doc = loadAsciiDoc(file, contentCatalog, asciidocConfig)
  if (!file.asciidoc) {
    file.asciidoc = extractAsciiDocMetadata(doc)
    if (asciidocConfig.keepSource || 'page-partial' in file.asciidoc.attributes) file.src.contents = file.contents
  }
  file.contents = Buffer.from(doc.convert())
  file.mediaType = 'text/html'
  return file
}

function requireAsciiDocLoader () {
  return requireAsciiDocLoader.cache || (requireAsciiDocLoader.cache = require('@antora/asciidoc-loader'))
}

module.exports = convertDocument
