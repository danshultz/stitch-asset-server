(function() {
  var ExpressAdapter, express, methods, path;

  path = require('path');

  express = require('express');

  methods = require('express/lib/router/methods');

  ExpressAdapter = (function() {

    function ExpressAdapter(server) {
      this.server = server != null ? server : express.createServer();
    }

    ExpressAdapter.prototype.route = function(verb, route, callback) {
      var _this = this;
      if (!methods.some(function(method) {
        return method === verb;
      })) {
        throw new Error("ArgumentError: verb " + verb + " is not supported");
      }
      return this.server[verb](route, function(req, res, next) {
        var result;
        result = callback();
        res.writeHead(result.statusCode, result.headers);
        return res.end(result.content);
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
      return this.server.listen(port);
    };

    return ExpressAdapter;

  })();

  module.exports = ExpressAdapter;

}).call(this);
