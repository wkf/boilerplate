module.exports = function(app) {
  console.log('Initializing Server...');

  var Q      = require('q'),
      http   = require('http'),
      io     = require('socket.io'),
      path   = require('path');

  app.roots.add_compiler(app.assets);

  app.configure(function() {
    app.set('port', process.env.PORT || 3000);
    app.set('views', path.normalize(__dirname + '/../views'));
    app.set('view engine', 'jade');
    app.use(app.assets());
    app.use(app.express.logger('dev'));
    app.use(app.express.bodyParser());
    app.use(app.express.methodOverride());
    app.use(app.router);
    app.use(app.express.static(path.normalize(__dirname + '/public')));
  });

  return Q(http.createServer(app)).then(function(server) {
    app.roots.watch(server);

    return Q.ninvoke(server, 'listen', app.get('port')).then(function() {
      var listener = io.listen(server);

      listener.configure(function() {
        listener.set('log level', 1);
        listener.set('transports',[
          'flashsocket',
          'websocket',
          'xhr-polling',
          'jsonp-polling'
        ]);
        listener.enable('browser client minification');
        listener.enable('browser client etag');
        listener.enable('browser client cache');
      });

      // listener.sockets.on('connection', app.Routers.Socket.route);

      return app;
    });
  });
}