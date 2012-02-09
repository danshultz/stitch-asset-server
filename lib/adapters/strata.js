(function() {
  var StrataAdapter, strata;

  strata = require('strata');

  StrataAdapter = (function() {

    function StrataAdapter(server) {
      this.server = server;
      if (!this.server) throw Error("NullArgument: server must be provided");
      if (!(this.server instanceof strata.Builder)) {
        throw Error("ArgumentError: server must be of type strata.Builder");
      }
      console.log('valid');
    }

    return StrataAdapter;

  })();

  module.exports = StrataAdapter;

}).call(this);
