app = angular.module('AnonymousApp', ['dialogs', 'ui.bootstrap', 'ngResource'])

app.config ($httpProvider) ->
    authToken = $("meta[name=\"csrf-token\"]").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

$(document).on 'page:load', ->
    $('[ng-app]').each ->
        module = $(this).attr('ng-app')
        angular.bootstrap(this, [module])
