Stomach = require './guts/stomach'

class MyApp
  constructor: (stuff) ->
    console.log(stuff)
    @stuff

  do_it: (live) ->
    stomach = new Stomach(live)
    stomach.digest()

  does_stuff: (live) ->
    console.log(live)

modules.exports = MyApp
