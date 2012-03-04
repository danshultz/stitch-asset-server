(function() {
  var Options, fs, path, toArray;

  fs = require('fs');

  path = require('path');

  toArray = require('./utils').toArray;

  Options = (function() {

    function Options(overrides) {
      var key, value, _ref;
      if (overrides == null) overrides = null;
      for (key in overrides) {
        value = overrides[key];
        this[key] = value;
      }
      _ref = this.readSlug();
      for (key in _ref) {
        value = _ref[key];
        this[key] = value;
      }
    }

    Options.prototype.readSlug = function(slug) {
      if (slug == null) slug = this.slug;
      if (!(slug && path.existsSync(slug))) return {};
      return JSON.parse(fs.readFileSync(slug, 'utf-8'));
    };

    Options.prototype.slug = './slug.json';

    Options.prototype.css = './css';

    Options.prototype.libs = [];

    Options.prototype.public = './public';

    Options.prototype.paths = ['./app'];

    Options.prototype.dependencies = [];

    Options.prototype.port = process.env.PORT || 9294;

    Options.prototype.cssPath = '/application.css';

    Options.prototype.jsPath = '/application.js';

    Options.prototype.test = './test';

    Options.prototype.testPageTemplate = '';

    Options.prototype.testPublic = './test/public';

    Options.prototype.testPath = '/test';

    Options.prototype.specs = './test/specs';

    Options.prototype.specsPath = '/test/specs.js';

    Options.prototype.build_compiler_package = function() {
      var key, obj, value, _ref, _ref2;
      obj = {
        js: {},
        css: {}
      };
      if (typeof this.jsPath === 'string') {
        obj.js[this.jsPath] = this.create_js_package(this.paths, this.libs, this.dependencies);
      } else {
        _ref = this.jsPath;
        for (key in _ref) {
          value = _ref[key];
          if (typeof value === 'string' || value instanceof Array) {
            value = this.create_js_package(value);
          }
          obj.js[key] = value;
        }
      }
      if (typeof this.cssPath === 'string') {
        obj.css[this.cssPath] = this.css;
      } else {
        _ref2 = this.cssPath;
        for (key in _ref2) {
          value = _ref2[key];
          obj.css[key] = value;
        }
      }
      return obj;
    };

    Options.prototype.create_js_package = function(paths, libs, dependencies) {
      if (libs == null) libs = [];
      if (dependencies == null) dependencies = [];
      return {
        paths: toArray(paths),
        libs: libs,
        dependencies: dependencies
      };
    };

    return Options;

  })();

  module.exports = Options;

}).call(this);
