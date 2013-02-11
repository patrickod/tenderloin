import 'ApplicationController'
Organization = Caboose.get('Organization')

class ApiController extends ApplicationController
  before_action (next) ->
    @params.format = 'json'
    next()
  
  error: (err) ->
    console.log err.stack
    @respond_json(500, {error: err.message})
