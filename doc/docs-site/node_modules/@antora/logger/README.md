# Antora Logger

The Logger is a component in Antora responsible for providing the infrastructure for logging, shaping, and reporting application messages.
The logger is typically configured once per run of Antora.
Each component then gets its own logger, which is a proxy of a named child of the root logger.
Messages can be emitted in a structured (JSON) log format so they can be piped to a separate application for processing/transport or emitted in a pretty format to make them easier for an author to comprehend.

[Antora](https://antora.org) is a modular static site generator designed for creating documentation sites from AsciiDoc documents.
Its site generator aggregates documents from versioned content repositories and processes them using [Asciidoctor](https://asciidoctor.org).

## Copyright and License

Copyright (C) 2017-present [OpenDevise Inc.](https://opendevise.com) and the [Antora Project](https://antora.org).

Use of this software is granted under the terms of the [Mozilla Public License Version 2.0](https://www.mozilla.org/en-US/MPL/2.0/) (MPL-2.0).
