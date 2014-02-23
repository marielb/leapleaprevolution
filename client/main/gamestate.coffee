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

    $('#play button').click () ->
      artist_name= $('#artistForm').val()
      song_name= $('#songForm').val()

      SC.get '/tracks', {q: artist_name + ' ' + song_name }, (tracks)->
        first_track = tracks[0]
        track_id = first_track.id
        track_title = first_track.title

        SC.stream '/tracks/' + track_id, {onfinish: ()->
          $('#play button').show()
        },
        (sound)->
          sound.play()
          $('#play button').hide()
          $('#play p').text(track_title)
    

    # Game stuff

    randomInt = (min, max) ->
      Math.floor(Math.random() * (max - min + 1)) + min

    changeText = (move) ->
      $('#main-inner .motion').html(move+"<br><img src='/images/" + move + ".jpg'>")

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
      if score != 0
        $('#main-inner .motion').html("<img src='/images/check.svg' width='50px'>")

      $(window).bind move, (e, gesture) ->
        $(window).unbind move
        incrementScore()
        llrSock.emit "moveSuccess", { move: e.type }

      setTimeout ( ->
        changeText move
      ), 1500

