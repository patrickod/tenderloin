return unless Caboose.command is 'server'

Room = Caboose.get('Room')
url = Caboose.get('UrlHelper')

Room.array (err, rooms) ->
  throw err if err?
  
  Caboose.app.io.of('/' + url.encode(r._id)) for r in rooms
