requirejs.config
  paths:
    'socket.io': '/socket.io/socket.io.js'

console.log 'Coffeescript Works!'

require ['socket.io'], (io) ->
  socket = io.connect 'http://localhost:3000'
  socket.on 'hello', (message) ->
    console.log 'Socket.io Works!'
