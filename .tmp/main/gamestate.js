(function() {
  angular.module('llrApp').controller("GameStateCtrl", function($scope, $rootScope, llrSock) {
    var changeText, connection, incrementScore, me, score, url;
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
    $(document).keypress(function(event) {
      var artist_name, song_name;
      if (event.which === 13 && score === 0) {
        url = "http://lyrics.wikia.com/" + artist_name + ":" + song_name + "#mw-content-text";
        console.log(url);
        $('.lyrics').html("<iframe src='" + url + "'></iframe>");
        $('.gi-user-wrapper .gi-color').text(score);
        llrSock.emit("gameTrigger");
        artist_name = $('#artistForm').val();
        song_name = $('#songForm').val();
        return SC.get('/tracks', {
          q: artist_name + ' ' + song_name
        }, function(tracks) {
          var first_track, track_id, track_title;
          first_track = tracks[0];
          track_id = first_track.id;
          track_title = first_track.title;
          return SC.stream('/tracks/' + track_id, {
            onfinish: function() {
              $('#play button').show();
              artist_name = $('#artistForm').val("");
              return song_name = $('#songForm').val("");
            }
          }, function(sound) {
            sound.play();
            return $('#play p').text(track_title);
          });
        });
      }
    });
    changeText = function(move) {
      return $('#main-inner .motion').html(move + "<br><img src='/images/" + move + ".jpg'>");
    };
    incrementScore = function() {
      score = score + 1;
      return $('.gi-user:first-child .gi-user-wrapper .gi-color').text(score);
    };
    $scope.users = [];
    return llrSock.on("gameLoop", function(data) {
      if (score !== 0) {
        $('#main-inner .motion').html("<img src='/images/check.svg' width='50px'>");
      }
      setTimeout((function() {
        return changeText(data.move);
      }), 1500);
      return $(window).bind(data.move, function(e, gesture) {
        $(window).unbind(data.move);
        return incrementScore() / llrSock.emit("gameTrigger");
      });
    });
  });

}).call(this);
