import 'kakao_map_models.dart';

class KakaoMapOptions {
  const KakaoMapOptions({
    required this.center,
    this.level = 6,
    this.mapType = KakaoMapMapType.roadmap,
    this.markers = const [],
    this.polylines = const [],
    this.enableCluster = false,
  });

  final KakaoMapLatLng center;
  final int level;
  final KakaoMapMapType mapType;
  final List<KakaoMapMarker> markers;
  final List<KakaoMapPolyline> polylines;
  final bool enableCluster;

  KakaoMapOptions copyWith({
    KakaoMapLatLng? center,
    int? level,
    KakaoMapMapType? mapType,
    List<KakaoMapMarker>? markers,
    List<KakaoMapPolyline>? polylines,
    bool? enableCluster,
  }) {
    return KakaoMapOptions(
      center: center ?? this.center,
      level: level ?? this.level,
      mapType: mapType ?? this.mapType,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      enableCluster: enableCluster ?? this.enableCluster,
    );
  }

  Map<String, dynamic> toJson() => {
        'center': center.toJson(),
        'level': level,
        'mapType': mapType.name,
        'markers': markers.map((e) => e.toJson()).toList(),
        'polylines': polylines.map((e) => e.toJson()).toList(),
        'enableCluster': enableCluster,
      };
}
