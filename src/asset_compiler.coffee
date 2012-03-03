fs = require 'fs'
path = require 'path'
util = require 'util'
resolve = path.resolve
{CssBundler} = require './css_bundler'
{Package} = require './js_packager'
{md5Namer} = require './file_namer'

class AssetCompiler
  constructor: (packages) ->
    @packages = packages

  create_routes: (adapter) ->
    @_create_route_for(@packages.js, adapter, Package)
    @_create_route_for(@packages.css, adapter, CssBundler)

  compile: (options = {}) ->
    manifest_name = options.manifest_name or= @packages.manifest_name or= 'manifest.mf'
    save_dir      = options.save_dir or= @packages.save_dir or= './build'
    save_dir      = path.resolve(save_dir)
    hash_names    = (options.hash_file_names == undefined) ? true : options.hash_file_names

    #TODO: support creating the recursive path if not exist
    if !path.existsSync(save_dir)
      fs.mkdirSync(save_dir)
    manifest = {}

    @_compile(@packages.js, save_dir, manifest, hash_names, Package)
    @_compile(@packages.css, save_dir, manifest, hash_names, CssBundler)
    fs.writeFileSync(path.join(save_dir, manifest_name), util.format('%j', manifest))

  #private
  
  _create_route_for: (package_data, adapter, packager) ->
    for file_name, data of package_data
      do (file_name, data) ->
        package = new packager(data)
        adapter.route('get', file_name, package)


  _compile: (package_data, save_dir, manifest, should_hash_name, packager) ->
    for file_name, data of package_data
      file_name = path.basename(file_name)
      file_data = new packager(data).compile()
      hashed_file_name = if should_hash_name then md5Namer(file_name, file_data) else file_name
      fs.writeFileSync(path.join(save_dir, hashed_file_name), file_data)
      manifest[file_name] = hashed_file_name


module.exports = AssetCompiler
    


