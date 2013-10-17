var initialize = function() {

  var mapOptions = {
    zoom: 9,
    center: new google.maps.LatLng(40.7577, -73.9857),
    mapTypeId: google.maps.MapTypeId.TERRAIN
  };

  var map = new google.maps.Map(document.getElementById("map-canvas"),
      mapOptions);
  var bounds = new google.maps.LatLngBounds();

  var spaces = JSON.parse($("#bootstrap").html());
  globalThing = spaces;
  spaces.forEach(function(space) {
    createMarker(space["latitude"], space["longitude"],
    space["title"], space["address"])
  });

  function createMarker(lat, long, title, addy, completed) {

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(lat, long),
      map: map,
      title: title
      // icon: redMarker
      // icon: completed ? greenMarker : redMarker
    });

    google.maps.event.addListener(marker, 'click', function() {
      var contentString = '<div id="info"><h1>'+title+'</h1><p>'+addy+'</p></div>';

      if (!this.getMap()._infoWindow){
        this.getMap()._infoWindow = new google.maps.InfoWindow();
      }
      this.getMap()._infoWindow.close();
      this.getMap()._infoWindow.setContent(contentString);
      this.getMap()._infoWindow.open(this.getMap(), this);
    });

  };
};

$(document).ready(function() {

  google.maps.event.addDomListener(window, 'load', initialize);

});