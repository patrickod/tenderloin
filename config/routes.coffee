module.exports = ->
  # Website Routes
  
  @route '/', 'application'
  
  @resources 'organizations', ->
    @resources 'rooms'
    @resources 'users'
  
  # Auth Routes
  
  @route 'auth/logout', 'auth#destroy'
  @route 'auth/google', 'auth#google_new'
  @route 'auth/google/callback', 'auth#google_create'
  
  # API Routes
  
  @namespace 'api', ->
    @route 'user', 'api_users'
    @resources 'organizations', 'api_organizations', ->
      @resources 'rooms', 'api_rooms', ->
        @resources 'scripts', 'api_scripts'
        @resources 'commands', 'api_commands'
    
    @resources 'rooms', 'api_rooms', ->
      @resources 'scripts', 'api_scripts'
      @resources 'commands', 'api_commands'
    
    #
    #
    #
    # @resources 'rooms', 'api_rooms', ->
    #   @namespace 'commands', ->
    #     @route 'microphone_on', 'api_commands#microphone_on'
    #     @route 'microphone_off', 'api_commands#microphone_off'
    #     @route 'camera_on', 'api_commands#camera_on'
    #     @route 'camera_off', 'api_commands#camera_off'
    #     @route 'alert', 'api_commands#alert'
    #     @route 'gist', 'api_commands#gist'
    #     @route 'sound', 'api_commands#sound'
    #     @route 'stop_sound', 'api_commands#stop_sound'
    #
    #   @resources 'commands', 'api_commands'
