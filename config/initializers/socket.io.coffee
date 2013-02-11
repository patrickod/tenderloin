return unless Caboose.command is 'server'

RedisStore = require('socket.io/lib/stores/redis')

Caboose.app.after 'boot', ->
  io = Caboose.app.io = require('socket.io').listen(Caboose.app.raw_http, 'tenderloin.localhost.dev')
  # io = Caboose.app.io = require('socket.io').listen(Caboose.app.raw_http, 'tenderloin-sf.herokuapp.com')

  io.configure ->
    io.set('transports', ['xhr-polling'])
    io.set("polling duration", 10)

  io.store = new RedisStore({
    redisPub: Caboose.app.redis.pub
    redisSub: Caboose.app.redis.sub
    redisClient: Caboose.app.redis.default
  })
