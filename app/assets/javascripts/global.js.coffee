app = angular.module('AnonymousApp', ["ngRoute", "ngTouch",'dialogs', 'ui.bootstrap', 'ngResource', 'snap'])

app.config ($httpProvider) ->
    authToken = $("meta[name=\"csrf-token\"]").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

app.config ($routeProvider, $locationProvider) ->
  $routeProvider.when "/",
    templateUrl: "templates/posts.html"

  $routeProvider.when "/login",
    templateUrl: "templates/login.html"

  $routeProvider.when "/signup",
    templateUrl: "templates/signup.html"

  return

$(document).on 'page:load', ->
    $('[ng-app]').each ->
        module = $(this).attr('ng-app')
        angular.bootstrap(this, [module])
