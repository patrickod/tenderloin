Caboose.app.rooms = {}

Caboose.app.rooms.__defineGetter__ 'sf', -> Caboose.app.io.of('/sf')
Caboose.app.rooms.__defineGetter__ 'nyc', -> Caboose.app.io.of('/nyc')
