{check}            = require "validator"

q                  = require "q"

{email_server, io} = require "../"


randomN = (min, max) ->
  Math.random() * (max - min) + min

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


SETTINGS =
  numTurns: 6


makeState = ->
  currentUser: 0
  
  getNextUser: ->
    if STATE.currentUser is (SETTINGS.numUsers-1)
    then 0
    else STATE.currentUser+1

  users: [
    name: 'whatmariel'
    current: true
  ,
    name: 'patatohead'
    current: false
  ,
    name: 'ozthehungry'
    current: false
  ]


STATE = makeState()


_lose = ->
  console.log "\ndisconnect: game over\n"
  clearInterval STATE.gameLoopI
  io.sockets.emit "state:all:users", STATE.users
  io.sockets.emit "state:gameOver:now", true
  STATE = makeState()


io.sockets.on "connection", (socket) ->
  socket.on "state:lobby", ->
    socket.emit "state:all:users", STATE.users

  socket.on "state:playing", ->
      # do stuff here

  socket.on "state:gameOver", ->
      # do stuff here

exports.llr = (req, res) ->
  res.json llr: true
