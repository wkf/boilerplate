var Q   = require('q'),
    app = require('express')();

require('coffee-script');

app.environment = process.env.NODE_ENV || 'development';

app.express     = require('express');
app.roots       = require('roots-express');
app.assets      = require('connect-assets');

app.database    = require('./lib/database.js');
app.server      = require('./lib/server.js');

app.Routers     = require('./routers');
app.Models      = require('./models');
app.Controllers = require('./controllers');

app.config      = require('./config.json');

for (option in app.config) { app.set(option, app.config[option]); }

Q(app)
  .then(appStart)
  .then(app.database)
  .then(app.Models)
  .then(app.Controllers)
  .then(app.Routers)
  .then(app.server)
  .then(receiveSignal)
  .then(appStop)
  .fail(appCrash);

function appStart(app) {
  console.log('Node App Started');

  return app;
}

function appStop(app) {
  console.log('Node App Stopped');
  process.exit(0);
}

function appCrash(error) {
  console.log('Node App Crashed', error);
  process.exit(1);
}

function receiveSignal(app) {
  var deferred = Q.defer();

  process.on('SIGINT', deferred.resolve.bind(deferred, app));
  process.on('SIGTERM', deferred.resolve.bind(deferred, app));

  return deferred.promise;
}