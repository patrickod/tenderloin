ApiController = Caboose.get('ApiController')

request = require 'request'

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

  camera_off: ->
    @send_command('bulkhead.camera_off()')
    @respond(json: 'ok')

  camera_on: ->
    @send_command('bulkhead.camera_on()')
    @respond(json: 'ok')

  alert: ->
    @send_command('bulkhead.play_sound("look_over_here.mp3")')
    @respond(json: 'ok')

  gist: ->
    return @respond(json: {error: "No URL provided"}) unless @query.url?
    request.get @query.url, (err, response, body) =>
      return @error(err) if err?
      return @respond(json: {error:"Couldn't load that gist"}) unless response.statusCode is 200

      @send_command(body)
      @respond(json: 'ok')

  sound: ->
    return @respond(json: {error: "No URL provided"}) unless @query.url?
    @send_command("bulkhead.play_sound('#{@query.url}')")
    @respond(json: 'ok')

  sound_stop: ->
    @send_command("bulkhead.stop_sound()")
    @respond(json: 'ok')
