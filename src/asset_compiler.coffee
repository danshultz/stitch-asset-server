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

  compile_and_create_manifest: (save_dir, manifest_name) ->
    manifest_name or= @packages.manifest_name or= 'manifest.mf'
    save_dir or= @packages.save_dir or= './build'
    save_dir = path.resolve(save_dir)
    manifest = {}

    @compile_javascript(save_dir, manifest)
    @compile_css(save_dir, manifest)
    fs.writeFileSync(path.join(save_dir, manifest_name), util.format(manifest))

  compile_javascript: (save_dir, manifest) ->
    for file_name, data of @packages.js
      file_data = new Package(data).compile()
      fs.writeFileSync(path.join(save_dir, file_name), file_data)
      manifest[file_name] = md5Namer(file_name, file_data)

  compile_css: (save_dir, manifest) ->
    for file_name, data of @packages.css
      file_data = new CssBundler(data).compile()
      fs.writeFileSync(path.join(save_dir, file_name), file_data)
      manifest[file_name] = md5Namer(file_name, file_data)


module.exports = AssetCompiler
    


