// lib/features/kakaomap/kakao_map_html_builder.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum KakaoMapType {
  roadmap,
  hybrid,
  skyview,
}

class KakaoMapLatLng {
  const KakaoMapLatLng(this.lat, this.lng);

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}

class KakaoMapMarkerImage {
  const KakaoMapMarkerImage({
    this.asset,
    this.assetPath,
    this.url,
    this.width,
    this.height,
    this.size,
    this.offset,
  });

  final String? asset;
  final String? assetPath;
  final String? url;

  final double? width;
  final double? height;

  final Size? size;
  final Offset? offset;

  Map<String, dynamic> toJson() => {
        if (asset != null) 'asset': asset,
        if (assetPath != null) 'assetPath': assetPath,
        if (url != null) 'url': url,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (size != null) ...{
          'sizeWidth': size!.width,
          'sizeHeight': size!.height,
        },
        if (offset != null) ...{
          'offsetX': offset!.dx,
          'offsetY': offset!.dy,
        },
      };
}

class KakaoMapMarker {
  const KakaoMapMarker({
    required this.id,
    required this.position,
    this.title,
    this.snippet,
    this.regionName,
    this.image,
    this.extra,
  });

  final String id;
  final KakaoMapLatLng position;
  final String? title;
  final String? snippet;
  final String? regionName;
  final KakaoMapMarkerImage? image;
  final Map<String, dynamic>? extra;

  Map<String, dynamic> toJson() => {
        'id': id,
        'lat': position.lat,
        'lng': position.lng,
        if (title != null) 'title': title,
        if (snippet != null) 'snippet': snippet,
        if (regionName != null) 'regionName': regionName,
        if (image != null) 'image': image!.toJson(),
        if (extra != null) 'extra': extra,
      };
}

class KakaoMapPolyline {
  const KakaoMapPolyline({
    required this.id,
    List<KakaoMapLatLng>? points,
    List<KakaoMapLatLng>? path,
    this.strokeColor,
    this.strokeWeight = 3,
    this.strokeOpacity = 1.0,
  }) : points = points ?? path ?? const [];

  final String id;
  final List<KakaoMapLatLng> points;
  final String? strokeColor;
  final int strokeWeight;
  final double strokeOpacity;

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points.map((e) => e.toJson()).toList(),
        'strokeWeight': strokeWeight,
        'strokeColor': strokeColor ?? '#3399ff',
        'strokeOpacity': strokeOpacity,
      };
}

class KakaoMapOptions {
  const KakaoMapOptions({
    this.level = 6,
    this.mapType = KakaoMapType.roadmap,
    this.showZoomControl = true,
    this.showMapTypeControl = true,
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
}

class KakaoMapHtmlBuilder {
  const KakaoMapHtmlBuilder();

  String build({
    required String apiKey,
    required KakaoMapLatLng center,
    KakaoMapLatLng? basePosition,
    required List<KakaoMapMarker> markers,
    List<KakaoMapPolyline> polylines = const [],
    KakaoMapOptions options = const KakaoMapOptions(),
    required String bridgeName,
    double searchRadiusMeters = 20000,
    bool enableClustering = false,
    String? additionalScripts,
  }) {
    final centerCount = markers.where((m) => m.id.startsWith('CENTER-')).length;
    if (kDebugMode) {
      debugPrint(
        '[MapBridge][INFO] HTML build: center=(${center.lat}, ${center.lng}), radiusKm=${(searchRadiusMeters / 1000).toStringAsFixed(1)}, markers=${markers.length}, centerMarkers=$centerCount',
      );
    }
    final payload = {
      'center': center.toJson(),
      'basePosition': (basePosition ?? center).toJson(),
      'markers': markers.map((e) => e.toJson()).toList(),
      'polylines': polylines.map((e) => e.toJson()).toList(),
      'options': options.toJson(),
      'clustering': enableClustering,
      'radiusMeters': searchRadiusMeters,
    };

    final initJson = jsonEncode(payload);

    return '''
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<style>
  html, body { margin:0; padding:0; width:100%; height:100%; }
  #map { width:100%; height:100%; }
  #tooltip-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 1000;
  }
  .marker-tooltip {
    background: rgba(255, 255, 255, 0.95);
    color: #1b1b1f;
    border-radius: 14px;
    padding: 8px 14px;
    font-size: 14px;
    font-weight: 600;
    line-height: 1.2;
    max-width: 190px;
    display: inline-block;
    pointer-events: none;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    position: relative;
  }
  .marker-tooltip::after {
    content: '';
    position: absolute;
    bottom: -6px;
    left: 50%;
    transform: translateX(-50%);
    border-width: 6px;
    border-style: solid;
    border-color: rgba(255, 255, 255, 0.95) transparent transparent transparent;
  }
  .current-location-dot {
    width: 14px;
    height: 14px;
    border-radius: 50%;
    background: #0b8bff;
    box-shadow: 0 0 0 3px rgba(11, 139, 255, 0.3);
    border: 2px solid white;
  }
</style>

<script>
  const initialPayload = $initJson;
  window.circleManager = window.circleManager || { circle: null, map: null, radius: null, center: null };
  window.__kakaoBasePosition = window.__kakaoBasePosition || initialPayload.basePosition;
  window.__kakaoRadiusMeters = window.__kakaoRadiusMeters || initialPayload.radiusMeters;

  function _post(msg) {
    try {
      $bridgeName.postMessage(JSON.stringify(msg));
    } catch (e) {
      console.log('[KakaoMap][bridge error]', e);
    }
  }

  function ensureFlutterBridge() {
    window.flutter_inappwebview = window.flutter_inappwebview || {};
    if (!window.flutter_inappwebview.callHandler) {
      window.flutter_inappwebview.callHandler = function(handlerName, payload) {
        _post({
          type: handlerName,
          payload: payload || {}
        });
      };
    }
  }

  function sendToFlutter(handlerName, payload) {
    ensureFlutterBridge();
    try {
      window.flutter_inappwebview.callHandler(handlerName, payload);
    } catch (e) {
      console.log('[KakaoMap][callHandler error]', e);
      _post({ type: handlerName, payload: payload });
    }
  }

  function createOrUpdateCircle(center, radius) {
    if (!window.circleManager.map) return;
    var radiusValue = typeof radius === 'number' ? radius : window.__kakaoRadiusMeters;
    if (typeof radiusValue !== 'number') {
      radiusValue = 20000;
    }
    window.__kakaoRadiusMeters = radiusValue;
    var latLng = new kakao.maps.LatLng(center.lat, center.lng);
    window.circleManager.center = center;
    window.circleManager.radius = radiusValue;

    if (window.circleManager.circle) {
      window.circleManager.circle.setCenter(latLng);
      window.circleManager.circle.setRadius(radiusValue);
      window.circleManager.circle.setMap(window.circleManager.map);
      return;
    }

    window.circleManager.circle = new kakao.maps.Circle({
      center: latLng,
      radius: radiusValue,
      strokeColor: '#3478F6',
      strokeOpacity: 0.9,
      strokeWeight: 2,
      fillColor: '#3478F6',
      fillOpacity: 0.12,
    });
    window.circleManager.circle.setMap(window.circleManager.map);
  }

  function buildCurrentLocationOverlay() {
    var dot = document.createElement('div');
    dot.className = 'current-location-dot';
    return dot;
  }

  window.app = window.app || {};

  window.app.showMarkerTooltip = function(id, name, lat, lng) {
    if (!window.circleManager.map) return;
    if (window.app._markerTooltip) {
      window.app._markerTooltip.setMap(null);
    }
    var content = document.createElement('div');
    content.className = 'marker-tooltip';
    content.textContent = name || id;

    var overlayPosition = new kakao.maps.LatLng(lat, lng);
    if (window.app._tooltipTimeout) {
      clearTimeout(window.app._tooltipTimeout);
    }

    window.app._markerTooltip = new kakao.maps.CustomOverlay({
      map: window.circleManager.map,
      position: overlayPosition,
      content: content,
      yAnchor: 1,
      zIndex: 9999,
    });
    window.app._tooltipTimeout = setTimeout(function() {
      if (window.app && window.app.hideMarkerTooltip) {
        window.app.hideMarkerTooltip();
      }
    }, 2000);
  };

  window.app.hideMarkerTooltip = function() {
    if (window.app._tooltipTimeout) {
      clearTimeout(window.app._tooltipTimeout);
      window.app._tooltipTimeout = null;
    }
    if (window.app._markerTooltip) {
      window.app._markerTooltip.setMap(null);
      window.app._markerTooltip = null;
    }
  };

  window.app.showMyPosition = function(lat, lng) {
    if (!window.circleManager.map) return;
    var pos = new kakao.maps.LatLng(lat, lng);
    if (!window.app._currentOverlay) {
      window.app._currentOverlay = new kakao.maps.CustomOverlay({
        position: pos,
        content: buildCurrentLocationOverlay(),
        xAnchor: 0.5,
        yAnchor: 0.5,
        zIndex: 9999,
      });
    } else {
      window.app._currentOverlay.setPosition(pos);
    }
    window.app._currentOverlay.setMap(window.circleManager.map);
  };

  window.app.moveTo = function(lat, lng, level) {
    if (!window.circleManager.map) return;
    var c = new kakao.maps.LatLng(lat, lng);
    window.circleManager.map.setCenter(c);
    if (typeof level === 'number') {
      window.circleManager.map.setLevel(level);
    }
    createOrUpdateCircle({ lat: lat, lng: lng }, window.__kakaoRadiusMeters);
    window.app.showMyPosition(lat, lng);
  };

  window.app.setBasePosition = function(lat, lng, radius) {
    window.__kakaoBasePosition = { lat: lat, lng: lng };
    if (typeof radius === 'number') {
      window.__kakaoRadiusMeters = radius;
    }
    if (window.kakaoMap && window.kakaoMap.moveTo) {
      window.kakaoMap.moveTo(lat, lng);
    }
    createOrUpdateCircle({ lat: lat, lng: lng }, radius);
    window.app.showMyPosition(lat, lng);
  };

  window.app.updateCircle = function(lat, lng, radius) {
    createOrUpdateCircle({ lat: lat, lng: lng }, radius);
    if (window.app.showMyPosition) {
      window.app.showMyPosition(lat, lng);
    }
  };

  window.kakaoBootstrap = function(overridePayload) {
    ensureFlutterBridge();
    if (!window.kakao || !window.kakao.maps) {
      _post({type:'error', payload:{code:'sdkFail', detail:'kakao.maps not available'}});
      return;
    }

    kakao.maps.load(function() {
      var p = Object.assign({}, initialPayload, overridePayload || {});
      var container = document.getElementById('map');
      var base = p.basePosition || window.__kakaoBasePosition || p.center;
      var basePosition = new kakao.maps.LatLng(base.lat, base.lng);
      var searchRadiusMeters =
        typeof p.radiusMeters === 'number' ? p.radiusMeters : (typeof window.__kakaoRadiusMeters === 'number' ? window.__kakaoRadiusMeters : 20000);

      window.__kakaoBasePosition = base;
      window.__kakaoRadiusMeters = searchRadiusMeters;

      var map = new kakao.maps.Map(container, {
        center: basePosition,
        level: p.options.level
      });

      window.circleManager.map = map;

      if (p.options.mapType === 'hybrid' || p.options.mapType === 'skyview') {
        map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);
      } else {
        map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);
      }

      if (p.options.showZoomControl) {
        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
      }
      if (p.options.showMapTypeControl) {
        var mtc = new kakao.maps.MapTypeControl();
        map.addControl(mtc, kakao.maps.ControlPosition.TOPRIGHT);
      }

      kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        var latlng = mouseEvent.latLng;
        _post({
          type: 'map',
          payload: {
            lat: latlng.getLat(),
            lng: latlng.getLng()
          }
        });
      });

      window.kakaoMap = _wrap(map, p, searchRadiusMeters);

      createOrUpdateCircle(base, searchRadiusMeters);
      window.app.showMyPosition(base.lat, base.lng);
      _post({type:'ready', payload:{}});
    });
  };

  function _wrap(map, p, searchRadiusMeters) {
    var markers = [];
    var polylines = [];
    var markerLookup = {};
    var clusterer = null;

    if (p.clustering) {
      try {
        clusterer = new kakao.maps.MarkerClusterer({
          map: map,
          averageCenter: true,
          minLevel: 7
        });
      } catch (e) {
        console.log('[KakaoMap] clusterer init fail', e);
      }
    }

    function syncMarkers(list) {
      markers.forEach(function(m) { m.setMap(null); });
      markers = [];
      markerLookup = {};

      if (!list || !list.length) {
        if (clusterer) {
          try {
            clusterer.clear();
          } catch (e) {
            console.log('[KakaoMap][ERROR] clusterer clear 실패', e);
          }
        }
        return;
      }

      list.forEach(function(m) {
        var pos = new kakao.maps.LatLng(m.lat, m.lng);

        var mk = new kakao.maps.Marker({
          map: map,
          position: pos,
          title: m.title || ''
        });

        kakao.maps.event.addListener(mk, 'click', function() {
          var isCenter = (m.id && m.id.indexOf('CENTER-') === 0);

          sendToFlutter('onMarkerTap', m.id);

          _post({
            type: isCenter ? 'centerMarkerClick' : 'marker',
            payload: isCenter
              ? m.id
              : {
                  id: m.id,
                  lat: m.lat,
                  lng: m.lng,
                  extra: m.extra || null
                }
          });

          if (!isCenter) {
            sendToFlutter('onMarkerClicked', {
              id: m.id,
              lat: m.lat,
              lng: m.lng,
              extra: m.extra || null
            });
          }

          if (window.app && window.app.showMarkerTooltip) {
            window.app.showMarkerTooltip(m.id, m.title, m.lat, m.lng);
            setTimeout(function() {
              if (window.app && window.app.hideMarkerTooltip) {
                window.app.hideMarkerTooltip();
              }
            }, 2000);
          }

        });

        kakao.maps.event.addListener(mk, 'mouseover', function() {
          if (window.app && window.app.showMarkerTooltip) {
            window.app.showMarkerTooltip(m.id, m.title, m.lat, m.lng);
          }
        });
        kakao.maps.event.addListener(mk, 'mouseout', function() {
          if (window.app && window.app.hideMarkerTooltip) {
            window.app.hideMarkerTooltip();
          }
        });

        markerLookup[m.id] = mk;
        markers.push(mk);
      });

      if (clusterer) {
        try {
          clusterer.clear();
          clusterer.addMarkers(markers);
        } catch (e) {
          console.log('[KakaoMap] clusterer update fail', e);
        }
      }
    }

    function syncPolylines(list) {
      polylines.forEach(function(pl) { pl.setMap(null); });
      polylines = [];
    }

    syncMarkers(p.markers);
    syncPolylines(p.polylines);

    kakao.maps.event.addListener(map, 'idle', function() {
      if (window.app && window.app.hideMarkerTooltip) {
        window.app.hideMarkerTooltip();
      }

      var center = map.getCenter();
      sendToFlutter('map_move', {
        lat: center.getLat(),
        lng: center.getLng(),
        level: map.getLevel()
      });
      _post({
        type: 'map_move',
        payload: {
          lat: center.getLat(),
          lng: center.getLng(),
          level: map.getLevel()
        }
      });
    });

    return {
      setMarkers: syncMarkers,
      setPolylines: syncPolylines,
      clearMarkers: function() { syncMarkers([]); },
      clearPolylines: function() { syncPolylines([]); },

      moveTo: function(lat, lng, lvl) {
        map.setCenter(new kakao.maps.LatLng(lat, lng));
        if (lvl != null) map.setLevel(lvl);
      },

      animateTo: function(lat, lng, lvl) {
        if (lvl != null) map.setLevel(lvl);
        map.panTo(new kakao.maps.LatLng(lat, lng));
      },

      zoomIn: function() {
        var level = map.getLevel();
        map.setLevel(level + 1);
      },

      zoomOut: function() {
        var level = map.getLevel();
        if (level > 1) {
          map.setLevel(level - 1);
        }
      },

      setMapType: function(t) {
        var id;
        if (t === 'hybrid' || t === 'skyview') {
          id = kakao.maps.MapTypeId.HYBRID;
        } else {
          id = kakao.maps.MapTypeId.ROADMAP;
        }
        map.setMapTypeId(id);
        _post({ type:'map_type', payload:{ value: t }});
      },

      fitBounds: function(list) {
        if (!list || !list.length) return;
        var bounds = new kakao.maps.LatLngBounds();
        list.forEach(function(m) {
          bounds.extend(new kakao.maps.LatLng(m.lat, m.lng));
        });
        map.setBounds(bounds);
      },

      reloadMap: function() {
        syncMarkers(p.markers);
        syncPolylines(p.polylines);
      },

      highlightMarker: function(id, lat, lng) {
        if (!id) return;
        var target = markerLookup[id];
        if (!target) return;

        if (lat != null && lng != null) {
          map.setCenter(new kakao.maps.LatLng(lat, lng));
        }

        try {
          target.setAnimation(kakao.maps.MarkerAnimation.BOUNCE);
          setTimeout(function() {
            target.setAnimation(null);
          }, 1500);
        } catch (e) {
          console.log('[KakaoMap] highlightMarker error', e);
        }
      }
    };
  }
</script>
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=$apiKey&autoload=false&libraries=services,clusterer"></script>

</head>
<body>
  <div id="map"></div>
  <div id="tooltip-container"></div>
  ${additionalScripts ?? ''}
</body>
</html>
''';
  }
}
