return unless Caboose.command is 'server'

io = require 'socket.io'
_ = require 'underscore'

Caboose.app.after 'boot', ->
  Caboose.app.io = io.listen(Caboose.app.raw_http, 'tenderloin-sf.herokuapp.com')

  Caboose.app.rooms = {
    sf: Caboose.app.io.of('/sf')
    nyc: Caboose.app.io.of('/nyc')
  }
