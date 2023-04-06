'use strict'

const Opal = global.Opal
const logger = require('@antora/logger')('asciidoctor')

const { $Antora } = require('../constants')

const LoggerAdapter = (() => {
  const classDef = Opal.klass(Opal.Antora || Opal.module(null, 'Antora', $Antora), Opal.Logger, 'LoggerAdapter')

  const severityMap = ((Severity) =>
    new Map(
      Severity.$constants().reduce(
        (accum, name) => {
          const lowerName = name.toLowerCase()
          if (lowerName === 'unknown') return accum
          const val = Severity[name]
          return accum.concat([
            [lowerName, val],
            [val, lowerName],
          ])
        },
        [
          ['silent', Infinity],
          [Infinity, 'silent'],
        ]
      )
    ))(classDef.$superclass().Severity)

  Opal.defn(classDef, '$initialize', function initialize (context) {
    Opal.send(this, Opal.find_super_dispatcher(this, 'initialize', initialize), [Opal.nil])
    const delegate = logger.unwrap()
    if ((this.level = severityMap.get(delegate.level)) == null) this.level = severityMap.get('info')
    if ((this.failureLevel = severityMap.get(delegate.failureLevel)) == null) this.failureLevel = Infinity
    this.context = context
    this.delegate = delegate
  })

  Opal.defn(classDef, '$add', function add (severity, message, progname) {
    const block = add.$$p
    add.$$p = null
    if (severity < this.level) {
      if (severity >= this.failureLevel) this.delegate.setFailOnExit()
      return true
    }
    if (message === Opal.nil) message = block ? block() : progname
    if (message.$$is_hash) message = Object.assign({}, message.$$smap)
    const logMethod = severityMap.get(severity) || 'info'
    const logObject = { file: this.context }
    if (message.text != null) {
      let loc
      if ((loc = message.include_location)) {
        message = message.text.replace(/ (of|in) include file: .+/, ' $1 include file')
      } else {
        loc = message.source_location
        message = message.text
      }
      if (loc) {
        const file = loc.file
        if (file.src) {
          logObject.file = file.src
          logObject.line = loc.lineno || undefined
          const stack = (logObject.stack = [])
          let ancestor = { file }
          while ((ancestor = ancestor.file.parent)) {
            stack.push({ file: ancestor.file.src || this.context, line: ancestor.lineno })
          }
          //if (stack.length > 10) stack.splice(0, stack.length - 10)
        } else {
          logObject.line = loc.lineno
        }
      }
    }
    this.delegate[logMethod](logObject, message)
    return true
  })

  return classDef
})()

module.exports = Object.assign(LoggerAdapter, { logger })
