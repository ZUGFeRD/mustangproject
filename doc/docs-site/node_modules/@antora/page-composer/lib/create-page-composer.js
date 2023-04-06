'use strict'

const { buildBaseUiModel, buildUiModel } = require('./build-ui-model')
const Handlebars = require('handlebars')
const logger = require('./logger')
const relativize = require('./helpers/relativize')
const resolvePage = require('./helpers/resolve-page')
const resolvePageURL = require('./helpers/resolve-page-url')
const requireFromString = require('require-from-string')

/**
 * Generates a function to wrap the page contents in a page layout.
 *
 * Compiles the Handlebars layouts, along with the partials and helpers, and
 * builds the shared site UI model. Passes these objects to a generated
 * function, which can then be used to apply a layout template to pages.
 *
 * @memberof page-composer
 *
 * @param {Object} playbook - The configuration object for Antora.
 * @param {ContentCatalog} contentCatalog - The content catalog
 *   that provides access to the virtual files in the site.
 * @param {UiCatalog} uiCatalog - The file catalog
 *   that provides access to the UI files for the site.
 * @returns {Function} A function to compose a page (i.e., wrap the embeddable
 *   HTML contents in a standalone page layout).
 */
function createPageComposer (playbook, contentCatalog, uiCatalog) {
  const handlebars = Handlebars.create()
  handlebars.registerHelper('relativize', relativize)
  handlebars.registerHelper('resolvePage', resolvePage)
  handlebars.registerHelper('resolvePageURL', resolvePageURL)
  uiCatalog
    .findByType('helper')
    .forEach(({ path, stem, contents }) =>
      handlebars.registerHelper(stem, requireFromString(contents.toString(), path))
    )
  uiCatalog.findByType('partial').forEach(({ stem, contents }) => handlebars.registerPartial(stem, contents.toString()))
  handlebars.layouts = uiCatalog.findByType('layout').reduce((accum, { path: srcName, stem, contents }) => {
    accum[stem] = handlebars.compile(contents.toString(), { preventIndent: true, srcName })
    return accum
  }, {})
  const composePage = createPageComposerInternal(handlebars, buildBaseUiModel(playbook, contentCatalog))
  const create404Page = (siteAsciiDocConfig) =>
    composePage({
      asciidoc: siteAsciiDocConfig,
      mediaType: 'text/html',
      out: { path: '404.html' },
      pub: {},
      src: { stem: '404' },
      title: (siteAsciiDocConfig && siteAsciiDocConfig.attributes['404-page-title']) || 'Page Not Found',
    })
  return Object.assign(composePage, { composePage, create404Page, handlebars })
}

function createPageComposerInternal ({ layouts }, baseUiModel) {
  /**
   * Wraps the embeddable HTML contents of the specified file in a page layout.
   *
   * Builds a UI model from the file and its context, executes on the specified
   * page layout on that model, and assigns the result to the contents property
   * of the file. If no layout is specified on the file, the default layout is
   * used.
   *
   * @memberof page-composer
   *
   * @param {File} file - The virtual file the contains embeddable HTML
   *   contents to wrap in a layout.
   * @param {ContentCatalog} _contentCatalog - The content catalog
   *   that provides access to the virtual files in the site (ignored).
   * @param {NavigationCatalog} navigationCatalog - The navigation catalog
   *   that provides access to the navigation for each component version.
   * @returns {File} The file whose contents were wrapped in the specified page layout.
   */
  return function composePage (file, _contentCatalog, navigationCatalog) {
    // QUESTION should we pass the playbook to the uiModel?
    const uiModel = buildUiModel(baseUiModel, file, baseUiModel.contentCatalog, navigationCatalog)
    let layout = uiModel.page.layout
    if (!(layout in layouts)) {
      if (layout === '404') throw new Error('404 layout not found')
      const defaultLayout = uiModel.site.ui.defaultLayout
      if (defaultLayout === layout) {
        throw new Error(`${layout} layout not found`)
      } else if (!(defaultLayout in layouts)) {
        throw new Error(`Neither ${layout} layout or fallback ${defaultLayout} layout found`)
      }
      logger.warn(
        { file: file.src },
        'Page layout specified by page not found: %s (reverting to default layout)',
        layout
      )
      layout = defaultLayout
    }
    // QUESTION should we call trim() on result?
    try {
      file.contents = Buffer.from(layouts[layout](uiModel))
    } catch (err) {
      throw transformHandlebarsError(err, layout)
    }
    return file
  }
}

function transformHandlebarsError ({ message, stack }, layout) {
  const m = stack.match(/\n *at Object\.ret \[as (.+?)\].*\n *at Object\.invokePartialWrapper \[as invokePartial\]/)
  const templatePath = `${m ? 'partials/' + m[1] : 'layouts/' + layout}.hbs`
  const err = new Error(`${message}${~message.indexOf('\n') ? '\n^ ' : ' '}in UI template ${templatePath}`)
  err.stack = [err.toString(), stack.substr(message.length + 8)].join('\n')
  return err
}

module.exports = createPageComposer
