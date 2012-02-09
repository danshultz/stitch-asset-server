(function() {
  var Options, fs, path;

  fs = require('fs');

  path = require('path');

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

    Options.prototype.testPublic = './test/public';

    Options.prototype.testPath = '/test';

    Options.prototype.specs = './test/specs';

    Options.prototype.specsPath = '/test/specs.js';

    Options.prototype.build_compiler_package = function() {
      var obj;
      obj = {
        js: {},
        css: {}
      };
      obj.js[this.jsPath] = {
        paths: this.paths,
        libs: this.libs,
        dependencies: this.dependencies
      };
      obj.css[this.cssPath] = this.css;
      return obj;
    };

    return Options;

  })();

  module.exports = Options;

}).call(this);
