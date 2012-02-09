fs = require 'fs'
path = require 'path'
util = require 'util'
resolve = path.resolve
{CssBundler} = require './css_bundler.coffee'
{Package} = require './package'
{md5Namer} = require './file_namer'

class AssetCompiler
  constructor: (packages) ->
    @packages = packages

  create_routes: (adapter) ->
    @create_route_for(@packages.js, adapter, Package)
    @create_route_for(@packages.css, adapter, CssBundler)


  compile_and_create_manifest: (save_dir, manifest_name) ->
    manifest_name or= @packages.manifest_name or= 'manifest.mf'
    save_dir or= @packages.save_dir or= './build'
    save_dir = path.resolve(save_dir)
    manifest = {}

    @compile(@packages.js, save_dir, manifest, Package)
    @compile(@packages.css, save_dir, manifest, CssBundler)
    fs.writeFileSync(path.join(save_dir, manifest_name), util.format('%j', manifest))

  #private
  
  create_route_for: (package_data, adapter, packager) ->
    for file_name, data of package_data
      do (file_name, data) ->
        callback = =>
          package = new packager(data)
          statusCode: 200
          headers: package.headers
          content: package.compile()
          
        adapter.route('get', file_name, callback)


  compile: (package_data, save_dir, manifest, packager) ->
    for file_name, data of package_data
      file_name = path.basename(file_name)
      file_data = new packager(data).compile()
      hashed_file_name = md5Namer(file_name, file_data)
      fs.writeFileSync(path.join(save_dir, hashed_file_name), file_data)
      manifest[file_name] = hashed_file_name


module.exports = AssetCompiler
    


