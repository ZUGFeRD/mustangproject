'use strict'

/**
 * The command line interface (CLI) for Antora.
 *
 * Provides a built-in set of commands to run Antora. The default command is
 * generate. The generate command builds the specified playbook, configures the
 * logger, then requires and invokes the generator function. When the generator
 * function completes or fails, the generate command finalizes the logger and
 * exits with the specified exit code.
 *
 * @namespace cli
 */
module.exports = require('./cli')
