{check}            = require "validator"

q                  = require "q"

{email_server, io} = require "../"

io.sockets.on "connection", (socket) ->
  socket.on "gameTrigger", ->
    io.sockets.emit "gameLoop"
  socket.on "moveSuccess", (data) -> 
    console.log("successfully performed ", data.move)
    io.sockets.emit "gameLoop", data

exports.llr = (req, res) ->
  res.json llr: true
