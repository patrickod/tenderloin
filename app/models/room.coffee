_ = require 'underscore'
url = Caboose.get('UrlHelper')

FIELDS = ['name', 'organization']

class Room extends Model
  store_in 'rooms'
  
  send_command: (cmd, callback) ->
    Caboose.app.channels.command.publish(JSON.stringify(
      room: @_id, message: cmd
    ))
  
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
