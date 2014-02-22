angular.module('llrApp')
  .controller "GameStateCtrl", ($scope, $rootScope, llrSock) ->

    # Connect URL
    url = 'https://goinstant.net/1efb28932cd4/mchacks'

    # Connect to GoInstant
    goinstant.connect url, (err, platformObj, roomObj) ->
      if err
        throw err;
  
      # Create a new instance of the WebRTC widget
      webrtc = new goinstant.widgets.WebRTC { room: roomObj, listContainer: $('.players')[0], expandContainer: $('.expand')[0] }

      # Initialize the WebRTC widget
      webrtc.initialize (err) ->
        if err
          throw err;
        # The widget should now be rendered on the page

    # Soundcloud stuff
    SC.initialize({
      client_id: "fd1dc47d643674b46399ab11ec8089bf"
    });
    
    $('#play h1').click () ->
      SC.stream '/tracks/293', {autoPlay: true}

    # Game stuff
    llrSock.emit "state:lobby"

    $scope.users = []

    moves = [
        name: "swipe left",   cb: ->
      ,
        name: "swipe right",  cb: ->
    ]


    llrSock.on "state:all:users", (us) -> $scope.$apply ->
      $scope.users = us

    llrSock.on "state:playing:turn", (command) -> $scope.$apply ->
      # do stuff here

    llrSock.on "state:gameOver:now", ->
      # do stuff here

    llrSock.on "state:playing", -> $scope.$apply ->
      # do stuff here

    $rootScope.$on "play", -> $scope.$apply ->
      llrSock.emit "state:playing"