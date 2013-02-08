import 'ApplicationController'

class ApiController extends ApplicationController
  before_action (next) ->
    @params.format = 'json'
    next()
