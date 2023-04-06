'use strict'

const buildPlaybook = require('@antora/playbook-builder')
const cli = require('./commander')
const convict = require('@antora/playbook-builder/lib/solitary-convict') // drop lib segment in Antora 4
const ospath = require('path')
const userRequire = require('@antora/user-require-helper')

const { version: VERSION } = require('../package.json')

async function run (argv = process.argv) {
  return cli.parseAsync((argv = argv.slice(2)).length ? argv : ['help'], { from: 'user' })
}

function exitWithError (err, opts, msg = undefined) {
  let errMessage = String(
    err instanceof Error ? err.message : Object.assign((err = new Error(String(err))), { stack: undefined }).message
  )
  const name = errMessage.startsWith('asciidoctor: FAILED: ')
    ? (errMessage = errMessage.slice(21)) && 'asciidoctor'
    : cli.name()
  if (!msg) msg = errMessage
  const { configureLogger, getLogger } = requireLogger()
  if (!getLogger) return lastDitchExit(err, msg)
  if (!getLogger(null)) {
    configureLogger({ format: 'pretty', level: opts.silent ? 'silent' : 'fatal', failureLevel: 'fatal' })
  }
  if (opts.stacktrace) {
    getLogger(name).fatal(err, msg)
  } else {
    getLogger(name).fatal({ hint: 'Add the --stacktrace option to see the cause of the error.' }, msg)
  }
  return exit()
}

function exit () {
  return requireLogger()
    .finalizeLogger()
    .then((failOnExit) => process.exitCode || (process.exitCode = failOnExit ? 1 : 0))
}

function lastDitchExit (err, msg) {
  if (msg !== err.message) console.error(msg)
  console.error(err)
  process.exitCode = process.exitCode || 1
}

function getTTYColumns () {
  return +process.env.COLUMNS || process.stdout.columns || 80
}

function outputError (str, write) {
  write(str.replace(/^error: /, cli.name() + ': '))
}

function requireLogger (fromPath = undefined, moduleName = '@antora/logger') {
  try {
    return (
      requireLogger.cache ||
      (requireLogger.cache = fromPath ? userRequire(moduleName, { paths: [fromPath] }) : require(moduleName))
    ) // dynamic require('@antora/logger')
  } catch {
    return fromPath ? (requireLogger.cache = require(moduleName)) : {}
  }
}

cli
  .allowExcessArguments(false)
  .configureOutput({ getOutHelpWidth: getTTYColumns, getErrHelpWidth: getTTYColumns, outputError })
  .storeOptionsAsProperties()
  .name('antora')
  .version(
    {
      toString () {
        const generator = cli._findCommand('generate').getOptionValue('generator')
        const buffer = ['@antora/cli: ' + VERSION]
        let generatorVersion
        const generatorPackageJson = generator + '/package.json'
        try {
          generatorVersion = require(generatorPackageJson).version
        } catch {
          try {
            generatorVersion = require(require.resolve(generatorPackageJson, { paths: [''] })).version
          } catch {}
        }
        buffer.push(generator + ': ' + (generatorVersion || 'not installed'))
        return buffer.join('\n')
      },
    },
    '-v, --version',
    'Output the version of the CLI and default site generator.'
  )
  .description('A modular, multi-repository documentation site generator for AsciiDoc.')
  .usage('[options] [[command] [args]]')
  .helpOption('-h, --help', 'Output usage information.')
  .addHelpText('after', () => {
    const name = cli.name()
    return cli
      .createHelp()
      .wrap(
        ` \nRun '${name} <command> --help' to see options and examples for a command (e.g., ${name} generate --help).`,
        getTTYColumns(),
        0
      )
  })
  .option('-r, --require <library>', 'Require library (aka node module) or script path before executing command.')
  .on('option:require', (requireRequest) => (cli.requireRequests = cli.requireRequests || []).push(requireRequest))
  .option('--stacktrace', 'Print the stacktrace to the console if the application fails.')

cli
  .command('generate <playbook>', { isDefault: true })
  .description('Generate a documentation site as specified by <playbook>.')
  .optionsFromConvict(convict(buildPlaybook.defaultSchema), { exclude: 'playbook' })
  .trackOptions()
  .action(async (playbookFile, options, command) => {
    const errorOpts = { stacktrace: cli.stacktrace, silent: command.silent }
    const playbookDir = ospath.resolve(playbookFile, '..')
    const userRequireContext = { dot: playbookDir, paths: [playbookDir, __dirname] }
    if (cli.requireRequests) {
      try {
        cli.requireRequests.forEach((requireRequest) => userRequire(requireRequest, userRequireContext))
      } catch (err) {
        return exitWithError(err, errorOpts)
      }
    }
    const args = command.optionArgs.concat('--playbook', playbookFile)
    let generator, generatorPath, playbook
    try {
      playbook = buildPlaybook(args, process.env, buildPlaybook.defaultSchema, (config) => {
        try {
          generatorPath = userRequire.resolve((generator = config.get('antora.generator')), userRequireContext)
        } catch {}
        try {
          requireLogger(generatorPath).configureLogger(config.getModel('runtime.log'), playbookDir)
        } catch {}
      })
    } catch (err) {
      return exitWithError(err, errorOpts)
    }
    let generateSite
    try {
      generateSite =
        (generateSite = require(generatorPath || userRequire.resolve(generator, userRequireContext))).length === 1
          ? generateSite.bind(null, playbook)
          : generateSite.bind(null, args, process.env)
    } catch (err) {
      let msg = 'Generator not found or failed to load.'
      if (generator && generator.charAt() !== '.') msg += ` Try installing the '${generator}' package.`
      return exitWithError(err, errorOpts, msg)
    }
    return generateSite().then(exit, (err) => exitWithError(err, errorOpts))
  })
  .options.sort((a, b) => a.long.localeCompare(b.long))

cli.command('help [command]', { hidden: true }).action((name, options, command) => {
  if (name) {
    const helpCommand = cli._findCommand(name)
    if (helpCommand) {
      helpCommand.help()
    } else {
      const message = `error: unknown command '${name}'. See '${cli.name()} --help' for a list of commands.`
      cli.error(message, { code: 'commander.unknownCommand', exitCode: 1 })
    }
  } else {
    cli.help()
  }
})

cli.command('version', { hidden: true }).action(() => cli.emit('option:version'))

module.exports = run
