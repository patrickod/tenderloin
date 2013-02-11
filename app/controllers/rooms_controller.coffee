import 'AuthenticatedController'

_ = require 'underscore'
async = require 'async'
Room = Caboose.get('Room')
Organization = Caboose.get('Organization')

class RoomsController extends AuthenticatedController
  before_action (next) ->
    Organization.where(_id: @params.organizations_id).first (err, org) =>
      return next(err) if err?
      @organization = org
      next()

  index: ->
    @organization.rooms().array (err, rooms) =>
      return @error(err) if err?
      @rooms = rooms
      @render()

  create: ->
    async.waterfall [
      (cb) => Room.save({organization_id: @params.organizations_id, name: @body.name}, cb),
      (room, cb) => Organization.upsert({_id: @params.organizations_id}, {$push: {rooms: room._id}}, cb)
    ], (err) =>
      return @error(err) if err?
      return @redirect_to("/organizations/#{@params.organizations_id}")
