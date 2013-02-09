import 'ApiController'
import 'Organization'

_ = require 'underscore'

class ApiOrganizationsController extends ApiController
  index: ->
    Organization.where(users: @current_user._id).fields(['name']).array (err, data) =>
      return @error(err) if err?
      @render(json: _(data).pluck('name'))
  
  # show: ->
  #   Organization.where(users: @current_user._id).fields('name').array (err, organizations) =>
  #     return @error(err) if err?
  #     @respond(json: organizations)
