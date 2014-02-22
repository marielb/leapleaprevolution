(function () {
  angular.module('llrApp').run([
    '$rootScope',
    'leapController',
    '$timeout',
    function ($rootScope, leapController, $timeout) {
      return leapController.loop(function (frame) {
      });
    }
  ]);
}.call(this));  /*
//@ sourceMappingURL=leap.js.map
*/