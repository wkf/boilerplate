module.exports = (App) ->
  console.log 'Initializing Routers...'

  Home = new App.Controllers.Home(App)
  Socket = new App.Controllers.Socket(App)

  App.get('/', Home.index.bind(Home))

  App.socket(Socket.connect.bind(Socket))

  App