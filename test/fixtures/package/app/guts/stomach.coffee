class Stomach
  constructor: (food) ->
    @food

  digest:
    console.log("digesting #{food}")

modules.exports = Stomach

