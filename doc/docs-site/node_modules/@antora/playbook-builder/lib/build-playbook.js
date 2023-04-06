'use strict'

const convict = require('./solitary-convict')
const defaultSchema = require('./config/schema')
const fs = require('fs')
const ospath = require('path')

/**
 * Builds a playbook object according to the provided schema from the specified
 * arguments and environment variables.
 *
 * Accepts an array of command line arguments (in the form of option flags and
 * switches) and a map of environment variables and translates this data into a
 * playbook object according the the specified schema. If no schema is
 * specified, the default schema provided by this package is used.
 *
 * @memberof playbook-builder
 *
 * @param {Array} [args=[]] - An array of arguments in the form of command line
 *   option flags and switches. Should begin with the first flag or switch.
 * @param {Object} [env=process.env] - A map of environment variables.
 * @param {Object} [schema=require('./config/schema').defaultSchema] - A convict configuration schema.
 * @param {Function} [beforeValidate=undefined] - A function to invoke on the
 *   config before validating it.
 *
 * @returns {Object} A playbook object containing a hierarchical structure that
 *   mirrors the configuration schema. With the exception of keys and descendants
 *   marked in the schema as preserve, all keys in the playbook are camelCased.
 */
function buildPlaybook (args = [], env = process.env, schema = defaultSchema, beforeValidate = undefined) {
  const config = Object.assign(convict(schema, { args, env }), { getModel })
  const playbook = config.has('playbook') && config.get('playbook')
  let absPlaybookPath
  if (playbook) {
    if (ospath.extname((absPlaybookPath = ospath.resolve(playbook)))) {
      if (!fs.existsSync(absPlaybookPath)) {
        throw new Error(`playbook file not found at ${absPlaybookPath}${getDetails(playbook, absPlaybookPath)}`)
      }
    } else if (fs.existsSync(absPlaybookPath + '.yml')) {
      absPlaybookPath += '.yml'
    } else if (fs.existsSync(absPlaybookPath + '.json')) {
      absPlaybookPath += '.json'
    } else if (fs.existsSync(absPlaybookPath + '.toml')) {
      absPlaybookPath += '.toml'
    } else {
      throw new Error(
        `playbook file not found at ${absPlaybookPath}.yml, ${absPlaybookPath}.json, or ${absPlaybookPath}.toml` +
          getDetails(playbook, absPlaybookPath)
      )
    }
  }
  try {
    if (playbook) {
      config.loadFile(absPlaybookPath)
      if (playbook !== absPlaybookPath) config.set('playbook', absPlaybookPath)
    }
    const beforeValidateFromSchema = config._def[Symbol.for('convict.beforeValidate')]
    if (beforeValidateFromSchema) beforeValidateFromSchema(config)
    if (beforeValidate) beforeValidate(config)
    return config.getModel()
  } catch (err) {
    if (!playbook) throw err
    const message = err.message.replace(/( in the schema)?$/m, (_, inTheSchema) => {
      return `${inTheSchema ? inTheSchema + ' for' : ' in'} ${absPlaybookPath}${getDetails(playbook, absPlaybookPath)}`
    })
    throw Object.assign(err, { message })
  }
}

function camelCaseKeys (o, stopPaths = [], p = '') {
  if (Array.isArray(o)) return o.map((it) => camelCaseKeys(it, stopPaths, p))
  if (o == null || o.constructor !== Object) return o
  const pathPrefix = p && p + '.'
  const accum = {}
  for (const [k, v] of Object.entries(o)) {
    const camelKey = k.toLowerCase().replace(/[_-]([a-z0-9])/g, (_, l, idx) => (idx ? l.toUpperCase() : l))
    accum[camelKey] = ~stopPaths.indexOf(pathPrefix + camelKey) ? v : camelCaseKeys(v, stopPaths, pathPrefix + camelKey)
  }
  return accum
}

function getModel (name) {
  let config = this
  const data = config.get(name)
  let schema = config._schema
  if (name) {
    schema = name.split('.').reduce((accum, key) => accum._cvtProperties[key], schema)
    config = Object.assign(convict(name.split('.').reduce((def, key) => def[key], config._def)), { _instance: data })
  }
  config.validate({ allowed: 'strict' })
  const model = camelCaseKeys(data, getStopPaths(schema._cvtProperties))
  if (!name) {
    model.dir = model.playbook ? ospath.dirname((model.file = model.playbook)) : process.cwd()
    model.env = config.getEnv()
    delete model.playbook
  }
  return model
}

function getStopPaths (schemaProperties, schemaPath = [], stopPaths = []) {
  for (const [key, { preserve, _cvtProperties }] of Object.entries(schemaProperties)) {
    if (preserve) {
      Array.isArray(preserve)
        ? preserve.forEach((it) => stopPaths.push(schemaPath.concat(key, it).join('.')))
        : stopPaths.push(schemaPath.concat(key).join('.'))
    } else if (_cvtProperties) {
      stopPaths.push(...getStopPaths(_cvtProperties, schemaPath.concat(key)))
    }
  }
  return stopPaths
}

function getDetails (playbook, absPlaybookPath) {
  if (playbook === absPlaybookPath) return ''
  return ` (${ospath.isAbsolute(playbook) ? '' : 'cwd: ' + process.cwd() + ', '}playbook: ${playbook})`
}

module.exports = Object.assign(buildPlaybook, { defaultSchema })
