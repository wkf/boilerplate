module.exports = (app) ->
  class SocketRouter extends app.Router
    @socket @routeTo(new app.Controllers.Socket(app), 'connect')