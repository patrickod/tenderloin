import 'ApiController'
import 'Organization'
import 'ApiHelper'

class ApiRoomsController extends ApiController
  before_action ApiHelper.fetch_organization('organizations_id')
  
  index: ->
    Organization::rooms.call(@organization).array (err, rooms) =>
      return @error(err) if err?
      @render(json: rooms)
  
  show: ->
    @organization.room(@params.id).first (err, room) =>
      return @error(err) if err?
      @render(json: room)
  
  create: ->
    @organization.create_room @body, (err, room) =>
      return @error(err) if err?
      @render(json: room)
