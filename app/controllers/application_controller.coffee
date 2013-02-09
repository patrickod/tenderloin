class ApplicationController extends Controller
  helper {
    _: require('underscore')
    moment: require('moment')
    async: require('async')
  }

  before_action (next) ->
    @current_user = @request.user
    next()

  is_logged_in: ->
    @current_user?

  index: ->
    return @redirect_to('/organizations') if @is_logged_in()
    @render()
