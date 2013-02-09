class ApplicationController extends Controller
  before_action (next) ->
    @current_user = @request.user
    next()

  is_logged_in: ->
    @current_user?
  
  respond_json: (code, obj) ->
    @set_headers('Content-Type': 'application/json')
    @respond(code: code, content: JSON.stringify(obj))
  
  index: ->
    return @redirect_to('/organizations') if @is_logged_in()
    @render()
