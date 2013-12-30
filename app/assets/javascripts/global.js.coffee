app = angular.module('AnonymousApp', ['ngResource'])

app.config ($httpProvider) ->
    authToken = $("meta[name=\"csrf-token\"]").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

$(document).on 'page:load', ->
    $('[ng-app]').each ->
        module = $(this).attr('ng-app')
        angular.bootstrap(this, [module])

console.log app

#
#AnonymousApp.factory('User', ($window) ->
#    class User
#        constructor: (key, longitude, latitude) ->
#            @key = key
#            @longitude = longitude
#            @latitude = latitude
#            
#        isSignedIn: ->
#            @key && @key.length
#            
#        hasLocation: ->
#            @longitude? && @latitude?
#            
#    $window.user = new User()
#)