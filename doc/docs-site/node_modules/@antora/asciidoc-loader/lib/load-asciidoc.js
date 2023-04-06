'use strict'

const Asciidoctor = require('./asciidoctor')
const { Extensions, LoggerManager, NullLogger } = Asciidoctor
const Opal = global.Opal
const createConverter = require('./converter/create')
const createExtensionRegistry = require('./create-extension-registry')
const LoggerAdapter = require('./logger/adapter')
const { posix: path } = require('path')
const resolveAsciiDocConfig = require('./config/resolve-asciidoc-config')
const resolveIncludeFile = require('./include/resolve-include-file')

const BLANK_LINE_BUF = Buffer.from('\n\n')
const DOCTITLE_MARKER_BUF = Buffer.from('= ')
const { EXAMPLES_DIR_TOKEN, PARTIALS_DIR_TOKEN } = require('./constants')
const EXTENSION_DSL_TYPES = Extensions.$constants(false).filter((name) => name.endsWith('Dsl'))

/**
 * Loads the AsciiDoc source from the specified file into a Document object.
 *
 * Uses the Asciidoctor.js load API to parse the source of the file into an Asciidoctor Document object. Sets options
 * and attributes that provide integration with the Antora environment. Options include a custom converter and extension
 * registry to handle page references and include directives, respectively. It also assigns attributes that provide
 * context either for the author (e.g., env=site) or processor (e.g., docfile).
 *
 * @memberof asciidoc-loader
 *
 * @param {File} file - The virtual file whose contents is an AsciiDoc source document.
 * @param {ContentCatalog} [contentCatalog=undefined] - The catalog of all virtual content files in the site.
 * @param {Object} [config={}] - AsciiDoc processor configuration options.
 * @param {Object} [config.attributes={}] - Shared AsciiDoc attributes to assign to the document.
 * @param {Array<Function>} [config.extensions=[]] - Self-registering AsciiDoc processor extension functions.
 * @param {Boolean} [config.relativizeResourceRefs=true] - Configures the AsciiDoc processor to generate relative
 * resource references (relative to the current page) instead of root relative (relative to the site root).
 *
 * @returns {Document} An Asciidoctor Document object created from the source of the specified file.
 */
function loadAsciiDoc (file, contentCatalog = undefined, config = {}) {
  const { family, relative, extname = path.extname(relative) } = file.src
  const intrinsicAttrs = {
    docname: (family === 'nav' ? 'nav$' : '') + relative.substr(0, relative.length - extname.length),
    docfile: file.path,
    // NOTE docdir implicitly sets base_dir on document; Opal only expands value to absolute path if it starts with ./
    docdir: file.dirname,
    docfilesuffix: extname,
    imagesdir: path.join(file.pub.moduleRootPath, '_images'),
    attachmentsdir: path.join(file.pub.moduleRootPath, '_attachments'),
    examplesdir: EXAMPLES_DIR_TOKEN,
    partialsdir: PARTIALS_DIR_TOKEN,
  }
  const attributes = Object.assign(
    family === 'page' ? { 'page-partial': '@' } : {},
    config.attributes,
    intrinsicAttrs,
    computePageAttrs(file.src, contentCatalog)
  )
  const extensionRegistry = createExtensionRegistry(Asciidoctor, {
    onInclude: contentCatalog
      ? (doc, target, cursor) => resolveIncludeFile(target, file, cursor, contentCatalog)
      : () => undefined,
  })
  const extensions = config.extensions || []
  LoggerManager.setLogger(LoggerAdapter.logger.noop ? NullLogger.$new() : LoggerAdapter.$new(file.src))
  if (extensions.length) extensions.forEach((ext) => ext.register(extensionRegistry, { file, contentCatalog, config }))
  const opts = { attributes, extension_registry: extensionRegistry, safe: 'safe' }
  if (config.doctype) opts.doctype = config.doctype
  if (config.sourcemap) opts.sourcemap = true
  let contents = file.contents
  if (config.headerOnly) {
    opts.parse_header_only = true
    const firstBlankLineIdx = contents.indexOf(BLANK_LINE_BUF)
    if (~firstBlankLineIdx) {
      const partialContents = contents.slice(0, firstBlankLineIdx)
      const doctitleIdx = partialContents.indexOf(DOCTITLE_MARKER_BUF)
      if (!doctitleIdx || partialContents[doctitleIdx - 1] === 10) contents = partialContents
    }
  } else if (contentCatalog) {
    attributes.relfilesuffix = '.adoc' // NOTE relfilesuffix must be set for page-to-page xrefs to work correctly
    opts.converter = createConverter(file, contentCatalog, config)
  }
  try {
    return Asciidoctor.load(contents.toString(), opts)
  } finally {
    if (extensions.length) {
      // low-level operation to free objects from memory that have been weaved into an extension DSL module
      EXTENSION_DSL_TYPES.forEach((type) => (Opal.const_get_local(Extensions, type).$$iclasses.length = 0))
    }
  }
}

function computePageAttrs ({ component, version, module: module_, relative, origin, editUrl }, contentCatalog) {
  const attrs = {}
  attrs['page-component-name'] = component
  attrs['page-component-version'] = attrs['page-version'] = version
  if ((component = contentCatalog && contentCatalog.getComponent(component))) {
    attrs['page-component-title'] = component.title
    const componentVersion = component.versions.find((it) => it.version === version)
    if (componentVersion) {
      attrs['page-component-display-version'] = componentVersion.displayVersion
      const latestVersion = component.latest.version
      if (version === latestVersion) attrs['page-component-version-is-latest'] = ''
      attrs['page-component-latest-version'] = latestVersion
    }
  }
  attrs['page-module'] = module_
  attrs['page-relative-src-path'] = relative
  if (editUrl) attrs['page-edit-url'] = editUrl
  if (origin) {
    attrs['page-origin-type'] = origin.type
    attrs['page-origin-url'] = origin.url
    attrs['page-origin-start-path'] = origin.startPath
    attrs['page-origin-reftype'] = origin.reftype
    attrs['page-origin-refname'] = attrs['page-origin-' + origin.reftype] = origin.refname
    if (origin.worktree) {
      attrs['page-origin-worktree'] = origin.worktree
      attrs['page-origin-refhash'] = '(worktree)'
    } else {
      attrs['page-origin-refhash'] = origin.refhash
    }
    if (origin.private) attrs['page-origin-private'] = ''
  }
  return attrs
}

function extractAsciiDocMetadata (doc) {
  const metadata = { attributes: doc.getAttributes() }
  if (doc.hasHeader()) {
    const doctitle = (metadata.doctitle = doc.getDocumentTitle())
    const xreftext = (metadata.xreftext = doc.$reftext().$to_s() || doctitle)
    const navtitle = doc.getAttribute('navtitle')
    metadata.navtitle = navtitle ? doc.$apply_reftext_subs(navtitle) : xreftext
  }
  return metadata
}

module.exports = Object.assign(loadAsciiDoc, {
  loadAsciiDoc,
  extractAsciiDocMetadata,
  resolveAsciiDocConfig,
  resolveConfig: resolveAsciiDocConfig, // @deprecated scheduled to be removed in Antora 4
})
