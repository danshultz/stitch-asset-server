{resolve} = require('path')
fs = require('fs')
{Package} = require resolve('./src/package')

describe "Package", ->

  config =
    paths: [resolve('./test/fixtures/package/app')]
    libs: [resolve('./test/fixtures/package/lib.js')]
  package = null
  before ->
    package = new Package(config)

  it "should compile", ->
    expected = fs.readFileSync(resolve('./test/fixtures/package/expected_result.js'), 'utf8')
    package.compile().should.equal(expected)

  it "should compile and minify", ->
    expected = fs.readFileSync(resolve('./test/fixtures/package/expected_result.min.js'), 'utf8')
    package.compile(true).should.equal(expected.trim())

  it "should create a server", (done) ->
    request = package.createServer()
    request(null, (status, header, body) ->
      status.should.equal(200)
      header['Content-Type'].should.equal('text/javascript')
      expected = fs.readFileSync(resolve('./test/fixtures/package/expected_result.js'), 'utf8')
      body.should.equal(expected)
      done()
    )
