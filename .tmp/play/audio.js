(function () {
  angular.module('llrApp').factory('llrAudio', [
    '$rootScope',
    '$timeout',
    'roundState',
    function ($rootScope, $timeout, roundState) {
      var sound, sounds, sounds_, _i, _len;
      sounds = [
        'bop',
        'pull',
        'twist',
        'passit'
      ];
      sounds_ = {};
      for (_i = 0, _len = sounds.length; _i < _len; _i++) {
        sound = sounds[_i];
        sounds_[sound] = new buzz.sound('/audio/sound-' + sound + '.mp3');
      }
      sounds_.gameOver = function () {
        var ss;
        ss = [
          new buzz.sound('/audio/yell.mp3'),
          new buzz.sound('/audio/fail.mp3'),
          new buzz.sound('/audio/insult.mp3')
        ];
        ss.slice(0, -1).map(function (s, i) {
          return s.bind('ended', function () {
            return ss[i + 1].play();
          });
        });
        return ss[0];
      }();
      sounds_.queueTurn = function (prevSound, command) {
        var ss;
        ss = [
          new buzz.sound('/audio/command-' + command + '.mp3'),
          new buzz.sound('/audio/fill.mp3'),
          new buzz.sound('/audio/break.mp3'),
          new buzz.sound('/audio/fill.mp3')
        ];
        ss[0].bind('ended', function () {
          return ss[1].play();
        });
        ss[1].bind('ended', function () {
          return ss[2].play();
        });
        ss[2].bind('ended', function () {
          $rootScope.$emit('cantLose');
          return ss[3].play();
        });
        ss[3].bind('ended', function () {
        });
        if (prevSound.isEnded()) {
          ss[0].play();
          $rootScope.$emit('mightLose', command);
        } else {
          prevSound.bind('ended', function () {
            ss[0].play();
            return $rootScope.$emit('mightLose', command);
          });
        }
        return ss;
      };
      return sounds_;
    }
  ]);
}.call(this));  /*
//@ sourceMappingURL=audio.js.map
*/