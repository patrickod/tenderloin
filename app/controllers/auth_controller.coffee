ApplicationController = Caboose.get('ApplicationController')

class AuthController extends ApplicationController
  before_action ((next) ->
    Caboose.app.passport.authenticate('google', {successRedirect: '/', failureRedirect: '/login'})(@request, @response, next)
    ), {only: ['google_new', 'google_create']}

  google_new: -> @render()
  google_create: -> @redirect_to('/')

  destroy: ->
    @request.logOut()
    @session.destroy()
    @redirect_to '/'
