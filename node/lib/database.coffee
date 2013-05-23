module.exports = (App) ->
  Q        = require('q')
  mongoose = require('mongoose-q')(require('mongoose'), prefix: '_')

  console.log 'Initializing Database...'

  mongoose.connect App.get('database');

  Q.ninvoke(mongoose.connection, 'once', 'open').then ->
    module.exports = mongoose
    App
