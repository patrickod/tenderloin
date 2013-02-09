import 'ApplicationController'

class ApiController extends ApplicationController
  before_action (next) ->
    @params.format = 'json'
    return @respond_json(401, {error: 'Unauthorized'}) unless @is_logged_in()
    next()
  
  error: (err) ->
    @respond_json(500, {error: err.message, stack: err.stack})
