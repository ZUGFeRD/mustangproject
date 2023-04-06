'use strict'

const computeRelativeUrlPath = require('../util/compute-relative-url-path')

function convertImageRef (resourceSpec, currentPage, contentCatalog) {
  const image = contentCatalog.resolveResource(resourceSpec, currentPage.src, 'image', ['image'])
  if (image) return computeRelativeUrlPath(currentPage.pub.url, image.pub.url)
}

module.exports = convertImageRef
