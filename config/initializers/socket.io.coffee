return unless Caboose.command is 'server'

io = require 'socket.io'

Caboose.app.after 'boot', ->
  Caboose.app.io = io.listen(Caboose.app.raw_http)

  Caboose.app.io.sockets.on 'connection', (socket) ->
    console.log "New client connected"
    socket.emit('message', {message: 'Hello world'})

  # Dynamic room creation
  Caboose.app.io.rooms = (name) -> Caboose.app.io.of(name)
