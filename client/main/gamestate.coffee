angular.module('llrApp')
  .controller "GameStateCtrl", ($scope, $rootScope, llrSock) ->

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