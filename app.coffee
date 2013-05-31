# require('muggle')()



# muggle new
# muggle start
# muggle generate



#  (app) ->
#   @load =>
#   .then =>
#     @database.open()
#   .then =>
#     @server.listen()






#   options  = require('./options.json')

#   Server   = require('./lib/server')(@)
#   Database = require('./lib/database')(@)

#     @server   = new Server(options.server)
#     @database = new Database(options.database)




# class Server extends app.Server
# class Database extends app.Database





# options = require('./options.json')

# app = require('muggle')(options = require('./options.json')).run ->


#   views: options.views
#   models: options.models
#   controllers: options.controllers
#   routers: options.routers
#   public: options.public








# ).then( ->

# )

# app.runs


# app.when.starts
#   .then

# app.run ->
#   Server   = require('./lib/database')(@)
#   Database = require('./lib/database')(@)

#   @server   = new Server(options.server)
#   @database = new Database(options.database)

#   @when.started (we) ->
#     we.then(=> @database.open())
#       .then(=> @server.listen())

#   @when.stopped

#   @when.crashed
#     .then(=> )








# require('muggle')().run (app) ->
#   options  = require('./options.json')

#   Server   = require('./lib/database')(@)
#   Database = require('./lib/database')(@)

#   @set('views', options.views)
#   @set('models', options.models)
#   @set('controllers', options.controllers)
#   @set('routers', options.routers)
#   @set('public', options.public)

#   @server   = new Server(options.server)
#   @database = new Database(options.database)

#   @when.loaded
#   .then(=> @database.open())
#   .then(=> @server.listen())




# $(muggle.load).then(muggle.run)





class App
  $     = require('when')
  defer = require('deferrable')($)

  constructor: ->
    @config      = require('./config.json')

    @Models      = require('./models')
    @Controllers = require('./controllers')
    @Routers     = require('./routers')

    @database    = new (require('./lib/database')(@))(@config.database)
    @server      = new (require('./lib/server')(@))(@config.server)

  run: ->
    console.log 'Started'

    $(@)
    .then(@Models)
    .then(@Controllers)
    .then(@Routers)
    .then(=>@database.open())
    .then(=>@server.listen())
    .then(receiveSignal)
    .then(appStopped, appCrashed)

  receiveSignal = ->
    deferred = $.defer()
    process.on 'SIGINT', deferred.resolve
    process.on 'SIGTERM', deferred.resolve
    deferred.promise

  appStopped = ->
    console.log 'Stopped'
    process.exit 0

  appCrashed = (error) ->
    console.log 'Crashed', error
    process.exit 1

(new App()).run()
