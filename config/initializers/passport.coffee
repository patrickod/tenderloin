User = Caboose.get('User')

_ = require 'underscore'
async = require 'async'
passport = Caboose.app.passport = require 'passport'
moment = require 'moment'

GoogleStrategy = require('passport-google').Strategy

GOOGLE_RETURN_URL = 'http://' + Caboose.app.config.domain.url + '/auth/google/callback'
GOOGLE_REALM = 'http://' + Caboose.app.config.domain.url + '/'

passport.serializeUser (user, done) ->
  done(null, user._id)

passport.deserializeUser (id, done) ->
  User.where(_id: id).first(done)

passport.use(
  new GoogleStrategy {
    returnURL: GOOGLE_RETURN_URL
    realm: GOOGLE_REALM
  }, (identifier, profile, done) ->
    return done("Authentication failure") unless identifier?
    
    email = profile.emails[0].value
    google_account = _({id: identifier}).extend(profile)
    
    User.where(_id: email).first (err, user) ->
      return done(err) if err?
      
      if user?
        user.update($set: {'accounts.google': google_account})
        return done(null, user)
      
      User.create(
        email: email
        name: {
          first: profile.name.givenName
          last: profile.name.familyName
        }
        accounts: {
          google: google_account
        }
      , done)
)
