angular.module('AnonymousApp').factory('Post', ($resource) ->
    class Post
        constructor: ->
            @service = $resource('/posts/:id.json', {id: '@id'}, {
                $upvote: {method:'PUT'}
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
          
            
)