'use strict'

const NUMBERS = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
const { isInteger } = Number

/**
 * An augmented semantic version comparison function.
 *
 * Augments the semantic version comparison algorithm with the following enhancements:
 *
 * * Discard the leading "v" character, if present and the version string is a semantic version.
 * * Compare non-semantic versions as strings in reverse alphabetical order (e.g., xenial comes before trusty).
 * * Compare semantic versions in descending order (e.g., 2.0.0 comes before 1.0.0).
 *
 * This function assumes that the string is a semantic version if it begins with a number (or a "v"
 * followed by a number) and contains a "." character or it's a parsable number.
 *
 * @param {String} a - The left version string.
 * @param {String} b - The right version string.
 * @returns 0 if the versions match, -1 if a is greater, or 1 if b is greater.
 */
function versionCompareDesc (a, b) {
  if (a === b) return 0
  if (a && b) {
    const semverA = resolveSemver(a)
    const semverB = resolveSemver(b)
    if (semverA) {
      return semverB ? -semverCompare(semverA, semverB) : 1
    } else {
      return semverB ? -1 : -2 * a.localeCompare(b, 'en', { numeric: true })
    }
  }
  return a ? 1 : -1
}

function resolveSemver (str) {
  const chr0 = str.charAt()
  if (chr0 === 'v') {
    if (isDigit(str.charAt(1)) && (str = str.substr(1)) && (~str.indexOf('.') || isDigit(str.charAt()))) {
      return str
    }
  } else if (isDigit(chr0) && (~str.indexOf('.') || isInteger(Number(str)))) {
    return str
  }
}

function isDigit (chr) {
  return NUMBERS.includes(chr)
}

function semverCompare (a, b) {
  let preA
  let preB
  const preOffsetA = a.indexOf('-')
  const preOffsetB = b.indexOf('-')
  if (~preOffsetA) {
    preA = a.substr(preOffsetA + 1)
    a = a.substr(0, preOffsetA)
  }
  if (~preOffsetB) {
    preB = b.substr(preOffsetB + 1)
    b = b.substr(0, preOffsetB)
  }
  const numsA = a.split('.')
  const numsB = b.split('.')
  for (let i = 0; i < 3; i++) {
    const numA = Number(numsA[i] || 0)
    const numB = Number(numsB[i] || 0)
    if (numA > numB) {
      return 1
    } else if (numB > numA) {
      return -1
    } else if (isNaN(numA)) {
      if (!isNaN(numB)) return -1
    } else if (isNaN(numB)) {
      return 1
    }
  }
  if (preA == null) {
    return preB == null ? 0 : 1
  } else {
    return preB == null ? -1 : preA.localeCompare(preB, 'en', { numeric: true })
  }
}

module.exports = versionCompareDesc
