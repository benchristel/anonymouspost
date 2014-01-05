angular.module('AnonymousApp').factory('Session', ($resource) ->
    class Session
        key: ''
        signedIn: false
        
        constructor: ->
            @service = $resource('/users/:id.json', {id: '@id'})
            
        signIn: (username, password) ->
            #@service.
            @key = username + password
            @signedIn = true
            
        signUp: (username, password) ->
            new_key = username + password
            promise = new @service(key: new_key).$save()
            promise.then ->
                @key = new_key
                @signedIn = true
            promise.catch ->
                alert "User already exists! Try a different name, or sign in"
                
        getKey: ->
            @key
            
        getSignedIn: ->
            @signedIn
)
