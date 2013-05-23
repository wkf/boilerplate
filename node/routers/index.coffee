module.exports = (App) ->
  console.log 'Initializing Routers...'

  App.get('/', (new App.Controllers.Home()).index)
  App