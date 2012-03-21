fs                = require 'fs'
path              = require 'path'
{CssBundler}      = require './css_bundler'
{Package}         = require './js_packager'

class TestServer
  
  constructor: (@options) ->

  create_routes: (adapter) ->
    if path.existsSync(@options.specs)
      @_create_test_routes(adapter)

  #private

  _create_test_routes: (adapter) ->
    package = new Package(paths: @options.specs, libs: @options.testLibs, identifier: 'specs', dependencies: 'jqueryify')
    adapter.route('get', @options.specsPath, package)
    test_page = if @options.testPageTemplate then require(path.resolve(@options.testPageTemplate)) else require('../assets/test_page')
    adapter.route 'get', '/test',
      headers: { 'Content-Type': 'text/html' }
      compile: -> test_page()

    adapter.route 'get' , '/test/assets/mocha.js',
      headers: { 'Content-Type': 'text/javascript' }
      compile: => @_read_test_asset('mocha/mocha')

    adapter.route 'get' , '/test/assets/mocha.css',
      headers: { 'Content-Type': 'text/css' }
      compile: => @_read_test_asset('mocha/mocha.css')

    adapter.route 'get', '/test/assets/chai.js',
      headers: { 'Content-Type': 'text/javascript' }
      compile: => @_read_test_asset('chai/chai')

  _read_test_asset: (asset) ->
    path = require.resolve(asset)
    fs.readFileSync(path)

module.exports = TestServer
