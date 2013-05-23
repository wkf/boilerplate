module.exports = function(app) {
  console.log('Initializing Routers...');

  app.get('/', app.Controllers.App.index);

  return app;
}