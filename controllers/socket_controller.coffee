module.exports = (app) ->
  class SocketController extends app.Controller
    connect: (client) ->
      new app.Models.Socket(client)