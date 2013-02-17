_ = require 'underscore'
uuid = require 'node-uuid'

FIELDS = ['name', 'owner', 'users']

class Organization extends Model
  store_in 'organizations'

  rooms: -> Caboose.get('Room').where(organization: @_id)
  room: (name) -> Caboose.get('Room').where(_id: @_id + ':' + name)
  create_room: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}

    props.organization = @_id

    Caboose.get('Room').create(props, callback)

  remove_room: (name, callback) ->
    console.log "Removing #{@_id}:#{name}"
    Caboose.get('Room').remove({_id: "#{@_id}:#{name}"}, callback)

  add_user: (email, callback) ->
    @update({$addToSet: {users: email}}, callback)

  @create: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}

    props = _.pick(props, FIELDS)
    props.api_key = uuid.v1()
    props._id = "#{props.owner}:#{props.name}"

    return callback(new Error('Organization name cannot contain a colon')) if /:/.test(props.name)

    @where(_id: props._id).count (err, count) =>
      return callback(err) if err?
      return callback(new Error('Organization named ' + props.name + ' already exists')) if count > 0
      @save(props, callback)
