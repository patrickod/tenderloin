return unless Caboose.command is 'server'

Room = Caboose.get('Room')
url = Caboose.get('UrlHelper')

Room.array (err, rooms) ->
  throw err if err?
  
  rooms.forEach (room) ->
    channel = Caboose.app.io.of('/' + url.encode(room._id))
    channel.authorization (handshake, callback) ->
      api_key = handshake.headers?['x-tenderloin-api-key']
      return callback(null, false) unless api_key?
      
      Organization = Caboose.get('Organization')
      Organization.where(_id: room.organization, api_key: api_key).count (err, count) ->
        return callback(err) if err?
        callback(null, count > 0)
    
    channel.on 'connection', (socket) ->
      console.log 'ON CONNECTION'
      socket.on 'ping', (msg) ->
        room.client_ping(socket.id)
