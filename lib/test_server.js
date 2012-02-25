(function() {
  var CssBundler, Package, TestServer, fs, path;

  fs = require('fs');

  path = require('path');

  CssBundler = require('./css_bundler').CssBundler;

  Package = require('./js_packager').Package;

  TestServer = (function() {

    function TestServer(options) {
      this.options = options;
    }

    TestServer.prototype.create_routes = function(adapter) {
      if (path.existsSync(this.options.specs)) {
        return this._create_test_routes(adapter);
      }
    };

    TestServer.prototype._create_test_routes = function(adapter) {
      var package, test_page,
        _this = this;
      package = new Package({
        paths: this.options.specs,
        identifier: 'specs',
        dependencies: 'jqueryify'
      });
      adapter.route('get', this.options.specsPath, package);
      test_page = require('../assets/test_page');
      adapter.route('get', '/test', {
        headers: {
          'Content-Type': 'text/html'
        },
        compile: function() {
          return test_page();
        }
      });
      adapter.route('get', '/test/assets/mocha.js', {
        headers: {
          'Content-Type': 'text/javascript'
        },
        compile: function() {
          return _this._read_test_asset('mocha/mocha');
        }
      });
      adapter.route('get', '/test/assets/mocha.css', {
        headers: {
          'Content-Type': 'text/css'
        },
        compile: function() {
          return _this._read_test_asset('mocha/mocha.css');
        }
      });
      return adapter.route('get', '/test/assets/chai.js', {
        headers: {
          'Content-Type': 'text/javascript'
        },
        compile: function() {
          return _this._read_test_asset('chai/chai');
        }
      });
    };

    TestServer.prototype._read_test_asset = function(asset) {
      path = require.resolve(asset);
      return fs.readFileSync(path);
    };

    return TestServer;

  })();

  module.exports = TestServer;

}).call(this);
