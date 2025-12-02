import 'dart:convert';

import '../../models/map/kakao_map_options.dart';

class KakaoMapHtmlBuilder {
  const KakaoMapHtmlBuilder();

  String build({
    required String apiKey,
    required KakaoMapOptions options,
    required String bridgeName,
  }) {
    if (apiKey.isEmpty) {
      return _missingApiKeyPage();
    }

    final optionsJson = jsonEncode(options.toJson());
    final escapedBridge = jsonEncode(bridgeName);

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <style>
    html, body, #map { width: 100%; height: 100%; margin: 0; padding: 0; }
    #overlay { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; background: rgba(0,0,0,0.05); font-family: Arial, sans-serif; }
  </style>
</head>
<body>
  <div id="map"></div>
  <div id="overlay" style="display:none;">Loading KakaoMap...</div>
  <script>
    const BRIDGE_NAME = $escapedBridge;
    const EVENT_SOURCE = 'kakaomap-js';
    const INITIAL_OPTIONS = $optionsJson;
    let map;
    let markers = [];
    let polylines = [];
    let commandQueue = [];
    let isReady = false;
    let currentOptions = INITIAL_OPTIONS;

    function emit(type, payload = {}, level = 'info') {
      const message = JSON.stringify({
        type: type,
        payload: payload || {},
        timestamp: Date.now(),
        level: level,
        source: EVENT_SOURCE,
      });
      try {
        if (window[BRIDGE_NAME] && window[BRIDGE_NAME].postMessage) {
          window[BRIDGE_NAME].postMessage(message);
        }
      } catch (e) {
        console.error('[KakaoMap] postMessage failed', e);
      }
    }

    ['log', 'warn', 'error'].forEach(function(level) {
      const original = console[level];
      console[level] = function() {
        const args = Array.from(arguments);
        emit('log', { messages: args.map(String) }, level === 'log' ? 'info' : level);
        if (original) {
          original.apply(console, args);
        }
      }
    });

    function toggleOverlay(show, message) {
      const overlay = document.getElementById('overlay');
      if (!overlay) return;
      overlay.style.display = show ? 'flex' : 'none';
      overlay.textContent = message || 'Loading KakaoMap...';
    }

    function clearMarkers() {
      markers.forEach(function(marker) { marker.setMap(null); });
      markers = [];
    }

    function clearPolylines() {
      polylines.forEach(function(poly) { poly.setMap(null); });
      polylines = [];
    }

    function setCenter(lat, lng, animate) {
      if (!map) return;
      const target = new kakao.maps.LatLng(lat, lng);
      if (animate) {
        map.panTo(target);
      } else {
        map.setCenter(target);
      }
    }

    function setLevel(level) {
      if (!map) return;
      map.setLevel(level);
    }

    function setMapType(type) {
      if (!map) return;
      switch (type) {
        case 'skyview':
          map.setMapTypeId(kakao.maps.MapTypeId.SKYVIEW);
          break;
        case 'hybrid':
          map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);
          break;
        case 'terrain':
          map.setMapTypeId(kakao.maps.MapTypeId.TERRAIN);
          break;
        case 'roadmap':
        default:
          map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);
      }
    }

    function applyMarkers(markerList) {
      clearMarkers();
      if (!Array.isArray(markerList)) return;
      markerList.forEach(function(item) {
        const position = new kakao.maps.LatLng(item.lat, item.lng);
        const marker = new kakao.maps.Marker({ position: position });
        marker.setMap(map);
        kakao.maps.event.addListener(marker, 'click', function() {
          emit('marker_click', {
            id: item.id,
            title: item.title,
            lat: item.lat,
            lng: item.lng,
          });
        });
        markers.push(marker);
      });
    }

    function applyPolylines(polylineList) {
      clearPolylines();
      if (!Array.isArray(polylineList)) return;
      polylineList.forEach(function(item) {
        const path = (item.points || []).map(function(point) {
          return new kakao.maps.LatLng(point.lat, point.lng);
        });
        const polyline = new kakao.maps.Polyline({
          map: map,
          path: path,
          strokeWeight: item.strokeWeight || 3,
          strokeColor: item.strokeColor || '#3366FF',
          strokeOpacity: item.strokeOpacity || 0.7,
          strokeStyle: 'solid',
        });
        polylines.push(polyline);
      });
    }

    function fitToMarkers(markerList) {
      if (!map || !Array.isArray(markerList) || markerList.length === 0) return;
      const bounds = new kakao.maps.LatLngBounds();
      markerList.forEach(function(item) {
        bounds.extend(new kakao.maps.LatLng(item.lat, item.lng));
      });
      map.setBounds(bounds, 30, 30, 30, 30);
    }

    function applyOptions(options) {
      currentOptions = options || currentOptions;
      if (!map || !currentOptions || !currentOptions.center) return;
      setMapType(currentOptions.mapType || 'roadmap');
      setLevel(currentOptions.level || 6);
      applyMarkers(currentOptions.markers || []);
      applyPolylines(currentOptions.polylines || []);
      setCenter(currentOptions.center.lat, currentOptions.center.lng, false);
    }

    function bindMapEvents() {
      if (!map) return;
      kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        emit('region_click', {
          lat: mouseEvent.latLng.getLat(),
          lng: mouseEvent.latLng.getLng(),
        });
      });
    }

    function handleCommand(command) {
      const cmd = typeof command === 'string' ? JSON.parse(command) : command;
      if (!cmd || !cmd.type) return;
      if (!isReady && cmd.type !== 'reload') {
        commandQueue.push(cmd);
        return;
      }

      switch (cmd.type) {
        case 'set_center':
          setCenter(cmd.payload.lat, cmd.payload.lng, cmd.payload.animate);
          break;
        case 'set_level':
          setLevel(cmd.payload.level);
          break;
        case 'set_map_type':
          setMapType(cmd.payload.mapType);
          break;
        case 'set_markers':
          applyMarkers(cmd.payload.markers || []);
          break;
        case 'set_polylines':
          applyPolylines(cmd.payload.polylines || []);
          break;
        case 'fit_to_markers':
          fitToMarkers(cmd.payload.markers || []);
          break;
        case 'reload':
          isReady = false;
          applyOptions(cmd.payload.options || currentOptions);
          isReady = true;
          emit('ready', {});
          flushQueue();
          break;
        default:
          emit('log', { message: 'Unknown command: ' + cmd.type }, 'warn');
      }
    }

    function flushQueue() {
      if (!isReady || !commandQueue.length) return;
      const pending = commandQueue.slice();
      commandQueue = [];
      pending.forEach(handleCommand);
    }

    function initMap() {
      toggleOverlay(true, '지도 로딩 중...');
      const container = document.getElementById('map');
      const center = new kakao.maps.LatLng(currentOptions.center.lat, currentOptions.center.lng);
      map = new kakao.maps.Map(container, {
        center: center,
        level: currentOptions.level || 6,
      });
      bindMapEvents();
      applyOptions(currentOptions);
      toggleOverlay(false);
      isReady = true;
      emit('ready', {});
      flushQueue();
    }

    function loadSdk() {
      emit('sdk_loading', {});
      const script = document.createElement('script');
      script.src = 'https://dapi.kakao.com/v2/maps/sdk.js?autoload=false&libraries=services,clusterer&appkey=$apiKey';
      script.onload = function() {
        emit('sdk_loaded', {});
        kakao.maps.load(initMap);
      };
      script.onerror = function(error) {
        emit('sdk_failed', { message: 'Kakao SDK load failed', detail: error?.message }, 'error');
        toggleOverlay(true, 'SDK 로딩 실패');
      };
      document.head.appendChild(script);
    }

    window.handleKakaoCommand = handleCommand;
    window.addEventListener('load', loadSdk);
  </script>
</body>
</html>
''';
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
