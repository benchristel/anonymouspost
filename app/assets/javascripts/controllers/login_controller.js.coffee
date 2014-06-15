angular.module('AnonymousApp').controller("loginCtrl", ($scope, $modalInstance, data, Session) ->
  $scope.user = name: ""
  $scope.user = password: ""

  $scope.cancel = ->
    $modalInstance.dismiss "canceled"
    return

  $scope.save = ->
    console.log($scope.user.name)
    console.log($scope.user.password)
    promise = Session.signIn($scope.user.name, $scope.user.password)
    promise.catch ->
        alert "This account doesn't exist"

    $modalInstance.close $scope.user.name
    return

  $scope.hitEnter = (evt) ->
    $scope.save()  if angular.equals(evt.keyCode, 13) and not (angular.equals($scope.name, null) or angular.equals($scope.name, ""))
    return

  return
)
