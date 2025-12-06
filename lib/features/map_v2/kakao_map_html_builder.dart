import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 지도 타입
enum KakaoMapType {
  roadmap,
  hybrid,
  skyview,
}

/// LatLng
class KakaoMapLatLng {
  const KakaoMapLatLng(this.lat, this.lng);

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}

/// 마커 이미지
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

  /// Flutter asset 경로
  final String? asset;

  /// 직접 넘긴 assetPath
  final String? assetPath;

  /// 원격 URL — ***새로 추가***
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

/// 마커
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

/// 폴리라인
class KakaoMapPolyline {
  const KakaoMapPolyline({
    required this.id,
    List<KakaoMapLatLng>? points,
    List<KakaoMapLatLng>? path,
    this.strokeColor,
    this.strokeWeight = 3,
    this.strokeOpacity = 1.0, // ← ★ 추가됨
  }) : points = points ?? path ?? const [];

  final String id;
  final List<KakaoMapLatLng> points;
  final String? strokeColor;
  final int strokeWeight;
  final double strokeOpacity; // ← ★ 새 필드

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points.map((e) => e.toJson()).toList(),
        'strokeWeight': strokeWeight,
        'strokeColor': strokeColor ?? '#3399ff',
        'strokeOpacity': strokeOpacity,
      };
}

/// 지도 옵션
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

/// HTML Builder
class KakaoMapHtmlBuilder {
  const KakaoMapHtmlBuilder();

  String build({
    required String apiKey,
    required KakaoMapLatLng center,
    required List<KakaoMapMarker> markers,
    List<KakaoMapPolyline> polylines = const [], // ← ★ 기본값 추가
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
    catch(e) { console.log('bridge error', e); }
  }

  window.kakaoBootstrap = function() {
    if (!window.kakao || !window.kakao.maps) {
      _post({type:'error',payload:{code:'sdkFail'}});
      return;
    }

    kakao.maps.load(function(){
      var p = $initJson;

      var container = document.getElementById('map');
      var center = new kakao.maps.LatLng(p.center.lat, p.center.lng);

      var map = new kakao.maps.Map(container, {
        center:center,
        level:p.options.level
      });

      window.kakaoMap = _wrap(map, p);
      _post({type:'ready',payload:{}});
    });
  };

  function _wrap(map, p) {
    var markers=[];
    var polylines=[];

    function syncMarkers(list){
      markers.forEach(m=>m.setMap(null));
      markers=[];
      list.forEach(m=>{
        var pos = new kakao.maps.LatLng(m.lat,m.lng);
        var mk = new kakao.maps.Marker({position:pos,title:m.title||''});
        mk.setMap(map);
        kakao.maps.event.addListener(mk,'click',function(){
          _post({type:'marker',payload:{id:m.id,lat:m.lat,lng:m.lng}});
        });
        markers.push(mk);
      });
    }

    function syncPolylines(list){
      polylines.forEach(pl=>pl.setMap(null));
      polylines=[];
      list.forEach(l=>{
        var path = l.points.map(pt=>new kakao.maps.LatLng(pt.lat,pt.lng));
        var pl = new kakao.maps.Polyline({
          path:path,
          strokeWeight:l.strokeWeight,
          strokeColor:l.strokeColor || '#3399ff',
          strokeOpacity:l.strokeOpacity,
          strokeStyle:'solid'
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
      clearMarkers: ()=>syncMarkers([]),
      clearPolylines: ()=>syncPolylines([]),
      moveTo: (lat,lng,lvl)=>{
        map.setCenter(new kakao.maps.LatLng(lat,lng));
        if (lvl!=null) map.setLevel(lvl);
      },
      animateTo:(lat,lng,lvl)=>{
        if (lvl!=null) map.setLevel(lvl);
        map.panTo(new kakao.maps.LatLng(lat,lng));
      },
      setMapType:(t)=>{
        map.setMapTypeId(t==='hybrid'||t==='skyview'
          ? kakao.maps.MapTypeId.HYBRID
          : kakao.maps.MapTypeId.ROADMAP
        );
        _post({type:'map_type',payload:{value:t}});
      },
      reloadMap:()=>{
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
