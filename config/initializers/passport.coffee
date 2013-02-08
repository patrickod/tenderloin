User = Caboose.get('User')

_ = require 'underscore'
async = require 'async'
passport = Caboose.app.passport = require 'passport'
moment = require 'moment'

GoogleStrategy = require('passport-google').Strategy

passport.serializeUser (user, done) ->
  done(null, user._id)

passport.deserializeUser (id, done) ->
  User.where(_id: id).first done

passport.use(
  new GoogleStrategy {
    returnURL: Caboose.app.config.google.return_url,
    realm: Caboose.app.config.google.realm
  }, (identifier, profile, done) ->
    return done("Authentication failure") unless identifier?

    User.where(_id: profile.emails[0].value).first (err, user) ->
      return done(err) if err?

      u = {
        _id: profile.emails[0].value
        google_id: identifier
        name: {first: profile.name.givenName, last: profile.name.familyName},
        google: profile
      }
      u = _.extend(u, {created_at: new Date()}) unless user?

      User.save u, done
)
