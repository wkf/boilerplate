module.exports = (App) ->
  console.log 'Initializing Models...'

  module.exports.Socket = require('./socket_model.coffee')

  App
