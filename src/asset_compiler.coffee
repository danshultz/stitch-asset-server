fs = require 'fs'
path = require 'path'
util = require 'util'
resolve = path.resolve
{CssBundler} = require './css_bundler'
{Package} = require './js_packager'
{md5Namer} = require './file_namer'
{watch} = require './utils'

class AssetCompiler
  constructor: (packages) ->
    @packages = packages

  create_routes: (adapter) ->
    @_create_route_for(@packages.js, adapter, Package)
    @_create_route_for(@packages.css, adapter, CssBundler)

  watch: (options = {}, postBuildCallBack = null) ->
    @compile(options)
    watchDirs = for _, dirs of @packages.js
      dirs.paths.concat(dirs.libs)
    watchDirs.push(dirs) for _, dirs of @packages.css
    watch(watchDirs, @_createOnWatchChange(options, postBuildCallBack))

  compile: (options = {}) ->
    options = Object.create(options) #instead of just plain extend, no real reason why this is done vs extend
    options.manifest_name or= @packages.manifest_name or= 'manifest.mf'
    options.save_dir or= @packages.save_dir or= './build'
    options.save_dir = path.resolve(options.save_dir)
    options.hash_file_names = if (options.hash_file_names == undefined) then true else options.hash_file_names
    options.minify = if (options.minify == undefined) then true else options.minify

    #TODO: support creating the recursive path if not exist
    if !path.existsSync(options.save_dir)
      fs.mkdirSync(options.save_dir)

    manifest = {}
    @_compile(@packages.js, manifest, Package, options)
    @_compile(@packages.css, manifest, CssBundler, options)
    fs.writeFileSync(path.join(options.save_dir, options.manifest_name), util.format('%j', manifest))

  #private
  
  _createOnWatchChange: (options, postBuildCallBack) ->
    compile = => @compile.apply(@, arguments)
    return (file, curr, prev) =>
      if curr and (curr.nlink is 0 or +curr.mtime isnt +prev?.mtime)
        console.log("#{file} changed.  Rebuilding...")
        compile(options)
        postBuildCallBack && postBuildCallBack()

  _create_route_for: (package_data, adapter, packager) ->
    for file_name, data of package_data
      do (file_name, data) ->
        package = new packager(data)
        adapter.route('get', file_name, package)


  _compile: (package_data, manifest, packager, options) ->
    for file_name, data of package_data
      file_name = path.basename(file_name)
      file_data = new packager(data).compile(options.minify)
      hashed_file_name = if options.hash_file_names then md5Namer(file_name, file_data) else file_name
      write_file_path = path.join(options.save_dir, hashed_file_name)
      fs.writeFileSync(write_file_path, file_data)
      console.log("file #{write_file_path} written")
      manifest[file_name] = hashed_file_name


module.exports = AssetCompiler
    


