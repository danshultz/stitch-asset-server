AssetCompiler       = require './asset_compiler'
Options             = require './options'
{ExpressAdapter}    = require './adapters'
TestServer          = require './test_server'


class AssetServer
  @create: (options, callback) ->
    (new @(options)).create(callback)

  @compile: (save_dir, manifest_name) ->
    (new @).compile(save_dir, manifest_name)

  constructor: (options = {}) ->
    @options = new Options(options)

  create: (callback) ->
    adapter = new ExpressAdapter()
    compiler = new AssetCompiler(@options.build_compiler_package())
    testServer = new TestServer(@options, adapter)

    compiler.create_routes(adapter)
    testServer.create_routes(adapter)

    adapter.static(@options.public)
    adapter.run(@options.port, callback)

  compile: (save_dir, manifest_name) ->
    #TODO: add save_dir and manifiest_name optionally from slug file
    compiler = new AssetCompiler(@options.build_compiler_package())
    compiler.compile_and_create_manifest(save_dir, manifest_name)

module.exports = AssetServer
