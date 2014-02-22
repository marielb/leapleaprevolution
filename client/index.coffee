llr = angular.module('llrApp', [
  'ngRoute'
  'ngAnimate'
])

.config ($routeProvider, $locationProvider) ->

  $routeProvider
    .when '/',
      templateUrl: 'main/mainView.html'
      controller: 'MainCtrl'
    .when '/play',
      templateUrl: 'play/playView.html'
    .when '/404',
      templateUrl: 'layout/404/index.html'
      controller: '404Ctrl'
    .otherwise
      redirectTo: '/404'

  $locationProvider.html5Mode(true)

.controller "BodyCtrl", ($http, $scope, $rootScope, $timeout) ->
  $rootScope.isLoaded = true
  $scope.animClass = ''
  $scope.animReady = false

  $timeout ->
    $scope.animClass = "llr-view"
    $scope.animReady = true
  , 10

  $rootScope.$on "$routeChangeStart", (e, next, current) ->
    null

.factory "llrSock", ->
  io.connect()

.factory "leapController", ->
  new Leap.Controller()

.factory "roundState", ->
  passedTurn: false
  gestures: 0