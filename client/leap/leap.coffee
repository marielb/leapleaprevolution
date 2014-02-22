angular.module('llrApp').run ($rootScope, leapController, $timeout) ->

    leapController.loop (frame) ->
      # do stuff here
      # $rootScope.$emit("something");
