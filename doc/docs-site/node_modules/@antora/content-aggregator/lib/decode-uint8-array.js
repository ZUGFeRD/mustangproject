'use strict'

module.exports = (({ StringDecoder }) => {
  const decoder = new StringDecoder()
  return decoder.write.bind(decoder)
})(require('string_decoder'))
