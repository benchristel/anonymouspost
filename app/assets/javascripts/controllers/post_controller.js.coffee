angular.module('AnonymousApp', ['dialogs', 'ui.bootstrap', 'ngResource']).controller('AppController'
,       ($sce, $scope, $timeout, $dialogs, Post, Session, Location) ->

    $scope.init = ->
        @postalService = new Post()
        #Session = new Session()


    $scope.logInModal = {
      launch:  ->
        dlg = $dialogs.create("/dialogs/login.html", "loginCtrl", {},
          key: false
          back: "static"
        )
        dlg.result.then ((name) ->
          $scope.name = name
          return
        ), ->
          $scope.name = "You decided not to enter in your name, that makes me sad."
          return
    }


    $scope.refresh = ->
        Location.getLocation().then ->
            (posts = new Post().all(Location.longitude, Location.latitude)).$promise.then ->
                $scope.posts = posts
                for post in posts
                    post.content = $sce.trustAsHtml(post.content)

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

            $scope.inputUsername = ''
            $scope.inputPassword = ''
            $scope.refresh()
        promise.catch ->
            alert "This account doesn't exist"



    $scope.signUp = ->
        promise= Session.signUp($scope.inputUsername, $scope.inputPassword)
        promise.then ->
            $scope.refresh()
            $scope.inputUsername = ''
            $scope.inputPassword = ''
        promise.catch ->
            alert "This account already exists"



    $scope.isSignedIn = ->
        Session.signedIn


    $scope.refresh()
    $scope.init()

).controller("loginCtrl", ($scope, $modalInstance, data) ->
  $scope.user = name: ""
  $scope.cancel = ->
    $modalInstance.dismiss "canceled"
    return

  $scope.save = ->
    $modalInstance.close $scope.user.name
    return

  $scope.hitEnter = (evt) ->
    $scope.save()  if angular.equals(evt.keyCode, 13) and not (angular.equals($scope.name, null) or angular.equals($scope.name, ""))
    return

  return
).run [
  "$templateCache"
  ($templateCache) ->
    $templateCache.put "/dialogs/login.html", "<div class=\"modal\"><div class=\"modal-dialog\"><div class=\"modal-content\"><div class=\"modal-header\"><h4 class=\"modal-title\"><span class=\"glyphicon glyphicon-star\"></span> User's Name</h4></div><div class=\"modal-body\"><ng-form name=\"nameDialog\" novalidate role=\"form\"><div class=\"form-group input-group-lg\" ng-class=\"{true: 'has-error'}[nameDialog.username.$dirty && nameDialog.username.$invalid]\"><label class=\"control-label\" for=\"username\">Name:</label><input type=\"text\" class=\"form-control\" name=\"username\" id=\"username\" ng-model=\"user.name\" ng-keyup=\"hitEnter($event)\" required><span class=\"help-block\">Enter your full name, first &amp; last.</span></div></ng-form></div><div class=\"modal-footer\"><button type=\"button\" class=\"btn btn-default\" ng-click=\"cancel()\">Cancel</button><button type=\"button\" class=\"btn btn-primary\" ng-click=\"save()\" ng-disabled=\"(nameDialog.$dirty && nameDialog.$invalid) || nameDialog.$pristine\">Save</button></div></div></div></div>"
]
