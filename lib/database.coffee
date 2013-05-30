module.exports = (app) ->
  class Database
    $     = require('when')
    defer = require('deferrable')($)
    mongo = require('mongodb')

    constructor: ->
      @name = app.config.database?.name
      @port = app.config.database?.port or 27017
      @host = app.config.database?.host or 'localhost'

    open: (options = {}) ->
      @server    = mongo.Server(
        options.host or @host, options.port or @port)
      @connector = mongo.Db(options.name or @name, @server)

      @connector.defer('open').then (database) =>
        @store = @database = database
        @

    find: (collection, query, field, options) ->
      $(@collections[collection] or @database.defer('collection', collection)).then (c) ->
        @collections[collection] = c

        c.defer('find', query, field)