AuthenticatedController = Caboose.get('AuthenticatedController')
Organization = Caboose.get('Organization')

class OrganizationsController extends AuthenticatedController

  index: ->
    Organization.where({users: @current_user._id}).array (err, orgs) =>
      return @error(err) if err?
      @organizations = orgs
      @render()

  new: ->
    @render()

  show: ->
    Organization.where(_id: @params.id).first (err, org) =>
      return @error(err) if err?
      @org = org
      @render()

  create: ->
    Organization.save {name: @body.name, users: [@current_user._id]}, (err, org) =>
      return @error(err) if err?
      @redirect_to("/organizations/#{org._id}")
