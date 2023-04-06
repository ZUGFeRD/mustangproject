'use strict'

const get = require('simple-get')
const defaultUserAgent = 'git/isomorphic-git@' + require('./git').version()

function distillResponse (res) {
  const { url, method, statusCode, statusMessage, headers } = res
  return { url, method, statusCode, statusMessage, headers, body: res }
}

async function mergeBuffers (data) {
  if (!Array.isArray(data)) return data
  if (data.length === 1 && data[0] instanceof Buffer) return data[0]
  const buffers = []
  let totalLength = 0
  for await (const chunk of data) {
    buffers.push(chunk)
    totalLength += chunk.byteLength
  }
  return Buffer.concat(buffers, totalLength)
}

function mergeHeaders (headers, extraHeaders) {
  const mergedHeaders = { 'user-agent': defaultUserAgent }
  if (extraHeaders == null) return Object.assign(headers, mergedHeaders)
  for (const name in extraHeaders) mergedHeaders[name.toLowerCase()] = extraHeaders[name]
  for (const name in headers) mergedHeaders[name.toLowerCase()] = headers[name]
  return mergedHeaders
}

module.exports = ({ headers: extraHeaders, httpProxy, httpsProxy, noProxy } = {}) => {
  if ((httpsProxy || httpProxy) && noProxy !== '*') {
    const { HttpProxyAgent, HttpsProxyAgent } = require('hpagent')
    const shouldProxy = require('should-proxy')
    return {
      async request ({ url, method, headers, body }) {
        headers = mergeHeaders(headers, extraHeaders)
        body = await mergeBuffers(body)
        const proxy = url.startsWith('https:')
          ? { Agent: HttpsProxyAgent, url: httpsProxy }
          : { Agent: HttpProxyAgent, url: httpProxy }
        const agent =
          proxy.url && shouldProxy(url, { no_proxy: noProxy }) ? new proxy.Agent({ proxy: proxy.url }) : undefined
        return new Promise((resolve, reject) =>
          get({ url, method, agent, headers, body }, (err, res) => (err ? reject(err) : resolve(distillResponse(res))))
        )
      },
    }
  }
  return {
    async request ({ url, method, headers, body }) {
      headers = mergeHeaders(headers, extraHeaders)
      body = await mergeBuffers(body)
      return new Promise((resolve, reject) =>
        get({ url, method, headers, body }, (err, res) => (err ? reject(err) : resolve(distillResponse(res))))
      )
    },
  }
}
