Q   = require('q')
App = require('express')()

App.environment = process.env.NODE_ENV or 'development'

App.express     = require('express')
App.roots       = require('roots-express')
App.assets      = require('connect-assets')

App.database    = require('./lib/database.coffee')
App.server      = require('./lib/server.coffee')

App.Routers     = require('./routers')
App.Models      = require('./models')
App.Controllers = require('./controllers')

App.config      = require('./config.json')

App.set(name, value) for name, value of App.config

Q(App)
  .then(AppStart)
  .then(App.database)
  .then(App.Models)
  .then(App.Controllers)
  .then(App.Routers)
  .then(App.server)
  .then(receiveSignal)
  .then(AppStop, AppCrash)

AppStart = (App) ->
  console.log 'Node App Started'
  App

AppStop = (App) ->
  console.log 'Node App Stopped'
  process.exit 0

AppCrash = (error) ->
  console.log 'Node App Crashed', error
  process.exit 1

receiveSignal = (App) ->
  deferred = Q.defer()
  process.on 'SIGINT', deferred.resolve.bind(deferred, App)
  process.on 'SIGTERM', deferred.resolve.bind(deferred, App)
  deferred.promise
