_ = require 'underscore'
redback = require 'redback'

Caboose.app.channels = {
  commands: redback.createClient().createChannel('commands')
}

return unless Caboose.command is 'server'

channels = {
  commands: redback.createClient().createChannel('commands').subscribe()
}

_(channels).each (channel, type) ->
  channel.on 'message', (items) ->
    return unless items?
    items = JSON.parse(items)


    if items.room? and items.data?
      room = items.room
      items = items.data

    items = [items] unless Array.isArray(items)

    if room?
      Caboose.app.io.rooms[room].emit(type, items)
    else
      Caboose.app.io.sockets.emit(type, items)
