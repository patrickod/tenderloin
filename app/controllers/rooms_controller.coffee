import 'ApiController'

_ = require 'underscore'

class RoomsController extends ApiController
  index: ->
    @render(json: _(Caboose.app.rooms).keys())
