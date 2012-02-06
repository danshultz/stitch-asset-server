{resolve} = require('path')
path = require 'path'
fs = require('fs')
util = require 'util'
AssetCompiler = require resolve('./src/asset_compiler')

describe "AssetCompiler", ->
  compiler = null
  build_dir = './test/build'
  fs.mkdir('./test/build')
  package =
    js:
      'application.js':
        paths: [resolve('./test/fixtures/package/app')]
        libs: [resolve('./test/fixtures/package/lib.js')]
        dependencies: []
    css:
      'application.css': [
        'test/fixtures/css_bundler/a.css',
        'test/fixtures/css_bundler/b.css',
        'test/fixtures/css_bundler/c.css'
      ]
      'other.css': 'test/fixtures/css_bundler/c.css'


  before ->
    fs.readdirSync(build_dir).forEach (file) ->
      fs.unlinkSync(path.join(build_dir, file))
  
  
  it "should compile and create manifest", ->
    compiler = new AssetCompiler(package)
    compiler.compile_and_create_manifest(build_dir)

    manifest_path = path.join(build_dir, 'manifest.mf')
    manifest = JSON.parse(fs.readFileSync(manifest_path).toString())
    manifest.should.eql
      'application.js': 'application-a5e62a3110f5acfa98259ce87c2aaf4b.js'
      'application.css': 'application-e0185cba9a838c87a1ba16e9c5cad5de.css'
      'other.css': 'other-7ab6eb3ade352f818cfb17afcb39422d.css'

    appjs = fs.readFileSync(path.join(build_dir, manifest['application.js']))
    appjs.should.eql fs.readFileSync(resolve('test/fixtures/package/expected_result.js'))

    appcss = fs.readFileSync(path.join(build_dir, manifest['application.css']))
    appcss.should.eql fs.readFileSync(resolve('test/fixtures/css_bundler/expanded.css'))
    
    othercss = fs.readFileSync(path.join(build_dir, manifest['other.css']))
    othercss.should.eql fs.readFileSync(resolve('test/fixtures/css_bundler/c.css'))


