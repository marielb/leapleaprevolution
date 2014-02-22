(function () {
  var llr;
  llr = angular.module('llrApp', [
    'ngRoute',
    'ngAnimate'
  ]).config([
    '$routeProvider',
    '$locationProvider',
    function ($routeProvider, $locationProvider) {
      $routeProvider.when('/', {
        templateUrl: 'main/mainView.html',
        controller: 'MainCtrl'
      }).when('/play', { templateUrl: 'play/playView.html' }).when('/404', {
        templateUrl: 'layout/404/index.html',
        controller: '404Ctrl'
      }).otherwise({ redirectTo: '/404' });
      return $locationProvider.html5Mode(true);
    }
  ]).controller('BodyCtrl', [
    '$http',
    '$scope',
    '$rootScope',
    '$timeout',
    function ($http, $scope, $rootScope, $timeout) {
      $rootScope.isLoaded = true;
      $scope.animClass = '';
      $scope.animReady = false;
      $timeout(function () {
        $scope.animClass = 'llr-view';
        return $scope.animReady = true;
      }, 10);
      return $rootScope.$on('$routeChangeStart', function (e, next, current) {
        return null;
      });
    }
  ]).factory('llrSock', function () {
    return io.connect();
  }).factory('leapController', function () {
    return new Leap.Controller();
  });
}.call(this));  /*
//@ sourceMappingURL=index.js.map
*/