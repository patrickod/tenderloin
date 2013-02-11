import 'ApiController'
import 'ApiHelper'

class ApiOrganizationsController extends ApiController
  before_action ApiHelper.fetch_organization('id')
  
  index: ->
    @current_user.organizations().array (err, data) =>
      return @error(err) if err?
      @render(json: data)
  
  show: ->
    @render(json: @organization)
  
  create: ->
    @current_user.create_organization @body, (err, org) =>
      return @error(err) if err?
      @render(json: org)
