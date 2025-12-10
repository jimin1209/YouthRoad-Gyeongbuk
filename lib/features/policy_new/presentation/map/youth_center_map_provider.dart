// lib/features/policy_new/presentation/map/youth_center_map_provider.dart

import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/di.dart' as app_di;
import '../../../../env/app_env.dart';
import '../../../map_v2/kakao_map_html_builder.dart';
import '../../application/youthcenter_providers.dart';
import '../../data/mappers/youth_center_mapper.dart';
import '../../data/sources/youthcenter/youth_center_remote_source.dart';
import '../../domain/youthcenter/youth_center_entity.dart';

const double kCenterRangeKm = 20.0;

enum YouthCenterMapStatus { initial, loading, loaded, empty, error }

class YouthCenterMapState {
  const YouthCenterMapState({
    required this.allCenters,
    required this.filteredCenters,
    required this.radiusKm,
    this.center,
    this.isLoading = false,
    this.errorMessage,
    this.status = YouthCenterMapStatus.initial,
  });

  final List<CenterMarkerPoint> allCenters;
  final List<CenterMarkerPoint> filteredCenters;
  final KakaoMapLatLng? center;
  final double radiusKm;
  final bool isLoading;
  final String? errorMessage;
  final YouthCenterMapStatus status;

  YouthCenterMapState copyWith({
    List<CenterMarkerPoint>? allCenters,
    List<CenterMarkerPoint>? filteredCenters,
    KakaoMapLatLng? center,
    double? radiusKm,
    bool? isLoading,
    String? errorMessage,
    YouthCenterMapStatus? status,
  }) {
    return YouthCenterMapState(
      allCenters: allCenters ?? this.allCenters,
      filteredCenters: filteredCenters ?? this.filteredCenters,
      center: center ?? this.center,
      radiusKm: radiusKm ?? this.radiusKm,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  static YouthCenterMapState initial() => const YouthCenterMapState(
        allCenters: [],
        filteredCenters: [],
        radiusKm: kCenterRangeKm,
        center: null,
        isLoading: false,
        status: YouthCenterMapStatus.initial,
      );
}

final youthCenterMapStateProvider =
    StateNotifierProvider<YouthCenterMapNotifier, YouthCenterMapState>(
  (ref) => YouthCenterMapNotifier(ref),
);

class YouthCenterMapNotifier extends StateNotifier<YouthCenterMapState> {
  YouthCenterMapNotifier(this._ref) : super(YouthCenterMapState.initial());

  final Ref _ref;

  Future<void> loadCenters({
    required KakaoMapLatLng center,
    double radiusKm = kCenterRangeKm,
  }) async {
    state = state.copyWith(
      isLoading: true,
      center: center,
      radiusKm: radiusKm,
      errorMessage: null,
      status: YouthCenterMapStatus.loading,
    );

    try {
      debugPrint('[YCMAP] 요청 시작 → center=(${center.lat}, ${center.lng}), '
          'radiusKm=$radiusKm');
      debugPrint('[Center][Auth] 센터 목록 API 요청 시작');
      final markers = await _fetchAllCenterMarkers(center);
      final filtered = filterCentersWithinRadius(markers, center, radiusKm);
      final status = filtered.isEmpty
          ? YouthCenterMapStatus.empty
          : YouthCenterMapStatus.loaded;
      state = state.copyWith(
        allCenters: markers,
        filteredCenters: filtered,
        isLoading: false,
        center: center,
        radiusKm: radiusKm,
        errorMessage: null,
        status: status,
      );
    } catch (error, stack) {
      debugPrint('[YCMAP] loadCenters failed: $error');
      if (kDebugMode) {
        debugPrint(stack.toString());
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: _buildUserMessage(error),
        status: YouthCenterMapStatus.error,
      );
    }
  }

  Future<void> retryLast() async {
    final center = state.center;
    if (center == null) return;
    await loadCenters(center: center, radiusKm: state.radiusKm);
  }

  void updateCenter(KakaoMapLatLng center, {double? radiusKm}) {
    final effectiveRadius = radiusKm ?? state.radiusKm;
    final filtered =
        filterCentersWithinRadius(state.allCenters, center, effectiveRadius);
    state = state.copyWith(
      center: center,
      radiusKm: effectiveRadius,
      filteredCenters: filtered,
      errorMessage: null,
      status: filtered.isEmpty
          ? YouthCenterMapStatus.empty
          : YouthCenterMapStatus.loaded,
    );
  }

  Future<List<CenterMarkerPoint>> _fetchAllCenterMarkers(
    KakaoMapLatLng center,
  ) async {
    debugPrint('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('[YCMAP] Provider START');
    debugPrint('[YCMAP] center=(${center.lat}, ${center.lng})');
    debugPrint('[YCMAP] radius=${state.radiusKm}km');

    final repo = _ref.read(youthCenterRepositoryProvider);
    final prefs = _ref.read(app_di.sharedPreferencesProvider);

    debugPrint(
      '[YCMAP] Kakao REST API KEY length=${AppEnv.kakaoRestApiKey.length}',
    );

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

    List<YouthCenterEntity> items;
    try {
      items = await repo.getCentersV2(pageSize: 300);
      debugPrint('[Center][Auth] 센터 목록 API 응답 성공 count=${items.length}');
    } catch (error) {
      debugPrint('[YCMAP] ❌ API 실패 → 마커 캐시 사용 시도: $error');
      debugPrint('[Center][Auth] 센터 목록 API 실패: $error');
      if (cachedMarkers.isNotEmpty) {
        debugPrint('[YCMAP] 캐시된 마커 반환 (${cachedMarkers.length}개)');
        return cachedMarkers;
      }
      rethrow;
    }
    debugPrint('[YCMAP] API success, item count=${items.length}');

    final result = <CenterMarkerPoint>[];

    for (final centerEntity in items) {
      final addr = centerEntity.address.trim();
      final detail = (centerEntity.detailAddress ?? '').trim();
      final fullAddress = detail.isNotEmpty ? '$addr $detail'.trim() : addr;

      debugPrint('\n[YCMAP] ──────────────────────────────────────────');
      debugPrint('[YCMAP] CenterName = ${centerEntity.centerName}');
      debugPrint('[YCMAP] AddressRaw = "$addr"');
      debugPrint('[YCMAP] AddressDetail = "$detail"');
      debugPrint('[YCMAP] FullAddress = "$fullAddress"');

      final cacheKey = '${centerEntity.centerName}|$fullAddress';
      double? lat = centerEntity.lat;
      double? lng = centerEntity.lng;

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
      final markerPoint = centerEntity.toMarkerPoint(lat: lat, lng: lng);
      result.add(markerPoint);
      debugPrint('[YCMAP] ✔ Marker prepared');
    }

    try {
      await prefs.setString('yc_center_geocode_cache_v1', jsonEncode(cache));
      await prefs.setString(
        'yc_center_marker_cache_v1',
        jsonEncode(result.map(_markerToJson).toList()),
      );
      debugPrint(
        '[YCMAP] Cache saved (geocode=${cache.length}, markers=${result.length})',
      );
    } catch (e) {
      debugPrint('[YCMAP] ⚠ Cache save error: $e');
    }

    debugPrint('[YCMAP] DONE → Result Count = ${result.length}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    return result;
  }

  String _buildUserMessage(Object error) {
    const fallback = '센터 정보를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.';

    if (error is YouthCenterApiException) {
      if (error.statusCode == 403 || error.statusCode == 401) {
        debugPrint(
          '[Center][Auth] 인증 오류 status=${error.statusCode}, message=${error.userMessage}',
        );
        return '센터 인증 정보가 올바르지 않습니다. 잠시 후 다시 시도해주세요.';
      }
      if (!kDebugMode) return error.userMessage;
      final code = error.statusCode != null ? ' (status: ${error.statusCode})' : '';
      return '${error.userMessage}$code';
    }

    if (error is DioException) {
      final status = error.response?.statusCode;
      if (!kDebugMode) return fallback;
      return '요청 실패 (status: $status, message: ${error.message})';
    }

    return fallback;
  }
}

List<CenterMarkerPoint> filterCentersWithinRadius(
  List<CenterMarkerPoint> all,
  KakaoMapLatLng center,
  double radiusKm,
) {
  if (all.isEmpty) return const [];
  final radiusMeters = radiusKm * 1000;
  final filtered = all
      .where(
        (point) =>
            distanceInMeters(
              center,
              KakaoMapLatLng(point.lat, point.lng),
            ) <=
            radiusMeters,
      )
      .toList();

  debugPrint('[Map][INFO] filterCentersWithinRadius(before: ${all.length}, '
      'after: ${filtered.length})');

  return filtered;
}

double distanceInMeters(KakaoMapLatLng a, KakaoMapLatLng b) {
  const earthRadius = 6371000.0;
  final dLat = _deg(b.lat - a.lat);
  final dLon = _deg(b.lng - a.lng);
  final lat1 = _deg(a.lat);
  final lat2 = _deg(b.lat);

  final sinLat = sin(dLat / 2);
  final sinLon = sin(dLon / 2);
  final aHarv = sinLat * sinLat + cos(lat1) * cos(lat2) * sinLon * sinLon;
  final c = 2 * atan2(sqrt(aHarv), sqrt(1 - aHarv));
  return earthRadius * c;
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
  debugPrint('[YCMAP][HTTP] GET /v2/local/search/address.json');
  debugPrint('[YCMAP][HTTP] headers={Authorization: KakaoAK $apiKey}');
  debugPrint('[YCMAP][HTTP] query={query: $fullAddress}');

  try {
    final response = await dio.get(
      '/v2/local/search/address.json',
      queryParameters: {'query': fullAddress},
      options: Options(headers: {'Authorization': 'KakaoAK $apiKey'}),
    );

    final docs = response.data['documents'] as List<dynamic>?;
    if (docs == null || docs.isEmpty) {
      debugPrint('[YCMAP] ⚠ Geocode response empty for "$fullAddress"');
      return null;
    }

    final doc = docs.first as Map<String, dynamic>;
    final lat = _toDouble(doc['y']);
    final lng = _toDouble(doc['x']);
    debugPrint('[YCMAP] ✔ Geocode success: lat=$lat, lng=$lng');

    if (lat == null || lng == null) return null;

    cache[cacheKey] = {'lat': lat, 'lng': lng};

    return {'lat': lat, 'lng': lng};
  } on DioException catch (e, stack) {
    debugPrint('[YCMAP] ❌ Geocode DioException: ${e.message}');
    final request = e.requestOptions;
    debugPrint('[YCMAP][ERR] url=${request.uri}');
    debugPrint('[YCMAP][ERR] method=${request.method}');
    debugPrint('[YCMAP][ERR] headers=${request.headers}');
    debugPrint('[YCMAP][ERR] query=${request.queryParameters}');
    debugPrint('[YCMAP][ERR] status=${e.response?.statusCode}');
    debugPrint('[YCMAP][ERR] body=${e.response?.data}');
    if (kDebugMode) debugPrint(stack.toString());
    return null;
  } catch (e) {
    debugPrint('[YCMAP] ❌ Geocode error: $e');
    return null;
  }
}

CenterMarkerPoint _markerFromJson(Map<String, dynamic> json) {
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
}

Map<String, dynamic> _markerToJson(CenterMarkerPoint marker) {
  return {
    'id': marker.id,
    'name': marker.name,
    'rawAddress': marker.rawAddress,
    'lat': marker.lat,
    'lng': marker.lng,
    'fullAddress': marker.fullAddress,
    'phone': marker.phone,
    'url': marker.url,
    'regionLabel': marker.regionLabel,
  };
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
