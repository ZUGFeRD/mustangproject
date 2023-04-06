'use strict';

var fs = require('fs');
var constants = fs.constants;
var yauzl = require('yauzl');
var File = require('../vinyl-zip');
var queue = require('queue');
var through = require('through');
var map = require('through2').obj;

function modeFromEntry(entry) {
	var attr = entry.externalFileAttributes >> 16 || 33188;

	// The following constants are not available on all platforms:
	// 448 = constants.S_IRWXU, 56 = constants.S_IRWXG, 7 = constants.S_IRWXO
	return [448, 56, 7]
		.map(function (mask) { return attr & mask; })
		.reduce(function (a, b) { return a + b; }, attr & constants.S_IFMT);
}

function mtimeFromEntry(entry) {
	return yauzl.dosDateTimeToDate(entry.lastModFileDate, entry.lastModFileTime);
}

function toStream(zip) {
	var result = through();
	var q = queue();
	var didErr = false;

	q.on('error', function (err) {
		didErr = true;
		result.emit('error', err);
	});

	zip.on('entry', function (entry) {
		if (didErr) { return; }

		var stat = new fs.Stats();
		stat.mode = modeFromEntry(entry);
		stat.mtime = mtimeFromEntry(entry);

		// directories
		if (/\/$/.test(entry.fileName)) {
			stat.mode = (stat.mode & ~constants.S_IFMT) | constants.S_IFDIR;
		}

		var file = {
			path: entry.fileName,
			stat: stat
		};

		if (stat.isFile()) {
			stat.size = entry.uncompressedSize;
			if (entry.uncompressedSize === 0) {
				file.contents = Buffer.alloc(0);
				result.emit('data', new File(file));
			} else {
				q.push(function (cb) {
					zip.openReadStream(entry, function (err, readStream) {
						if (err) { return cb(err); }
						file.contents = readStream;
						result.emit('data', new File(file));
						cb();
					});
				});

				q.start();
			}
		} else if (stat.isSymbolicLink()) {
			stat.size = entry.uncompressedSize;
			q.push(function (cb) {
				zip.openReadStream(entry, function (err, readStream) {
					if (err) { return cb(err); }
					file.symlink = '';
					readStream.on('data', function (c) { file.symlink += c; });
					readStream.on('error', cb);
					readStream.on('end', function () {
						result.emit('data', new File(file));
						cb();
					});
				});
			});

			q.start();
		} else if (stat.isDirectory()) {
			result.emit('data', new File(file));
		} else {
			result.emit('data', new File(file));
		}
	});

	zip.on('end', function () {
		if (didErr) {
			return;
		}

		if (q.length === 0) {
			result.end();
		} else {
			q.on('end', function () {
				result.end();
			});
		}
	});

	return result;
}

function unzipFile(zipPath) {
	var result = through();
	yauzl.open(zipPath, function (err, zip) {
		if (err) { return result.emit('error', err); }
		toStream(zip).pipe(result);
	});
	return result;
}

function unzip() {
	return map(function (file, enc, next) {
		if (!file.isBuffer()) return next(new Error('Only supports buffers'));
		yauzl.fromBuffer(file.contents, (err, zip) => {
			if (err) return this.emit('error', err);
			toStream(zip)
				.on('error', next)
				.on('data', (data) => this.push(data))
				.on('end', next);
		});
	});
}

function src(zipPath) {
	return zipPath ? unzipFile(zipPath) : unzip();
}

module.exports = src;
