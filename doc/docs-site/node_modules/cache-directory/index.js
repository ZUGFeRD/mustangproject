/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

'use strict';

var xdg = require('xdg-basedir');
var home = require('os').homedir();
var path = require('path');

function cacheDir(appName) {
	switch (process.platform) {
	case 'win32':
		return process.env.APPDATA ? path.join(process.env.APPDATA, appName, 'Caches') : null;
	case 'darwin':
		return home ? path.join(home, 'Library/Caches', appName) : null;
	case 'linux':
		return xdg.cache ? path.join(xdg.cache, appName) : null;
	}

	return null;
}

module.exports = cacheDir;
