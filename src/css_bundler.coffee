{resolve} = require('path')
compilers = require('./compilers')
{toArray}    = require('./utils')

class CssBundler
  constructor: (files) ->
    @files = toArray(files).map(resolve).map(require.resolve)

  compile: ->
    @files.map(@rerequire).join('')

  createServer: ->
    (req, res, next) =>
      content = @compile()
      res.writeHead(200, 'Content-Type': 'text/css')
      res.end(content)

  rerequire: (file) ->
    delete require.cache[file]
    require(file)
      
module.exports =
  CssBundler: CssBundler
  createPackage: (paths) ->
    new CssBundler(paths)
