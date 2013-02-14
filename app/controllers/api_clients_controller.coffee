import 'ApiController'
import 'Room'

class ApiClientsController extends ApiController
  index: ->
    Room.clients (err, clients) =>
      return @error(err) if err?
      @render(json: clients)
  # 
  # show: ->
  #   @current_user.script(UrlHelper.decode(@params.id)).first (err, script) =>
  #     return @error(err) if err?
  #     @render(json: script)
  # 
  # create: ->
  #   @current_user.create_script @body, (err, script) =>
  #     return @error(err) if err?
  #     @render(json: script)
