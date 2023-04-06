'use strict'

// matches pattern version@component:module:family$relative
// ex. 1.0@antora:asciidoc:syntax/lists.adoc
const RESOURCE_ID_RX = /^(?:([^@:$]+)@)?(?:(?:([^@:$]+):)?(?:([^@:$]+))?:)?(?:([^@:$]+)\$)?([^:$][^@:$]*)$/
const RESOURCE_ID_RX_GROUP = { version: 1, component: 2, module: 3, family: 4, relative: 5 }

/**
 * Parses a contextual resource ID spec into a file src object.
 *
 * Parses the specified resource ID spec to produce a resource ID object (an identifier shorthand
 * that corresponds to the identity stored in the src property of a virtual file). If a context
 * object is provided, it will be used to qualify the identifier, populating the component, version,
 * and/or module properties, as necessary.
 *
 * * If a component is specified, but a version is not, the version remains undefined.
 * * If a component is specified, but a module is not, the module defaults to "ROOT".
 * * If the family is not specified, the default family is used.
 * * If the family is specified, it is validated against the permitted families.
 *
 * @memberof content-classifier
 *
 * @param {String} spec - The contextual resource ID spec (e.g., version@component:module:family$relative).
 * @param {Object} [ctx={}] - The src context.
 * @param {String} [defaultFamily='page'] - The default family to use if family is not specified in the spec.
 *   This value is always used instead of family value provided by the ctx.
 * @param {Array<String>} [permittedFamilies=undefined] - An optional array of family names to allow.
 *
 * @returns {Object} A resource ID object that can be used to look up the file in the content
 * catalog. If the spec is malformed, the return value is undefined.
 */
function parseResourceId (spec, ctx = {}, defaultFamily = 'page', permittedFamilies = undefined) {
  const match = spec.match(RESOURCE_ID_RX)
  if (!match) return

  let version = match[RESOURCE_ID_RX_GROUP.version]
  let component = match[RESOURCE_ID_RX_GROUP.component]
  let module_ = match[RESOURCE_ID_RX_GROUP.module]
  let family = match[RESOURCE_ID_RX_GROUP.family]
  let relative = match[RESOURCE_ID_RX_GROUP.relative]

  if (version === '_') version = ''

  if (component) {
    if (!module_) module_ = 'ROOT'
  } else {
    component = ctx.component
    if (version == null) version = ctx.version
    if (!module_) module_ = ctx.module
  }

  if (family) {
    if (permittedFamilies && !permittedFamilies.includes(family)) family = undefined
  } else {
    family = defaultFamily
  }

  if (~relative.indexOf('/')) {
    const relativeSegments = relative.split('/')
    let from
    if (relativeSegments[0] === '.' && (from = ctx.relative)) {
      relativeSegments[0] = from.substr(0, (from.lastIndexOf('/') + 1 || 1) - 1)
    }
    relative = relativeSegments
      .reduce((accum, segment) => {
        segment === '..' ? accum.pop() : (segment || '.') !== '.' && accum.push(segment)
        return accum
      }, [])
      .join('/')
  }

  return { component, version, module: module_, family, relative }
}

module.exports = parseResourceId
