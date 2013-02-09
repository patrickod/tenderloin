AuthenticatedController = Caboose.get('AuthenticatedController')
Organisation = Caboose.get('Organisation')

class OrganisationsController extends AuthenticatedController

  index: ->
    Organisation.where({users: @current_user._id}).array (err, orgs) =>
      return @error(err) if err?
      @orgs = orgs
      @render()
