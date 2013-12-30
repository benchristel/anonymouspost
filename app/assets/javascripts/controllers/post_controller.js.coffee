angular.module('AnonymousApp').controller 'PostController', ($scope, Post, Session, Location) ->

        
    $scope.isSignedIn = ->
        Session.signedIn
        
    $scope.refresh = (longitude = null , latitude = null ) ->
        console.log 'refresh'
        if not latitude
            Location.getLocation().then () ->
                console.log Location.longitude
                console.log Location.latitude
                (posts = new Post().all(Location.longitude, Location.latitude)).$promise.then ->
                    console.log 'about to apply'
                    $scope.posts = posts
                    console.log $scope.posts
        else
            (posts = new Post().all(longitude, latitude)).$promise.then ->
                    console.log 'about to apply'
                    $scope.posts = posts
                    console.log $scope.posts


    $scope.createPost = ->
        raise 'not signed in' unless Session.signedIn
        Location.getLocation().then () ->
            attrs = {
                content:   $scope.newPostContent
                user_key:  Session.key
                longitude: Location.longitude
                latitude:  Location.latitude
            }
            new Post().create(attrs).then $scope.refresh(Location.longitude, Location.latitude)
            
    $scope.refresh()