(function () {
  angular.module('llrApp').controller('MainCtrl', [
    '$scope',
    '$http',
    '$window',
    'leapController',
    function ($scope, $http, $window, leapController) {
      var connected, testConnect, testTimeout;
      connected = false;
      leapController.connect();
      $('.connected').hide();
      leapController.on('deviceDisconnected', function () {
        $('.connected').hide();
        return $('.disconnected').fadeIn('slow');
      });
      leapController.on('deviceConnected', function () {
        $('.connected').fadeIn('slow');
        return $('.disconnected').hide();
      });
      leapController.on('deviceFrame', function (fr) {
        return connected = true;
      });
      testConnect = function () {
        if (connected) {
          $('.connected').show();
          $('.disconnected').hide();
        }
        return clearTimeout(testTimeout);
      };
      testTimeout = setTimeout(testConnect, 1000);
      return $scope.twitterAuth = function () {
        return $window.location.href = '/auth/twitter';
      };
    }
  ]);
}.call(this));  /*
//@ sourceMappingURL=main.js.map
*/