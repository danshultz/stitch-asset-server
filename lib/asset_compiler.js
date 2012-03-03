(function() {
  var AssetCompiler, CssBundler, Package, fs, md5Namer, path, resolve, util;

  fs = require('fs');

  path = require('path');

  util = require('util');

  resolve = path.resolve;

  CssBundler = require('./css_bundler').CssBundler;

  Package = require('./js_packager').Package;

  md5Namer = require('./file_namer').md5Namer;

  AssetCompiler = (function() {

    function AssetCompiler(packages) {
      this.packages = packages;
    }

    AssetCompiler.prototype.create_routes = function(adapter) {
      this._create_route_for(this.packages.js, adapter, Package);
      return this._create_route_for(this.packages.css, adapter, CssBundler);
    };

    AssetCompiler.prototype.compile = function(options) {
      var manifest, _base, _base2;
      if (options == null) options = {};
      options = Object.create(options);
      options.manifest_name || (options.manifest_name = (_base = this.packages).manifest_name || (_base.manifest_name = 'manifest.mf'));
      options.save_dir || (options.save_dir = (_base2 = this.packages).save_dir || (_base2.save_dir = './build'));
      options.save_dir = path.resolve(options.save_dir);
      options.hash_file_names = options.hash_file_names === void 0 ? true : options.hash_file_names;
      options.minify = options.minify === void 0 ? true : options.minify;
      if (!path.existsSync(options.save_dir)) fs.mkdirSync(options.save_dir);
      manifest = {};
      this._compile(this.packages.js, manifest, Package, options);
      this._compile(this.packages.css, manifest, CssBundler, options);
      return fs.writeFileSync(path.join(options.save_dir, options.manifest_name), util.format('%j', manifest));
    };

    AssetCompiler.prototype._create_route_for = function(package_data, adapter, packager) {
      var data, file_name, _results;
      _results = [];
      for (file_name in package_data) {
        data = package_data[file_name];
        _results.push((function(file_name, data) {
          var package;
          package = new packager(data);
          return adapter.route('get', file_name, package);
        })(file_name, data));
      }
      return _results;
    };

    AssetCompiler.prototype._compile = function(package_data, manifest, packager, options) {
      var data, file_data, file_name, hashed_file_name, _results;
      _results = [];
      for (file_name in package_data) {
        data = package_data[file_name];
        file_name = path.basename(file_name);
        file_data = new packager(data).compile(options.minify);
        hashed_file_name = options.hash_file_names ? md5Namer(file_name, file_data) : file_name;
        fs.writeFileSync(path.join(options.save_dir, hashed_file_name), file_data);
        _results.push(manifest[file_name] = hashed_file_name);
      }
      return _results;
    };

    return AssetCompiler;

  })();

  module.exports = AssetCompiler;

}).call(this);
