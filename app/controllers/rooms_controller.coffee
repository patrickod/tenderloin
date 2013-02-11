import 'AuthenticatedController'

_ = require 'underscore'
async = require 'async'
Room = Caboose.get('Room')
Organization = Caboose.get('Organization')
url = Caboose.get('UrlHelper')

class RoomsController extends AuthenticatedController
  before_action (next) ->
    Organization.where(_id: url.decode(@params.organizations_id)).first (err, org) =>
      return next(err) if err?
      @redirect_to('/organizations') unless org?
      @organization = org
      next()

  index: ->
    @organization.rooms().array (err, rooms) =>
      return @error(err) if err?
      @rooms = rooms
      @render()

  create: ->
    @organization.create_room @body, (err, room) =>
      return @error(err) if err?
      @redirect_to "/organizations/#{url.encode(room.organization)}"
