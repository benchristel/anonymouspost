angular.module('AnonymousApp').factory('Post', ($resource, Session) ->
    class Post
        constructor: ->
            @service = $resource('/posts/:id.json', {id: '@id', user_key: -> Session.key }, {
                $upvote: {method:'PUT', url: '/posts/:id/upvote.json'},
                $downvote: {method:'PUT', url: '/posts/:id/downvote.json'},
                $unvote: {method:'PUT', url: '/posts/:id/unvote.json'}
            })
            
        
        all: (longitude, latitude) ->
            @service.query(longitude: longitude, latitude: latitude)
            
        create: (attrs) ->
            console.log Session.key
            promise = new @service(post: attrs).$save (post) ->
                attrs.id = post.id
            promise
            
        delete: (attrs) ->
            promise = new @service(attrs).$delete()
            
            
        upvote: (attrs) ->
            @service.$upvote(attrs).$promise
            
        downvote: (attrs) ->
            @service.$downvote(attrs).$promise

        unvote: (attrs) ->
            @service.$unvote(attrs).$promise
          
            
)