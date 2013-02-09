return unless Caboose.command is 'server'

Caboose.app.after 'boot', ->
  io = Caboose.app.io = require('socket.io').listen(Caboose.app.raw_http)
  # io = Caboose.app.io = require('socket.io').listen(Caboose.app.raw_http, 'tenderloin-sf.herokuapp.com')

  io.configure ->
    io.set('transports', ['xhr-polling'])
    io.set("polling duration", 10)
