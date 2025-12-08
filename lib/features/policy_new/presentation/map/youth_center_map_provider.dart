// lib/features/policy_new/presentation/map/youth_center_map_provider.dart

import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/di.dart' as app_di;
import '../../../../env/app_env.dart';
import '../../application/youthcenter_providers.dart';
import '../../data/mappers/youth_center_mapper.dart';
import '../../domain/youthcenter/youth_center_entity.dart';

const double kCenterRangeKm = 20.0;

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
  final prefs = ref.read(app_di.sharedPreferencesProvider);

  // 앱 시작할 때 API 키가 잘 들어왔는지 체크
  debugPrint('[YCMAP] Kakao REST API KEY length=${AppEnv.kakaoRestApiKey.length}');

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
  final centersWithDistance = <_CenterDistance>[];

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
    double? lat = center.lat;
    double? lng = center.lng;

    if (lat == null || lng == null) {
      final cached = cache[cacheKey];
      if (cached is Map<String, dynamic>) {
        final cachedLat = _toDouble(cached['lat']);
        final cachedLng = _toDouble(cached['lng']);
        if (cachedLat != null && cachedLng != null) {
          lat = cachedLat;
          lng = cachedLng;
          debugPrint(
            '[YCMAP] 📦 Cache hit: lat=$lat, lng=$lng (key=$cacheKey)',
          );
        }
      }
    }

    if (lat == null || lng == null) {
      final geocodeResult =
          await _geocodeWithKakao(fullAddress, cacheKey, cache);
      if (geocodeResult != null) {
        lat = geocodeResult['lat'];
        lng = geocodeResult['lng'];
      }
    }

    // 좌표 없으면 skip
    if (lat == null || lng == null) {
      debugPrint(
        '[YCMAP] ❌ Skip: null lat/lng (no cache & no geocode)',
      );
      continue;
    }

    if (lat == 0 || lng == 0 || lat.isNaN || lng.isNaN) {
      debugPrint('[YCMAP] ❌ Skip: 좌표가 0,0 또는 NaN 입니다');
      continue;
    }

    cache[cacheKey] = {'lat': lat, 'lng': lng};
    final markerPoint = center.toMarkerPoint(lat: lat, lng: lng);
    final dist = _distanceKm(request.lat, request.lng, lat, lng);
    debugPrint('[YCMAP] Distance = ${dist.toStringAsFixed(2)}km');

    centersWithDistance.add(
      _CenterDistance(point: markerPoint, distanceKm: dist),
    );

    if (dist > request.radiusKm) {
      debugPrint('[YCMAP] Skip: too far');
      continue;
    }

    result.add(markerPoint);
    debugPrint('[YCMAP] ✔ Added to result (within radius)');
  }

  if (result.isEmpty && centersWithDistance.isNotEmpty) {
    final ordered = [...centersWithDistance]
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    final fallbackCandidates = ordered.take(3).toList();

    debugPrint(
      '[YCMAP] No center within ${request.radiusKm}km → fallback to nearest 3 centers',
    );
    for (final candidate in fallbackCandidates) {
      final point = candidate.point;
      debugPrint(
        '[YCMAP] Fallback center: ${point.name} (dist=${candidate.distanceKm.toStringAsFixed(2)}km, lat=${point.lat}, lng=${point.lng})',
      );
      result.add(point);
    }
  }

  // ─────────────────────────────────────────────
  // 캐시 저장 (마커 + 지오코드)
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

Future<Map<String, double>?> _geocodeWithKakao(
  String fullAddress,
  String cacheKey,
  Map<String, dynamic> cache,
) async {
  final apiKey = AppEnv.kakaoRestApiKey;
  if (apiKey.isEmpty) {
    debugPrint('[YCMAP] ⚠ Geocode skipped: Kakao REST API KEY is empty');
    return null;
  }

  final dio = Dio(BaseOptions(baseUrl: 'https://dapi.kakao.com'));
  debugPrint('[YCMAP] 🔍 Geocode request: "$fullAddress" (key=$cacheKey)');

  try {
    final response = await dio.get(
      '/v2/local/search/address.json',
      queryParameters: {'query': fullAddress},
      options: Options(
        headers: {
          'Authorization': 'KakaoAK $apiKey',
        },
      ),
    );

    final documents = response.data?['documents'];
    if (documents is List && documents.isNotEmpty) {
      final firstDocument = documents.first;
      if (firstDocument is Map<String, dynamic>) {
        final lat = _toDouble(firstDocument['y']);
        final lng = _toDouble(firstDocument['x']);
        if (lat != null && lng != null) {
          cache[cacheKey] = {'lat': lat, 'lng': lng};
          debugPrint(
            '[YCMAP] ✅ Geocode success & cached: lat=$lat, lng=$lng',
          );
          return {'lat': lat, 'lng': lng};
        }
      }
    }
    debugPrint('[YCMAP] ⚠ Geocode no result for "$fullAddress"');
  } catch (error) {
    debugPrint('[YCMAP] ❌ Geocode error: $error');
  }
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

class _CenterDistance {
  const _CenterDistance({
    required this.point,
    required this.distanceKm,
  });

  final CenterMarkerPoint point;
  final double distanceKm;
}

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
