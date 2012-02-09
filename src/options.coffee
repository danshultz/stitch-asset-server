fs = require('fs')
path = require 'path'

class Options
  constructor: (overrides = null) ->
    @[key] = value for key, value of overrides
    @[key] = value for key, value of @readSlug()

  readSlug: (slug = @slug) ->
    return {} unless slug and path.existsSync(slug)
    JSON.parse(fs.readFileSync(slug, 'utf-8'))

  # default options
  slug:         './slug.json'
  css:          './css'
  libs:         []
  public:       './public'
  paths:        ['./app']
  dependencies: []
  port:         process.env.PORT or 9294
  cssPath:      '/application.css'
  jsPath:       '/application.js'

  test:         './test'
  testPublic:   './test/public'
  testPath:     '/test'
  specs:        './test/specs'
  specsPath:    '/test/specs.js'

  build_compiler_package: ->
    obj = { js:{}, css:{} }
    if typeof @jsPath is 'string'
      obj.js[this.jsPath] =
        paths: this.paths
        libs: this.libs
        dependencies: this.dependencies
    else
      for key, value of @jsPath
        if typeof value is 'string'
          value =
            paths: [value]
            libs: []
            dependencies: []
        else if value instanceof Array
          value =
            paths: value
            libs: []
            dependencies: []
          
        obj.js[key] = value
        

    if typeof @cssPath is 'string'
      obj.css[this.cssPath] = this.css
    else
      for key, value of @cssPath
        obj.css[key] = value

    return obj


module.exports = Options
