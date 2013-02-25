express = require 'express'
flash = require 'connect-flash'
passport = Caboose.app.passport
RedisStore = require('connect-redis')(express)

module.exports = (http) ->
  http.use express.bodyParser()
  http.use express.methodOverride()

  http.use (req, res, next) ->
    if req.headers['x-tenderloin-auth']?
      req.headers.cookie = 'connect.sid=' + req.headers['x-tenderloin-auth']
      delete req.headers['x-tenderloin-auth']
    next()

  http.use (req, res, next) ->
    if req.headers['x-tenderloin-api-key']?
      req.api_key = req.headers['x-tenderloin-api-key']
      delete req.headers['x-tenderloin-api-key']
    next()

  http.use express.cookieParser()
  http.use express.session(secret: '1sMCS037ADabTTf8wp5AlmmuzNY1BYgC', store: new RedisStore(client: Caboose.app.redis.default))

  http.use passport.initialize()
  http.use passport.session()

  http.use (req, res, next) ->
    # res.header 'Access-Control-Allow-Credentials', true
    res.header 'Access-Control-Allow-Origin', '*'
    res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS'
    res.header 'Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'

    return res.end() if req.method.toLowerCase() is 'options'
    next()

  http.use flash()
  http.use -> Caboose.app.router.route.apply(Caboose.app.router, arguments)
  http.use express.static Caboose.root.join('public').path
