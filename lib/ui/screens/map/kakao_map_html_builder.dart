import 'dart:convert';

String _escape(String value) => const HtmlEscape().convert(value);

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
</head>
<body>
  <div id="map"></div>
  <script>
    (() => {
      const ORIGIN = 'kakao-map-webview';
      const SDK_URL = 'https://dapi.kakao.com/v2/maps/sdk.js?appkey=$apiKey&autoload=false&libraries=services$clusteringLibrary';
      const state = {
        ready: false,
        loading: false,
        loadTimer: null,
        loadAttempts: 0,
        sdkPollCount: 0,
        maxPolls: 80,
        maxReloads: 3,
        map: null,
        clusterer: null,
        markers: [],
        polylines: [],
        markerData: $markerJson,
        polylineData: $polylineJson,
        options: $optionsJson,
        enableClustering: ${enableClustering ? 'true' : 'false'},
        sdkLoaded: false,
        sdkLoading: false,
      };

      const bridge = window.$bridgeName;

      function envelope(type, payload, level) {
        return {
          type: type,
          payload: payload || {},
          timestamp: Date.now(),
          origin: ORIGIN,
          logLevel: level || 'info',
        };
      }

      function notifyFlutter(type, payload, level) {
        if (!bridge) return;
        try {
          bridge.postMessage(JSON.stringify(envelope(type, payload, level)));
        } catch (e) {
          console.warn('[KakaoMap] Failed to post message', e);
        }
      }

      function log(level, ...args) {
        const message = args.map(String).join(' ');
        notifyFlutter('log', { message }, level);
      }

      log('info', 'html-loaded');

      function installConsoleProxy() {
        const originalLog = console.log;
        const originalWarn = console.warn;
        const originalError = console.error;
        console.log = function(...args) {
          log('info', ...args);
          originalLog.apply(console, args);
        };
        console.warn = function(...args) {
          log('warn', ...args);
          originalWarn.apply(console, args);
        };
        console.error = function(...args) {
          log('error', ...args);
          originalError.apply(console, args);
        };
      }

      function handleGlobalErrors() {
        window.addEventListener('error', function(event) {
          notifyFlutter('error', {
            code: 'jsException',
            message: event.message,
            source: event.filename,
            line: event.lineno,
            column: event.colno,
          }, 'error');
        });
        window.addEventListener('unhandledrejection', function(event) {
          notifyFlutter('error', {
            code: 'jsException',
            message: event.reason ? String(event.reason) : 'Unhandled rejection',
          }, 'error');
        });
      }

      function sendLoading(value) {
        state.loading = value;
        notifyFlutter('loading', { value });
      }

      function ensureSdkLoaded(force) {
        if (state.sdkLoaded && window.kakao && window.kakao.maps) {
          pollSdkLoaded(force);
          return;
        }
        if (!state.sdkLoading) {
          state.sdkLoading = true;
          log('info', 'sdk-script-load-start');
          const existing = document.querySelector('script[data-kakao-sdk="true"]');
          if (!existing) {
            const script = document.createElement('script');
            script.src = SDK_URL;
            script.async = true;
            script.defer = true;
            script.dataset.kakaoSdk = 'true';
            script.onload = function() {
              state.sdkLoaded = true;
              state.sdkLoading = false;
              log('info', 'sdkLoaded');
              pollSdkLoaded(force);
            };
            script.onerror = function(event) {
              state.sdkLoading = false;
              log('error', 'sdkFail');
              notifyFlutter('error', {
                code: 'sdkFail',
                message: 'Failed to load Kakao SDK',
                detail: event && event.message ? String(event.message) : 'script load error',
              }, 'error');
            };
            document.head.appendChild(script);
          } else {
            state.sdkLoading = false;
            state.sdkLoaded = !!(window.kakao && window.kakao.maps);
            log('info', 'sdk-script-cache');
          }
        }
        setTimeout(function() { pollSdkLoaded(force); }, 120);
      }

      function markerImage(options) {
        if (!options || !options.url) return null;
        const size = new kakao.maps.Size(options.width || 32, options.height || 32);
        return new kakao.maps.MarkerImage(options.url, size);
      }

      function clearMarkers() {
        state.markers.forEach(marker => marker.setMap(null));
        state.markers = [];
        if (state.clusterer) { state.clusterer.clear(); }
      }

      function clearPolylines() {
        state.polylines.forEach(polyline => polyline.setMap(null));
        state.polylines = [];
      }

      function createMarker(m) {
        const position = new kakao.maps.LatLng(m.lat, m.lng);
        const markerOptions = { position };
        const image = markerImage(m.image);
        if (image) { markerOptions.image = image; }
        const marker = new kakao.maps.Marker(markerOptions);
        const infoWindow = new kakao.maps.InfoWindow({
          content: '<div style="padding:8px;font-size:13px;">' + m.title + '</div>'
        });
        kakao.maps.event.addListener(marker, 'click', function() {
          infoWindow.open(state.map, marker);
          notifyFlutter('marker', { id: m.id });
        });
        return marker;
      }

      function renderMarkers(targetMap) {
        if (!Array.isArray(state.markerData)) return;
        clearMarkers();
        state.markerData.forEach(function(m) {
          const marker = createMarker(m);
          state.markers.push(marker);
        });
        if (state.clusterer) {
          state.clusterer.addMarkers(state.markers);
        } else {
          state.markers.forEach(marker => marker.setMap(targetMap));
        }
      }

      function renderPolylines(targetMap) {
        if (!Array.isArray(state.polylineData)) return;
        clearPolylines();
        state.polylineData.forEach(function(p) {
          const path = (p.path || []).map(function(point) {
            return new kakao.maps.LatLng(point.lat, point.lng);
          });
          const polyline = new kakao.maps.Polyline({
            path: path,
            strokeWeight: p.strokeWeight || 4,
            strokeColor: p.strokeColor || '#2E8B57',
            strokeOpacity: p.strokeOpacity || 0.9,
            strokeStyle: 'solid'
          });
          polyline.setMap(targetMap);
          state.polylines.push(polyline);
        });
      }

      function setMarkers(data) {
        if (Array.isArray(data)) {
          state.markerData = data;
        }
        if (!state.map) return;
        renderMarkers(state.map);
      }

      function setPolylines(data) {
        if (Array.isArray(data)) {
          state.polylineData = data;
        }
        if (!state.map) return;
        renderPolylines(state.map);
      }

      function moveTo(lat, lng, level) {
        if (!state.map) return;
        const latlng = new kakao.maps.LatLng(lat, lng);
        state.map.setCenter(latlng);
        if (typeof level === 'number') { state.map.setLevel(level); }
      }

      function animateTo(lat, lng, level) {
        if (!state.map) return;
        const latlng = new kakao.maps.LatLng(lat, lng);
        state.map.panTo(latlng);
        if (typeof level === 'number') { state.map.setLevel(level); }
      }

      function zoomIn() {
        if (!state.map) return;
        state.map.setLevel(state.map.getLevel() - 1);
      }

      function zoomOut() {
        if (!state.map) return;
        state.map.setLevel(state.map.getLevel() + 1);
      }

      function fitBounds(data) {
        if (!state.map) return;
        const points = Array.isArray(data) ? data : state.markerData;
        if (!points || !points.length) return;
        const bounds = new kakao.maps.LatLngBounds();
        points.forEach(function(m) { bounds.extend(new kakao.maps.LatLng(m.lat, m.lng)); });
        state.map.setBounds(bounds);
      }

      function setMapType(type) {
        if (!state.map) return;
        const mapping = {
          'roadmap': kakao.maps.MapTypeId.ROADMAP,
          'skyview': kakao.maps.MapTypeId.SKYVIEW,
          'hybrid': kakao.maps.MapTypeId.HYBRID,
          'terrain': kakao.maps.MapTypeId.TERRAIN
        };
        const target = mapping[type] || kakao.maps.MapTypeId.ROADMAP;
        state.map.setMapTypeId(target);
        notifyFlutter('map_type', { value: type });
      }

      function prepareClusterer(targetMap) {
        if (!state.options || !state.enableClustering) return;
        state.clusterer = new kakao.maps.MarkerClusterer({
          map: targetMap,
          averageCenter: true,
          minLevel: 5,
        });
        kakao.maps.event.addListener(state.clusterer, 'clusterclick', function(cluster) {
          const center = cluster.getCenter();
          notifyFlutter('cluster', { lat: center.getLat(), lng: center.getLng() });
        });
      }

      function initMap() {
        log('info', 'init-start');
        const container = document.getElementById('map');
        const options = {
          center: new kakao.maps.LatLng(${center.lat}, ${center.lng}),
          level: state.options.level || 6,
          mapTypeId: kakao.maps.MapTypeId[(state.options.mapType || 'roadmap').toUpperCase()] || kakao.maps.MapTypeId.ROADMAP,
        };
        state.map = new kakao.maps.Map(container, options);
        clearTimeout(state.loadTimer);
        prepareClusterer(state.map);
        renderMarkers(state.map);
        renderPolylines(state.map);
        setMapType(state.options.mapType || 'roadmap');
        if (state.options.showZoomControl) {
          const zoomControl = new kakao.maps.ZoomControl();
          state.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
        }
        if (state.options.showMapTypeControl) {
          const mapTypeControl = new kakao.maps.MapTypeControl();
          state.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
        }
        kakao.maps.event.addListener(state.map, 'click', function(mouseEvent) {
          notifyFlutter('map', {
            lat: mouseEvent.latLng.getLat(),
            lng: mouseEvent.latLng.getLng()
          });
        });
        state.ready = true;
        sendLoading(false);
        notifyFlutter('ready', {
          center: { lat: ${center.lat}, lng: ${center.lng} },
          attempt: state.loadAttempts,
        });
        log('info', 'init-end');
      }

      function handleLoadTimeout() {
        if (state.ready) return;
        notifyFlutter('error', { code: 'timeout', attempt: state.loadAttempts }, 'error');
      }

      function pollSdkLoaded(force) {
        if (window.kakao && kakao.maps && kakao.maps.load) {
          state.sdkLoaded = true;
          log('info', 'bootstrap-ready');
          kakao.maps.load(initMap);
          return;
        }
        state.sdkPollCount += 1;
        if (state.sdkPollCount > state.maxPolls) {
          log('error', 'sdkFail');
          notifyFlutter('error', { code: 'sdkFail', attempt: state.loadAttempts, polls: state.sdkPollCount }, 'error');
          if (state.loadAttempts <= state.maxReloads) {
            loadKakaoMap(true);
          }
          return;
        }
        setTimeout(function() { pollSdkLoaded(force); }, 250);
      }

      function loadKakaoMap(force) {
        state.ready = false;
        sendLoading(true);
        state.loadAttempts += 1;
        state.sdkPollCount = 0;
        clearTimeout(state.loadTimer);
        state.loadTimer = setTimeout(handleLoadTimeout, 12000);
        if (force) {
          state.map = null;
        }
        log('info', 'bootstrap-start', 'attempt', state.loadAttempts);
        ensureSdkLoaded(force);
      }

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
        get isReady() { return !!state.ready; },
      };

      function bootstrap() {
        installConsoleProxy();
        handleGlobalErrors();
        notifyFlutter('log', { message: 'bootstrap-start' }, 'info');
        loadKakaoMap(false);
        notifyFlutter('log', { message: 'bootstrap-end' }, 'info');
      }

      window.kakaoBootstrap = function() {
        bootstrap();
      };
      ${additionalScripts ?? ''}
    })();
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
