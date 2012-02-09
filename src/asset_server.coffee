path = require 'path'
AssetCompiler = require './asset_compiler'
Options = require './options'
{ExpressAdapter} = require './adapters'

class AssetServer
  @create: (options, callback) ->
    (new @(options)).create(callback)

  constructor: (options = {}) ->
    @options = new Options(options)

  create: (callback) ->
    adapter = new ExpressAdapter()
    compiler = new AssetCompiler(@options.build_compiler_package())
    compiler.create_routes(adapter)
    adapter.static(@options.public)
    adapter.run(@options.port, callback)

  include: (server) ->
    if @server_is_strata(server)
      console.log("is strata")
    else
      console.log("expecting express")

  server_is_strata: (server) ->
    try
      strata    = require('strata')
      return server instanceof strata.Builder
    catch err
      return false

module.exports = AssetServer
