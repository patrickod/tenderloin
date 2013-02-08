return unless Caboose.command is 'server'

Caboose.app.after 'boot', ->
  io = Caboose.app.io = require('socket.io').listen(Caboose.app.raw_http)
  # io = Caboose.app.io = require('socket.io').listen(Caboose.app.raw_http, 'tenderloin-sf.herokuapp.com')
  
  io.configure ->
    io.set('transports', ['xhr-polling'])
    io.set("polling duration", 10)
  
  console.log(k) for k, v of Caboose.app.offices
  
  io.sockets.on 'connection', (socket) ->
    console.log 'New Connection'
    socket.on 'disconnect', ->
      console.log 'Disconnected'
