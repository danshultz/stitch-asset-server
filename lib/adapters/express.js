(function() {
  var ExpressAdapter, express, methods, path;

  path = require('path');

  express = require('express');

  methods = require('express/lib/router/methods');

  ExpressAdapter = (function() {

    function ExpressAdapter(server) {
      this.server = server != null ? server : express.createServer();
    }

    ExpressAdapter.prototype.route = function(verb, route, package) {
      var _this = this;
      if (!methods.some(function(method) {
        return method === verb;
      })) {
        throw new Error("ArgumentError: verb " + verb + " is not supported");
      }
      return this.server[verb](route, function(req, res, next) {
        var content;
        content = package.compile();
        res.writeHead(200, package.headers);
        return res.end(content);
      });
    };

    ExpressAdapter.prototype.static = function(directory) {
      if (path.existsSync(directory)) {
        return this.server.use(express.static(directory));
      }
    };

    ExpressAdapter.prototype.run = function(port, callback) {
      if (callback) this.server.on('listening', callback);
      port || (port = 9294);
      this.server.on('listening', function() {
        return console.log("Express server started and running on port " + port + ".\nAccess the server by going to http://0.0.0.0:" + port + "\nPress CTRL-C to quit");
      });
      return this.server.listen(port);
    };

    return ExpressAdapter;

  })();

  module.exports = ExpressAdapter;

}).call(this);
