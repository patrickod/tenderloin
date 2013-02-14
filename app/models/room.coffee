_ = require 'underscore'
url = Caboose.get('UrlHelper')

FIELDS = ['name', 'organization']

client_rx = /room:\[([^\]]+)\]:(.+)/

class Room extends Model
  store_in 'rooms'
  
  send_command: (cmd, callback) ->
    Caboose.app.channels.command.publish(JSON.stringify(
      room: @_id, message: cmd
    ))
  
  client_ping: (client_id) ->
    Caboose.app.redis.default.setex('room:[' + @_id + ']:' + client_id, 5, 1)
  
  clients: (callback) ->
    Caboose.app.redis.default.keys 'room:[' + @_id + ']:*', (err, keys) ->
      return callback(err) if err?
      callback(null, keys.map (k) ->
        [_x, room, client_id] = client_rx.exec(k)
        client_id
      )
  
  @create: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}
    
    props = _.pick(props, FIELDS)
    return callback(new Error("Room name cannot contain :")) if props.name.match /:/

    props._id = "#{props.organization}:#{props.name}"

    @where(_id: props._id).count (err, count) =>
      return callback(err) if err?
      return callback(new Error('Room named ' + props.name + ' already exists')) if count > 0

      @save(props, callback)
      
      # Create socket.io the namespace for the new room
      Caboose.app.io.of('/' + url.encode(props._id))
  
  @clients: (callback) ->
    Caboose.app.redis.default.keys 'room:*', (err, keys) ->
      return callback(err) if err?
      callback(null, _.chain(keys)
        .map (k) ->
          [_x, room, client_id] = client_rx.exec(k)
          {
            room: room
            client_id: client_id
          }
        .inject((o, v) ->
          o[v.room] ?= {
            organization: /[^:]+:[^:]+/.exec(v.room)[0]
            room: v.room.split(':')[2]
            count: 0
            clients: []
          }
          o[v.room].count += 1
          o[v.room].clients.push(v.client_id)
          o
        , {})
        .value()
      )
