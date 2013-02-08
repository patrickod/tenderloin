_ = require 'underscore'
redback = require 'redback'

Caboose.app.channels = {
  command: redback.createClient().createChannel('commands')
}

return unless Caboose.command is 'server'

channels = {
  command: redback.createClient().createChannel('commands').subscribe()
}

_(channels).each (channel, type) ->
  channel.on 'message', (items) ->
    return unless items?
    items = JSON.parse(items)
    items = [items] unless Array.isArray(items)
    
    items.forEach (message) ->
      return unless message.room? and message.message?
      room = Caboose.app.rooms[message.room]
      return unless room?
      Caboose.app.rooms[message.room].send(message.message)
