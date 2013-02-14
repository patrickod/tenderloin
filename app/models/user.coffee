class User extends Model
  store_in 'users'
  
  organizations: -> Caboose.get('Organization').where(users: @_id)
  organization: (name) -> Caboose.get('Organization').where(users: @_id, name: name)
  
  create_organization: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}
    
    props.owner = @_id
    props.users ?= []
    props.users.push(@_id)
    
    Caboose.get('Organization').create(props, callback)
  
  scripts: -> Caboose.get('Script').where(_id: new RegExp("^#{@_id}:"))
  script: (name) -> Caboose.get('Script').where(_id: "#{@_id}:#{name}")
  
  create_script: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}
    
    props.owner = @_id
    
    Caboose.get('Script').create(props, callback)
  
  @create: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}
    
    props.created_at = new Date()
    props._id = props.email
    
    @where(_id: props._id).count (err, count) =>
      return callback(err) if err?
      return callback(new Error('User with email ' + props._id + ' already exists')) if count > 0
      @save(props, callback)
