module.exports = (app) ->
  class HomeController extends app.Controller
    index: (request, response) ->
      response.render 'index', title: 'Express'