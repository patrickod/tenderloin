# Description:
#   Interacts with Unified's persistent G+ hangout.
#
# Commands:
#   hubot $OFFICE mute - Mute the microphone for $OFFICE's G+ session
#   hubot $OFFICE unmute - Unmute the microphone for $OFFICE's G+ session
#   hubot $OFFICE alert - Get the attention of everyone  in $OFFICE
#   hubot $OFFICE url - Make tenderloin execute the contents of the URL
#

TENDERLOIN_ROOT = 'http://tenderloin-sf.herokuapp.com/api/'

module.exports = (robot) ->

  ## Control the microphone
  robot.respond /(.*) (mic|microphone) (off|on)/i, (msg) ->
    office = msg.match[1]
    state = msg.match[3]
    msg.http("#{TENDERLOIN_ROOT}/offices/#{office}/commands/microphone_#{state}")
       .get() (err, res, body) ->
         return msg.send("Microphone in #{office} #{if state is "on" then "enabled" else "disabled"}") if  res.responseCode is 200

  ## Control the camera
  robot.respond /(.*) (cam|camera) (off|on)/i, (msg) ->
    office = msg.match[1]
    state = msg.match[3]
    msg.http("#{TENDERLOIN_ROOT}/offices/#{office}/commands/camera_#{state}")
       .get() (err, res, body) ->
         return msg.send("Camera in #{office} #{if state is "on" then "enabled" else "disabled"}") if  res.responseCode is 200

  ## Play an alert noise
  robot.respond /(.*) alert/i, (msg) ->
    office = msg.match[1]
    msg.http("#{TENDERLOIN_ROOT}/offices/#{office}/commands/alert")
       .get() (err, res, body) ->
         return msg.send("That got their attention") if  res.responseCode is 200
         return msg.send("Oh noes! It broke!")

  ## Execute a gist in their G+ session
  robot.respond /(.*) gist (https?:\/\/gist\.github\.com\/(.*)\/([0-9a-f]+)/i, (msg) ->
    office msg.match[1]
    gist_url = msg.match[2] + '/raw'
    msg.http("#{TENDERLOIN_ROOT}/offices/#{office}/gist")
       .query(q: gist_url)
       .get() (err, response, body) ->
         msg.send body

