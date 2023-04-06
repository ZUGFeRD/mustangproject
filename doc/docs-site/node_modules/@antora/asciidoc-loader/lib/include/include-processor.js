'use strict'

const Opal = global.Opal

const { $Antora } = require('../constants')
const DBL_COLON = '::'
const DBL_SQUARE = '[]'
const NEWLINE_RX = /\r\n?|\n/
const TAG_DIRECTIVE_RX = /\b(?:tag|(e)nd)::(\S+?)\[\](?=$|[ \r])/m

const IncludeProcessor = (() => {
  const $callback = Symbol('callback')
  const classDef = Opal.klass(
    Opal.Antora || Opal.module(null, 'Antora', $Antora),
    Opal.Asciidoctor.Extensions.IncludeProcessor,
    'IncludeProcessor'
  )

  Opal.defn(classDef, '$initialize', function initialize (callback) {
    Opal.send(this, Opal.find_super_dispatcher(this, 'initialize', initialize))
    this[$callback] = callback
  })

  Opal.defn(classDef, '$process', function (doc, reader, target, attrs) {
    if (reader.maxdepth === Opal.nil) return
    const sourceCursor = reader.$cursor_at_prev_line()
    if (reader.$include_depth() >= Opal.hash_get(reader.maxdepth, 'curr')) {
      log('error', `maximum include depth of ${Opal.hash_get(reader.maxdepth, 'rel')} exceeded`, reader, sourceCursor)
      return
    }
    const resolvedFile = this[$callback](doc, target, sourceCursor)
    if (resolvedFile) {
      let includeContents
      let linenums
      let tags
      let startLineNum
      if ((linenums = getLines(attrs))) {
        ;[includeContents, startLineNum] = filterLinesByLineNumbers(reader, target, resolvedFile, linenums)
      } else if ((tags = getTags(attrs))) {
        ;[includeContents, startLineNum] = filterLinesByTags(reader, target, resolvedFile, tags, sourceCursor)
      } else {
        includeContents = resolvedFile.contents
        startLineNum = 1
      }
      Opal.hash_put(attrs, 'partial-option', '')
      // eslint-disable-next-line no-new-wrappers
      const file = Object.assign(new String(resolvedFile.file), {
        src: resolvedFile.src,
        parent: { file: reader.file, lineno: reader.lineno - 1 },
      })
      reader.pushInclude(includeContents, file, resolvedFile.path, startLineNum, attrs)
    } else {
      if (attrs['$key?']('optional-option')) {
        log('info', `optional include dropped because include file not found: ${target}`, reader, sourceCursor)
      } else {
        log('error', `target of include not found: ${target}`, reader, sourceCursor)
        reader.$unshift(`Unresolved include directive in ${sourceCursor.file} - include::${target}[]`)
      }
    }
  })

  return classDef
})()

function getLines (attrs) {
  if (attrs['$key?']('lines')) {
    const lines = attrs['$[]']('lines')
    if (lines) {
      const linenums = []
      let filtered
      ;(~lines.indexOf(',') ? lines.split(',') : lines.split(';'))
        .filter((it) => it)
        .forEach((linedef) => {
          filtered = true
          let delim
          let from
          if (~(delim = linedef.indexOf('..'))) {
            from = linedef.substr(0, delim)
            let to = linedef.substr(delim + 2)
            if ((to = parseInt(to, 10) || -1) > 0) {
              if ((from = parseInt(from, 10) || -1) > 0) {
                for (let i = from; i <= to; i++) linenums.push(i)
              }
            } else if (to === -1 && (from = parseInt(from, 10) || -1) > 0) {
              linenums.push(from, Infinity)
            }
          } else if ((from = parseInt(linedef, 10) || -1) > 0) {
            linenums.push(from)
          }
        })
      if (linenums.length) return [...new Set(linenums.sort((a, b) => a - b))]
      if (filtered) return []
    }
  }
}

function getTags (attrs) {
  if (attrs['$key?']('tag')) {
    const tag = attrs['$[]']('tag')
    if (tag && tag !== '!') {
      return tag.charAt() === '!' ? new Map().set(tag.substr(1), false) : new Map().set(tag, true)
    }
  } else if (attrs['$key?']('tags')) {
    const tags = attrs['$[]']('tags')
    if (tags) {
      const result = new Map()
      let any = false
      tags.split(~tags.indexOf(',') ? ',' : ';').forEach((tag) => {
        if (tag && tag !== '!') {
          any = true
          tag.charAt() === '!' ? result.set(tag.substr(1), false) : result.set(tag, true)
        }
      })
      if (any) return result
    }
  }
}

function filterLinesByLineNumbers (reader, target, file, linenums) {
  let lineNum = 0
  let startLineNum
  let selectRest
  const lines = []
  file.contents.split(NEWLINE_RX).some((line) => {
    lineNum++
    if (selectRest || (selectRest = linenums[0] === Infinity)) {
      if (!startLineNum) startLineNum = lineNum
      lines.push(line)
    } else {
      if (linenums[0] === lineNum) {
        if (!startLineNum) startLineNum = lineNum
        linenums.shift()
        lines.push(line)
      }
      if (!linenums.length) return true
    }
  })
  return [lines, startLineNum || 1]
}

function filterLinesByTags (reader, target, file, tags, sourceCursor) {
  let selectingDefault, selecting, wildcard
  const globstar = tags.get('**')
  const star = tags.get('*')
  if (globstar === undefined) {
    if (star === undefined) {
      selectingDefault = selecting = !mapContainsValue(tags, true)
    } else {
      if ((wildcard = star) || tags.keys().next().value !== '*') {
        selectingDefault = selecting = false
      } else {
        selectingDefault = selecting = !wildcard
      }
      tags.delete('*')
    }
  } else {
    tags.delete('**')
    selectingDefault = selecting = globstar
    if (star === undefined) {
      if (!globstar && tags.values().next().value === false) wildcard = true
    } else {
      tags.delete('*')
      wildcard = star
    }
  }

  const lines = []
  const tagStack = []
  const foundTags = []
  let activeTag
  let lineNum = 0
  let startLineNum
  file.contents.split(NEWLINE_RX).forEach((line) => {
    lineNum++
    let m
    if (~line.indexOf(DBL_COLON) && ~line.indexOf(DBL_SQUARE) && (m = line.match(TAG_DIRECTIVE_RX))) {
      const thisTag = m[2]
      if (m[1]) {
        if (thisTag === activeTag) {
          tagStack.shift()
          ;[activeTag, selecting] = tagStack.length ? tagStack[0] : [undefined, selectingDefault]
        } else if (tags.has(thisTag)) {
          const idx = tagStack.findIndex(([name]) => name === thisTag)
          if (~idx) {
            tagStack.splice(idx, 1)
            log(
              'warn',
              `mismatched end tag (expected '${activeTag}' but found '${thisTag}') ` +
                `at line ${lineNum} of include file: ${file.file})`,
              reader,
              sourceCursor,
              createIncludeCursor(reader, file, target, lineNum)
            )
          } else {
            log(
              'warn',
              `unexpected end tag '${thisTag}' at line ${lineNum} of include file: ${file.file}`,
              reader,
              sourceCursor,
              createIncludeCursor(reader, file, target, lineNum)
            )
          }
        }
      } else if (tags.has(thisTag)) {
        foundTags.push(thisTag)
        tagStack.unshift([(activeTag = thisTag), (selecting = tags.get(thisTag)), lineNum])
      } else if (wildcard !== undefined) {
        selecting = activeTag && !selecting ? false : wildcard
        tagStack.unshift([(activeTag = thisTag), selecting, lineNum])
      }
    } else if (selecting) {
      if (!startLineNum) startLineNum = lineNum
      lines.push(line)
    }
  })
  if (tagStack.length) {
    tagStack.forEach(([tagName, _, tagLineNum]) =>
      log(
        'warn',
        `detected unclosed tag '${tagName}' starting at line ${tagLineNum} of include file: ${file.file}`,
        reader,
        sourceCursor,
        createIncludeCursor(reader, file, target, tagLineNum)
      )
    )
  }
  if (foundTags.length) foundTags.forEach((name) => tags.delete(name))
  if (tags.size) {
    log(
      'warn',
      `tag${tags.size > 1 ? 's' : ''} '${[...tags.keys()].join(', ')}' not found in include file: ${file.file}`,
      reader,
      sourceCursor,
      createIncludeCursor(reader, file, target, 0)
    )
  }
  return [lines, startLineNum || 1]
}

function createIncludeCursor (reader, { file, src }, path, lineno) {
  return reader.$create_include_cursor(
    // eslint-disable-next-line no-new-wrappers
    Object.assign(new String(file), { src, parent: { file: reader.file, lineno: reader.lineno - 1 } }),
    path,
    lineno
  )
}

function log (severity, message, reader, sourceCursor, includeCursor = undefined) {
  const opts = includeCursor
    ? { source_location: sourceCursor, include_location: includeCursor }
    : { source_location: sourceCursor }
  reader.$logger()['$' + severity](reader.$message_with_context(message, Opal.hash(opts)))
}

function mapContainsValue (map, value) {
  for (const v of map.values()) {
    if (v === value) return true
  }
}

module.exports = IncludeProcessor
