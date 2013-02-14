class Script extends Model
  store_in 'scripts'
  
  @create: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}
    
    props.created_at = new Date()
    id = "#{props.owner}:#{props.name or new @ObjectID().toString()}"
    
    @upsert {_id: id}, {$set: props}, (err) =>
      return callback(err) if err?
      props._id = id
      callback(null, new @(props))
