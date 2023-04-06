'use strict'

const { Command } = require('commander')

Command.prototype.optionsFromConvict = function (convictConfig, opts = {}) {
  let exclude = opts.exclude
  if (exclude && !Array.isArray(exclude)) exclude = [exclude]
  getOptions(convictConfig).forEach(({ name, form, description, default: default_, choices }) => {
    if (exclude && exclude.includes(name)) return
    this.addOption(
      choices
        ? this.createOption(form, description).default(default_, default_).choices(choices)
        : this.createOption(form, description).default(default_, default_)
    )
  })
  return this
}

function getOptions (config) {
  //return collectOptions(config._schema._cvtProperties).sort((a, b) => a.name.localeCompare(b.name))
  return collectOptions(config._schema._cvtProperties)
}

function collectOptions (props, context = undefined) {
  return Object.entries(props).reduce((accum, [key, value]) => {
    if ('_cvtProperties' in value) {
      accum.push(...collectOptions(value._cvtProperties, context ? `${context}.${key}` : key))
    } else if ('arg' in value) {
      const { arg, format, default: default_ } = value
      const option = { name: arg, form: `--${arg}`, description: value.doc, format }
      if (Array.isArray(format)) {
        option.form += ' <choice>'
        const choices = format.slice()
        const value = () => choices
        Object.defineProperties((option.choices = choices), { map: { value }, slice: { value } })
      } else if (format !== 'boolean') {
        option.form += ` <${arg.substr(arg.lastIndexOf('-') + 1, arg.length)}>`
      }
      if (default_ === null) {
        //option.mandatory = true
        option.description += ' (required)'
      } else if (default_ && default_.constructor !== Object) {
        option.default = default_
      }
      accum.push(option)
      //if (format === 'boolean') accum.push({ form: `--no-${arg}`, format: format })
    }
    return accum
  }, [])
}
