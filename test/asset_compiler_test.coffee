{resolve} = require('path')
path = require 'path'
fs = require('fs')
util = require 'util'
should = require('should')
AssetCompiler = require resolve('./src/asset_compiler')

describe "AssetCompiler", ->
  package =
    js:
      '/application.js':
        paths: [resolve('./test/fixtures/package/app')]
        libs: [resolve('./test/fixtures/package/lib.js')]
        dependencies: []
    css:
      '/application.css': [
        'test/fixtures/css_bundler/a.css',
        'test/fixtures/css_bundler/b.css',
        'test/fixtures/css_bundler/c.css'
      ]
      '/other.css': 'test/fixtures/css_bundler/c.css'

  expected_package_result =
    '/application.js': fs.readFileSync(resolve('test/fixtures/package/expected_result.js'))
    '/application.css': fs.readFileSync(resolve('test/fixtures/css_bundler/expanded.css'))
    '/other.css' : fs.readFileSync(resolve('test/fixtures/css_bundler/c.css'))
  expected_package_headers = 
    '/application.js': { 'Content-Type': 'text/javascript' }
    '/application.css': { 'Content-Type': 'text/css' }
    '/other.css' : { 'Content-Type': 'text/css' }

  compiler = null
  before -> compiler = new AssetCompiler(package)

  describe "#compile", ->
    build_dir = './test/build'
    fs.mkdir('./test/build')
    before ->
      fs.readdirSync(build_dir).forEach (file) ->
        fs.unlinkSync(path.join(build_dir, file))
    
    it "should compile and create manifest", ->
      compiler.compile(save_dir: build_dir)

      manifest_path = path.join(build_dir, 'manifest.mf')
      manifest = JSON.parse(fs.readFileSync(manifest_path).toString())
      manifest.should.eql
        'application.js': 'application-4b4d7fa6613776a909eb1d71cd58673e.js'
        'application.css': 'application-e0185cba9a838c87a1ba16e9c5cad5de.css'
        'other.css': 'other-7ab6eb3ade352f818cfb17afcb39422d.css'

      appjs = fs.readFileSync(path.join(build_dir, manifest['application.js']))
      appjs.should.eql fs.readFileSync(resolve('test/fixtures/package/expected_result.min.js'))

      appcss = fs.readFileSync(path.join(build_dir, manifest['application.css']))
      appcss.should.eql fs.readFileSync(resolve('test/fixtures/css_bundler/expanded.css'))
      
      othercss = fs.readFileSync(path.join(build_dir, manifest['other.css']))
      othercss.should.eql fs.readFileSync(resolve('test/fixtures/css_bundler/c.css'))

    describe "passing options to not hash file name", ->
      it "should not hash the output files", ->
        compiler.compile(save_dir: build_dir, hash_file_names: false, minify: false)

        manifest_path = path.join(build_dir, 'manifest.mf')
        manifest = JSON.parse(fs.readFileSync(manifest_path).toString())
        manifest.should.eql
          'application.js': 'application.js'
          'application.css': 'application.css'
          'other.css': 'other.css'

        appjs = fs.readFileSync(path.join(build_dir, manifest['application.js']))
        appjs.should.eql fs.readFileSync(resolve('test/fixtures/package/expected_result.js'))

        appcss = fs.readFileSync(path.join(build_dir, manifest['application.css']))
        appcss.should.eql fs.readFileSync(resolve('test/fixtures/css_bundler/expanded.css'))
        
        othercss = fs.readFileSync(path.join(build_dir, manifest['other.css']))
        othercss.should.eql fs.readFileSync(resolve('test/fixtures/css_bundler/c.css'))

  describe "#create_routes", ->
    for asset_type, asset_package of package
      for asset_name, asset_contents of asset_package
        do (asset_name, asset_contents) ->

          it "should create route for #{asset_name}", ->
            results = {}
            adapter =
              route: (verb, route, package) ->
                results[route] = { verb: verb, package: package }

            compiler.create_routes(adapter)
            result = results[asset_name]
            should.exist(result, "expected route #{asset_name} to exist")
            result.verb.should.equal('get')
            package = result.package

            package.headers.should.eql expected_package_headers[asset_name]
            package.compile().should.eql expected_package_result[asset_name].toString()

