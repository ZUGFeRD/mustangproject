'use strict'

/**
 * Splits the specified string at the first occurrence of the specified separator.
 *
 * @memberof asciidoc-loader
 *
 * @param {String} string - The string to split.
 * @param {String} separator - A single character on which to split the string.
 * @returns {String[]} A 2-element Array that contains the string before and after the separator, if
 * the separator is found, otherwise a single-element Array that contains the original string.
 */
function splitOnce (string, separator) {
  const separatorIdx = string.indexOf(separator)
  return ~separatorIdx ? [string.substr(0, separatorIdx), string.substr(separatorIdx + 1)] : [string]
}

module.exports = splitOnce
