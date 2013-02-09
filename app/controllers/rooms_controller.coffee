import 'AuthenticatedController'

_ = require 'underscore'
async = require 'async'
Room = Caboose.get('Room')
Organization = Caboose.get('Organization')

class RoomsController extends AuthenticatedController
  index: ->
    @render(json: _(Caboose.app.rooms).keys())

  create: ->
    async.waterfall [
      (cb) => Room.save({organization_id: @params.organizations_id, name: @body.name}, cb),
      (room, cb) => Organization.upsert({_id: @params.organizations_id}, {$push: {rooms: room._id}}, cb)
    ], (err) =>
      return @error(err) if err?
      return @redirect_to("/organizations/#{@params.organizations_id}")
