function locateAndSubmit() {
    findMe();
    var timeout = 0
    var interval = setInterval(function() {
	timeout = timeout + 100
	if (document.getElementById('post_longitude').value) {
          clearInterval(interval);
          $("form").submit();
	} else if (timeout > 3000){
          clearInterval(interval);
	}
}, 100);
}
function findMe() {
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      document.getElementById('post_latitude').value = position.coords.latitude;
      document.getElementById('post_longitude').value = position.coords.longitude;
    }, function() {
      alert('We couldn\'t find your position.');
    });
  } else {
    alert('Your browser doesn\'t support geolocation.');
  }
}

function mySubmit(){
 
}