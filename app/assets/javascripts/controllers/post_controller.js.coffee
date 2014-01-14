angular.module('AnonymousApp').controller 'AppController'
,       ($scope, $timeout, Post, Session, Location) ->
    
    
    $scope.init = () ->
        @postalService = new Post()
    
    $scope.refresh = ->
        Location.getLocation().then ->
            (posts = new Post().all(Location.longitude, Location.latitude)).$promise.then ->
                $scope.posts = posts
                $scope.newPostContent = ''
                console.log posts

    $scope.createPost = ->
        raise 'not signed in' unless Session.signedIn
        shallow_post = {content: $scope.newPostContent, created_at: new Date(),  net_upvotes: 0}
        $scope.posts.unshift(shallow_post)
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
        if Session.signedIn
            attrs = {
                user_key:  Session.key
                id:        post.id
            }
            if post.added == -1
                post.net_upvotes = post.net_upvotes + 2
                post.added = 1
                new Post().upvote(attrs)
            else if post.added == 1
                post.net_upvotes = post.net_upvotes - 1
                post.added = 0
                new Post().unvote(attrs)
            else
                post.added = 1
                post.net_upvotes = post.net_upvotes + 1
                new Post().upvote(attrs)
            
        else
            alert 'You need to sign in to vote!'
    
    $scope.downvote = (post) ->
        if Session.signedIn
            attrs = {
                user_key:  Session.key
                id:        post.id
            }
            if post.added == -1
                post.net_upvotes = post.net_upvotes + 1
                post.added = 0
                new Post().unvote(post)
            else if post.added == 1
                post.net_upvotes = post.net_upvotes - 2
                post.added = -1
                new Post().downvote(post)
            else
                post.added = -1
                post.net_upvotes = post.net_upvotes - 1
                new Post().downvote(attrs)
        else
            alert 'You need to sign in to vote!'
            
    $scope.isOwner = (post) ->
        post.can_edit
        
    $scope.delete = (post)->
        if Session.signedIn
            attrs = {
                user_key:  Session.key
                id:        post.id
            }
            new Post().delete(attrs)
        else
            alert "You've been signed out. You probably should never see this alert. We done fucked up"
            
    $scope.signIn = ->
        Session.signIn($scope.inputUsername, $scope.inputPassword)
        $scope.inputUsername = ''
        $scope.inputPassword = ''
        
    $scope.isSignedIn = ->
        Session.signedIn
        
    $scope.refresh()
