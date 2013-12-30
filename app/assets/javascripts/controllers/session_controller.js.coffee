angular.module('AnonymousApp').controller 'SessionController', ($scope, Session) ->
    $scope.signIn = ->
        Session.signIn($scope.inputUsername, $scope.inputPassword)
        $scope.inputUsername = ''
        $scope.inputPassword = ''
        
    $scope.isSignedIn = ->
        Session.signedIn
