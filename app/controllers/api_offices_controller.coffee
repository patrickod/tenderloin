import 'ApiController'

_ = require 'underscore'

class ApiOfficesController extends ApiController
  index: ->
    @render(json: _(Caboose.app.offices).keys())
