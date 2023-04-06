'use strict'

const { posix: path } = require('path')
const splitOnce = require('../util/split-once')

const { EXAMPLES_DIR_TOKEN, PARTIALS_DIR_TOKEN } = require('../constants')
const RESOURCE_ID_DETECTOR_RX = /[$:@]/

/**
 * Resolves the specified target of an include directive to a virtual file in the content catalog.
 *
 * @memberof asciidoc-loader
 *
 * @param {String} target - The target of the include directive to resolve.
 * @param {File} page - The outermost virtual file from which the include originated (not
 *   necessarily the current file).
 * @param {Cursor} cursor - The cursor of the reader for file that contains the include directive.
 * @param {ContentCatalog} catalog - The content catalog that contains the virtual files in the site.
 * @returns {Object} A map containing the file, path, and contents of the resolved file.
 */
function resolveIncludeFile (target, page, cursor, catalog) {
  const src = (cursor.file || {}).src || page.src
  let resolved
  let family
  let relative
  if (RESOURCE_ID_DETECTOR_RX.test(target)) {
    // support for legacy {partialsdir} and {examplesdir} prefixes is @deprecated; scheduled to be removed in Antora 4
    if (target.startsWith(PARTIALS_DIR_TOKEN) || target.startsWith(EXAMPLES_DIR_TOKEN)) {
      ;[family, relative] = splitOnce(target, '$')
      if (relative.charAt() === '/') relative = relative.substr(1)
      resolved = catalog.getById({
        component: src.component,
        version: src.version,
        module: src.module,
        family,
        relative,
      })
    } else {
      resolved = catalog.resolveResource(target, extractResourceId(src), 'page')
    }
  } else {
    // bypassing resource ID resolution for relative include path is @deprecated; scheduled to be removed in Antora 4
    resolved = catalog.getByPath({
      component: src.component,
      version: src.version,
      // QUESTION does cursor.dir always contain the value we expect?
      path: path.join(cursor.dir.toString(), target),
    })
  }
  if (resolved) {
    const resolvedSrc = resolved.src
    return {
      src: resolvedSrc,
      file: resolvedSrc.path,
      path: resolvedSrc.basename,
      // NOTE src.contents holds AsciiDoc source for page marked as a partial
      // QUESTION should we only use src.contents if family is 'page' and mediaType is 'text/asciidoc'?
      contents: (resolvedSrc.contents || resolved.contents || '').toString(),
    }
  }
}

function extractResourceId ({ component, version, module: module_, family, relative }) {
  return { component, version, module: module_, family, relative }
}

module.exports = resolveIncludeFile
