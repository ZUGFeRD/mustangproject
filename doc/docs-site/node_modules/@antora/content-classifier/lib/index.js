'use strict'

/**
 * Content Classifier component for Antora
 *
 * Organizes virtual files in the raw aggregate into a virtual content
 * catalog. This catalog can be used by other components in Antora to find
 * files by select properties, such as family, component, or version.
 *
 * @namespace content-classifier
 */
module.exports = require('./classify-content')
