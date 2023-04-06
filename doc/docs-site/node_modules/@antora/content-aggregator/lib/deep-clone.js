'use strict'

function deepClone (o) {
  switch (o.constructor) {
    case Object:
      return Object.keys(o).reduce((accum, k) => {
        const v = o[k]
        accum[k] = !v || typeof v !== 'object' ? v : deepClone(v)
        return accum
      }, {})
    case Array:
      return o.map((it) => (!it || typeof it !== 'object' ? it : deepClone(it)))
    default:
      return o
  }
}

module.exports = deepClone
