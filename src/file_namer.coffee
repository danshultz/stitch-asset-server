crypto = require 'crypto'
path = require 'path'
utils = require './utils'

md5Filenamer = (filename, code) ->
  hash = crypto.createHash('md5')
  hash.update code
  md5Hex = hash.digest 'hex'
  ext = path.extname filename
  "#{utils.stripExt filename}-#{md5Hex}#{ext}"

module.exports = 
  md5Namer: md5Filenamer
