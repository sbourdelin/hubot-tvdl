# Description
#   A hubot script that control the TVDL
#
# Configuration:
#   HUBOT_TVDL_URL
#
# Commands:
#   hubot tvdl get - Retrieve the channel list
#   hubot tvdl zap <channel> - Zap the tvdl to <channel>
#
# Author:
#   Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>

tvdl_url = process.env.HUBOT_TVDL_URL || ""

module.exports = (robot) ->

  robot.respond /tvdl get/i, (msg) ->
    msg.http(tvdl_url + "/channels")
      .get() (err, res, body) ->
        if err
          res.send "Http request error, server down?"
          return
        try
          json = JSON.parse(body)
          msg.send "Available channels:"
          for x in json
            msg.send "#{x.channel}: #{x.description}"
        catch error
          msg.send "Error"
          return

  robot.respond /tvdl zap ([0-9]+)/i, (msg) ->
    msg.send "Zap to channel " + msg.match[1]
    msg.http(tvdl_url + "/zap?channel=" + msg.match[1])
    .post() (err, res, body) ->
      return
