angular.module('AnonymousApp').factory('Session', ($resource) ->
    {
        key: ''
        signedIn: false
        
        signIn: (username, password) ->
            @key = username + password
            @signedIn = true        
    }
)
