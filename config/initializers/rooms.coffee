return unless Caboose.command is 'server'

Room = Caboose.get('Room')
_ = require 'underscore'

Caboose.app.rooms = {}

Room.array (err, rooms) ->
  throw err if err?

  _.each rooms, (r) ->
    [owner, organization, name] = r._id.split(':')
    url = "/organizations/#{organization}/rooms/#{name}"

    Caboose.app.rooms[url] = Caboose.app.io.of(url)
