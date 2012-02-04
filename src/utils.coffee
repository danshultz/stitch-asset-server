exports.flatten = flatten = (array, results = []) ->
  for item in array
    if Array.isArray(item)
      flatten(item, results)
    else
      results.push(item)
  results

exports.toArray = (value = []) ->
  if Array.isArray(value) then value else [value]

exports.stripExt = (filePath) ->
  if (lastDotIndex = filePath.lastIndexOf '.') >= 0
    filePath[0...lastDotIndex]
  else
    filePath
