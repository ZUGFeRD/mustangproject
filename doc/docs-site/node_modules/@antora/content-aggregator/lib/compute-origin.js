'use strict'

const { posix: path } = require('path')
const posixify = require('./posixify')
const removeGitSuffix = require('./remove-git-suffix')

const EDIT_URL_TEMPLATE_VAR_RX = /\{(web_url|ref(?:hash|name|type)|path)\}/g
const HOSTED_GIT_REPO_RX = /^(?:https?:\/\/|.+@)(git(?:hub|lab)\.com|bitbucket\.org|pagure\.io)[/:](.+?)(?:\.git)?$/

function computeOrigin (url, authStatus, gitdir, ref, startPath, worktreePath = undefined, editUrl = true) {
  const { shortname: refname, oid: refhash, remote, type: reftype } = ref
  const origin = { type: 'git', url, gitdir, reftype, refname, [reftype]: refname, refhash, startPath }
  if (worktreePath !== undefined) {
    if ((origin.worktree = worktreePath)) {
      delete origin.refhash
      origin.fileUriPattern =
        (posixify ? 'file:///' + posixify(worktreePath) : 'file://' + worktreePath) +
        (startPath ? '/' + startPath + '/%s' : '/%s')
    } else if (remote) {
      origin.remote = remote
    }
    if (url.startsWith('file://')) url = undefined
  }
  if (authStatus) origin.private = authStatus
  if (url) origin.webUrl = removeGitSuffix(url)
  if (editUrl === true) {
    const match = url && url.match(HOSTED_GIT_REPO_RX)
    if (match) {
      const host = match[1]
      let action = 'blob'
      let category = ''
      if (host === 'pagure.io') {
        category = 'f'
      } else if (host === 'bitbucket.org') {
        action = 'src'
      } else if (reftype === 'branch') {
        action = 'edit'
      }
      origin.editUrlPattern = 'https://' + path.join(match[1], match[2], action, refname, category, startPath, '%s')
    }
  } else if (editUrl) {
    const vars = {
      path: () => (startPath ? path.join(startPath, '%s') : '%s'),
      refhash: () => refhash,
      reftype: () => reftype,
      refname: () => refname,
      web_url: () => origin.webUrl || '',
    }
    origin.editUrlPattern = editUrl.replace(EDIT_URL_TEMPLATE_VAR_RX, (_, name) => vars[name]())
  }
  return origin
}

module.exports = computeOrigin
