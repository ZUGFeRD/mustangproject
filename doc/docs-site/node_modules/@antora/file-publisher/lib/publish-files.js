'use strict'

const ReadableOutputFileArray = require('./readable-output-file-array')
const userRequire = require('@antora/user-require-helper')

const { DEFAULT_DEST_FS } = require('./constants.js')

/**
 * Publishes all publishable files in the specified catalogs using the
 * destination providers specified in the playbook.
 *
 * This function starts by retrieving all publishable files from the specified
 * collection of catalogs (currently those files with an out property). It then
 * resolves the publish function for each destination provider specified in the
 * playbook (i.e., `output.destinations`). If the provider is not known, the
 * publish function for that provider is resolved by requiring a module (or
 * relative path) having the same name as the provider.  Once the publish
 * function is resolved, the configuration specified in the playbook for that
 * provider is bound to the function as its first argument.  This function then
 * iterates over all publish providers and passes a Readable of the publishable
 * files as the second argument and the playbook as the third. The path of each
 * file has been updated to match the `out.path` value (currently by
 * instantiating a copy of the file).
 *
 * If a directory is specified directly on the output property of the playbook
 * (i.e., `output.dir`), that directory is used to create or override the first
 * fs provider in the list of destinations. If the clean property is set directly
 * on the output property of the playbook (i.e., `output.clean`), the clean
 * property is added to the configuration for each provider.
 *
 * @memberof file-publisher
 *
 * @param {Object} playbook - The configuration object for Antora that provides
 *   access to the output destinations.
 * @param {Array<Catalog>} catalogs - The collection of catalogs from which to retrieve the
 *   publishable virtual files. If catalogs is not an array, it will be wrapped in one.
 * @returns {Array<Object>} An array of reports that provide information about where the files were published.
 */
async function publishFiles (playbook, catalogs) {
  const output = playbook.output
  const destinations = getDestinations(output)

  if (!destinations.length) return []

  const clean = output.clean
  const publishers = destinations.map((destination) => {
    const { provider, options } = resolveDestination(destination, clean)
    switch (provider) {
      case 'archive':
      case 'fs':
        return require('./providers/' + provider).bind(null, options)
      default:
        try {
          const userRequireContext = { dot: playbook.dir, paths: [playbook.dir || '', __dirname] }
          return userRequire(provider, userRequireContext).bind(null, options)
        } catch (err) {
          const prettyErr = new Error('Unsupported destination provider: ' + provider)
          prettyErr.stack += `\nCaused by: ${err.stack || err}`
          throw prettyErr
        }
    }
  })

  // Q: add getPublishableFiles / getOutFiles; return a stream? or getOutFilesAsStream?
  const files = (Array.isArray(catalogs) ? catalogs : [catalogs]).reduce((accum, catalog) => {
    // the check for getAll on catalogs is @deprecated; scheduled to be removed in Antora 4
    accum.push(...(catalog.getFiles || catalog.getAll).apply(catalog).filter((file) => file.out))
    return accum
  }, [])

  const cloneStreams = publishers.length > 1
  return Promise.all(publishers.map((publish) => publish(new ReadableOutputFileArray(files, cloneStreams), playbook)))
}

function getDestinations (output) {
  let destinations = output.destinations
  if (output.dir) {
    if (destinations && destinations.length) {
      destinations = destinations.slice()
      const primaryFsDestIdx = destinations.findIndex(({ provider: candidate }) => candidate === 'fs')
      if (~primaryFsDestIdx) {
        ;(destinations[primaryFsDestIdx] = Object.assign({}, destinations[primaryFsDestIdx])).path = output.dir
      } else {
        destinations.unshift({ provider: 'fs', path: output.dir })
      }
    } else {
      destinations = [{ provider: 'fs', path: output.dir }]
    }
  } else if (!destinations) {
    destinations = [{ provider: 'fs', path: DEFAULT_DEST_FS }]
  }

  return destinations
}

function resolveDestination (destination, clean) {
  const { provider, ...options } = destination
  if (clean) options.clean = true
  return { provider, options }
}

module.exports = publishFiles
