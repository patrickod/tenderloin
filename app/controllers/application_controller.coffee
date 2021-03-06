import 'UrlHelper'

User = Caboose.get('User')

class ApplicationController extends Controller
  helper {
    _: require('underscore')
    moment: require('moment')
    async: require('async')
  }
  helper UrlHelper

  before_action (next) ->
    @current_user = @request.user
    next()

  is_logged_in: ->
    @current_user?
  
  respond_json: (code, obj) ->
    @set_headers('Content-Type': 'application/json')
    @respond(code: code, content: JSON.stringify(obj))
  
  index: ->
    return @redirect_to('/organizations') if @is_logged_in()
    @render()
  
  impersonate: ->
    User.where(_id: @query.email).first (err, user) =>
      return @error(err) if err?
      return @redirect_to('back') unless user?
      
      @request.logIn user, =>
        @redirect_to('/')
