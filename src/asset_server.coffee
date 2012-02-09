path = require 'path'
AssetCompiler = require './asset_compiler'
Options = require './options'
{ExpressAdapter} = require './adapters'

class AssetServer
  constructor: (options = {}) ->
    @options = new Options(options)

  create: (callback) ->
    adapter = new ExpressAdapter()
    compiler = new AssetCompiler(@options.build_compiler_package())
    compiler.create_routes(adapter)
    adapter.static(@options.public)
    adapter.run(@options.port, callback)


module.exports = AssetServer
