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
      this.create_route_for(this.packages.js, adapter, Package);
      return this.create_route_for(this.packages.css, adapter, CssBundler);
    };

    AssetCompiler.prototype.compile_and_create_manifest = function(save_dir, manifest_name) {
      var manifest, _base, _base2;
      manifest_name || (manifest_name = (_base = this.packages).manifest_name || (_base.manifest_name = 'manifest.mf'));
      save_dir || (save_dir = (_base2 = this.packages).save_dir || (_base2.save_dir = './build'));
      save_dir = path.resolve(save_dir);
      if (!path.existsSync(save_dir)) fs.mkdirSync(save_dir);
      manifest = {};
      this.compile(this.packages.js, save_dir, manifest, Package);
      this.compile(this.packages.css, save_dir, manifest, CssBundler);
      return fs.writeFileSync(path.join(save_dir, manifest_name), util.format('%j', manifest));
    };

    AssetCompiler.prototype.create_route_for = function(package_data, adapter, packager) {
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

    AssetCompiler.prototype.compile = function(package_data, save_dir, manifest, packager) {
      var data, file_data, file_name, hashed_file_name, _results;
      _results = [];
      for (file_name in package_data) {
        data = package_data[file_name];
        file_name = path.basename(file_name);
        file_data = new packager(data).compile();
        hashed_file_name = md5Namer(file_name, file_data);
        fs.writeFileSync(path.join(save_dir, hashed_file_name), file_data);
        _results.push(manifest[file_name] = hashed_file_name);
      }
      return _results;
    };

    return AssetCompiler;

  })();

  module.exports = AssetCompiler;

}).call(this);
