_ = require 'underscore'
redback = require 'redback'
betturl = require 'betturl'

create_client = () ->
  if process.env.REDIS_URL
    config = betturl.parse(process.env.REDIS_URL)
    client = redback.createClient(config.port, config.host)
    client.client.auth(config.auth.password) if config.auth?.password?
  else
    client = redback.createClient()
  return client

Caboose.app.channels = {
  command: create_client().createChannel('commands')
}

return unless Caboose.command is 'server'

channels = {
  command: create_client().createChannel('commands').subscribe()
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
