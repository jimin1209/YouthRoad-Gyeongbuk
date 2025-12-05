import 'package:dio/dio.dart';

import '../../../../core/constants/env.dart';
import '../../../domain/youthcenter/policy_search_query.dart';
import '../../dto/policy_youthcenter_dto.dart';

class YouthPolicyRemoteSource {
  YouthPolicyRemoteSource(
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

  Future<PolicyYouthcenterDto> fetchPolicies(PolicySearchQuery query) async {
    final parameters = <String, dynamic>{
      ...query.toQueryParameters(),
    };

    if (_apiKey.isNotEmpty) {
      parameters['apiKey'] = _apiKey;
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/policy.json',
      queryParameters: parameters,
    );

    final data = response.data;
    if (data == null) {
      throw StateError('정책 응답이 비어 있습니다.');
    }

    return PolicyYouthcenterDto.fromJson(data);
  }

  static String _normalizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }
}
