module.exports = (app) ->
  class AuthRouter extends app.Router
    initialize: ->
      Auth = new app.Controllers.Auth(app)

      app.get('/auth/twitter', @routeTo(Auth, 'twitterAuth'))
      app.get('/auth/twitter/callback', @routeTo(Auth, 'twitterCallback'))

      app.get('/auth/facebook', @routeTo(Auth, 'facebookAuth'))
      app.get('/auth/facebook/callback', @routeTo(Auth, 'facebookCallback'))