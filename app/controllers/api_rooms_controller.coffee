import 'ApiController'
import 'Organization'

_ = require 'underscore'

class ApiRoomsController extends ApiController
  before_action (next) ->
    @current_user.organization(@params.organizations_id).first (err, org) =>
      return next(err) if err?
      @organization = org
      next()

  index: ->
    Organization::rooms.call(@organization).array (err, rooms) =>
      return @error(err) if err?
      @render(json: rooms)

  create: ->
    @organization.create_room @body, (err, room) =>
      return @error(err) if err?
      @render(json: room)
