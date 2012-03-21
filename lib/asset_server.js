(function() {
  var AssetCompiler, AssetServer, ExpressAdapter, Options, TestServer;

  AssetCompiler = require('./asset_compiler');

  Options = require('./options');

  ExpressAdapter = require('./adapters').ExpressAdapter;

  TestServer = require('./test_server');

  AssetServer = (function() {

    AssetServer.create = function(options, callback) {
      return (new this(options)).create(callback);
    };

    AssetServer.compile = function(save_dir, manifest_name) {
      return (new this).compile(save_dir, manifest_name);
    };

    AssetServer.watch = function(save_dir, manifest_name) {
      return (new this).watch(save_dir, manifest_name);
    };

    function AssetServer(options) {
      if (options == null) options = {};
      this.options = new Options(options);
    }

    AssetServer.prototype.create = function(callback) {
      var adapter, compiler, testServer;
      adapter = new ExpressAdapter();
      compiler = new AssetCompiler(this.options.build_compiler_package());
      testServer = new TestServer(this.options);
      compiler.create_routes(adapter);
      testServer.create_routes(adapter);
      adapter.static(this.options.public);
      return adapter.run(this.options.port, callback);
    };

    AssetServer.prototype.compile = function(save_dir, manifest_name) {
      var compiler;
      compiler = new AssetCompiler(this.options.build_compiler_package());
      return compiler.compile({
        save_id: save_dir,
        manifest_name: manifest_name
      });
    };

    AssetServer.prototype.watch = function(save_dir, manifest_name) {
      var compiler;
      compiler = new AssetCompiler(this.options.build_compiler_package());
      return compiler.watch({
        save_id: save_dir,
        manifest_name: manifest_name
      });
    };

    return AssetServer;

  })();

  module.exports = AssetServer;

}).call(this);
