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
    options = Object.create(options) #instead of just plain extend, no real reason why this is done vs extend
    options.manifest_name or= @packages.manifest_name or= 'manifest.mf'
    options.save_dir or= @packages.save_dir or= './build'
    options.save_dir = path.resolve(options.save_dir)
    options.hash_file_names = if (options.hash_file_names == undefined) then true else options.hash_file_names

    #TODO: support creating the recursive path if not exist
    if !path.existsSync(options.save_dir)
      fs.mkdirSync(options.save_dir)

    manifest = {}
    @_compile(@packages.js, manifest, Package, options)
    @_compile(@packages.css, manifest, CssBundler, options)
    fs.writeFileSync(path.join(options.save_dir, options.manifest_name), util.format('%j', manifest))

  #private
  
  _create_route_for: (package_data, adapter, packager) ->
    for file_name, data of package_data
      do (file_name, data) ->
        package = new packager(data)
        adapter.route('get', file_name, package)


  _compile: (package_data, manifest, packager, options) ->
    for file_name, data of package_data
      file_name = path.basename(file_name)
      file_data = new packager(data).compile()
      hashed_file_name = if options.hash_file_names then md5Namer(file_name, file_data) else file_name
      fs.writeFileSync(path.join(options.save_dir, hashed_file_name), file_data)
      manifest[file_name] = hashed_file_name


module.exports = AssetCompiler
    


