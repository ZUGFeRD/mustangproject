# Antora Redirect Producer

The redirect producer is the component in Antora responsible for producing redirects (HTTP redirections) to a given page from its registered aliases.
These redirects are derived from alias entries in the content catalog.

This component can produce redirects using different facilities.
If the deployment environment does not offer redirect capabilities, Antora can output static HTML redirect pages (for client-side redirection).
If redirect capabilities are available in the deployment environment, such as rewrite rules in nginx, Antora can output a suitable server configuration file (for server-side redirection).

[Antora](https://antora.org) is a modular static site generator designed for creating documentation sites from AsciiDoc documents.
Its site generator aggregates documents from versioned content repositories and processes them using [Asciidoctor](https://asciidoctor.org).

## Copyright and License

Copyright (C) 2017-present [OpenDevise Inc.](https://opendevise.com) and the [Antora Project](https://antora.org).

Use of this software is granted under the terms of the [Mozilla Public License Version 2.0](https://www.mozilla.org/en-US/MPL/2.0/) (MPL-2.0).
