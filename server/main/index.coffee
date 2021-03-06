{check}            = require "validator"

q                  = require "q"

{email_server, io} = require "../"

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

moves = ["swipeleft", "swiperight", "swipetop", "swipebottom", "circleleft", "circleright"]

io.sockets.on "connection", (socket) ->

  socket.on "gameTrigger", ->
    move = moves[randomInt(0, moves.length - 1)]
    console.log("move to perform: ". move)
    io.sockets.emit "gameLoop", { move: move }
    
exports.llr = (req, res) ->
  res.json llr: true
