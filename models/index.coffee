module.exports = (app) ->
  console.log 'Initializing Models...'

  app.Model  = class Model
    constructor: ->

  app.Models.Socket = require('./socket_model.coffee')(app)

  app
