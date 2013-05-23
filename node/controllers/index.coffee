module.exports = (App) ->
  console.log 'Initializing Controllers...'

  module.exports.Home = require('./home_controller.coffee')

  App