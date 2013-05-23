module.exports = function(app) {
  console.log('Initializing Controllers...');

  module.exports.App = require('./app_controller.js')(app);

  return app;
}