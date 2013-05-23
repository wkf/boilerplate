module.exports = class
  constructor: (client) ->
    console.log 'Client Connected'
    @client = client
    @ip = client.handshake.address.address
    @client.emit('hello')

    @client.on 'message', (message) =>
      console.log 'Client Message: ' + message

    @client.on 'disconnect', (reason) =>
      @client
        .removeAllListeners('message')
        .removeAllListeners('disconnect')