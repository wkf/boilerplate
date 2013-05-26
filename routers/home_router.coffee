module.exports = (app) ->
  class HomeRouter extends app.Router
    initialize: ->
      app.get('/', @routeTo(new app.Controllers.Home(app), 'index'))