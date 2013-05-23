module.exports = class
  index: (request, response) ->
    response.render 'index', title: 'Express'