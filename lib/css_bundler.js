(function() {
  var CssBundler, compilers, resolve, toArray;

  resolve = require('path').resolve;

  compilers = require('./compilers');

  toArray = require('./utils').toArray;

  CssBundler = (function() {

    function CssBundler(files) {
      this.files = toArray(files).map(resolve).map(require.resolve);
    }

    CssBundler.prototype.compile = function() {
      return this.files.map(this.rerequire).join('');
    };

    CssBundler.prototype.createServer = function() {
      var _this = this;
      return function(req, res, next) {
        var content;
        content = _this.compile();
        res.writeHead(200, {
          'Content-Type': 'text/css'
        });
        return res.end(content);
      };
    };

    CssBundler.prototype.headers = {
      'Content-Type': 'text/css'
    };

    CssBundler.prototype.rerequire = function(file) {
      delete require.cache[file];
      return require(file);
    };

    return CssBundler;

  })();

  module.exports = {
    CssBundler: CssBundler,
    createPackage: function(paths) {
      return new CssBundler(paths);
    }
  };

}).call(this);
