AuthenticatedController = Caboose.get('AuthenticatedController')
Organization = Caboose.get('Organization')
url = Caboose.get('UrlHelper')

class OrganizationsController extends AuthenticatedController
  before_action (next) ->
    return next() unless @params.id?
    
    Organization.where(_id: url.decode(@params.id)).first (err, organization) =>
      return next(err) if err?
      return @redirect_to('/organizations') unless organization?
      @organization = organization
      next()

  index: ->
    @current_user.organizations().array (err, orgs) =>
      return @error(err) if err?
      @organizations = orgs
      @render()

  new: ->
    @render()

  show: ->
    @organization.rooms().array (err, rooms) =>
      return @error(err) if err?
      @organization.rooms = rooms
      @render()
  
  create: ->
    @current_user.create_organization @body, (err, org) =>
      return @error(err) if err?
      @redirect_to("/organizations/#{url.encode(org._id)}")
