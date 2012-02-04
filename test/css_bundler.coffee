{resolve} = require('path')
fs = require('fs')
{CssBundler} = require resolve('./src/css_bundler.coffee')

describe 'css_bundler', ->
  bundler = null

  before ->
    files = [
      'test/fixtures/css_bundler/a.css',
      'test/fixtures/css_bundler/b.css',
      'test/fixtures/css_bundler/c.css'
      ]
    bundler = new CssBundler(files)

  it "should compile to css", ->
    expected = fs.readFileSync(resolve('test/fixtures/css_bundler/expanded.css')).toString()
    bundler.compile().should.equal(expected)
    
