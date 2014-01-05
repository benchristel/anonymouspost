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
            promise = new @service(post: attrs).$save (post) ->
                attrs.id = post.id
            promise
            
        delete: (attrs) ->
            @service(attrs).$delete()
            
        upvote: (attrs) ->
            @service.$upvote(attrs)
            
        downvote: (attrs) ->
            @service.$downvote(attrs)

        unvote: (attrs) ->
            @service.$unvote(attrs)
          
            
)