'use strict'

const { buildPageUiModel } = require('./../build-ui-model')

module.exports = (spec, { data, hash: context }) => {
  if (!spec) return
  const { contentCatalog, page, site } = data.root
  const raw = 'model' in context && (context.model ? !delete context.model : delete context.model)
  if (page.component) {
    context = Object.assign({ component: page.component.name, version: page.version, module: page.module }, context)
  }
  const file = contentCatalog.resolvePage(spec, context)
  if (file) return raw ? file : buildPageUiModel(site, file, contentCatalog)
}
