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

module.exports = Options
