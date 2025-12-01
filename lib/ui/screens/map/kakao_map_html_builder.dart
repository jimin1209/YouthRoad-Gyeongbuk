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

class KakaoMapMarker {
  const KakaoMapMarker({
    required this.id,
    required this.title,
    required this.position,
  });

  final String id;
  final String title;
  final KakaoMapLatLng position;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': _escape(title),
        ...position.toJson(),
      };

  KakaoMapMarker copyWith({
    String? id,
    String? title,
    KakaoMapLatLng? position,
  }) {
    return KakaoMapMarker(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KakaoMapMarker &&
        other.id == id &&
        other.title == title &&
        other.position == position;
  }

  @override
  int get hashCode => Object.hash(id, title, position);
}

class KakaoMapHtmlBuilder {
  const KakaoMapHtmlBuilder();

  String build({
    required String apiKey,
    required KakaoMapLatLng center,
    required List<KakaoMapMarker> markers,
    String bridgeName = 'KakaoBridge',
  }) {
    if (apiKey.isEmpty) {
      return _missingApiKeyPage();
    }

    final markerJson = jsonEncode(markers.map((m) => m.toJson()).toList());

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <style>
    html, body, #map { width: 100%; height: 100%; margin: 0; padding: 0; }
  </style>
  <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=$apiKey&autoload=false"></script>
</head>
<body>
  <div id="map"></div>
  <script>
    var map;
    var markers = [];
    var markerData = $markerJson;

    function notifyFlutter(event) {
      if (!event || !window.$bridgeName) { return; }
      try {
        window.$bridgeName.postMessage(JSON.stringify(event));
      } catch (e) {
        console.error('[WEBVIEW] Bridge postMessage failed', e);
      }
    }

    function moveTo(lat, lng, level) {
      if (!map) return;
      var latlng = new kakao.maps.LatLng(lat, lng);
      map.setCenter(latlng);
      if (typeof level === 'number') {
        map.setLevel(level);
      }
    }

    function clearMarkers() {
      markers.forEach(function(marker) { marker.setMap(null); });
      markers = [];
    }

    function renderMarkers(targetMap) {
      if (!Array.isArray(markerData)) return;
      markerData.forEach(function(m) {
        var position = new kakao.maps.LatLng(m.lat, m.lng);
        var marker = new kakao.maps.Marker({ position: position });
        marker.setMap(targetMap);
        markers.push(marker);

        var infoWindow = new kakao.maps.InfoWindow({
          content: '<div style="padding:8px;font-size:13px;">' + m.title + '</div>'
        });
        kakao.maps.event.addListener(marker, 'click', function() {
          infoWindow.open(targetMap, marker);
          notifyFlutter({ type: 'marker_tap', payload: { id: m.id } });
        });
      });
    }

    function setMarkers(data) {
      if (Array.isArray(data)) {
        markerData = data;
      }
      if (!map) return;
      clearMarkers();
      renderMarkers(map);
    }

    function initMap() {
      var container = document.getElementById('map');
      var options = {
        center: new kakao.maps.LatLng(${center.lat}, ${center.lng}),
        level: 6
      };
      map = new kakao.maps.Map(container, options);
      renderMarkers(map);
      kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        notifyFlutter({
          type: 'map_tap',
          payload: { lat: mouseEvent.latLng.getLat(), lng: mouseEvent.latLng.getLng() }
        });
      });
      notifyFlutter({ type: 'ready' });
    }

    function loadKakaoMap() {
      if (window.kakao && kakao.maps && kakao.maps.load) {
        kakao.maps.load(initMap);
      } else {
        setTimeout(loadKakaoMap, 100);
      }
    }

    window.onload = loadKakaoMap;

    window.kakaoMap = {
      moveTo: moveTo,
      setMarkers: setMarkers,
      clearMarkers: clearMarkers,
      get isReady() { return !!map; }
    };
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
