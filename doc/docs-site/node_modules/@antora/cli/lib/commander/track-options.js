'use strict'

const { Command } = require('commander')

Command.prototype.trackOptions = function () {
  const optionArgs = (this.optionArgs = [])
  for (const eventName of this.eventNames().filter((name) => name.startsWith('option:'))) {
    this.on(eventName, function () {
      optionArgs.push(`--${eventName.slice(7)}`)
      if (arguments.length) optionArgs.push(arguments[0])
    })
  }
  return this
}
