module.exports = ->
  @route '/', 'application'
  @resources 'orgs', ->
    @resources 'hangouts'
  
  @resources 'offices', ->
    @resources 'commands'

  @route 'auth/logout', 'auth#destroy'
  @route 'auth/google', 'auth#google_new'
  @route 'auth/google/callback', 'auth#google_create'

  @namespace 'api', ->
    @resources 'offices', 'api_offices', ->
      @namespace 'commands', ->
        @route 'microphone_on', 'api_commands#microphone_on'
        @route 'microphone_off', 'api_commands#microphone_off'
        @route 'camera_on', 'api_commands#camera_on'
        @route 'camera_off', 'api_commands#camera_off'
        @route 'alert', 'api_commands#alert'
        @route 'gist', 'api_commands#gist'
        @route 'sound', 'api_commands#sound'
        @route 'stop_sound', 'api_commands#stop_sound'

      @resources 'commands', 'api_commands'
