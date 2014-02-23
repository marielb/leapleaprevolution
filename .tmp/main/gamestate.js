(function() {
  angular.module('llrApp').controller("GameStateCtrl", function($scope, $rootScope, llrSock) {
    var changeText, connection, incrementScore, me, moves, randomInt, score, url;
    url = 'https://goinstant.net/1efb28932cd4/mchacks';
    me = null;
    score = 0;
    connection = new goinstant.Connection(url);
    goinstant.connect(url, function(err, connection, roomObj) {
      var webrtc;
      if (err) {
        throw err;
      }
      roomObj.self().get(function(err, userData, context) {
        if (err) {
          throw err;
        }
        console.log(userData.displayName, 'has joined!');
        console.log(userData);
        return me = userData;
      });
      webrtc = new goinstant.widgets.WebRTC({
        room: roomObj,
        listContainer: $('.players')[0],
        expandContainer: $('.expand')[0]
      });
      webrtc.initialize(function(err) {
        if (err) {
          throw err;
        }
      });
      return connection.on('disconnect', function(connection) {
        return console.log(me.displayName, 'has left!');
      });
    });
    SC.initialize({
      client_id: "fd1dc47d643674b46399ab11ec8089bf"
    });
    $('#play button').click(function() {
      var track_url;
      track_url = $('#urlForm').val();
      return SC.get('/resolve', {
        url: track_url
      }, function(data) {
        SC.stream('/tracks/' + data.id, {
          autoPlay: true
        });
        return $('#play p').text(data.title);
      });
    });
    randomInt = function(min, max) {
      return Math.floor(Math.random() * (max - min + 1)) + min;
    };
    changeText = function(move) {
      return $('#main-inner .motion').html(move + "<br><img src='/images/" + move + ".jpg'>");
    };
    incrementScore = function() {
      score = score + 1;
      return $('.gi-user:first-child .gi-user-wrapper .gi-color').text(score);
    };
    $scope.users = [];
    moves = ["swipeleft", "swiperight", "swipetop", "swipebottom", "circleleft", "circleright"];
    $('#play h1').click(function() {
      $('.gi-user-wrapper .gi-color').text(score);
      return llrSock.emit("gameTrigger");
    });
    return llrSock.on("gameLoop", function() {
      var move;
      move = moves[randomInt(0, moves.length - 1)];
      if (score !== 0) {
        $('#main-inner .motion').html("<img src='/images/check.svg' width='50px'>");
      }
      $(window).bind(move, function(e, gesture) {
        $(window).unbind(move);
        incrementScore();
        return llrSock.emit("moveSuccess", {
          move: e.type
        });
      });
      return setTimeout((function() {
        return changeText(move);
      }), 1500);
    });
  });

}).call(this);
