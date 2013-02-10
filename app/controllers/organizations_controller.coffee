AuthenticatedController = Caboose.get('AuthenticatedController')
Organization = Caboose.get('Organization')
User = Caboose.get('User')
Room = Caboose.get('Room')

_ = require 'underscore'
async = require 'async'
uuid = require 'node-uuid'

class OrganizationsController extends AuthenticatedController

  index: ->
    @current_user.organizations().array (err, orgs) =>
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
        async.parallel {
          users: (cb) => async.map(org.users, ((u, cb) -> User.where(_id: u).first(cb)), cb),
          rooms: (cb) => async.map(org.rooms, ((u, cb) -> Room.where(_id: u).first(cb)), cb)
        }, (err, results) =>
          return cb(err) if err?
          cb(null, _.extend(org, results))
    ], (err, org) =>
      return @error(err) if err?
      @org = org
      @render()

  create: ->
    @current_user.create_organization @body, (err, org) =>
      return @error(err) if err?
      @redirect_to("/organizations/#{org._id}")
