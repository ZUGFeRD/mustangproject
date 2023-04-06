'use strict'

const computeRelativeUrlPath = require('../util/compute-relative-url-path')

/**
 * Converts the specified resource reference to the data necessary to build an HTML link.
 *
 * Parses the resource reference (resource ID and optional fragment), resolves the corresponding file from
 * the content catalog, then grabs its publication (root-relative) path. If the relativize param is
 * true, transforms the root-relative path to a relative path from the current page to the target
 * resource. Uses the resulting path to create the href for an HTML link that points to the published
 * target resource.
 *
 * @memberof asciidoc-loader
 *
 * @param {String} refSpec - The target of an interdocument xref macro, which is a resource spec with an optional
 * fragment identifier.
 * @param {String} content - The content (i.e., formatted text) of the link (undefined if not specified).
 * @param {File} currentPage - The virtual file for the current page, which serves as the context.
 * @param {ContentCatalog} contentCatalog - The content catalog that contains the virtual files in the site.
 * @param {Boolean} [relativize=true] - Compute the target relative to the current page.
 * @returns {Object} A map ({ content, target, family, internal, unresolved }) containing the resolved
 * content and target to make an HTML link, the family (if resolved), and hints to indicate if the reference is either
 * internal or unresolved.
 */
function convertResourceRef (refSpec, content, currentPage, contentCatalog, relativize = true) {
  let resourceSpec
  let hash
  let target
  let resource
  if (~(hash = refSpec.indexOf('#'))) {
    resourceSpec = refSpec.substr(0, hash)
    hash = refSpec.substr(hash)
  } else {
    resourceSpec = refSpec
    hash = ''
  }
  if (!((resource = contentCatalog.resolveResource(resourceSpec, currentPage.src, 'page')) || {}).pub) {
    return { content: content || refSpec, target: '#' + refSpec, unresolved: true }
  }
  if (relativize) {
    target = computeRelativeUrlPath(currentPage.pub.url, resource.pub.url, hash)
    if (target === hash) return { content, target, internal: true }
  } else {
    target = resource.pub.url + hash
  }
  const family = (resource.src || { family: 'page' }).family
  if (content) return { content, target, family }
  if (family === 'page' && !hash) {
    content =
      (currentPage.src.family === 'nav' ? (resource.asciidoc || {}).navtitle : (resource.asciidoc || {}).xreftext) ||
      resourceSpec
  } else {
    content = resourceSpec + hash
  }
  return { content, target, family }
}

module.exports = convertResourceRef
