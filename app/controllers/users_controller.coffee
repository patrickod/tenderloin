import 'AuthenticatedController'

_ = require 'underscore'
async = require 'async'
Organization = Caboose.get('Organization')
url = Caboose.get('UrlHelper')

class UsersController extends AuthenticatedController
  before_action (next) ->
    Organization.where(_id: url.decode(@params.organizations_id)).first (err, org) =>
      return next(err) if err?
      @redirect_to('/organizations') unless org?
      @organization = org
      next()

  create: ->
    @organization.add_user @body.name, (err) =>
      return @error(err) if err?
      @redirect_to "/organizations/#{@params.organizations_id}"

  destroy: ->
    @organization.remove_user url.decode(@params.id), (err) =>
      return @error(err) if err?
      @redirect_to "/organizations/#{@params.organizations_id}"
