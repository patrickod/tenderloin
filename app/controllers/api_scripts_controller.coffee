import 'ApiController'
import 'UrlHelper'

class ApiScriptsController extends ApiController
  index: ->
    @current_user.scripts().array (err, scripts) =>
      return @error(err) if err?
      @render(json: scripts)
  
  show: ->
    @current_user.script(UrlHelper.decode(@params.id)).first (err, script) =>
      return @error(err) if err?
      @render(json: script)
  
  create: ->
    @current_user.create_script @body, (err, script) =>
      return @error(err) if err?
      @render(json: script)
  
  destroy: ->
    @current_user.script(@params.id).remove (err) =>
      return @error(err) if err?
      @render(json: 'ok')
