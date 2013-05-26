requirejs.config
  paths:
    'socket.io': '/socket.io/socket.io.js'

# workaround for a bug with facebook's oauth implementation
if window.location.hash and window.location.hash is '#_=_'
  if window.history and history.pushState
    window.history.pushState('', document.title, window.location.pathname)
  else
    scrollTop = document.body.scrollTop
    scrollLeft = document.body.scrollLeft
    window.location.hash = ''
    document.body.scrollTop = scrollTop
    document.body.scrollLeft = scrollLeft

console.log 'Coffeescript Works!'

# require ['socket.io'], (io) ->
#   socket = io.connect 'http://localhost:3000'
#   socket.on 'hello', (message) ->
#     console.log 'Socket.io Works!'
