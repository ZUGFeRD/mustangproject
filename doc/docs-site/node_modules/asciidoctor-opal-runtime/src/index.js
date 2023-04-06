/* global globalThis, self */
var globalObject
if (typeof globalThis !== 'undefined') {
  globalObject = globalThis
} else if (typeof self !== 'undefined') {
  globalObject = self
} else if (typeof window !== 'undefined') {
  globalObject = window
} else if (typeof global !== 'undefined') {
  globalObject = global
} else {
  throw new Error('Unable to locate global object. Unsupported runtime.')
}
if (globalObject && globalObject.Opal) {
  // Opal is already loaded!
  var rubyEngineVersion = globalObject.Opal.$$['RUBY_ENGINE_VERSION']
  if (!rubyEngineVersion.startsWith('0.11')) {
    // incompatible version!
    throw new Error('Opal is already loaded and version ' + rubyEngineVersion + ' is not compatible with 0.11. Please upgrade Asciidoctor.js to the latest version.')
  }
} else {
  // load Opal
  require('./opal.js')
  require('./nodejs.js')
  require('./pathname.js')
  require('./stringio.js')
}

module.exports.Opal = globalObject.Opal
