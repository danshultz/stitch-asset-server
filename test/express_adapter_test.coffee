path = require('path')
assert = require('assert')
resolve = path.resolve
request = require('./support/http')
methods = require('express/lib/router/methods')
{ExpressAdapter} = require resolve './src/adapters'

describe "ExpressAdapter", ->
  it "takes the server on instantiation", ->
    server = {}
    (new ExpressAdapter(server)).server.should.equal(server)

  #This test needs a better way to identify that the server was created
  it "creates a server if none is passed", ->
    (new ExpressAdapter()).server.should.be.a('object')

  describe "#route", ->

    describe "supports verb", ->
      callback = -> ({ statusCode: 200, headers: {}, content: ""})
      adapter = null
      before -> adapter = new ExpressAdapter()

      methods.forEach (method) ->
        it method, ->
          (-> adapter.route(method, "/#{method}", callback)).should.not.throw()

      it "throws not ArumentError for invalid verbs", ->
        (-> adapter.route('invalidmethod', "/bad", callback)).should.throw /ArgumentError/

    #need to identify how to properly test the response to ensure it's wired up properly
    it "adds a route", ->
      adapter = new ExpressAdapter()
      adapter.route 'get', '/my-route', =>
        statusCode: 200
        headers:
          'Content-Type': 'text/html'
        content: "<h1>Hello World</h1>"

      route = request(adapter.service).get('/my-route')
      route.method.should.equal('get')
      route.path.should.equal('/my-route')

