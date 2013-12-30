angular.module('AnonymousApp').controller 'PostController', ($scope, Post, Session, Location) ->
    $scope.refresh = () ->
        console.log 'refresh'
        Location.getLocation().then () ->
            console.log Location.longitude
            console.log Location.latitude
            (posts = new Post().all(Location.longitude, Location.latitude)).$promise.then ->
                console.log 'about to apply'
                $scope.posts = posts
                console.log $scope.posts
                $scope.$apply()

    $scope.createPost = ->
        raise 'not signed in' unless Session.signedIn
        Location.getLocation().then () ->
            attrs = {
                content:   $scope.newPostContent
                user_key:  Session.key
                longitude: Location.longitude
                latitude:  Location.latitude
            }
            new Post().create(attrs).then $scope.refresh
            
    $scope.refresh()