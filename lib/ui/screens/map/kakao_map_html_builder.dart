class KakaoMapLatLng {
  const KakaoMapLatLng(this.lat, this.lng);

  final double lat;
  final double lng;
}

class KakaoMapPolicyMarker {
  const KakaoMapPolicyMarker({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
  });

  final String id;
  final String title;
  final double lat;
  final double lng;
}

class KakaoMapHtmlBuilder {
  const KakaoMapHtmlBuilder();

  String build({
    required String apiKey,
    required KakaoMapLatLng center,
    required List<KakaoMapPolicyMarker> markers,
    String? bridgeName,
  }) {
    if (apiKey.isEmpty) {
      return _missingApiKeyPage();
    }

    final markerJson = markers
        .map(
          (m) => "{id: '${_escape(m.id)}', title: '${_escape(m.title)}', lat: ${m.lat}, lng: ${m.lng}}",
        )
        .join(',');

    final safeBridgeName = bridgeName != null && bridgeName.isNotEmpty
        ? bridgeName
        : null;

    final notifyFlutter = safeBridgeName != null
        ? """
            function notifyFlutter(message) {
              try {
                $safeBridgeName.postMessage(message);
              } catch (e) {
                console.warn('Bridge postMessage failed', e);
              }
            }
          """
        : "function notifyFlutter(message) {}";

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <style>
    html, body, #map { width: 100%; height: 100%; margin: 0; padding: 0; }
  </style>
  <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=$apiKey&autoload=true"></script>
</head>
<body>
  <div id="map"></div>
  <script>
    var map;

    $notifyFlutter

    function moveTo(lat, lng) {
      if (!map) return;
      var latlng = new kakao.maps.LatLng(lat, lng);
      map.setCenter(latlng);
    }

    function createMarkers(map) {
      var markers = [$markerJson];
      markers.forEach(function(m) {
        var position = new kakao.maps.LatLng(m.lat, m.lng);
        var marker = new kakao.maps.Marker({ position: position });
        marker.setMap(map);

        var infoWindow = new kakao.maps.InfoWindow({
          content: '<div style="padding:8px;font-size:13px;">' + m.title + '</div>'
        });
        kakao.maps.event.addListener(marker, 'click', function() {
          infoWindow.open(map, marker);
          notifyFlutter('marker:' + m.id);
        });
      });
    }

    function initMap() {
      var container = document.getElementById('map');
      var options = {
        center: new kakao.maps.LatLng(${center.lat}, ${center.lng}),
        level: 6
      };
      map = new kakao.maps.Map(container, options);
      createMarkers(map);
      kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        notifyFlutter('region:' + mouseEvent.latLng.getLat() + ',' + mouseEvent.latLng.getLng());
      });
      notifyFlutter('ready');
    }

    window.onload = function() {
      if (kakao && kakao.maps) {
        initMap();
      } else {
        setTimeout(() => initMap(), 100);
      }
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
