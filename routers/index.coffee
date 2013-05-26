module.exports = (app) ->
  console.log 'Initializing Routers...'

  app.Router = class Router
    routeTo: (controller, action) -> controller[action].bind(controller)

  app.Routers.Home   = require('./home_router.coffee')(app)
  app.Routers.Auth   = require('./auth_router.coffee')(app)
  app.Routers.Socket = require('./socket_router.coffee')(app)

  (new Router()).initialize() for name, Router of app.Routers

  app