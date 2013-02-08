import 'ApplicationController'

class AuthenticatedController extends ApplicationController
  before_action (next) ->
    return @redirect_to('/') unless @is_logged_in()
    next()
