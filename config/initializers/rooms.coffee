return unless Caboose.command is 'server'

Room = Caboose.get('Room')
url = Caboose.get('UrlHelper')

Room.array (err, rooms) ->
  throw err if err?
  
  rooms.forEach (room) ->
    channel = Caboose.app.io.of('/' + url.encode(room._id))
    channel.authorization (handshake, callback) ->
      api_key = handshake.headers?['x-tenderloin-api-key']
      unless api_key?
        console.log 'NO TENDERLOIN API KEY'
        return callback(null, false)
      
      Caboose.get('Organization').where(_id: room.organization, api_key: api_key).count (err, count) ->
        return callback(err) if err?
        console.log('ORGANIZATION DOES NOT MATCH API KEY: ' + room.organization + ' - ' + api_key) if count is 0
        callback(null, count > 0)
    
    channel.on 'connection', (socket) ->
      console.log 'ON CONNECTION'
      socket.on 'ping', (msg) ->
        room.client_ping(socket.id)
      socket.on 'disconnect', ->
        console.log 'DISCONNECTED'
