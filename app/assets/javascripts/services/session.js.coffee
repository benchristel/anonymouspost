angular.module('AnonymousApp').factory('Session', ($resource, $q) ->
  #class Session

  Session = $ =
    {
      key: ''
      signedIn: false

      signIn: (username, password) ->
        $.service = $resource('/users/:id.json', {id: '@id'}, {$sign_in: {method:'GET', url: '/users/sign_in.json'}})
        new_key = username + password
        promise = $.service.$sign_in(key: new_key).$promise
        promise.then ->
          $.completeSignIn(username, password)

      signUp: (username, password) ->
        $.service = $resource('/users/:id.json', {id: '@id'})
        new_key = username + password
        promise = new $.service(key: new_key).$save()
        promise.then ->
          $.completeSignIn(username, password)


      completeSignIn: (username, password) ->
        $.key = username + password
        $.signedIn = true
    }

  Session
)
