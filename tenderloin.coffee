# Description:
#   Interacts with Unified's persistent G+ hangout.
#
# Commands:
#   hubot <room> mute - Mute the microphone for <room>'s G+ session
#   hubot <room> unmute - Unmute the microphone for <room>'s G+ session
#   hubot <room> alert - Get the attention of everyone  in <room>
#   hubot <room> url - Execute the contents of the URL in <room>'s session
#

TENDERLOIN_ROOT = 'http://tenderloin-sf.herokuapp.com/api/'

module.exports = (robot) ->

  ## Control the microphone
  robot.respond /(.*) (mic|microphone) (off|on)/i, (msg) ->
    room = msg.match[1]
    state = msg.match[3]
    msg.http("#{TENDERLOIN_ROOT}/rooms/#{room}/commands/microphone_#{state}")
       .get() (err, res, body) ->
         return msg.send("Microphone in #{room} #{if state is "on" then "enabled" else "disabled"}") if  res.statusCode is 200

  ## Control the camera
  robot.respond /(.*) (cam|camera) (off|on)/i, (msg) ->
    room = msg.match[1]
    state = msg.match[3]
    msg.http("#{TENDERLOIN_ROOT}/rooms/#{room}/commands/camera_#{state}")
       .get() (err, res, body) ->
         return msg.send("Camera in #{room} #{if state is "on" then "enabled" else "disabled"}") if res.statusCode is 200

  ## Play an alert noise
  robot.respond /(.*) alert/i, (msg) ->
    room = msg.match[1]
    msg.http("#{TENDERLOIN_ROOT}/rooms/#{room}/commands/alert")
       .get() (err, res, body) ->
         return msg.send("That got their attention") if res.statusCode is 200
         return msg.send("Oh noes! It broke!")

  ## Execute a gist in their G+ session
  robot.respond /(.*) gist (https?:\/\/gist\.github\.com\/.*\/[0-9a-f]+)/i, (msg) ->
    room = msg.match[1]
    gist_url = msg.match[2] + '/raw'
    msg.http("#{TENDERLOIN_ROOT}/rooms/#{room}/gist")
       .query(q: gist_url)
       .get() (err, response, body) ->
         msg.send body

  robot.respond /(.*) sound stop/i, (msg) ->
    room = msg.match[1]
    msg.http("#{TENDERLOIN_ROOT}/rooms/#{room}/stop_sound")
       .get() (err, response, body) ->
         return msg.send "And there was silence" if res.statusCode is 200
