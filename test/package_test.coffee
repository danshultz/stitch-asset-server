{resolve} = require('path')
fs = require('fs')
{Package} = require resolve('./src/package')

describe "Package", ->

  config =
    paths: [resolve('./test/fixtures/package/app')]
    libs: [resolve('./test/fixtures/package/lib.js')]
  package = new Package(config)

  it "should package", ->
    fs.readFile resolve('./test/fixtures/package/expected_result.js'), 'utf8', (err, expected) ->
      if err then throw err 
      package.compile().should.equal(expected)



