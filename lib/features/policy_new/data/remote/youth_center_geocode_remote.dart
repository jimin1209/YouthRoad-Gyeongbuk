import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../env/app_env.dart';

class GeocodePosition {
  final double lat;
  final double lng;

  const GeocodePosition({required this.lat, required this.lng});
}

class YouthCenterGeocodeRemote {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dapi.kakao.com/v2/local/search/address.json',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );

  YouthCenterGeocodeRemote() {
    // 디버깅 로그 추가: API 키가 제대로 설정되었는지 확인
    debugPrint('[GEOCODE] Using Kakao API Key: ${AppEnv.kakaoRestApiKey}');
    _dio.options.headers = {
      'Authorization': 'KakaoAK ${AppEnv.kakaoRestApiKey}',
    };
  }

  Future<GeocodePosition?> geocodeAddress(String address) async {
    try {
      if (address.isEmpty) {
        debugPrint('[GEOCODE] address empty → skip');
        return null;
      }

      // 디버깅 로그 추가: 실제 API 요청 URL과 쿼리 파라미터 확인
      debugPrint('[GEOCODE] Requesting geocode for address: $address');
      final res = await _dio.get('', queryParameters: {'query': address});

      // 응답 코드 확인
      if (res.statusCode != 200) {
        debugPrint('[GEOCODE] FAIL http=${res.statusCode} "$address"');
        debugPrint('[GEOCODE] Response: ${res.data}');
        return null;
      }

      final docs = res.data['documents'] as List<dynamic>;
      if (docs.isEmpty) {
        debugPrint('[GEOCODE] ZERO_RESULT "$address"');
        return null;
      }

      final first = docs.first;
      final lat = double.tryParse(first['y'] ?? '');
      final lng = double.tryParse(first['x'] ?? '');

      if (lat == null || lng == null) {
        debugPrint('[GEOCODE] PARSE_FAIL "$address"');
        return null;
      }

      debugPrint('[GEOCODE] OK ($lat, $lng) "$address"');
      return GeocodePosition(lat: lat, lng: lng);
    } catch (e, s) {
      // 에러 발생 시 추가적인 디버그 로그 출력
      debugPrint('[GEOCODE] ERROR "$address" → $e');
      debugPrint('[GEOCODE] Stack Trace: $s');
      return null;
    }
  }
}
