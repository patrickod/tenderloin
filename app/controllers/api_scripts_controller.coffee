import 'ApiController'
import 'UrlHelper'
import 'Script'

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
    Script.remove {_id: UrlHelper.decode(@params.id)}, (err) =>
      return @error(err) if err?
      @render(json: 'ok')
