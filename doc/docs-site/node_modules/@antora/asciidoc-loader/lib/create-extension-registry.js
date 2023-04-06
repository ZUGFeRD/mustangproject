'use strict'

const IncludeProcessor = require('./include/include-processor')

/**
 * Creates an extension registry instance that provides extensions to integrate AsciiDoc into Antora.
 *
 * This registry includes a built-in include processor that resolves the target of include directives
 * to files in Antora's virtual content catalog.
 *
 * @memberof asciidoc-loader
 *
 * @param {Asciidoctor} Asciidoctor - Asciidoctor API.
 * @param {Object} callbacks - Callback functions.
 * @param {Function} callbacks.onInclude - A function that resolves the target of an include.
 *
 * @returns {Registry} An instance of Asciidoctor's extension registry.
 */
function createExtensionRegistry (Asciidoctor, callbacks) {
  const registry = Asciidoctor.Extensions.create()
  registry.includeProcessor(IncludeProcessor.$new(callbacks.onInclude))
  return registry
}

module.exports = createExtensionRegistry
