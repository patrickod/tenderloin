ApplicationController = Caboose.get('ApplicationController')
passport = Caboose.app.passport

class AuthController extends ApplicationController
  before_action (next) ->
    Caboose.app.passport.authenticate('google')(@request, @response, next)
  , {only: ['google_new', 'google_create']}

  google_new: -> @render()
  google_create: ->
    user = @request.user
    init = passport.initialize()
    sess = passport.session()
    
    @request.session.regenerate =>
      init @request, @response, =>
        sess @request, @response, =>
          @request.logIn user, =>
            @redirect_to('/')
  
  destroy: ->
    @request.logOut()
    @session.destroy()
    @redirect_to '/'
