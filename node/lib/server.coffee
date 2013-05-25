module.exports = class Server
  constructor: (app) ->
    @app        = app
    @port       = app.config.port or 3000
    @viewPath   = expandPath(app.config.views or 'views')
    @staticPath = expandPath(app.config.static or 'public')
    @viewEngine = app.config.viewEngine or 'jade'

    console.log @viewPath

  initialize: (app) ->
    Q        = require('q')
    http     = require('http')
    io       = require('socket.io')
    assets   = require('connect-assets')
    express  = require('express')
    roots    = require('roots-express')
    passport = require('passport')

    console.log 'Initializing Server...'

    roots.add_compiler(assets)

    @app.configure =>
      @app.set('views', @viewPath)
      @app.set('view engine', @viewEngine)
      @app.use(assets())
      @app.use(express.static(@staticPath))
      @app.use(express.cookieParser())
      @app.use(express.bodyParser())
      @app.use(express.methodOverride())
      @app.use(express.session({ secret: 'secret' }));
      @app.use(passport.initialize())
      @app.use(passport.session())
      @app.use(@app.router)

    @server = http.createServer(@app)

    roots.watch(@server)

    @app.socket = (handler) =>
      if handler then @app._socket = handler else @app._socket

    @listening = Q.ninvoke(@server, 'once', 'listening').then =>
      listener = io.listen(@server)
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
      listener.sockets.on('connection', @app.socket()) if @app.socket()
      @app

    @app

  listen: (app) ->
    Q = require('q')

    Q.ninvoke(@server, 'listen', @port).then => @listening

# private

  expandPath = (path) ->
    require('path').normalize(__dirname + '/../' + path)
