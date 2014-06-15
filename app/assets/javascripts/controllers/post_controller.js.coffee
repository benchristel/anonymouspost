angular.module('AnonymousApp').controller("postCtrl", ($scope, $modalInstance, data, Session, Location, Post) ->
  $scope.user = post: ""

  $scope.cancel = ->
    $modalInstance.dismiss "canceled"
    return

  $scope.save = ->
    raise 'not signed in' unless Session.signedIn
    #shallow_post = {content: $scope.newPostContent, created_at: new Date(),  net_upvotes: 0}
    #$scope.posts.unshift(shallow_post)
    Location.getLocation().then ->
        attrs = {
            content:   $scope.user.post
            user_key:  Session.key
            longitude: Location.longitude
            latitude:  Location.latitude
        }
        promise = new Post().create(attrs)
        promise.catch ->
            alert 'Server encountered an error and your post was not saved'
            #$scope.newPostContent = $scope.posts[0].content
            #$scope.posts.shift()

    $modalInstance.close $scope.user.post
    return

  # $scope.hitEnter = (evt) ->
  #   $scope.save()  if angular.equals(evt.keyCode, 13) and not (angular.equals($scope.name, null) or angular.equals($scope.name, ""))
  #   return

  return
)
