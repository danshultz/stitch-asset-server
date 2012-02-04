{resolve} = require('path')
fs = require('fs')
namers = require resolve('./src/file_namer')

describe 'File Namers', ->
  it 'Should generate a file name with an md5 hash', ->
    file_name =
      namers.md5Namer('my-file-name.js', '(function(){ console.log("doing it live"); }).call()')
    file_name.should.equal('my-file-name-0f0a8b40d94819d79816cb5fa482fd8c.js')
