'use strict'

const logger = require('../logger')

const ATTR_REF_RX = /\\?\{(\w[\w-]*)\}/g

function collateAsciiDocAttributes (scoped, { initial, merge, mdc }) {
  if (!scoped) return initial
  const locked = {}
  if (merge && initial) {
    Object.entries(initial).forEach(([name, val]) => {
      if (!(val ? val.constructor === String && val.charAt(val.length - 1) === '@' : val === false)) locked[name] = true
    })
  }
  let changed
  const collated = merge ? Object.assign({}, initial) : initial || {}
  Object.entries(scoped).forEach(([name, val]) => {
    if (locked[name]) return collated
    if (val && val.constructor === String) {
      let alias
      val = val.replace(ATTR_REF_RX, (ref, refname) => {
        if (ref.charAt() === '\\') return ref.substr(1)
        const refval = collated[refname]
        if (refval == null || refval === false) {
          if (refname in collated && ref === val) {
            alias = refval
          } else if (collated['attribute-missing'] === 'warn') {
            logger.warn(mdc, "Skipping reference to missing attribute '%s' in value of '%s' attribute", refname, name)
          }
          return ref
        } else if (refval.constructor === String) {
          const lastIdx = refval.length - 1
          return refval.charAt(lastIdx) === '@' ? refval.substr(0, lastIdx) : refval
        } else if (ref === val) {
          alias = refval
          return ref
        }
        return refval.toString()
      })
      if (alias !== undefined) val = alias
    }
    collated[name] = val
    changed = true
  })
  return merge && !changed ? initial : collated
}

module.exports = collateAsciiDocAttributes
