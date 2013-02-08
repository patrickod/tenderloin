import 'ApiController'

class ApiCommandsController extends ApiController
  send_command: (cmd) ->
    Caboose.app.channels.command.publish(JSON.stringify(
      office: @params.offices_id, message: cmd
    ))
  
  create: ->
    @send_command(@body.command)
    @respond(json: 'ok')
  
  microphone_off: ->
    @send_command('bulkhead.microphone_off()')
    @respond(json: 'ok')
  
  microphone_on: ->
    @send_command('bulkhead.microphone_on()')
    @respond(json: 'ok')
  
  alert: ->
    @send_command('bulkhead.play_sound("look_over_here")')
    @respond(json: 'ok')
