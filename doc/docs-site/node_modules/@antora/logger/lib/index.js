'use strict'

/**
 * Logger component for Antora
 *
 * Responsible for providing the infrastructure for logging, shaping, and
 * reporting application messages. The logger is typically configured once per
 * run of Antora. Each component then gets its own logger, which is a proxy of
 * a named child of the root logger. Messages can be emitted in a structured
 * (JSON) log format so they can be piped to a separate application for
 * processing/transport or emitted in a pretty format to make them easier for
 * an author to comprehend.
 *
 * @namespace logger
 */
module.exports = require('./logger')
