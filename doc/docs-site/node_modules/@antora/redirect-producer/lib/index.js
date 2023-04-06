'use strict'

/**
 * Redirect Producer component for Antora
 *
 * Produces HTTP redirection configuration suitable for the redirect facility
 * provided by the target environment (e.g., static bounce pages, nginx
 * rewrite rules, mod_rewrite rules, netlify redirects file, etc.).
 */
module.exports = require('./produce-redirects')
