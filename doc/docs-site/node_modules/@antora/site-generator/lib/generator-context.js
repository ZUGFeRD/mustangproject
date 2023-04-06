'use strict'

const EventEmitter = require('events')
const getLogger = require('@antora/logger')
const noopNotify = async function notify () {}
const userRequire = require('@antora/user-require-helper')

const FUNCTION_PROVIDERS = {
  loadAsciiDoc: 'asciidoc-loader', // dynamic require('@antora/asciidoc-loader')
  extractAsciiDocMetadata: 'asciidoc-loader', // dynamic require('@antora/asciidoc-loader')
  resolveAsciiDocConfig: 'asciidoc-loader', // dynamic require('@antora/asciidoc-loader')
  aggregateContent: 'content-aggregator', // dynamic require('@antora/content-aggregator')
  loadUi: 'ui-loader', // dynamic require('@antora/ui-loader')
  classifyContent: 'content-classifier', // dynamic require('@antora/content-classifier')
  convertDocument: 'document-converter', // dynamic require('@antora/document-converter')
  convertDocuments: 'document-converter', // dynamic require('@antora/document-converter')
  buildNavigation: 'navigation-builder', // dynamic require('@antora/navigation-builder')
  createPageComposer: 'page-composer', // dynamic require('@antora/page-composer')
  produceRedirects: 'redirect-producer', // dynamic require('@antora/redirect-producer')
  mapSite: 'site-mapper', // dynamic require('@antora/site-mapper')
  publishFiles: 'file-publisher', // dynamic require('@antora/file-publisher')
}

const FUNCTION_WITH_POSITIONAL_PARAMETER_RX = /^(?:function *)?(?:\w+ *)?\( *\w|^\w+(?: *, *\w+)* *=>/
const NEWLINES_RX = /\r?\n/g

class StopSignal extends Error {}

class GeneratorContext extends EventEmitter {
  #fxns
  #vars

  constructor (module_) {
    super()
    if (!('path' in (this.module = module_))) module_.path = require('path').dirname(module_.filename)
  }

  getFunctions () {
    return arguments.length ? this.#fxns : Object.assign({}, this.#fxns)
  }

  getLogger (name = 'antora') {
    return getLogger(name)
  }

  getVariables () {
    return Object.assign({}, this.#vars)
  }

  lockVariable (name) {
    return Object.defineProperty(this.#vars, name, { configurable: false, writable: false })[name]
  }

  async notify (eventName) {
    if (!this.listenerCount(eventName)) return
    for (const listener of this.rawListeners(eventName)) {
      const wantsVariables = (listener.listener || listener).length === 1
      const outcome = wantsVariables ? listener.call(this, this.getVariables()) : listener.call(this)
      if (outcome instanceof Promise) await outcome
    }
    if (!this._eventsCount) Object.defineProperty(this, 'notify', { value: noopNotify })
  }

  removeVariable (name) {
    try {
      const value = this.#vars[name]
      delete this.#vars[name]
      return value
    } catch (err) {
      if (err instanceof TypeError) {
        err.message = err.message.replace(/ delete property '(.+?)' .*/, " remove locked variable '$1'")
      }
      throw err
    }
  }

  replaceFunctions (updates) {
    const fxns = this.#fxns
    const names = Object.assign({ publishSite: '' }, FUNCTION_PROVIDERS)
    Object.entries(updates).forEach(([name, fxn]) => {
      if (name in names && typeof fxn === 'function') fxns[name] = fxn.bind(this)
    })
  }

  require (request) {
    return this.module.require(request)
  }

  stop (code) {
    if (code != null) process.exitCode = code
    throw Object.assign(new StopSignal(), { notify: this.notify.bind(this, 'contextStopped') })
  }

  updateVariables (updates) {
    try {
      Object.assign(this.#vars, updates)
    } catch (err) {
      if (err instanceof TypeError) {
        err.message = err.message.replace(/ assign to read.only property '(.+?)' .*/, " update locked variable '$1'")
      }
      throw err
    }
  }

  static async close (instance) {
    await instance.notify('contextClosed').catch(() => undefined)
  }

  static isStopSignal (err) {
    return err instanceof StopSignal
  }

  static async start (instance, playbook) {
    const returnValue = instance._init(playbook)
    await instance.notify('contextStarted')
    return returnValue
  }

  _init (playbook) {
    // dynamic require('@antora/site-publisher')
    const fxns = (this.#fxns = Object.defineProperty({}, 'publishSite', {
      enumerable: true,
      get () {
        return this.publishFiles
      },
      set (value) {
        this.publishFiles = value
      },
    }))
    const vars = (this.#vars = { playbook })
    this._registerExtensions(playbook, vars)
    this._registerFunctions(fxns)
    Object.defineProperties(this, { _init: {}, _registerExtensions: {}, _registerFunctions: {} })
    const varsFacade = { lock: (name) => this.lockVariable(name), remove: (name) => this.removeVariable(name) }
    return { fxns, vars: new Proxy(vars, { get: (target, property) => varsFacade[property] || target[property] }) }
  }

  _registerExtensions (playbook, vars) {
    const extensions = (playbook.antora || {}).extensions || []
    if (extensions.length) {
      const requireContext = { dot: playbook.dir, paths: [playbook.dir || '', this.module.path] }
      extensions.forEach((ext) => {
        const { enabled = true, id, require: request, ...config } = ext.constructor === String ? { require: ext } : ext
        if (!enabled) return
        const { register } = userRequire(request, requireContext)
        if (typeof register !== 'function') return
        if (register.length) {
          if (FUNCTION_WITH_POSITIONAL_PARAMETER_RX.test(register.toString().replace(NEWLINES_RX, ' '))) {
            register.length === 1 ? register(this) : register(this, Object.assign({ config }, vars))
          } else {
            register.call(this, Object.assign({ config }, vars))
          }
        } else {
          register.call(this)
        }
      })
    }
    if (!this._eventsCount) Object.defineProperty(this, 'notify', { value: noopNotify })
  }

  _registerFunctions (fxns) {
    Object.entries(
      Object.entries(FUNCTION_PROVIDERS).reduce((accum, [fxnName, moduleKey]) => {
        accum[moduleKey] = (accum[moduleKey] || []).concat(fxnName)
        return accum
      }, {})
    ).forEach(([moduleKey, fxnNames]) => {
      let defaultExport
      fxnNames.forEach((fxnName) => {
        if (fxnName in fxns) return
        if (!defaultExport) defaultExport = this.require('@antora/' + moduleKey)
        fxns[fxnName] = (fxnName === defaultExport.name ? defaultExport : defaultExport[fxnName]).bind(this)
      })
    })
  }
}

module.exports = GeneratorContext
