module.exports = class
  constructor: (App) ->
    @App = App

  connect: (client) ->
    new @App.Models.Socket(client)