(function () {
  angular.module('llrApp').controller('GameStateCtrl', [
    '$scope',
    '$rootScope',
    'llrSock',
    function ($scope, $rootScope, llrSock) {
      var moves;
      llrSock.emit('state:lobby');
      $scope.users = [];
      moves = [
        {
          name: 'swipe left',
          cb: function () {
          }
        },
        {
          name: 'swipe right',
          cb: function () {
          }
        }
      ];
      llrSock.on('state:all:users', function (us) {
        return $scope.$apply(function () {
          return $scope.users = us;
        });
      });
      llrSock.on('state:playing:turn', function (command) {
        return $scope.$apply(function () {
        });
      });
      llrSock.on('state:gameOver:now', function () {
      });
      llrSock.on('state:playing', function () {
        return $scope.$apply(function () {
        });
      });
      return $rootScope.$on('play', function () {
        return $scope.$apply(function () {
          return llrSock.emit('state:playing');
        });
      });
    }
  ]);
}.call(this));  /*
//@ sourceMappingURL=gamestate.js.map
*/