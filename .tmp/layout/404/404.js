(function () {
  'use strict';
  angular.module('llrApp').controller('404Ctrl', [
    '$scope',
    '$http',
    function ($scope, $http) {
      console.log('404 :(');
      return console.log('There\'s nothing here!');
    }
  ]);
}.call(this));  /*
//@ sourceMappingURL=404.js.map
*/