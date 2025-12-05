import 'package:dio/dio.dart';

import '../../../../core/constants/env.dart';
import '../../dto/center_youthcenter_dto.dart';

class YouthCenterRemoteSource {
  YouthCenterRemoteSource(
    this._dio, {
    String? apiKey,
    String? baseUrl,
  })  : _apiKey = apiKey ?? Env.youthApiKey,
        _baseUrl = _normalizeBaseUrl(
          baseUrl ?? 'https://www.youthcenter.go.kr/openapi',
        );

  final Dio _dio;
  final String _apiKey;
  final String _baseUrl;

  Future<CenterYouthcenterDto> fetchCenters({CancelToken? cancelToken}) async {
    final parameters = <String, dynamic>{};

    if (_apiKey.isNotEmpty) {
      parameters['apiKey'] = _apiKey;
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/center.json',
      queryParameters: parameters,
      cancelToken: cancelToken,
    );

    final data = response.data;
    if (data == null) {
      throw StateError('센터 응답이 비어 있습니다.');
    }

    return CenterYouthcenterDto.fromJson(data);
  }

  static String _normalizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }
}
