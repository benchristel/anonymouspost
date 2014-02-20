angular.module('AnonymousApp').controller 'AppController'
,       ($scope, $timeout, Post, Session, Location) ->
    
    
    $scope.init = ->
        @postalService = new Post()
        #Session = new Session()
        
        
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
            promise = new Post().create(attrs)
            promise.then ->
                $scope.refresh()
            promise.catch ->
                alert 'Server encountered an error and your post was not saved'
                $scope.newPostContent = $scope.posts[0].content
                $scope.posts.shift()
            
               
                
    $scope.upvote = (post) ->
        if Session.signedIn
            attrs = {
                user_key:  Session.key
                id:        post.id
            }
            if post.existing_vote == -1
                post.net_upvotes = post.net_upvotes + 2
                post.existing_vote = 1
                new Post().upvote(attrs).catch ->
                    alert 'Server encountered an error and your vote was not saved'
                    post.net_upvotes = post.net_upvotes - 2
                    post.existing_vote = -1
            else if post.existing_vote == 1
                post.net_upvotes = post.net_upvotes - 1
                post.existing_vote = 0
                new Post().unvote(attrs).catch ->
                    alert 'Server encountered an error and your vote was not saved'
                    post.net_upvotes = post.net_upvotes + 1
                    post.existing_vote = 1

            else
                post.existing_vote = 1
                post.net_upvotes = post.net_upvotes + 1
                new Post().upvote(attrs).catch ->
                    alert 'Server encountered an error and your vote was not saved'
                    post.existing_vote = 0
                    post.net_upvotes = post.net_upvotes - 1 
        else
            alert 'You need to sign in to vote!'
    
    
    $scope.downvote = (post) ->
        if Session.signedIn
            attrs = {
                user_key:  Session.key
                id:        post.id
            }
            if post.existing_vote == -1
                post.net_upvotes = post.net_upvotes + 1
                post.existing_vote = 0
                new Post().unvote(post).catch ->
                    alert 'Server encountered an error and your vote was not saved'
                    post.net_upvotes = post.net_upvotes - 1
                    post.existing_vote = -1
            else if post.existing_vote == 1
                post.net_upvotes = post.net_upvotes - 2
                post.existing_vote = -1
                new Post().downvote(post).catch ->
                    alert 'Server encountered an error and your vote was not saved'
                    post.net_upvotes = post.net_upvotes + 2
                    post.existing_vote = 1
            else
                post.existing_vote = -1
                post.net_upvotes = post.net_upvotes - 1
                new Post().downvote(attrs).catch ->
                    alert 'Server encountered an error and your vote was not saved'
                    post.existing_vote = 0
                    post.net_upvotes = post.net_upvotes + 1
        else
            alert 'You need to sign in to vote!'
            
    $scope.isOwner = (post) ->
        post.can_edit
    
    $scope.delete = (index)->
        post = $scope.posts[index]
        if Session.signedIn
            attrs = {
                user_key:  Session.key
                id:        post.id
            }
            (new Post().delete(attrs)).then ->
                $scope.posts.splice(index, 1)
        else
            alert "You've been signed out. You probably should never see this alert. We done fucked up"
            
            
    $scope.signIn = ->
        promise = Session.signIn($scope.inputUsername, $scope.inputPassword)
        promise.then ->
            console.log "Signing in shallow...."

            Session.shallowSignIn($scope.inputUsername, $scope.inputPassword)
            $scope.inputUsername = ''
            $scope.inputPassword = ''
            $scope.refresh()
        promise.catch ->
            alert "This account doesn't exist"


        
    $scope.signUp = ->
        promise= Session.signUp($scope.inputUsername, $scope.inputPassword)
        promise.then ->
            console.log "Signing UP shallow...."
            Session.shallowSignIn($scope.inputUsername, $scope.inputPassword)
            $scope.refresh()
            $scope.inputUsername = ''
            $scope.inputPassword = ''
        promise.catch ->
            alert "This account already exists"
        
        
        
    $scope.isSignedIn = ->
        Session.signedIn

        
    $scope.refresh()
    $scope.init()
