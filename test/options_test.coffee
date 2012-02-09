fs = require('fs')
path = require('path')
resolve = path.resolve
{format} = require('util')
Options = require resolve './src/options'

describe "Options", ->
  fs.mkdir('./test/tmp') unless path.existsSync('./test/tmp')

  it "should provide default options", ->
    options = new Options()
    options[key].should.eql(value) for key, value of default_options

  it "should support overriding default options", ->
    options = new Options(overrides)
    options[key].should.eql(value) for key, value of overrides

  it "should use the values in the slug file as master options", ->
    slug_path = './test/tmp/slug.json'
    fs.writeFileSync(resolve(slug_path), format('%j', slug_file_data))
    options = new Options(slug: slug_path, css: 'nogood', paths: [])
    options[key].should.eql(value) for key, value of slug_file_data
    options.slug.should.eql slug_path

  describe "#build_compiler_package", ->
    it "builds with basic options", ->
      options = new Options(default_options)
      options.build_compiler_package().should.eql
        js:
          '/application.js':
            paths: default_options.paths
            libs: default_options.libs
            dependencies: default_options.dependencies
        css:
          '/application.css': default_options.css
      
    it "builds with complex options", ->
      options = new Options(complex_options)
      options.build_compiler_package().should.eql
        js:
          '/application.js':
            paths: ['./app', './stuff']
            libs: ['./lib/lib.js']
            dependencies: 'gfx'
          '/jquery.js':
            paths: ['./file']
            libs: []
            dependencies: []
          '/other.js':
            paths: ['./app', './b']
            libs: []
            dependencies: []
        css:
          '/application.css': ['a.css', 'b.css']
          '/other.css': 'somefile.css'



  default_options =
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

  overrides =
    slug:         './overidendslug.json'
    css:          './css_other'
    libs:         ['./libs', './others']
    public:       './public_overide'
    paths:        ['./app2']
    dependencies: ['jquery.js']
    port:         9999
    cssPath:      '/application2.css'
    jsPath:       '/application2.js'
    test:         './test2'
    testPublic:   './test/public2'
    testPath:     '/test2'
    specs:        './test/specs2'
    specsPath:    '/test/specs2.js'

  slug_file_data =
    css:          './css_other'
    libs:         ['./libs', './others']
    public:       './public_overide'
    paths:        ['./app2']
    dependencies: ['jquery.js']
    port:         989898
    cssPath:      '/application2.css'
    jsPath:       '/application2.js'
    test:         './test2'
    testPublic:   './test/public2'
    testPath:     '/test2'
    specs:        './test/specs2'
    specsPath:    '/test/specs2.js'

  complex_options =
    cssPath:
      '/application.css': ['a.css', 'b.css']
      '/other.css': 'somefile.css'
    jsPath:
      '/application.js':
        paths: ['./app', './stuff']
        libs: ['./lib/lib.js']
        dependencies: 'gfx'
      '/jquery.js': './file'
      '/other.js': ['./app', './b']


