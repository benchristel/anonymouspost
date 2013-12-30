angular.module('AnonymousApp').factory('Location', ($resource) ->
    {
        longitude: 0
        latitude: 0
        
        getLocation: ->
            deferred = $.Deferred();
            if navigator.geolocation
                navigator.geolocation.getCurrentPosition(
                    onSuccess = (position) =>
                        console.log position
                        this.longitude = position.coords.longitude
                        this.latitude = position.coords.latitude
                        deferred.resolve(this)
                    , onFailure = () ->
                        alert "Couldn't find your position."
                )
            
                deferred.promise();
            else
                deferred.resolve(null)
                alert "Your browser doesn't support geolocation."
            deferred.promise();
    }
)
