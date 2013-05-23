module.exports = (App) ->
  console.log 'Initializing Controllers...'

  module.exports.Home = require('./home_controller.coffee')
  module.exports.Socket = require('./socket_controller.coffee')

  App