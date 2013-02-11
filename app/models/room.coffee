FIELDS = ['_id', 'name', 'organization']
class Room extends Model
  store_in 'rooms'

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
      [owner, organization, name] = props._id.split(':')
      url = "/organizations/#{organization}/rooms/#{name}"
      Caboose.app.rooms[url] = Caboose.app.io.of(url)
