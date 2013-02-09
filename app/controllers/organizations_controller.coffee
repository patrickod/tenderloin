AuthenticatedController = Caboose.get('AuthenticatedController')
Organization = Caboose.get('Organization')
User = Caboose.get('User')

_ = require 'underscore'
async = require 'async'

class OrganizationsController extends AuthenticatedController

  index: ->
    Organization.where({users: @current_user._id}).array (err, orgs) =>
      return @error(err) if err?
      @organizations = orgs
      @render()

  new: ->
    @render()

  show: ->
    async.waterfall [
      (cb) => Organization.where(_id: @params.id).first(cb),
      (org, cb) ->
        return cb(new Error("Organization not found")) unless org?
        async.map(
          org.users,
          (u, cb) -> User.where(_id: u).first(cb),
          (err, users) =>
            return cb(err) if err?
            cb(null, _.extend(org, {users: _.compact(users)}))
        )
    ], (err, org) =>
      return @error(err) if err?
      @org = org
      @render()

  create: ->
    Organization.save {name: @body.name, users: [@current_user._id]}, (err, org) =>
      return @error(err) if err?
      @redirect_to("/organizations/#{org._id}")
