# multi-progress

This module adds a layer on top of the API of [progress](https://github.com/tj/node-progress) that allows for multiple progress bars.

### Usage

Install with npm: `npm install multi-progress`

`multi-progress@4` requires `progress@2` as a peer dependency.
If you don't already have `progress@2` as a dependency, add it like so: `npm install progress@2`.

```js
// require the library
var Multiprogress = require('multi-progress');

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

More detailed usage examples are available in the following projects:

- [rslashimg](https://github.com/pitaj/rslashimg/blob/master/library.js#L14-L58)
