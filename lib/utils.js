(function() {
  var flatten, fs, path, toArray, watch,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  fs = require('fs');

  path = require('path');

  exports.flatten = flatten = function(array, results) {
    var item, _i, _len;
    if (results == null) results = [];
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      item = array[_i];
      if (Array.isArray(item)) {
        flatten(item, results);
      } else {
        results.push(item);
      }
    }
    return results;
  };

  exports.toArray = toArray = function(value) {
    if (value == null) value = [];
    if (Array.isArray(value)) {
      return value;
    } else {
      return [value];
    }
  };

  exports.stripExt = function(filePath) {
    var lastDotIndex;
    if ((lastDotIndex = filePath.lastIndexOf('.')) >= 0) {
      return filePath.slice(0, lastDotIndex);
    } else {
      return filePath;
    }
  };

  exports.watch = watch = function(filesOrDirs, callback) {
    var dir, uniqWatchDirs, watchTree, _i, _len, _results;
    watchTree = require('watch').watchTree;
    filesOrDirs = flatten(toArray(filesOrDirs));
    uniqWatchDirs = [];
    _results = [];
    for (_i = 0, _len = filesOrDirs.length; _i < _len; _i++) {
      dir = filesOrDirs[_i];
      if (!path.existsSync(dir)) continue;
      dir = fs.statSync(dir).isDirectory() ? dir : path.dirname(dir);
      if (__indexOf.call(uniqWatchDirs, dir) >= 0) continue;
      uniqWatchDirs.push(dir);
      console.log("Now watching directory " + dir + " for changes");
      _results.push(require('watch').watchTree(dir, callback));
    }
    return _results;
  };

  exports.stuff = function() {};

}).call(this);
