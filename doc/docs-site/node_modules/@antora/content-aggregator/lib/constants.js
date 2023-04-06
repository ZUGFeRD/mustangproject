'use strict'

module.exports = Object.freeze({
  COMPONENT_DESC_FILENAME: 'antora.yml',
  CONTENT_CACHE_FOLDER: 'content',
  CONTENT_SRC_GLOB: '**/*[!~]',
  CONTENT_SRC_OPTS: { follow: true, nomount: true, nosort: true, nounique: true, strict: false },
  FILE_MODES: { 100644: 0o100666 & ~process.umask(), 100755: 0o100777 & ~process.umask() },
  GIT_CORE: 'antora',
  GIT_OPERATION_LABEL_LENGTH: 8,
  GIT_PROGRESS_PHASES: ['Counting objects', 'Compressing objects', 'Receiving objects', 'Resolving deltas'],
  REF_PATTERN_CACHE_KEY: Symbol('RefPatternCache'),
  SYMLINK_FILE_MODE: '120000',
  VALID_STATE_FILENAME: 'valid',
})
