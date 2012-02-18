(function() {
  var AssetCompiler, AssetServer, ExpressAdapter, Options, path;

  path = require('path');

  AssetCompiler = require('./asset_compiler');

  Options = require('./options');

  ExpressAdapter = require('./adapters').ExpressAdapter;

  AssetServer = (function() {

    AssetServer.create = function(options, callback) {
      return (new this(options)).create(callback);
    };

    AssetServer.compile = function(save_dir, manifest_name) {
      return (new this).compile(save_dir, manifest_name);
    };

    function AssetServer(options) {
      if (options == null) options = {};
      this.options = new Options(options);
    }

    AssetServer.prototype.create = function(callback) {
      var adapter, compiler;
      adapter = new ExpressAdapter();
      compiler = new AssetCompiler(this.options.build_compiler_package());
      compiler.create_routes(adapter);
      adapter.static(this.options.public);
      return adapter.run(this.options.port, callback);
    };

    AssetServer.prototype.compile = function(save_dir, manifest_name) {
      var compiler;
      compiler = new AssetCompiler(this.options.build_compiler_package());
      return compiler.compile_and_create_manifest(save_dir, manifest_name);
    };

    AssetServer.prototype.include = function(server) {
      if (this.server_is_strata(server)) {
        return console.log("is strata");
      } else {
        return console.log("expecting express");
      }
    };

    AssetServer.prototype.server_is_strata = function(server) {
      var strata;
      try {
        strata = require('strata');
        return server instanceof strata.Builder;
      } catch (err) {
        return false;
      }
    };

    return AssetServer;

  })();

  module.exports = AssetServer;

}).call(this);
