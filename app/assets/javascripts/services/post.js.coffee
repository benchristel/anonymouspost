angular.module('AnonymousApp').factory('Post', ($resource) ->
    class Post
        constructor: ->
            @service = $resource('/posts/:id.json', {id: '@id'})
            
        
        all: (longitude, latitude) ->
            #deferred = $.Deferred()
            
            r = @service.query(longitude: longitude, latitude: latitude)
            console.log r
            r
            
            
            
        create: (attrs) ->
            promise = new @service(post: attrs).$save (post) ->
                attrs.id = post.id
            promise
)
