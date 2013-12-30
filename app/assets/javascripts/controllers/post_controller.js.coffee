angular.module('AnonymousApp').controller 'AppController'
,       ($scope, $timeout, Post, Session, Location) ->
    
    $scope.refresh = ->
        Location.getLocation().then ->
            (posts = new Post().all(Location.longitude, Location.latitude)).$promise.then ->
                $scope.posts = posts
                $scope.newPostContent = ''

    $scope.createPost = ->
        raise 'not signed in' unless Session.signedIn
        Location.getLocation().then ->
            attrs = {
                content:   $scope.newPostContent
                user_key:  Session.key
                longitude: Location.longitude
                latitude:  Location.latitude
            }
            new Post().create(attrs).then ->
                $scope.refresh()
            
    $scope.signIn = ->
        Session.signIn($scope.inputUsername, $scope.inputPassword)
        $scope.inputUsername = ''
        $scope.inputPassword = ''
        
    $scope.isSignedIn = ->
        Session.signedIn
        
    $scope.refresh()