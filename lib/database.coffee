module.exports = class Database
  constructor: (app) ->
    @app  = app
    @name = app.config.database.name
    @host = app.config.database.host
    @port = app.config.database.port

  initialize: (app) ->
    Q         = require('q')
    @mongoose = require('mongoose-q')(require('mongoose'), prefix: '_')

    @mongoose.connect "mongodb://#{@host}:#{@port}/#{@name}"

    Q.ninvoke(@mongoose.connection, 'once', 'open').then => @app
