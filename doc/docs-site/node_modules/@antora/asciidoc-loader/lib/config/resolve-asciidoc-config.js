'use strict'

const Asciidoctor = require('../asciidoctor')
const { Extensions } = Asciidoctor
const collateAsciiDocAttributes = require('./collate-asciidoc-attributes')
const userRequire = require('@antora/user-require-helper')

/**
 * Resolves a global AsciiDoc configuration object from data in the playbook.
 *
 * Reads data from the asciidoc category of the playbook and resolves it into a global AsciiDoc configuration object
 * that can be used by the loadAsciiDoc function. This configuration object consists of built-in attributes as well as a
 * shallow clone of the data from the asciidoc category in the playbook.
 *
 * The main purpose of this function is to resolve extension references in the playbook to extension
 * functions. If the extension is scoped, the function is stored in this object. If the extension is global, it is
 * registered with the global extension registry, then discarded.
 *
 * @memberof asciidoc-loader
 *
 * @param {Object} playbook - The configuration object for Antora (default: {}).
 * @param {Object} playbook.asciidoc - The AsciiDoc configuration data in the playbook.
 *
 * @returns {Object} A resolved configuration object to be used by the loadAsciiDoc function.
 */
function resolveAsciiDocConfig (playbook = {}) {
  const attributes = {
    env: 'site',
    'env-site': '',
    'site-gen': 'antora',
    'site-gen-antora': '',
    'attribute-missing': 'warn',
    'data-uri': null,
    icons: 'font',
    sectanchors: '',
    'source-highlighter': 'highlight.js',
  }
  if (playbook.site) {
    const site = playbook.site
    if (site.title) attributes['site-title'] = site.title
    if (site.url) attributes['site-url'] = site.url
  }
  if (!playbook.asciidoc) return { attributes }
  const mdc = { file: { path: playbook.file } }
  const { extensions, ...config } = Object.assign({}, playbook.asciidoc, {
    attributes: collateAsciiDocAttributes(playbook.asciidoc.attributes, { initial: attributes, mdc }),
  })
  if (extensions && extensions.length) {
    const userRequireContext = { dot: playbook.dir, paths: [playbook.dir || '', __dirname] }
    const scopedExtensions = extensions.reduce((accum, extensionPath) => {
      const extension = userRequire(extensionPath, userRequireContext)
      if ('register' in extension) {
        accum.push(extension)
      } else if (!isExtensionRegistered(extension, Extensions)) {
        // QUESTION should we assign an antora-specific group name?
        Extensions.register(extension)
      }
      return accum
    }, [])
    if (scopedExtensions.length) config.extensions = scopedExtensions
  }
  return config
}

function isExtensionRegistered (ext, registry) {
  return Object.values(registry.getGroups()).includes(ext)
}

module.exports = resolveAsciiDocConfig
