module.exports = function(app) {
  console.log('Initializing Database...');

  var Q          = require('q'),
      mongoose   = require('mongoose-q')(require('mongoose'), {prefix : '_'});

  mongoose.connect(app.get('database'));

  return Q.ninvoke(mongoose.connection, 'once', 'open').then(function() {
    return module.exports = mongoose, app;
  });
}