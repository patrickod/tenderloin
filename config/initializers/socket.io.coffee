return unless Caboose.command is 'server'

RedisStore = require('socket.io/lib/stores/redis')

Caboose.app.after 'boot', ->
  io = Caboose.app.io = require('socket.io').listen(Caboose.app.raw_http, Caboose.app.config.domain.url)
  
  io.configure ->
    io.set('transports', ['xhr-polling'])
    io.set("polling duration", 10)
  
  io.store = new RedisStore(
    redis: require('redback/node_modules/redis')
    redisPub: Caboose.app.redis.pub
    redisSub: Caboose.app.redis.sub
    redisClient: Caboose.app.redis.default
  )
