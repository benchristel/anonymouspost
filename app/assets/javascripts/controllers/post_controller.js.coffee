angular.module('AnonymousApp').controller 'AppController'
,       ($scope, $timeout, Post, Session, Location) ->
    
    
    $scope.init = () ->
        @postalService = new Post()
    
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
                
    $scope.upvote = (post) ->
        if post.added == -1
            post.net_upvotes = post.net_upvotes + 2
            post.added = 1
        else if post.added == 1
            post.net_upvotes = post.net_upvotes - 1
            post.added = 0
        else
            post.added = 1
            post.net_upvotes = post.net_upvotes + 1
        attrs = {
            user_key:  Session.key
            id:        post.id
        }
        new Post().upvote(attrs)
    
    $scope.downvote = (post) ->
        if post.added == -1
            post.net_upvotes = post.net_upvotes + 1
            post.added = 0
        else if post.added == 1
            post.net_upvotes = post.net_upvotes - 2
            post.added = -1
        else
            post.added = -1
            post.net_upvotes = post.net_upvotes - 1
        #new Post().downvote(post)
            
    $scope.signIn = ->
        Session.signIn($scope.inputUsername, $scope.inputPassword)
        $scope.inputUsername = ''
        $scope.inputPassword = ''
        
    $scope.isSignedIn = ->
        Session.signedIn
        
    $scope.refresh()
