(function() {
  var crypto, md5Filenamer, path, utils;

  crypto = require('crypto');

  path = require('path');

  utils = require('./utils');

  md5Filenamer = function(filename, code) {
    var ext, hash, md5Hex;
    hash = crypto.createHash('md5');
    hash.update(code);
    md5Hex = hash.digest('hex');
    ext = path.extname(filename);
    return "" + (utils.stripExt(filename)) + "-" + md5Hex + ext;
  };

  module.exports = {
    md5Namer: md5Filenamer
  };

}).call(this);
