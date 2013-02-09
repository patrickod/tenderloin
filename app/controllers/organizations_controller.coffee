AuthenticatedController = Caboose.get('AuthenticatedController')
Organization = Caboose.get('Organization')

class OrganizationsController extends AuthenticatedController

  index: ->
    Organization.where({users: @current_user._id}).array (err, orgs) =>
      return @error(err) if err?
      @orgs = orgs
      @render()
