module.exports = class Database
  constructor: (app) ->
    @app      = app
    @database = app.config.database

  initialize: (app) ->
    Q        = require('q')
    mongoose = require('mongoose-q')(require('mongoose'), prefix: '_')

    mongoose.connect @database

    Q.ninvoke(mongoose.connection, 'once', 'open').then => @app
