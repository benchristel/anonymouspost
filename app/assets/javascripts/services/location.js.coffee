angular.module('AnonymousApp').factory('Location', ($resource, $q) ->
    {
        longitude: 0
        latitude: 0
        lastUpdate: 0

        getLocation: (invalidateCacheAfterMs=10000)->
            deferred = $q.defer();

            if new Date().getTime() - @lastUpdate < invalidateCacheAfterMs
                deferred.resolve(this)
                return deferred.promise

            if navigator.geolocation
                navigator.geolocation.getCurrentPosition(
                    onSuccess = (position) =>
                        @lastUpdate = new Date().getTime()
                        @longitude = position.coords.longitude
                        @latitude = position.coords.latitude
                        deferred.resolve(this)
                    ,
                    onFailure = () ->
                        deferred.fail()
                        alert "Couldn't find your position."
                )
            else
                deferred.reject()
                alert "Your browser doesn't support geolocation."

            deferred.promise
    }
)
