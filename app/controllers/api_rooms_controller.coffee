import 'ApiController'

_ = require 'underscore'

class ApiRoomsController extends ApiController
  index: ->
    @render(json: _(Caboose.app.rooms).keys())
