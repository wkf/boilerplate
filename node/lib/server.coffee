module.exports = (App) ->
  Q    = require('q')
  http = require('http')
  io   = require('socket.io')
  path = require('path')

  console.log 'Initializing Server...'

  App.roots.add_compiler(App.assets);

  App.configure ->
    App.set('views', path.normalize(__dirname + '/../views'))
    App.set('view engine', 'jade')
    App.use(App.assets())
    App.use(App.express.logger('dev'))
    App.use(App.express.bodyParser())
    App.use(App.express.methodOverride())
    App.use(App.router)
    App.use(App.express.static(path.normalize(__dirname + '/../public')))

  Q(http.createServer App).then (server) ->
    App.roots.watch(server)

    Q.ninvoke(server, 'listen', App.get 'port').then ->
      listener = io.listen(server)
      listener.configure ->
        listener.set('log level', 1)
        listener.set('transports',[
          'websocket'
          'xhr-polling'
          'jsonp-polling'
        ])
        listener.enable('browser client minification')
        listener.enable('browser client etag')
        listener.enable('browser client cache')
      listener.sockets.on('connection', App.socket()) if App.socket()
      App