# `cache-directory`

Find the proper cache directory based on operating system

## Installation

    npm install cache-directory

## Usage

`cache-directory` takes one argument, the app name.

```js
var cacheDir = require('cache-directory');

console.log(cacheDir('myApp'));
```

## Caveats

When run on OS X, `cache-directory` assumes it isn't run in a sandboxed process environment. If it is, it will probably break. Additionally, the app name is used instead of the [conventional][1] bundle identifier (for simplicity and because many `cache-directory` consumers won't necessarily _have_ a bundle identifier).

If a suitable cache directory can't be found, `cache-directory` will return `null`. You need to handle this case. A reasonable course of action would be to use a temp directory, for which you can use the [`cache-or-tmp-directory`][2] module.

## License

LGPL 3.0+

## Author

Alex Jordan <alex@strugee.net>

 [1]: https://developer.apple.com/library/prerelease/content/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/MacOSXDirectories/MacOSXDirectories.html#//apple_ref/doc/uid/TP40010672-CH10-SW1
 [2]: https://npmjs.com/package/cache-or-tmp-directory
