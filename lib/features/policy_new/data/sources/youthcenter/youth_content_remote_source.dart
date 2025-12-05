import 'package:dio/dio.dart';

import '../../../../core/constants/env.dart';
import '../../dto/content_youthcenter_dto.dart';

class YouthContentRemoteSource {
  YouthContentRemoteSource(
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

  Future<ContentYouthcenterDto> fetchContents({int page = 1}) async {
    final parameters = <String, dynamic>{
      'pageNum': page,
      'pageSize': 10,
    };

    if (_apiKey.isNotEmpty) {
      parameters['apiKey'] = _apiKey;
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/content.json',
      queryParameters: parameters,
    );

    final data = response.data;
    if (data == null) {
      throw StateError('콘텐츠 응답이 비어 있습니다.');
    }

    return ContentYouthcenterDto.fromJson(data);
  }

  static String _normalizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }
}
