module.exports = ->
  # Website Routes

  @route '/', 'application'

  @resources 'scripts'
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
    @resources 'scripts', 'api_scripts'
    @resources 'clients', 'api_clients'
    @resources 'organizations', 'api_organizations', ->
      @resources 'rooms', 'api_rooms', ->
        @resources 'scripts', 'api_scripts'
        @resources 'commands', 'api_commands'

    @resources 'rooms', 'api_rooms', ->
      @resources 'commands', 'api_commands'
