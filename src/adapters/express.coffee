path = require 'path'
express   = require('express')
methods = require('express/lib/router/methods')

class ExpressAdapter
  constructor: (@server = express.createServer()) ->

  route: (verb, route, callback) ->
    if !methods.some((method) -> method == verb)
      throw new Error("ArgumentError: verb #{verb} is not supported")

    @server[verb] route, (req, res, next) =>
      result = callback()
      res.writeHead result.statusCode, result.headers
      res.end result.content

  static: (directory) ->
    if path.existsSync(directory)
      @server.use(express.static(directory))

  run: (port, callback) ->
    if callback
      @server.on('listening', callback)
    port or= 9294
    @server.on('listening', -> console.log("Express server started and running on port #{port}.\nAccess the server by going to http://0.0.0.0:#{port}."))
    @server.listen(port)

module.exports = ExpressAdapter
