class ApplicationController extends Controller
  before_action (next) ->
    @current_user = @request.user
    next()

  is_logged_in: ->
    @current_user?
  
  index: ->
    return @redirect_to('/orgs') if @is_logged_in()
    @render()
