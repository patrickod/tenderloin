betturl = require 'betturl'

if process.env is 'PRODUCTION'
  Caboose.app.config.redis = betturl.parse(process.env.REDIS_URL)
else
  Caboose.app.config.redis = {}
