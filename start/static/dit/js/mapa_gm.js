var googlemap_key='AIzaSyAL8DygYVmXi0S4uBOqPY1ZbfFfrj2WPcE';
	scriptgoogle = document.createElement('script');
	scriptgoogle.type = 'text/javascript';
	scriptgoogle.src = 'https://maps.googleapis.com/maps/api/js?key='+googlemap_key+'&v=3.exp&signed_in=false&callback=respuestaAPI_googleMaps';
	document.head.appendChild(scriptgoogle);

var events = [
  'bounds_changed', 'center_changed', 'click',
  'dblclick', 'drag', 'dragend',
  'dragstart', 'heading_changed', 'idle',
  'maptypeid_changed', 'mousemove', 'mouseout',
  'mouseover', 'projection_changed', 'resize',
  'rightclick', 'tilesloaded', 'tilt_changed',
  'zoom_changed'
];
console.log('cargando mapa_gm.js');

var map;
var scale;
var id_div='map-canvas';

var center_latitude = 19.255354;
var center_longitude = -99.153314;
var scale = 15;
var initGeoLocation=1
var points;
var scriptgoogle;

function respuestaAPI_googleMaps(pargs){
	
	//console.log('Respuesta de API:'+pargs);
	var scriptgeomarker = document.createElement('script');
	scriptgeomarker.type = 'text/javascript';
	scriptgeomarker.src = '/dlintec/static/dit/js/geomarker.js';
	document.body.appendChild(scriptgeomarker);
    google.maps.event.addDomListener(window, 'load', iniciar_mapas);

}


function registrarMapa(pid_div,pvars){
	//console.log('Registrando mapa:'+pid_div);
	//googlemap_key=pvars['googlemap_key'];
	//scale=pvars['scale'];
	id_div=pid_div;
	//center_latitude= pvars['center_latitude'];
	//center_longitude = pvars['center_latitude'];
return map;
}

function resize(x,y){
	//console.log('cambio tamaño mapa '+x+'x'+y);
}
function setupListener(map, name) {
  var timeout;
  var eventRow = document.getElementById(name);
  google.maps.event.addListener(map, name, function() {
      if (eventRow != null ) {
        eventRow.className = 'event active';
        clearTimeout(timeout);
        var timeout = setTimeout(function() {
          eventRow.className = 'event inactive';
        }, 1000);
      }
  });

}
    
// Dynamically create the table of events from the defined hashmap
function populateTable() {
  var eventsTable = document.getElementById('events');
  if (eventsTable != null ) {
      var content = '';
      for (var i = 0; i < events.length; i++) {
        content += '<div class="event" id="' + events[i] + '">' + events[i] +
          '</div>';
      }
      eventsTable.innerHTML = content;
  }
}


    
function iniciar_mapas() {
	//console.log('iniciarmapas:'+id_div);
	var mapOptions = {
		zoom: scale,
		center: new google.maps.LatLng(center_latitude, center_longitude)
	};

	map = new google.maps.Map(document.getElementById(id_div),mapOptions);
	map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
	console.log('mapa creado:'+id_div+map);

	//for ( point in points){
	//  if (point.latitude and point.longitude){
    //  var point = mapOptions.center;
      //createMarker(point, 0,'{{=point.get('map_marker',maker(point))}}');
	//  }
	//}
		//console.log('contenedor de mapa:'+document.getElementById(id_div).parentNode);
	google.maps.event.addDomListener(document.getElementById(id_div).parentNode, 'resize', resize);

	populateTable();
	for (var i = 0; i < events.length; i++) {
		setupListener(map, events[i]);
	}

	//console.log('iniciarmapas 2a fase:'+id_div+map);
		
		var verGeoLoc=1
		if(verGeoLoc=initGeoLocation){
		  if(navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(function(position) {
				var pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
				var infowindow = new google.maps.InfoWindow({ map: map, position: pos, content: 'Tus Alrededores...' });
				map.setCenter(pos);
			}, function() {
				handleNoGeolocation(true);
			});

		  } else {
			// Browser doesn't support Geolocation
			handleNoGeolocation(false);
		  }
		}
		var GeoMarker = new GeolocationMarker(map);
		GeoMarker.setCircleOptions({fillColor: '#808080'});
		google.maps.event.addListenerOnce(GeoMarker, 'position_changed', function() {
			  map.setCenter(this.getPosition());
			  map.fitBounds(this.getBounds());
		});
		google.maps.event.addListener(GeoMarker, 'geolocation_error', function(e) {
			  alert('There was an error obtaining your position. Message: ' + e.message);
		});





	function handleNoGeolocation(errorFlag) {
		  if (errorFlag) {
			var content = 'Error: The Geolocation service failed.';
		  } else {
			var content = 'Error: Your browser doesn\'t support geolocation.';
		  }

		  var geoloc = {
				map: map,
				position: new google.maps.LatLng(center_latitude, center_longitude),
				content: content
			};

		  var infowindow = new google.maps.InfoWindow(geoloc);
		  map.setCenter(geoloc.position);
	}
	function handleNoGeolocation(errorFlag) {
		  if (errorFlag) {
			var content = 'Error: The Geolocation service failed.';
		  } else {
			var content = 'Error: Your browser doesn\'t support geolocation.';
		  }

		  var geoloc = {
				map: map,
				position: new google.maps.LatLng(center_latitude, center_longitude),
				content: content
			};

		  var infowindow = new google.maps.InfoWindow(geoloc);
		  map.setCenter(geoloc.position);
	}
	function createMarker(point, i, message) {
		  // Set up our GMarkerOptions object
		  var properties = {
			position: point,
			map: map,
			title:'Testing Icon',
			icon:'https://www.google.com/intl/en_us/mapfiles/ms/micons/blue-dot.png',
			shadow:'https://www.google.com/mapfiles/shadow50.png'
			};
			var marker = new google.maps.Marker(properties);
			return marker;
	}
}

$(function(){
	//console.log('Funcion JQUery en mapa_gm.js   $():'+id_div+map);
	
	
});

//	$(document).ready(function(){

//	});
