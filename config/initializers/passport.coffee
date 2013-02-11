User = Caboose.get('User')

_ = require 'underscore'
async = require 'async'
passport = Caboose.app.passport = require 'passport'
moment = require 'moment'

GoogleStrategy = require('passport-google').Strategy

passport.serializeUser (user, done) ->
  done(null, user._id)

passport.deserializeUser (id, done) ->
  User.where(_id: id).first(done)

passport.use(
  new GoogleStrategy {
    returnURL: Caboose.app.config.google.return_url,
    realm: Caboose.app.config.google.realm
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
