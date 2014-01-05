angular.module('AnonymousApp').factory('Session', ($resource, $q) ->
    #class Session
    {
        key: ''
        signedIn: false
            
        signIn: (username, password) ->
            @service = $resource('/users/:id.json', {id: '@id'})
            new_key = username + password
            promise = new @service().$get(key: new_key)
            promise
        
        signUp: (username, password) ->
            @service = $resource('/users/:id.json', {id: '@id'})
            new_key = username + password
            promise = new @service(key: new_key).$save()
            promise
        
        shallowSignIn: (username, password) ->
            @key = username + password
            @signedIn = true     
    }
)
