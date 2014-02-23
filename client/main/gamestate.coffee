angular.module('llrApp')
  .controller "GameStateCtrl", ($scope, $rootScope, llrSock) ->

    # Connect URL
    url = 'https://goinstant.net/1efb28932cd4/mchacks'

    me = null

    score = 0

    # Connect to GoInstant
    connection = new goinstant.Connection url
    goinstant.connect url, (err, connection, roomObj) ->
      if err
        throw err;

      roomObj.self().get (err, userData, context) ->
        if (err) 
          throw err;
        console.log userData.displayName, 'has joined!'
        console.log userData
        me = userData

      # Create a new instance of the WebRTC widget
      webrtc = new goinstant.widgets.WebRTC { room: roomObj, listContainer: $('.players')[0], expandContainer: $('.expand')[0] }

      # Initialize the WebRTC widget
      webrtc.initialize (err) ->
        if err
          throw err;

      connection.on 'disconnect', (connection) ->
          console.log me.displayName, 'has left!'

    # Soundcloud stuff
    SC.initialize({
      client_id: "fd1dc47d643674b46399ab11ec8089bf"
    });
    
    currently_play = false;

    $('#play button').click () ->
      track_url = $('#urlForm').val()

      SC.get '/resolve', url: track_url, (data) ->
        SC.stream '/tracks/' + data.id, {onfinish: ()->
          $('#play button').show()
        },
        (sound)->
          sound.play()
          $('#play button').hide()
          $('#play p').text(data.title)

    # Game stuff

    randomInt = (min, max) ->
      Math.floor(Math.random() * (max - min + 1)) + min

    changeText = (move) ->
      $('#main-inner .motion').text(move)

    incrementScore = ->
      score = score + 1
      $('.gi-user:first-child .gi-user-wrapper .gi-color').text(score)

    $scope.users = []

    moves = ["swipeleft", "swiperight", "swipetop", "swipebottom", "circleleft", "circleright"]

    $('#play h1').click () ->
      $('.gi-user-wrapper .gi-color').text(score)
      llrSock.emit "gameTrigger"


    llrSock.on "gameLoop", ->
      move = moves[randomInt(0, moves.length - 1)]
      $('#main-inner .motion').text('')
      setTimeout ( ->
        changeText move
      ), 2000

      $(window).bind move, (e, gesture) ->
        incrementScore()
        $(window).unbind move
        llrSock.emit "moveSuccess", { move: e.type }

