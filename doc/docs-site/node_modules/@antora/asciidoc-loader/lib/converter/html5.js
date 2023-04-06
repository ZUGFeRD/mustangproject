'use strict'

const Opal = global.Opal
const { $Antora } = require('../constants')
const $logger = Symbol('logger')
const $imageRefCallback = Symbol('imageRefCallback')
const $resourceRefCallback = Symbol('resourceRefCallback')
const converterFor = Opal.Asciidoctor.Converter.$for.bind(Opal.Asciidoctor.Converter)

let classDef

const defineHtml5Converter = () => {
  const superclass = converterFor('html5')
  if (classDef) {
    if (classDef.$superclass() !== superclass) {
      Object.setPrototypeOf(classDef.$$prototype, (classDef.$$super = superclass).$$prototype)
    }
    return classDef
  }

  classDef = Opal.klass(Opal.Antora || Opal.module(null, 'Antora', $Antora), superclass, 'Html5Converter')

  Opal.defn(classDef, '$initialize', function initialize (backend, opts, callbacks) {
    Opal.send(this, Opal.find_super_dispatcher(this, 'initialize', initialize), [backend, opts])
    this[$resourceRefCallback] = callbacks.onResourceRef
    this[$imageRefCallback] = callbacks.onImageRef
  })

  Opal.defn(classDef, '$convert_inline_anchor', function convertInlineAnchor (node) {
    if (node.getType() === 'xref') {
      let callback
      let refSpec =
        node.getAttribute('path') ||
        // NOTE detect and convert self reference into a page reference
        (node.target === '#' &&
          node.getText() == null &&
          node.getAttribute('refid') == null &&
          node.getDocument().getAttribute('page-relative-src-path'))
      if (refSpec && (callback = this[$resourceRefCallback])) {
        const attrs = node.getAttributes()
        const fragment = attrs.fragment
        if (fragment) refSpec += '#' + fragment
        const { content, target, family, internal, unresolved } = callback(refSpec, node.getText())
        let type
        if (internal) {
          type = 'xref'
          attrs.path = undefined
          attrs.fragment = attrs.refid = fragment
        } else {
          type = 'link'
          if (unresolved) {
            logUnresolved(this, node, refSpec, 'xref')
            attrs.role = `xref unresolved${attrs.role ? ' ' + attrs.role : ''}`
          } else {
            attrs.role = `xref ${family}${attrs.role ? ' ' + attrs.role : ''}`
          }
        }
        const attributes = Opal.hash2(Object.keys(attrs), attrs)
        const options = Opal.hash2(['type', 'target', 'attributes'], { type, target, attributes })
        node = Opal.Asciidoctor.Inline.$new(node.getParent(), 'anchor', content, options)
      }
    }
    return Opal.send(this, Opal.find_super_dispatcher(this, 'convert_inline_anchor', convertInlineAnchor), [node])
  })

  Opal.defn(classDef, '$convert_image', function convertImage (node) {
    return Opal.send(this, Opal.find_super_dispatcher(this, 'convert_image', convertImage), [
      transformImageNode(this, node, node.getAttribute('target')),
    ])
  })

  Opal.defn(classDef, '$convert_inline_image', function convertInlineImage (node) {
    return Opal.send(this, Opal.find_super_dispatcher(this, 'convert_inline_image', convertInlineImage), [
      transformImageNode(this, node, node.getTarget()),
    ])
  })

  return classDef
}

function transformImageNode (converter, node, imageTarget) {
  if (matchesResourceSpec(imageTarget)) {
    const imageRefCallback = converter[$imageRefCallback]
    if (imageRefCallback) {
      const alt = node.getAttribute('alt')
      if (node.isAttribute('default-alt', alt)) node.setAttribute('alt', alt.split(/[@:]/).pop())
      Opal.defs(node, '$image_uri', (imageSpec) => {
        const imageSrc = imageRefCallback(imageSpec)
        if (imageSrc) return imageSrc
        logUnresolved(converter, node, imageSpec, 'image')
        const role = node.getAttribute('role')
        node.setAttribute('role', `unresolved${role ? ' ' + role : ''}`)
        return imageSpec
      })
    }
  }
  if (node.hasAttribute('link')) {
    if (node.isAttribute('link', 'self')) {
      const superImageUri = node.$image_uri.bind(node)
      Opal.defs(node, '$image_uri', () => {
        const imageSrc = superImageUri(imageTarget)
        if (!imageSrc.startsWith('data:')) node.setAttribute('link', imageSrc)
        return imageSrc
      })
    }
  } else if (node.hasAttribute('xref')) {
    let resourceRefCallback
    const refSpec = node.getAttribute('xref') || ''
    if (refSpec.charAt() === '#') {
      node.setAttribute('link', refSpec)
    } else if (hasExt(refSpec) && (resourceRefCallback = converter[$resourceRefCallback])) {
      const { target, family, internal, unresolved } = resourceRefCallback(refSpec, refSpec)
      if (!internal) {
        if (unresolved) logUnresolved(converter, node, refSpec, 'xref on image')
        const role = node.getAttribute('role')
        node.setAttribute('role', `xref-${unresolved ? 'unresolved' : family}${role ? ' ' + role : ''}`)
      }
      node.setAttribute('link', target)
    } else {
      node.setAttribute('link', '#' + refSpec)
    }
  }
  return node
}

function hasExt (target) {
  if (target.endsWith('.adoc')) return true
  const hashIdx = target.indexOf('#')
  if (~hashIdx) target = target.substr(0, hashIdx)
  const lastDotIdx = target.lastIndexOf('.')
  return ~lastDotIdx && !~target.indexOf('/', lastDotIdx)
}

function matchesResourceSpec (target) {
  return !(~target.indexOf(':') && (~target.indexOf('://') || (target.startsWith('data:') && ~target.indexOf(','))))
}

function getLogger (converter) {
  return converter[$logger] || (converter[$logger] = converter.$logger())
}

function logUnresolved (converter, node, resourceSpec, label) {
  let msg = 'target of ' + label + ' not found: ' + resourceSpec
  const loc = (node.isInline() ? node.getParent() : node).getSourceLocation()
  if (loc) msg = converter.$message_with_context(msg, Opal.hash2(['source_location'], { source_location: loc }))
  getLogger(converter).error(msg)
}

module.exports = defineHtml5Converter
