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

module.exports = ExpressAdapter
