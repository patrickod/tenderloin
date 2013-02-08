express = require 'express'
flash = require 'connect-flash'

module.exports = (http) ->
  http.use express.bodyParser()
  http.use express.methodOverride()
  http.use express.cookieParser()
  http.use express.session(secret: 'some kind of random string')
  http.use flash()
  http.use (req, res, next) ->
    res.header 'Access-Control-Allow-Credentials', true
    res.header 'Access-Control-Allow-Origin', '*'
    res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS'
    res.header 'Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'

    return res.end() if req.method.toLowerCase() is 'options'
    next()
  
  http.use -> Caboose.app.router.route.apply(Caboose.app.router, arguments)
  http.use express.static Caboose.root.join('public').path
