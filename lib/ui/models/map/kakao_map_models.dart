import 'dart:convert';

enum KakaoMapEventType {
  sdkLoading,
  sdkLoaded,
  sdkFailed,
  ready,
  markerClick,
  regionClick,
  clusterClick,
  log,
  error,
}

enum KakaoMapLogLevel { info, warn, error }

enum KakaoMapMapType { roadmap, skyview, hybrid, terrain }

class KakaoMapLatLng {
  const KakaoMapLatLng({required this.lat, required this.lng});

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  factory KakaoMapLatLng.fromJson(Map<String, dynamic> json) {
    return KakaoMapLatLng(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}

class KakaoMapBounds {
  const KakaoMapBounds({required this.southWest, required this.northEast});

  final KakaoMapLatLng southWest;
  final KakaoMapLatLng northEast;

  Map<String, dynamic> toJson() => {
        'southWest': southWest.toJson(),
        'northEast': northEast.toJson(),
      };
}

class KakaoMapMarker {
  const KakaoMapMarker({
    required this.id,
    required this.title,
    required this.position,
    this.description,
    this.imageUrl,
  });

  final String id;
  final String title;
  final KakaoMapLatLng position;
  final String? description;
  final String? imageUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'lat': position.lat,
        'lng': position.lng,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };
}

class KakaoMapPolyline {
  const KakaoMapPolyline({
    required this.id,
    required this.points,
    this.strokeColor = '#3366FF',
    this.strokeWeight = 3,
    this.strokeOpacity = 0.7,
  });

  final String id;
  final List<KakaoMapLatLng> points;
  final String strokeColor;
  final int strokeWeight;
  final double strokeOpacity;

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points.map((e) => e.toJson()).toList(),
        'strokeColor': strokeColor,
        'strokeWeight': strokeWeight,
        'strokeOpacity': strokeOpacity,
      };
}

class KakaoMapEvent {
  KakaoMapEvent({
    required this.type,
    required this.payload,
    required this.timestamp,
    required this.level,
    required this.source,
  });

  final KakaoMapEventType type;
  final Map<String, dynamic> payload;
  final int timestamp;
  final KakaoMapLogLevel level;
  final String source;

  factory KakaoMapEvent.fromJsonString(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return KakaoMapEvent(
      type: _typeFromString(decoded['type'] as String?),
      payload: (decoded['payload'] as Map?)?.cast<String, dynamic>() ?? const {},
      timestamp: (decoded['timestamp'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      level: _levelFromString(decoded['level'] as String?),
      source: decoded['source'] as String? ?? 'kakaomap-js',
    );
  }

  static KakaoMapEventType _typeFromString(String? value) {
    switch (value) {
      case 'sdk_loading':
        return KakaoMapEventType.sdkLoading;
      case 'sdk_loaded':
        return KakaoMapEventType.sdkLoaded;
      case 'sdk_failed':
        return KakaoMapEventType.sdkFailed;
      case 'ready':
        return KakaoMapEventType.ready;
      case 'marker_click':
        return KakaoMapEventType.markerClick;
      case 'region_click':
        return KakaoMapEventType.regionClick;
      case 'cluster_click':
        return KakaoMapEventType.clusterClick;
      case 'error':
        return KakaoMapEventType.error;
      case 'log':
      default:
        return KakaoMapEventType.log;
    }
  }

  static KakaoMapLogLevel _levelFromString(String? value) {
    switch (value) {
      case 'warn':
        return KakaoMapLogLevel.warn;
      case 'error':
        return KakaoMapLogLevel.error;
      case 'info':
      default:
        return KakaoMapLogLevel.info;
    }
  }
}

class KakaoMapCommandResult {
  const KakaoMapCommandResult({required this.success, this.message});

  final bool success;
  final String? message;
}
