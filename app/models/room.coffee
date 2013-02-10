class Room extends Model
  store_in 'rooms'
  
  @create: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}
    
    props._id = "#{props.organization}:#{props.name}"
    
    @where(_id: props._id).count (err, count) =>
      return callback(err) if err?
      return callback(new Error('Room named ' + props.name + ' already exists')) if count > 0
      @save(props, callback)
