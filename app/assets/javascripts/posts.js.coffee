# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.locateAndSubmit = () ->
    findMe onSuccess = (position) ->
        $('#post_latitude').val(position.coords.latitude)
        $('#post_longitude').val(position.coords.longitude)
        $("form").submit()
        
findMe = (onSuccess = ->) ->
    if navigator.geolocation
        navigator.geolocation.getCurrentPosition(
            onSuccess,
            onFailure = ->
                alert "We couldn't find your position."
        )
    else
        alert "Your browser doesn't support geolocation."
