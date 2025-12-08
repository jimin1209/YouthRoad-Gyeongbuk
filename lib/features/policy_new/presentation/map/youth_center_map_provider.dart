// lib/features/policy_new/presentation/map/youth_center_map_provider.dart

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/di.dart' as app_di;
import '../../../../env/app_env.dart';
import '../../application/youthcenter_providers.dart';
import '../../data/mappers/youth_center_mapper.dart';
import '../../data/remote/youth_center_geocode_remote.dart';
import '../../domain/youthcenter/youth_center_entity.dart';

const double kCenterRangeKm = 40.0;

class CenterFetchRequest {
  const CenterFetchRequest({
    required this.lat,
    required this.lng,
    this.radiusKm = kCenterRangeKm,
  });

  final double lat;
  final double lng;
  final double radiusKm;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CenterFetchRequest &&
        other.lat == lat &&
        other.lng == lng &&
        other.radiusKm == radiusKm;
  }

  @override
  int get hashCode => Object.hash(lat, lng, radiusKm);
}

final youthCenterGeocodeRemoteProvider =
    Provider<YouthCenterGeocodeRemote>((ref) {
  return YouthCenterGeocodeRemote();
});

// ─────────────────────────────────────────────────────────────────────────────
// Youth Center Map Provider
// ─────────────────────────────────────────────────────────────────────────────
final youthCenterMapProvider = FutureProvider.autoDispose
    .family<List<CenterMarkerPoint>, CenterFetchRequest>((ref, request) async {
  debugPrint('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  debugPrint('[YCMAP] Provider START');
  debugPrint('[YCMAP] center=(${request.lat}, ${request.lng})');
  debugPrint('[YCMAP] radius=${request.radiusKm}km');

  final repo = ref.read(youthCenterRepositoryProvider);
  final geocoder = ref.read(youthCenterGeocodeRemoteProvider);
  final prefs = ref.read(app_di.sharedPreferencesProvider);

  // 앱 시작할 때 API 키가 잘 들어왔는지 체크
  debugPrint('[YCMAP] Kakao REST API KEY = ${geocoder.runtimeType} '
      '| env key: ${AppEnv.kakaoRestApiKey}');

  // ───────────────────────────────────────
  // 캐시 로드
  // ───────────────────────────────────────
  Map<String, dynamic> cache = {};
  List<CenterMarkerPoint> cachedMarkers = const [];
  try {
    final raw = prefs.getString('yc_center_geocode_cache_v1');
    if (raw != null) {
      cache = jsonDecode(raw);
      debugPrint('[YCMAP] Cache loaded: ${cache.length} entries');
    }

    final markerRaw = prefs.getString('yc_center_marker_cache_v1');
    if (markerRaw != null) {
      final decoded = jsonDecode(markerRaw) as List<dynamic>;
      cachedMarkers = decoded
          .map((e) => _markerFromJson(e as Map<String, dynamic>))
          .whereType<CenterMarkerPoint>()
          .toList();
      debugPrint('[YCMAP] Marker cache loaded: ${cachedMarkers.length} entries');
    }
  } catch (e) {
    debugPrint('[YCMAP] ⚠ Cache decode error → reset cache: $e');
    cache = {};
  }

  // ───────────────────────────────────────
  // 전체 센터 정보 조회
  // ───────────────────────────────────────
  List<YouthCenterEntity> items;
  try {
    items = await repo.getCentersV2(pageSize: 300);
  } catch (error) {
    debugPrint('[YCMAP] ❌ API 실패 → 마커 캐시 사용 시도: $error');
    if (cachedMarkers.isNotEmpty) {
      debugPrint('[YCMAP] 캐시된 마커 반환 (${cachedMarkers.length}개)');
      return cachedMarkers;
    }
    rethrow;
  }
  debugPrint('[YCMAP] API success, item count=${items.length}');

  final result = <CenterMarkerPoint>[];
  final candidates = <({CenterMarkerPoint point, double distance})>[];

  for (final center in items) {
    final addr = center.address.trim();
    final detail = (center.detailAddress ?? '').trim();

    // fullAddress 정규화 로그
    final fullAddress =
        detail.isNotEmpty ? '$addr $detail'.trim() : addr.trim();

    debugPrint('\n[YCMAP] ──────────────────────────────────────────');
    debugPrint('[YCMAP] CenterName = ${center.centerName}');
    debugPrint('[YCMAP] AddressRaw = "$addr"');
    debugPrint('[YCMAP] AddressDetail = "$detail"');
    debugPrint('[YCMAP] FullAddress = "$fullAddress"');

    final cacheKey = '${center.centerName}|$fullAddress';
    double? lat;
    double? lng;

    // ─────────────────────────────
    // 캐시 Hit
    // ─────────────────────────────
    if (cache.containsKey(cacheKey)) {
      final entry = cache[cacheKey];
      lat = entry?['lat']?.toDouble();
      lng = entry?['lng']?.toDouble();
      debugPrint('[YCMAP] Cache HIT -> ($lat, $lng)');
    } else {
      debugPrint('[YCMAP] Cache MISS → Geocode required');
    }

    // ─────────────────────────────
    // Geocode 호출
    // ─────────────────────────────
    if (lat == null || lng == null) {
      debugPrint('[YCMAP][Geocode] Calling geocode for "$fullAddress"...');

      final pos = await geocoder.geocodeAddress(fullAddress);

      if (pos == null) {
        debugPrint('[YCMAP][Geocode] ❌ FAIL geocoding "$fullAddress"');
        continue;
      }

      lat = pos.lat;
      lng = pos.lng;

      debugPrint('[YCMAP][Geocode] ✔ OK → ($lat, $lng)');

      cache[cacheKey] = {'lat': lat, 'lng': lng};
    }

    // 좌표 없으면 skip
    if (lat == null || lng == null) {
      debugPrint('[YCMAP] ❌ Skip: null lat/lng');
      continue;
    }

    // 거리 계산
    final dist = _distanceKm(request.lat, request.lng, lat, lng);
    debugPrint('[YCMAP] Distance = ${dist.toStringAsFixed(2)}km');

    final markerPoint = center.toMarkerPoint(lat: lat, lng: lng);

    candidates.add((point: markerPoint, distance: dist));

    if (dist <= request.radiusKm) {
      result.add(markerPoint);
      debugPrint('[YCMAP] ✔ Added to result');
    } else {
      debugPrint('[YCMAP] Skip: too far');
    }
  }

  if (result.isEmpty && candidates.isNotEmpty) {
    debugPrint('[YCMAP] 🔍 반경 내 결과 없음 → 가장 가까운 센터 3곳 노출');

    candidates.sort((a, b) => a.distance.compareTo(b.distance));
    final fallbackCenters = candidates.take(3).map((c) => c.point).toList();

    debugPrint('[YCMAP] fallback count=${fallbackCenters.length}');
    return fallbackCenters;
  }

  if (result.isEmpty && cachedMarkers.isNotEmpty) {
    debugPrint('[YCMAP] 새 결과 없음 → 캐시된 마커 사용 (${cachedMarkers.length}개)');
    return cachedMarkers;
  }

  // ─────────────────────────────────────────────
  // 캐시 저장
  // ─────────────────────────────────────────────
  try {
    await prefs.setString('yc_center_geocode_cache_v1', jsonEncode(cache));
    await prefs.setString(
      'yc_center_marker_cache_v1',
      jsonEncode(result.map(_markerToJson).toList()),
    );
    debugPrint('[YCMAP] Cache saved (geocode=${cache.length}, markers=${result.length})');
  } catch (e) {
    debugPrint('[YCMAP] ⚠ Cache save error: $e');
  }

  debugPrint('[YCMAP] DONE → Result Count = ${result.length}');
  debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  return result;
});

// 거리 계산
double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0;
  final dLat = _deg(lat2 - lat1);
  final dLon = _deg(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg(lat1)) * cos(_deg(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  return R * 2 * atan2(sqrt(a), sqrt(1 - a));
}

double _deg(double deg) => deg * (pi / 180.0);

CenterMarkerPoint? _markerFromJson(Map<String, dynamic> json) {
  try {
    return CenterMarkerPoint(
      id: json['id'] as String,
      name: json['name'] as String,
      rawAddress: json['rawAddress'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      fullAddress: json['fullAddress'] as String,
      phone: json['phone'] as String?,
      url: json['url'] as String?,
      regionLabel: json['regionLabel'] as String,
    );
  } catch (error) {
    debugPrint('[YCMAP] ⚠ Marker cache decode failed: $error');
    return null;
  }
}

Map<String, dynamic> _markerToJson(CenterMarkerPoint point) {
  return {
    'id': point.id,
    'name': point.name,
    'rawAddress': point.rawAddress,
    'lat': point.lat,
    'lng': point.lng,
    'fullAddress': point.fullAddress,
    'phone': point.phone,
    'url': point.url,
    'regionLabel': point.regionLabel,
  };
}
