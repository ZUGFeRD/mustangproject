'use strict'

const { makeMatcherRx, refMatcherOpts: getMatcherOpts, MATCH_ALL_RX } = require('./matcher')

function compileRx (pattern, opts) {
  if (pattern === '*' || pattern === '**') return MATCH_ALL_RX
  return pattern.charAt() === '!' // do our own negate
    ? Object.defineProperty(makeMatcherRx(pattern.substr(1), opts), 'negated', { value: true })
    : makeMatcherRx(pattern, opts)
}

function createMatcher (patterns, cache, opts) {
  const rxs = patterns.map(
    (pattern) =>
      cache.get(pattern) || cache.set(pattern, compileRx(pattern, opts || (opts = getMatcherOpts(cache)))).get(pattern)
  )
  if (rxs[0].negated) rxs.unshift(MATCH_ALL_RX)
  return (candidate) => {
    let matched
    for (const rx of rxs) {
      let voteIfMatched = true
      if (matched) {
        if (!rx.negated) continue
        voteIfMatched = false
      } else if (rx.negated) {
        continue
      }
      if (rx.test(candidate)) matched = voteIfMatched
    }
    return matched
  }
}

function filterRefs (candidates, patterns, cache = Object.assign(new Map(), { braces: new Map() })) {
  const isMatch = createMatcher(patterns, cache)
  return candidates.reduce((accum, candidate) => {
    if (isMatch(candidate)) accum.push(candidate)
    return accum
  }, [])
}

module.exports = filterRefs
