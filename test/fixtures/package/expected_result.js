// This is a plan old javascript lib

(function() {
  var one = 1;
  var two = 2;

  console.log(one + two);
}).call(this);
  


(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {}, require = function(name, root) {
      var path = expand(root, name), indexPath = expand(path, './index'), module, fn;
      module   = cache[path] || cache[indexPath]      
      if (module) {
        return module;
      } else if (fn = modules[path] || modules[path = indexPath]) {
        module = {id: path, exports: {}};
        cache[path] = module.exports;
        fn(module.exports, function(name) {
          return require(name, dirname(path));
        }, module);
        return cache[path] = module.exports;
      } else {
        throw 'module ' + name + ' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    }
    this.require.define = function(bundle) {
      for (var key in bundle)
        modules[key] = bundle[key];
    };
    this.require.modules = modules;
    this.require.cache   = cache;
  }
  return this.require.define;
}).call(this)({
  "guts/stomach": function(exports, require, module) {(function() {
  var Stomach;

  Stomach = (function() {

    function Stomach(food) {
      this.food;
    }

    Stomach.prototype.digest = console.log("digesting " + food);

    return Stomach;

  })();

  modules.exports = Stomach;

}).call(this);
}, "index": function(exports, require, module) {(function() {
  var MyApp, Stomach;

  Stomach = require('./guts/stomach');

  MyApp = (function() {

    function MyApp(stuff) {
      console.log(stuff);
      this.stuff;
    }

    MyApp.prototype.do_it = function(live) {
      var stomach;
      stomach = new Stomach(live);
      return stomach.digest();
    };

    MyApp.prototype.does_stuff = function(live) {
      return console.log(live);
    };

    return MyApp;

  })();

  modules.exports = MyApp;

}).call(this);
}
});