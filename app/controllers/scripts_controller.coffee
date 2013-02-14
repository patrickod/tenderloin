import 'AuthenticatedController'
import 'Room'

_ = require 'underscore'
async = require 'async'
url = Caboose.get('UrlHelper')

DEFAULT_SCRIPTS = [
  {_id: 'microphone_off', name: 'microphone_off', code: 'gg.microphone_off()'}
  {_id: 'microphone_on', name: 'microphone_on', code: 'gg.microphone_on()'}
  {_id: 'camera_off', name: 'camera_off', code: 'gg.camera_off()'}
  {_id: 'camera_on', name: 'camera_on', code: 'gg.camera_on()'}
  {_id: 'alert', name: 'alert', code: 'gg.play_sound("look_over_here.mp3")'}
]

class ScriptsController extends AuthenticatedController
  # before_action (next) ->
  #   Organization.where(_id: url.decode(@params.organizations_id)).first (err, org) =>
  #     return next(err) if err?
  #     @redirect_to('/organizations') unless org?
  #     @organization = org
  #     next()
  
  before_action (next) ->
    @current_user.organizations().array (err, orgs) =>
      return next(err) if err?
      async.forEach orgs, (org, cb) ->
        org.rooms().array (err, rooms) ->
          return cb(err) if err?
          org.rooms = rooms
          cb()
      , (err) =>
        return next(err) if err?
        @organizations = orgs
        next()

  index: ->
    async.parallel {
      scripts: (cb) => @current_user.scripts().array(cb)
      rooms: (cb) -> Room.clients(cb)
    }, (err, data) =>
      @rooms = data.rooms
      @scripts = DEFAULT_SCRIPTS.slice().concat(data.scripts)
      @script_map = _(@scripts).inject (o, v) ->
        o[v._id] = v
        o
      , {}
      @render()
