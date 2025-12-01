import 'dart:convert';

class KakaoMapLatLng {
  const KakaoMapLatLng(this.lat, this.lng);

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };

  @override
  bool operator ==(Object other) {
    return other is KakaoMapLatLng && other.lat == lat && other.lng == lng;
  }

  @override
  int get hashCode => Object.hash(lat, lng);
}

class KakaoMapMarkerImage {
  const KakaoMapMarkerImage({
    required this.url,
    required this.width,
    required this.height,
  });

  final String url;
  final int width;
  final int height;

  Map<String, dynamic> toJson() => {
        'url': url,
        'width': width,
        'height': height,
      };

  @override
  bool operator ==(Object other) {
    return other is KakaoMapMarkerImage &&
        other.url == url &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(url, width, height);
}

class KakaoMapMarker {
  const KakaoMapMarker({
    required this.id,
    required this.title,
    required this.position,
    this.image,
  });

  final String id;
  final String title;
  final KakaoMapLatLng position;
  final KakaoMapMarkerImage? image;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': _escape(title),
        ...position.toJson(),
        if (image != null) 'image': image!.toJson(),
      };

  KakaoMapMarker copyWith({
    String? id,
    String? title,
    KakaoMapLatLng? position,
    KakaoMapMarkerImage? image,
  }) {
    return KakaoMapMarker(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KakaoMapMarker &&
        other.id == id &&
        other.title == title &&
        other.position == position &&
        other.image == image;
  }

  @override
  int get hashCode => Object.hash(id, title, position, image);
}

class KakaoMapPolyline {
  const KakaoMapPolyline({
    required this.id,
    required this.path,
    this.strokeColor = '#2E8B57',
    this.strokeWeight = 4,
    this.strokeOpacity = 0.9,
  });

  final String id;
  final List<KakaoMapLatLng> path;
  final String strokeColor;
  final int strokeWeight;
  final double strokeOpacity;

  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path.map((point) => point.toJson()).toList(),
        'strokeColor': strokeColor,
        'strokeWeight': strokeWeight,
        'strokeOpacity': strokeOpacity,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! KakaoMapPolyline || other.id != id) return false;
    if (other.strokeColor != strokeColor ||
        other.strokeWeight != strokeWeight ||
        other.strokeOpacity != strokeOpacity) return false;
    if (path.length != other.path.length) return false;
    for (var i = 0; i < path.length; i++) {
      if (path[i] != other.path[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(id, strokeColor, strokeWeight, strokeOpacity, Object.hashAll(path));
}

enum KakaoMapType { roadmap, skyview, hybrid, terrain }

class KakaoMapOptions {
  const KakaoMapOptions({
    this.level = 6,
    this.mapType = KakaoMapType.roadmap,
    this.showZoomControl = false,
    this.showMapTypeControl = false,
  });

  final int level;
  final KakaoMapType mapType;
  final bool showZoomControl;
  final bool showMapTypeControl;

  Map<String, dynamic> toJson() => {
        'level': level,
        'mapType': mapType.name,
        'showZoomControl': showZoomControl,
        'showMapTypeControl': showMapTypeControl,
        };

  @override
  bool operator ==(Object other) {
    return other is KakaoMapOptions &&
        other.level == level &&
        other.mapType == mapType &&
        other.showZoomControl == showZoomControl &&
        other.showMapTypeControl == showMapTypeControl;
  }

  @override
  int get hashCode => Object.hash(level, mapType, showZoomControl, showMapTypeControl);
}

class KakaoMapHtmlBuilder {
  const KakaoMapHtmlBuilder();

  String build({
    required String apiKey,
    required KakaoMapLatLng center,
    required List<KakaoMapMarker> markers,
    List<KakaoMapPolyline> polylines = const [],
    KakaoMapOptions options = const KakaoMapOptions(),
    String bridgeName = 'KakaoBridge',
    bool enableClustering = false,
    String? additionalScripts,
  }) {
    if (apiKey.isEmpty) {
      return _missingApiKeyPage();
    }

    final markerJson = jsonEncode(markers.map((m) => m.toJson()).toList());
    final polylineJson = jsonEncode(polylines.map((p) => p.toJson()).toList());
    final optionsJson = jsonEncode(options.toJson());
    final clusteringLibrary = enableClustering ? ',clusterer' : '';

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <style>
    html, body, #map { width: 100%; height: 100%; margin: 0; padding: 0; }
  </style>
  <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=$apiKey&autoload=false&libraries=services$clusteringLibrary"></script>
</head>
<body>
  <div id="map"></div>
  <script>
    var map;
    var clusterer;
    var markers = [];
    var polylines = [];
    var markerData = $markerJson;
    var polylineData = $polylineJson;
    var mapOptions = $optionsJson;
    var ready = false;
    var loadTimer;
    var loadAttempts = 0;

    function notifyFlutter(event) {
      if (!event || !window.$bridgeName) { return; }
      try {
        window.$bridgeName.postMessage(JSON.stringify(event));
      } catch (e) {
        console.error('[WEBVIEW] Bridge postMessage failed', e);
      }
    }

    function sendLoading(value) {
      notifyFlutter({ type: 'loading', payload: { value: value } });
    }

    function setMapType(type) {
      if (!map) return;
      var mapping = {
        'roadmap': kakao.maps.MapTypeId.ROADMAP,
        'skyview': kakao.maps.MapTypeId.SKYVIEW,
        'hybrid': kakao.maps.MapTypeId.HYBRID,
        'terrain': kakao.maps.MapTypeId.TERRAIN
      };
      var target = mapping[type] || kakao.maps.MapTypeId.ROADMAP;
      map.setMapTypeId(target);
      notifyFlutter({ type: 'map_type', payload: { value: type } });
    }

    function markerImage(options) {
      if (!options || !options.url) return null;
      var size = new kakao.maps.Size(options.width || 32, options.height || 32);
      return new kakao.maps.MarkerImage(options.url, size);
    }

    function clearMarkers() {
      markers.forEach(function(marker) { marker.setMap(null); });
      markers = [];
      if (clusterer) { clusterer.clear(); }
    }

    function clearPolylines() {
      polylines.forEach(function(polyline) { polyline.setMap(null); });
      polylines = [];
    }

    function createMarker(m) {
      var position = new kakao.maps.LatLng(m.lat, m.lng);
      var markerOptions = { position: position };
      var image = markerImage(m.image);
      if (image) { markerOptions.image = image; }
      var marker = new kakao.maps.Marker(markerOptions);
      var infoWindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:8px;font-size:13px;">' + m.title + '</div>'
      });
      kakao.maps.event.addListener(marker, 'click', function() {
        infoWindow.open(map, marker);
        notifyFlutter({ type: 'marker_tap', payload: { id: m.id } });
      });
      return marker;
    }

    function renderMarkers(targetMap) {
      if (!Array.isArray(markerData)) return;
      clearMarkers();
      markerData.forEach(function(m) {
        var marker = createMarker(m);
        markers.push(marker);
      });
      if (clusterer) {
        clusterer.addMarkers(markers);
      } else {
        markers.forEach(function(marker) { marker.setMap(targetMap); });
      }
    }

    function renderPolylines(targetMap) {
      if (!Array.isArray(polylineData)) return;
      clearPolylines();
      polylineData.forEach(function(p) {
        var path = (p.path || []).map(function(point) {
          return new kakao.maps.LatLng(point.lat, point.lng);
        });
        var polyline = new kakao.maps.Polyline({
          path: path,
          strokeWeight: p.strokeWeight || 4,
          strokeColor: p.strokeColor || '#2E8B57',
          strokeOpacity: p.strokeOpacity || 0.9,
          strokeStyle: 'solid'
        });
        polyline.setMap(targetMap);
        polylines.push(polyline);
      });
    }

    function setMarkers(data) {
      if (Array.isArray(data)) {
        markerData = data;
      }
      if (!map) return;
      renderMarkers(map);
    }

    function setPolylines(data) {
      if (Array.isArray(data)) {
        polylineData = data;
      }
      if (!map) return;
      renderPolylines(map);
    }

    function moveTo(lat, lng, level) {
      if (!map) return;
      var latlng = new kakao.maps.LatLng(lat, lng);
      map.setCenter(latlng);
      if (typeof level === 'number') { map.setLevel(level); }
    }

    function animateTo(lat, lng, level) {
      if (!map) return;
      var latlng = new kakao.maps.LatLng(lat, lng);
      map.panTo(latlng);
      if (typeof level === 'number') { map.setLevel(level); }
    }

    function zoomIn() {
      if (!map) return;
      map.setLevel(map.getLevel() - 1);
    }

    function zoomOut() {
      if (!map) return;
      map.setLevel(map.getLevel() + 1);
    }

    function fitBounds(data) {
      if (!map) return;
      var points = Array.isArray(data) ? data : markerData;
      if (!points || !points.length) return;
      var bounds = new kakao.maps.LatLngBounds();
      points.forEach(function(m) { bounds.extend(new kakao.maps.LatLng(m.lat, m.lng)); });
      map.setBounds(bounds);
    }

    function prepareClusterer(targetMap) {
      if (!mapOptions || !mapOptions.enableClustering) return;
      clusterer = new kakao.maps.MarkerClusterer({
        map: targetMap,
        averageCenter: true,
        minLevel: 5,
      });
      kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
        var center = cluster.getCenter();
        notifyFlutter({ type: 'cluster_tap', payload: { lat: center.getLat(), lng: center.getLng() } });
      });
    }

    function initMap() {
      var container = document.getElementById('map');
      var options = {
        center: new kakao.maps.LatLng(${center.lat}, ${center.lng}),
        level: mapOptions.level || 6,
        mapTypeId: kakao.maps.MapTypeId[(mapOptions.mapType || 'roadmap').toUpperCase()] || kakao.maps.MapTypeId.ROADMAP,
      };
      map = new kakao.maps.Map(container, options);
      clearTimeout(loadTimer);
      prepareClusterer(map);
      renderMarkers(map);
      renderPolylines(map);
      setMapType(mapOptions.mapType || 'roadmap');
      if (mapOptions.showZoomControl) {
        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
      }
      if (mapOptions.showMapTypeControl) {
        var mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      }
      kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        notifyFlutter({
          type: 'map_tap',
          payload: { lat: mouseEvent.latLng.getLat(), lng: mouseEvent.latLng.getLng() }
        });
      });
      ready = true;
      sendLoading(false);
      notifyFlutter({ type: 'ready' });
    }

    function handleLoadTimeout() {
      if (ready) return;
      notifyFlutter({ type: 'error', payload: { code: 'sdk_load_timeout', attempt: loadAttempts } });
    }

    function loadKakaoMap(force) {
      ready = false;
      sendLoading(true);
      loadAttempts += 1;
      clearTimeout(loadTimer);
      loadTimer = setTimeout(handleLoadTimeout, 7000);
      if (force) {
        map = null;
      }
      if (window.kakao && kakao.maps && kakao.maps.load) {
        kakao.maps.load(initMap);
      } else {
        setTimeout(function() { loadKakaoMap(false); }, 200);
      }
    }

    window.onload = function() {
      mapOptions.enableClustering = ${enableClustering ? 'true' : 'false'};
      loadKakaoMap(false);
    };

    window.kakaoMap = {
      moveTo: moveTo,
      animateTo: animateTo,
      zoomIn: zoomIn,
      zoomOut: zoomOut,
      fitBounds: fitBounds,
      setMarkers: setMarkers,
      clearMarkers: clearMarkers,
      setPolylines: setPolylines,
      clearPolylines: clearPolylines,
      setMapType: setMapType,
      reloadMap: function() { loadKakaoMap(true); },
      get isReady() { return !!ready; }
    };

    ${additionalScripts ?? ''}
  </script>
</body>
</html>
''';
  }

  String _escape(String value) {
    return value.replaceAll("'", "\\'");
  }

  String _missingApiKeyPage() {
    return '''
<!DOCTYPE html>
<html>
<body>
  <p style="padding:16px;font-size:16px;">
    카카오맵 API 키가 설정되지 않았습니다. KAKAO_MAP_API_KEY 환경 변수를 추가해주세요.
  </p>
</body>
</html>
''';
  }
}
