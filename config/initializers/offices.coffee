Caboose.app.offices = {}

Caboose.app.offices.__defineGetter__ 'sf', -> Caboose.app.io.of('/sf')
Caboose.app.offices.__defineGetter__ 'nyc', -> Caboose.app.io.of('/nyc')
