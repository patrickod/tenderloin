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
