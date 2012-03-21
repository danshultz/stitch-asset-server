fs = require 'fs'
path = require 'path'

exports.flatten = flatten = (array, results = []) ->
  for item in array
    if Array.isArray(item)
      flatten(item, results)
    else
      results.push(item)
  results

exports.toArray = toArray = (value = []) ->
  if Array.isArray(value) then value else [value]

exports.stripExt = (filePath) ->
  if (lastDotIndex = filePath.lastIndexOf '.') >= 0
    filePath[0...lastDotIndex]
  else
    filePath

exports.watch = watch = (filesOrDirs, callback) ->
  {watchTree} = require('watch')
  filesOrDirs = flatten(toArray(filesOrDirs))

  uniqWatchDirs = []
  for dir in filesOrDirs
    continue unless path.existsSync(dir)
    dir = if fs.statSync(dir).isDirectory() then dir else path.dirname(dir)
    continue if dir in uniqWatchDirs
    uniqWatchDirs.push(dir)
    console.log("Now watching directory #{dir} for changes")
    require('watch').watchTree(dir, callback)

exports.stuff = ->

