'use strict'

module.exports = {
  playbook: {
    doc: 'Location of the playbook file.',
    format: String,
    default: undefined,
    arg: 'playbook',
  },
  antora: {
    generator: {
      doc: 'A require request for the generator package name or script to use.',
      format: String,
      default: '@antora/site-generator',
      arg: 'generator',
    },
    extensions: {
      doc:
        'A list of extensions that listen for lifecycle events. ' +
        'Each extension is specified as a require request string or an object with a require key.',
      format: 'require-array',
      default: [],
      arg: 'extension',
      preserve: ['data'],
    },
  },
  site: {
    start_page: {
      doc: 'The start page for the site, redirected from the site index.',
      format: String,
      default: undefined,
      arg: 'start-page',
    },
    title: {
      doc: 'The title of the site.',
      format: String,
      default: undefined,
      arg: 'title',
    },
    url: {
      doc: 'The base URL (absolute URL or pathname) of the published site. Should not include a trailing slash.',
      format: 'url-or-pathname',
      default: undefined,
      arg: 'url',
      env: 'URL',
    },
    robots: {
      doc: 'Controls generation of robots.txt if site.url is set (allowed values: allow, disallow, or custom string).',
      format: String,
      default: undefined,
    },
    keys: {
      doc: 'An API key (in the form name=value) to pass to the UI model. May be specified multiple times.',
      format: 'primitive-map',
      default: {},
      arg: 'key',
    },
    // NOTE used to map env var for site.keys.google_analytics key
    __private__google_analytics_key: {
      doc: 'The environment variable mapping for the Google Analytics account key.',
      format: String,
      default: undefined,
      env: 'GOOGLE_ANALYTICS_KEY',
    },
  },
  content: {
    branches: {
      doc: 'The default branch pattern to use when no specific pattern is provided.',
      format: 'array-or-string',
      default: ['HEAD', 'v{0..9}*'],
    },
    edit_url: {
      doc: 'The default edit URL setting when no specific setting is provided.',
      format: 'boolean-or-string',
      default: true,
    },
    sources: {
      doc: 'The list of git repository urls, references, and start paths to use as content sources.',
      format: Array,
      default: [],
      preserve: ['version'],
    },
    tags: {
      doc: 'The default tag pattern to use when no specific pattern is provided.',
      format: 'array-or-string',
      default: undefined,
    },
  },
  ui: {
    bundle: {
      url: {
        doc: 'The URL of the UI bundle. Can be a path on the local filesystem.',
        format: String,
        arg: 'ui-bundle-url',
        default: null,
      },
      snapshot: {
        doc: 'Whether the bundle URL points to a snapshot that changes over time.',
        format: Boolean,
        default: false,
      },
      start_path: {
        doc: 'The relative path inside the bundle from which to start reading files.',
        format: String,
        default: '',
      },
    },
    output_dir: {
      doc: 'The output directory path relative to the site root where the UI files should be written.',
      format: String,
      default: '_',
    },
    default_layout: {
      doc: 'The default layout to apply to pages that do not specify a layout.',
      format: String,
      default: undefined,
    },
    supplemental_files: {
      doc: 'Supplemental file list or a directory of files to append to the UI bundle.',
      format: 'dir-or-virtual-files',
      default: undefined,
    },
  },
  asciidoc: {
    attributes: {
      doc: 'A document attribute to set on each page. May be specified multiple times.',
      format: 'map',
      default: {},
      arg: 'attribute',
      preserve: true,
    },
    extensions: {
      doc:
        'A list of extensions to register either globally or per instance of the AsciiDoc processor. ' +
        'Each extension is specified as a require request string.',
      format: Array,
      default: [],
    },
    sourcemap: {
      doc: 'Enables the sourcemap option on the AsciiDoc processor, which adds file and line information to blocks.',
      format: Boolean,
      default: false,
      arg: 'asciidoc-sourcemap',
    },
  },
  git: {
    credentials: {
      path: {
        doc: 'The path to a git credentials file matching the format used by git-credential-store.',
        format: String,
        default: undefined,
        arg: 'git-credentials-path',
        env: 'GIT_CREDENTIALS_PATH',
      },
      contents: {
        doc: 'The git credentials data matching the format used by git-credentials-store (optionally comma-separated).',
        format: String,
        default: undefined,
        env: 'GIT_CREDENTIALS',
      },
    },
    ensure_git_suffix: {
      doc: 'Instructs the git client to automatically append .git to the repository URL if absent.',
      format: Boolean,
      default: true,
    },
    fetch_concurrency: {
      doc: 'The maximum number of fetch or clone operations that are permitted to run at once. Use 0 for unlimited.',
      format: 'int',
      default: 0,
    },
    plugins: {
      credential_manager: {
        doc: 'A require request for a plugin to replace the built-in credential manager used by the git client.',
        format: String,
        default: undefined,
      },
      http: {
        doc: 'A require request for a plugin to replace the built-in HTTP client used by the git client.',
        format: String,
        default: undefined,
      },
    },
  },
  network: {
    http_proxy: {
      doc: 'The URL of the proxy to use for HTTP URLs.',
      format: 'url',
      default: undefined,
      arg: 'http-proxy',
      env: 'http_proxy',
    },
    https_proxy: {
      doc: 'The URL of the proxy to use for HTTPS URLs.',
      format: 'url',
      default: undefined,
      arg: 'https-proxy',
      env: 'https_proxy',
    },
    no_proxy: {
      doc: 'A comma-separated list of domains and IPs that should not be proxied.',
      format: String,
      default: undefined,
      arg: 'noproxy',
      env: 'no_proxy',
    },
  },
  runtime: {
    cache_dir: {
      doc: 'The cache directory. (default: antora folder under cache dir for current user)',
      format: String,
      default: undefined,
      arg: 'cache-dir',
      env: 'ANTORA_CACHE_DIR',
    },
    fetch: {
      doc: 'Download updates from remote resources. Includes content repositories and the UI bundle.',
      format: Boolean,
      default: false,
      arg: 'fetch',
    },
    quiet: {
      doc: 'Do not write any messages to stdout.',
      format: Boolean,
      default: false,
      arg: 'quiet',
    },
    silent: {
      doc: 'Suppress all messages.',
      format: Boolean,
      default: false,
      arg: 'silent',
    },
    log: {
      level: {
        doc: 'Set the minimum log level of messages that get logged.',
        format: ['all', 'debug', 'info', 'warn', 'error', 'fatal', 'silent'],
        default: 'warn',
        arg: 'log-level',
        env: 'ANTORA_LOG_LEVEL',
      },
      level_format: {
        doc: 'Set the format to use for the log level in structured log messages.',
        format: ['number', 'label'],
        default: 'label',
        arg: 'log-level-format',
        env: 'ANTORA_LOG_LEVEL_FORMAT',
      },
      failure_level: {
        doc: 'Set the log level tolerance that, when exceeded, will cause the application to fail on exit.',
        format: ['warn', 'error', 'fatal', 'none'],
        default: 'fatal',
        arg: 'log-failure-level',
        env: 'ANTORA_LOG_FAILURE_LEVEL',
      },
      format: {
        doc: 'Set the format of log messages. Defaults to pretty if CI=true or stdout is a TTY, json otherwise.',
        format: ['json', 'pretty'],
        default: 'auto',
        arg: 'log-format',
        env: 'ANTORA_LOG_FORMAT',
      },
      destination: {
        file: {
          doc: 'Write log messages to this file or stream. Defaults to stderr if format is pretty, stdout otherwise.',
          format: String,
          default: undefined,
          arg: 'log-file',
          env: 'ANTORA_LOG_FILE',
        },
        append: {
          doc: 'Whether to append messages to the log file if it already exists.',
          format: Boolean,
          default: true,
        },
        buffer_size: {
          doc: 'The size of the log buffer that must be exceeded before writing a chunk to the destination.',
          format: 'int',
          default: 0,
        },
        sync: {
          doc: 'Whether to immediately flush messages to the destination when the buffer size is exceeded.',
          format: Boolean,
          default: true,
        },
      },
    },
  },
  urls: {
    html_extension_style: {
      doc: 'The user-facing URL extension to use for HTML pages.',
      format: ['default', 'drop', 'indexify'],
      default: 'default',
      arg: 'html-url-extension-style',
    },
    latest_version_segment_strategy: {
      doc: 'The strategy to use for cloaking the latest version or prerelease version segment in the URL.',
      format: ['replace', 'redirect:to', 'redirect:from'],
      default: undefined,
    },
    latest_prerelease_version_segment: {
      doc: 'The value to use instead of the latest prerelease version segment in the URL.',
      format: String,
      default: undefined,
    },
    latest_version_segment: {
      doc: 'The value to use instead of the latest version segment in the URL.',
      format: String,
      default: undefined,
    },
    redirect_facility: {
      doc: 'The facility for handling page alias and start page redirections.',
      format: ['disabled', 'gitlab', 'httpd', 'netlify', 'nginx', 'static'],
      default: 'static',
      arg: 'redirect-facility',
    },
  },
  output: {
    clean: {
      doc: 'Remove destination path before publishing (fs only).',
      format: Boolean,
      default: false,
      arg: 'clean',
    },
    dir: {
      doc: 'The directory where the site should be published. (default: build/site)',
      format: String,
      default: undefined,
      arg: 'to-dir',
    },
    destinations: {
      doc: 'A list of destinations where the generated site should be published.',
      format: Array,
      default: undefined,
    },
  },
  [Symbol.for('convict.beforeValidate')]: ({ getEnv, _instance: data, _schema: schema }) => {
    const runtime = data.runtime
    const log = runtime.log
    if (log.format === 'auto') {
      const env = getEnv()
      log.format = env.CI === 'true' || (env.IS_TTY || String(process.stdout.isTTY)) === 'true' ? 'pretty' : 'json'
    }
    if (runtime.silent) {
      if (runtime.quiet === false) runtime.quiet = true
      if (runtime.log.level !== 'silent') runtime.log.level = 'silent'
    }
    const site = data.site
    if (site.__private__google_analytics_key != null) site.keys.google_analytics = site.__private__google_analytics_key
    delete site.__private__google_analytics_key
    delete schema._cvtProperties.site._cvtProperties.__private__google_analytics_key
  },
}
