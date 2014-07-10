'use strict';

/**
 * @ngdoc function
 * @name javascriptsApp.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the javascriptsApp
 */
angular.module('javascriptsApp')
  .controller('AboutCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
