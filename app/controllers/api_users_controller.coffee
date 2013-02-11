import 'ApiController'
import 'ApiHelper'

class ApiUsersController extends ApiController
  before_action ApiHelper.ensure_logged_in
  
  index: ->
    @render(json: @current_user)
