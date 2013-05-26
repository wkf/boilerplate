module.exports = (app) ->
  class SocketRouter extends app.Router
    initialize: () ->
      app.socket(@routeTo(new app.Controllers.Socket(app), 'connect'))