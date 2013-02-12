return unless Caboose.command is 'server'

Room = Caboose.get('Room')
url = Caboose.get('UrlHelper')

Room.array (err, rooms) ->
  throw err if err?
  
  rooms.forEach (room) ->
    Caboose.app.io.of('/' + url.encode(room._id)).authorization (handshake, callback) ->
      api_key = handshake.headers?['x-tenderloin-api-key']
      return callback(null, false) unless api_key?
      
      Organization = Caboose.get('Organization')
      Organization.where(_id: room.organization, api_key: api_key).count (err, count) ->
        return callback(err) if err?
        callback(null, count > 0)
