ApiController = Caboose.get('ApiController')
Organization = Caboose.get('Organization')
ApiHelper = Caboose.get('ApiHelper')

url = Caboose.get('UrlHelper')
_ = require 'underscore'
request = require 'request'

basic_command = (cmd) ->
  (cb) -> cb(null, cmd)

COMMANDS =
  microphone_off: basic_command('gg.microphone_off()')
  microphone_on: basic_command('gg.microphone_on()')
  camera_off: basic_command('gg.camera_off()')
  camera_on: basic_command('gg.camera_on()')
  alert: basic_command('gg.play_sound("look_over_here.mp3")')

  gist: (cb) ->
    return cb(new Error('No URL provided')) unless @query.url?
    request.get @query.url, (err, response, body) =>
      return cb(err) if err?
      return cb(new Error('Could not load gist: ' + @query.url)) unless response.statusCode is 200
      cb(null, body)

  sound: (cb) ->
    return cb(new Error('No URL provided')) unless @query.url?
    cb(null, "gg.play_sound('#{@query.url}')")

  sound_stop: basic_command("gg.stop_sound()")


class ApiCommandsController extends ApiController
  before_action ApiHelper.fetch_room

  index: ->
    @render(json: _(COMMANDS).keys())

  show: ->
    command = COMMANDS[@params.id]
    @respond_json(404, {error: 'Invalid command: ' + @params.id}) unless command?

    command.call @, (err, cmd) =>
      return @respond_json(500, {error: err.message}) if err?

      @room.send_command(cmd)
      @respond(json: 'ok')

  create: ->
    @room.send_command(@body.command)
    @respond(json: 'ok')
