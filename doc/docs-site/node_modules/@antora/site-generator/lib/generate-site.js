'use strict'

const GeneratorContext = require('./generator-context')
const SiteCatalog = require('./site-catalog')

async function generateSite (playbook) {
  const context = new GeneratorContext(module)
  try {
    if (Array.isArray(playbook)) playbook = buildPlaybookFromArguments.apply(context, arguments)
    const { fxns, vars } = await GeneratorContext.start(context, playbook)
    await context.notify('playbookBuilt')
    deepFreeze((playbook = vars.lock('playbook')))
    vars.siteAsciiDocConfig = fxns.resolveAsciiDocConfig(playbook)
    vars.siteCatalog = new SiteCatalog()
    await context.notify('beforeProcess')
    const siteAsciiDocConfig = vars.lock('siteAsciiDocConfig')
    await Promise.all([
      fxns.aggregateContent(playbook).then((contentAggregate) =>
        context.notify('contentAggregated', Object.assign(vars, { contentAggregate })).then(() => {
          vars.contentCatalog = fxns.classifyContent(playbook, vars.remove('contentAggregate'), siteAsciiDocConfig)
        })
      ),
      fxns.loadUi(playbook).then((uiCatalog) => context.notify('uiLoaded', Object.assign(vars, { uiCatalog }))),
    ])
    await context.notify('contentClassified')
    const contentCatalog = vars.lock('contentCatalog')
    const uiCatalog = vars.lock('uiCatalog')
    fxns.convertDocuments(contentCatalog, siteAsciiDocConfig)
    await context.notify('documentsConverted')
    vars.navigationCatalog = fxns.buildNavigation(contentCatalog, siteAsciiDocConfig)
    await context.notify('navigationBuilt')
    ;(({ composePage, create404Page }) => {
      const navigationCatalog = vars.remove('navigationCatalog')
      contentCatalog.getPages((page) => page.out && composePage(page, contentCatalog, navigationCatalog))
      if (playbook.site.url) vars.siteCatalog.addFile(create404Page(siteAsciiDocConfig))
    })(fxns.createPageComposer(playbook, contentCatalog, uiCatalog, playbook.env))
    await context.notify('pagesComposed')
    vars.siteCatalog.addFiles(fxns.produceRedirects(playbook, contentCatalog.findBy({ family: 'alias' })))
    await context.notify('redirectsProduced')
    if (playbook.site.url) {
      const publishablePages = contentCatalog.getPages((page) => page.out)
      vars.siteCatalog.addFiles(fxns.mapSite(playbook, publishablePages))
      await context.notify('siteMapped')
    }
    await context.notify('beforePublish')
    return await fxns
      .publishFiles(playbook, [contentCatalog, uiCatalog, vars.lock('siteCatalog')])
      .then((publications) => {
        if (!playbook.runtime.quiet && (playbook.env.IS_TTY || String(process.stdout.isTTY)) === 'true') {
          const indexPath = contentCatalog.getSiteStartPage() ? '/index.html' : ''
          const log = (msg) => process.stdout.write(msg + '\n')
          log('Site generation complete!')
          publications.forEach(
            ({ fileUri } = {}) => fileUri && log(`Open ${fileUri}${indexPath} in a browser to view your site.`)
          )
        }
        return context
          .notify('sitePublished', Object.assign(vars, { publications }))
          .then(() => vars.remove('publications'))
      })
  } catch (err) {
    if (!GeneratorContext.isStopSignal(err)) throw err
    await err.notify()
  } finally {
    await GeneratorContext.close(context)
  }
}

function buildPlaybookFromArguments (args, env) {
  return require('@antora/playbook-builder')(args, env, undefined, (config) => {
    try {
      const { configureLogger, finalizeLogger } = require('@antora/logger')
      const playbookFile = config.get('playbook') || process.cwd() + '/.'
      configureLogger(config.getModel('runtime.log'), require('path').dirname(playbookFile))
      this.on('contextClosed', finalizeLogger)
    } catch {}
  })
}

function deepFreeze (o, p = '') {
  for (const [k, v] of Object.entries(o)) Object.isFrozen(v) || (k === 'env' && !p) || deepFreeze(v, p + k + '.')
  return Object.freeze(o)
}

module.exports = generateSite
