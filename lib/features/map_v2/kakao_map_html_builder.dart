import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// 지도 타입
/// ─────────────────────────────────────────────────────────────────────────────
enum KakaoMapType {
  roadmap,
  hybrid,
  skyview,
}

/// ─────────────────────────────────────────────────────────────────────────────
/// LatLng
/// ─────────────────────────────────────────────────────────────────────────────
class KakaoMapLatLng {
  const KakaoMapLatLng(this.lat, this.lng);

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// 마커 이미지
///   - url: 원격 이미지 (https://...)
//    - assetPath: Flutter asset 를 직접 지정 (예: assets/images/marker.png)
//    - asset: 의미상 alias (assetPath 대신 쓸 수 있게만 둠)
/// ─────────────────────────────────────────────────────────────────────────────
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

  /// Flutter asset key (의미상 alias)
  final String? asset;

  /// 실제 asset 경로 (예: assets/images/marker.png)
  final String? assetPath;

  /// 원격 URL
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

/// ─────────────────────────────────────────────────────────────────────────────
/// 마커
/// ─────────────────────────────────────────────────────────────────────────────
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

/// ─────────────────────────────────────────────────────────────────────────────
/// 폴리라인
///   - points / path 둘 다 지원 (예전 코드 호환)
///   - strokeOpacity 추가
/// ─────────────────────────────────────────────────────────────────────────────
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

/// ─────────────────────────────────────────────────────────────────────────────
/// 지도 옵션
/// ─────────────────────────────────────────────────────────────────────────────
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

/// ─────────────────────────────────────────────────────────────────────────────
/// HTML Builder
///   - Kakao JS SDK v2 + autoload=false
///   - window.kakaoBootstrap() 를 Flutter 쪽에서 호출
///   - window.kakaoMap.* API 를 KakaoMapController 가 호출
/// ─────────────────────────────────────────────────────────────────────────────
class KakaoMapHtmlBuilder {
  const KakaoMapHtmlBuilder();

  String build({
    required String apiKey,
    required KakaoMapLatLng center,
    required List<KakaoMapMarker> markers,
    List<KakaoMapPolyline> polylines = const [],
    KakaoMapOptions options = const KakaoMapOptions(),
    required String bridgeName,
    bool enableClustering = false,
    String? additionalScripts,
  }) {
    final payload = {
      'center': center.toJson(),
      'markers': markers.map((e) => e.toJson()).toList(),
      'polylines': polylines.map((e) => e.toJson()).toList(),
      'options': options.toJson(),
      'clustering': enableClustering,
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
</style>

<script>
  function _post(msg) {
    try { $bridgeName.postMessage(JSON.stringify(msg)); }
    catch(e) { console.log('[KakaoMap][bridge error]', e); }
  }

  function _logOrigin() {
    var href = window.location.href;
    var origin = window.location.origin;
    var referrer = document.referrer;
    var msg = '[KakaoMap][origin] href=' + href + ' origin=' + origin + ' referrer=' + referrer;
    console.log(msg);
    _post({ type: 'log', payload: { message: msg } });
  }

  window.kakaoBootstrap = function() {
    _logOrigin();
    if (!window.kakao || !window.kakao.maps) {
      _post({type:'error',payload:{code:'sdkFail',detail:'kakao.maps not available'}});
      return;
    }

    kakao.maps.load(function(){
      var p = $initJson;

      var container = document.getElementById('map');
      var center = new kakao.maps.LatLng(p.center.lat, p.center.lng);

      var map = new kakao.maps.Map(container, {
        center: center,
        level: p.options.level
      });

      // 지도 타입
      if (p.options.mapType === 'hybrid' || p.options.mapType === 'skyview') {
        map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);
      } else {
        map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);
      }

      // 컨트롤들
      if (p.options.showZoomControl) {
        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
      }
      if (p.options.showMapTypeControl) {
        var mtc = new kakao.maps.MapTypeControl();
        map.addControl(mtc, kakao.maps.ControlPosition.TOPRIGHT);
      }

      // 맵 클릭 이벤트
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

      window.kakaoMap = _wrap(map, p);
      _post({type:'ready',payload:{}});
    });
  };

  function _resolveMarkerImage(mImage) {
    if (!mImage) return null;

    var src = null;

    if (mImage.url) {
      src = mImage.url;
    } else if (mImage.assetPath) {
      // Flutter WebView 에서 asset 접근용 기본 스킴
      src = 'https://appassets.androidplatform.net/' + mImage.assetPath;
    } else if (mImage.asset) {
      src = 'https://appassets.androidplatform.net/' + mImage.asset;
    }

    if (!src) return null;

    var width = mImage.sizeWidth || mImage.width || 32;
    var height = mImage.sizeHeight || mImage.height || 32;

    var size = new kakao.maps.Size(width, height);

    var offsetX = (typeof mImage.offsetX === 'number')
      ? mImage.offsetX
      : width / 2;
    var offsetY = (typeof mImage.offsetY === 'number')
      ? mImage.offsetY
      : height;

    var offset = new kakao.maps.Point(offsetX, offsetY);

    return new kakao.maps.MarkerImage(src, size, { offset: offset });
  }

  function _wrap(map, p) {
    var markers = [];
    var polylines = [];
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

      list.forEach(function(m) {
        var pos = new kakao.maps.LatLng(m.lat, m.lng);
        var image = _resolveMarkerImage(m.image);

        var mk = new kakao.maps.Marker({
          position: pos,
          title: m.title || '',
          image: image || undefined
        });

        mk.setMap(map);

        kakao.maps.event.addListener(mk, 'click', function() {
          _post({
            type: 'marker',
            payload: {
              id: m.id,
              lat: m.lat,
              lng: m.lng
            }
          });
        });

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

      list.forEach(function(l) {
        var path = (l.points || []).map(function(pt) {
          return new kakao.maps.LatLng(pt.lat, pt.lng);
        });

        if (!path.length) return;

        var pl = new kakao.maps.Polyline({
          path: path,
          strokeWeight: l.strokeWeight || 3,
          strokeColor: l.strokeColor || '#3399ff',
          strokeOpacity: (typeof l.strokeOpacity === 'number') ? l.strokeOpacity : 1.0,
          strokeStyle: 'solid'
        });

        pl.setMap(map);
        polylines.push(pl);
      });
    }

    syncMarkers(p.markers);
    syncPolylines(p.polylines);

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
      }
    };
  }
</script>

<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=$apiKey&autoload=false&libraries=services,clusterer"></script>

</head>
<body>
  <div id="map"></div>
  ${additionalScripts ?? ''}
</body>
</html>
''';
  }
}
