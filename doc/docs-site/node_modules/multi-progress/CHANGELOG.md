<!--
Detail changes here upon release

Format:

## Version <version> (<date>)

### New

- Large improvements
- Features

### Fixes

- Bug fixes
- Small improvements
-->

## Version 4.0.0 (2020-10-14)

API changed back to work like v1/v2, no longer having the user pass in Progress to a builder.

Progress is still a peer dependency like with v3, so that users can pick the exact version of progress they wish to use.

## Version 3.0.0 (2020-06-08)

Changed to work by passing through Progress like so:

```js
var Progress = require('progress');
var MultiProgrss = require('multi-progress')(Progress);

// spawn an instance with the optional stream to write to
var multi = new Multiprogress(process.stderr);

// create a progress bar
var bar = multi.newBar('  downloading [:bar] :percent :etas', {
  complete: '=',
  incomplete: ' ',
  width: 30,
  total: size
});

// `bar` is an instance of ProgressBar
// Use the progressbar API with it
```

`progress@2` is now a peer dependency.

## Version 2.0.0 (2016-06)

Do nothing if input stream is not a TTY console.

## Version 1.0.0 (2015-08)

Initial release