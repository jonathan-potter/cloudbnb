var initializeMap = function() {

  var spaces = JSON.parse($("#bootstrap").html());
  var maxLat, minLat, maxLon, minLon;
  var bounds = new google.maps.LatLngBounds();

  spaces.forEach(function(space) {

    if (!maxLat || maxLat < space["latitude"])  { maxLat = space["latitude"]};
    if (!minLat || minLat > space["latitude"])  { minLat = space["latitude"]};
    if (!maxLon || maxLon < space["longitude"]) { maxLon = space["longitude"]};
    if (!minLon || minLon > space["longitude"]) { minLon = space["longitude"]};

    bounds.extend(new google.maps.LatLng(space["latitude"], space["longitude"]))

  });

  var centerLat = (maxLat + minLat) / 2;
  var centerLon = (maxLon + minLon) / 2;

  var mapOptions = {
    zoom: 9,
    center: new google.maps.LatLng(centerLat, centerLon),
    mapTypeId: google.maps.MapTypeId.MAP
  };

  var map = new google.maps.Map(document.getElementById("map-canvas"),
      mapOptions);
  map.fitBounds(bounds)

  function createMarker(lat, long, title, addy, number) {

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(lat, long),
      map: map,
      title: title,
      icon: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=" + number + "|FFaaaa|333333"
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

  var index = 1;
  spaces.forEach(function(space) {
    createMarker(space["latitude"], space["longitude"], space["title"], space["address"], index);
    index++;
  });
};