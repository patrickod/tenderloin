_ = require 'underscore'
redback = require 'redback'
betturl = require 'betturl'

config = betturl.parse(process.env.REDIS_URL || {})

Caboose.app.channels = {
  command: redback.createClient(config.port, config.host).createChannel('commands')
}

return unless Caboose.command is 'server'

channels = {
  command: redback.createClient(config.port, config.host).createChannel('commands').subscribe()
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
