'use strict';

/**
 * @ngdoc function
 * @name javascriptsApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the javascriptsApp
 */
angular.module('javascriptsApp')
  .controller('MainCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
