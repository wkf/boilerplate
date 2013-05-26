Q   = require('q')
app = require('express')()

app.environment = process.env.NODE_ENV or 'development'

app.Routers     = require('./routers')
app.Models      = require('./models')
app.Controllers = require('./controllers')

app.config      = require('./config.json')

app.database    = new (require('./lib/database'))(app)
app.server      = new (require('./lib/server'))(app)

appStart = (app) ->
  console.log 'Node app Started'
  app

appStop = (app) ->
  console.log 'Node app Stopped'
  process.exit 0

appCrash = (error) ->
  console.log 'Node app Crashed', error
  process.exit 1

receiveSignal = (app) ->
  deferred = Q.defer()
  process.on 'SIGINT', deferred.resolve.bind(deferred, app)
  process.on 'SIGTERM', deferred.resolve.bind(deferred, app)
  deferred.promise

Q(app)
  .then(appStart)
  .then(->app.database.initialize())
  .then(->app.server.initialize())
  .then(app.Models)
  .then(app.Controllers)
  .then(app.Routers)
  .then(->app.server.listen())
  .then(receiveSignal)
  .then(appStop, appCrash)