'use strict'

const { compile: bracesToGroup, expand: expandBraces } = require('braces')
const { makeRe } = require('picomatch')

const BASE_OPTS = {
  bash: true,
  dot: true,
  expandRange: (begin, end, step, opts) => bracesToGroup(opts ? `{${begin}..${end}..${step}}` : `{${begin}..${end}}`),
  fastpaths: false,
  nobracket: true,
  noglobstar: true,
  nonegate: true,
  noquantifiers: true,
  regex: false,
  strictSlashes: true,
}

function makeMatcherRx (input, opts) {
  if (input && ~input.indexOf('{')) input = input.replace(/^([^({]+)\./, '$1(?:.)')
  return makeRe(input, opts)
}

module.exports = {
  MATCH_ALL_RX: { test: () => true },
  expandBraces,
  makeMatcherRx,
  pathMatcherOpts: Object.assign({}, BASE_OPTS, { dot: false }),
  refMatcherOpts: (cache) =>
    Object.assign({}, BASE_OPTS, {
      expandRange: (begin, end, step, opts) => {
        const pattern = opts ? `{${begin}..${end}..${step}}` : `{${begin}..${end}}`
        return cache.braces.get(pattern) || cache.braces.set(pattern, bracesToGroup(pattern)).get(pattern)
      },
    }),
  versionMatcherOpts: Object.assign({}, BASE_OPTS, { nonegate: false }),
}
