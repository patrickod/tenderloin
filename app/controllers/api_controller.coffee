import 'ApplicationController'
Organization = Caboose.get('Organization')

class ApiController extends ApplicationController
  before_action (next) ->
    @params.format = 'json'
    return @respond_json(401, {error: 'Unauthorized'}) unless @is_logged_in() or @request.api_key
    next()

  before_action (next) ->
    Organization.where({api_key: @request.api_key}).first (err, org) =>
      return @error(err) if err?
      return @respond_json(401, {error: "Invalid API key"}) unless org?
      @organization = org
      next()

  before_action (next) ->
    return unless @params.organizations_id
    return @respond_json({401: {error: "Unauthorized"}) unless @organization.name is @params.organization
    next()

  error: (err) ->
    console.log err.stack
    @respond_json(500, {error: err.message})

  user: ->
    @render(json: @current_user)
