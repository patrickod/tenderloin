import 'ApiController'

_ = require 'underscore'

class ApiOrganizationsController extends ApiController
  index: ->
    @current_user.organizations().array (err, data) =>
      return @error(err) if err?
      @render(json: data)
  
  show: ->
    @current_user.organization(@params.id).first (err, org) =>
      return @error(err) if err?
      @render(json: org)
  
  create: ->
    @current_user.create_organization @body, (err, org) =>
      return @error(err) if err?
      @render(json: org)
