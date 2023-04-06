'use strict'

const { homedir } = require('os')
const expandPath = require('@antora/expand-path-helper')
const { promises: fsp } = require('fs')
const invariably = require('./invariably')
const ospath = require('path')

class GitCredentialManagerStore {
  configure ({ config, startDir }) {
    this.entries = undefined
    this.path = undefined
    this.urls = {}
    if (!(this.contents = (config = config || {}).contents) && config.path) {
      this.path = expandPath(config.path, { dot: startDir })
    }
    return this
  }

  async load () {
    if (this.entries) return this.entries
    return (this.entries = new Promise((resolve) => {
      let contentsPromise
      let delimiter = '\n'
      if (this.contents) {
        contentsPromise = Promise.resolve(this.contents)
        delimiter = /[,\n]/
      } else if (this.path) {
        contentsPromise = fsp.access(this.path).then(() => fsp.readFile(this.path, 'utf8'), invariably.void)
      } else {
        const homeGitCredentialsPath = ospath.join(homedir(), '.git-credentials')
        const xdgConfigGitCredentialsPath = ospath.join(
          process.env.XDG_CONFIG_HOME || ospath.join(homedir(), '.config'),
          'git',
          'credentials'
        )
        contentsPromise = fsp.access(homeGitCredentialsPath).then(
          () => fsp.readFile(homeGitCredentialsPath, 'utf8'),
          () =>
            fsp
              .access(xdgConfigGitCredentialsPath)
              .then(() => fsp.readFile(xdgConfigGitCredentialsPath, 'utf8'), invariably.void)
        )
      }
      contentsPromise.then((contents) => {
        if (contents) {
          resolve(
            contents
              .trim()
              .split(delimiter)
              .reduce((accum, url) => {
                try {
                  const { username, password, hostname, pathname } = new URL(url)
                  let credentials
                  if (password) {
                    credentials = { username: decodeURIComponent(username), password: decodeURIComponent(password) }
                  } else if (username) {
                    credentials = { username: decodeURIComponent(username), password: '' }
                  } else {
                    return accum
                  }
                  if (pathname === '/') {
                    accum[hostname] = credentials
                  } else {
                    accum[hostname + pathname] = credentials
                    if (!pathname.endsWith('.git')) accum[hostname + pathname + '.git'] = credentials
                  }
                } catch {}
                return accum
              }, {})
          )
        } else {
          resolve({})
        }
      })
    }))
  }

  async fill ({ url }) {
    this.urls[url] = 'requested'
    return this.load().then((entries) => {
      if (!Object.keys(entries).length) return
      const { hostname, pathname } = new URL(url)
      return entries[hostname + pathname] || entries[hostname]
    })
  }

  async approved ({ url }) {
    this.urls[url] = 'approved'
  }

  async rejected ({ url, auth }) {
    this.urls[url] = 'rejected'
    const statusCode = 401
    const statusMessage = 'HTTP Basic: Access Denied'
    const err = new Error(`HTTP Error: ${statusCode} ${statusMessage}`)
    err.name = err.code = 'HttpError'
    err.data = { statusCode, statusMessage }
    if (auth) err.rejected = true
    throw err
  }

  status ({ url }) {
    return this.urls[url]
  }
}

module.exports = GitCredentialManagerStore
