path = require 'path'
resolve = path.resolve
AsssetServer = require resolve 'src/asset_server'

describe "AsssetServer", ->
  
  it "should create the server", (done) ->
    server = new AsssetServer()
    server.create(done)
