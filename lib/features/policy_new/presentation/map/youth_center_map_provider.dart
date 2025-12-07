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
  try {
    final raw = prefs.getString('yc_center_geocode_cache_v1');
    if (raw != null) {
      cache = jsonDecode(raw);
      debugPrint('[YCMAP] Cache loaded: ${cache.length} entries');
    }
  } catch (e) {
    debugPrint('[YCMAP] ⚠ Cache decode error → reset cache: $e');
    cache = {};
  }

  // ───────────────────────────────────────
  // 전체 센터 정보 조회
  // ───────────────────────────────────────
  final items = await repo.getCentersV2(pageSize: 300);
  debugPrint('[YCMAP] API success, item count=${items.length}');

  final result = <CenterMarkerPoint>[];

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

    if (dist <= request.radiusKm) {
      result.add(center.toMarkerPoint(lat: lat, lng: lng));
      debugPrint('[YCMAP] ✔ Added to result');
    } else {
      debugPrint('[YCMAP] Skip: too far');
    }
  }

  // ─────────────────────────────────────────────
  // 캐시 저장
  // ─────────────────────────────────────────────
  try {
    await prefs.setString('yc_center_geocode_cache_v1', jsonEncode(cache));
    debugPrint('[YCMAP] Cache saved (${cache.length} entries)');
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
