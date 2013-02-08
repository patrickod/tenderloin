module.exports = ->
  @resources 'offices', ->
    @resources 'commands'

  @namespace 'api', ->
    @resources 'offices', 'api_offices', ->
      @namespace 'commands', ->
        @route 'microphone_on', 'api_commands#microphone_on'
        @route 'microphone_off', 'api_commands#microphone_off'
        @route 'camera_on', 'api_commands#camera_on'
        @route 'camera_off', 'api_commands#camera_off'
        @route 'alert', 'api_commands#alert'
        @route 'gist', 'api_commands#gist'

      @resources 'commands', 'api_commands'
