_ = require 'underscore'
uuid = require 'node-uuid'

FIELDS = ['name', 'owner', 'rooms']

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

  @create: (props, callback) ->
    if typeof props is 'function'
      callback = props
      props = {}

    props.rooms ?= []
    props.api_key = uuid.v1()
    props._id = "#{props.owner}:#{props.name}"

    props = _.pick(props, FIELDS)

    return callback(new Error("Organization name cannot contain :")) if props.name.match /:/

    @where(_id: props._id).count (err, count) =>
      return callback(err) if err?
      return callback(new Error('Organization named ' + props.name + ' already exists')) if count > 0
      @save(props, callback)
