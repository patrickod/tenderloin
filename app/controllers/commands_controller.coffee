import 'ApplicationController'

class CommandsController extends ApplicationController
  index: -> @render()
  
  create: ->
    Caboose.app.channels.command.publish(JSON.stringify(room: @params.rooms_id, message: @body.command))
    if @params.format is 'json'
      @render(json: 'ok')
    else
      @redirect_to "/rooms/#{@params.rooms_id}/commands"
