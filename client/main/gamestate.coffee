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

    changeText = (move) ->
      $('#main-inner .motion').html(move+"<br><img src='/images/" + move + ".jpg'>")

    incrementScore = ->
      score = score + 1
      $('.gi-user:first-child .gi-user-wrapper .gi-color').text(score)

    $scope.users = []

    $('#play h1').click () ->
      $('.gi-user-wrapper .gi-color').text(score)
      llrSock.emit "gameTrigger"

    llrSock.on "gameLoop", (data) ->
      if score != 0
        $('#main-inner .motion').html("<img src='/images/check.svg' width='50px'>")

      setTimeout ( ->
        changeText data.move
      ), 1500

      $(window).bind data.move, (e, gesture) ->
        $(window).unbind data.move
        incrementScore()/
        llrSock.emit "gameTrigger"

