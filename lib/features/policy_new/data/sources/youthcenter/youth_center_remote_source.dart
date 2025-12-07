import 'package:dio/dio.dart';

import 'package:youth_road_app/core/constants/env.dart';
import 'package:youth_road_app/env/app_env.dart';
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

  Future<CenterYouthcenterDto> fetchCentersV2({
    String? ctpvCd,
    String? sggCd,
    int pageNum = 1,
    int pageSize = 300,
    CancelToken? cancelToken,
  }) async {
    final params = <String, dynamic>{
      'apiKeyNm': AppEnv.youthCenterApiKey,
      'rtnType': 'json',
      'pageNum': pageNum,
      'pageSize': pageSize,
      if (ctpvCd != null) 'ctpvCd': ctpvCd,
      if (sggCd != null) 'sggCd': sggCd,
    };

    final response = await _dio.get<Map<String, dynamic>>(
      'https://www.youthcenter.go.kr/go/ythip/getSpace',
      queryParameters: params,
      cancelToken: cancelToken,
    );

    final data = response.data;
    final dto = data != null ? CenterYouthcenterDto.fromJson(data) : null;
    final list = dto?.result?.youthPolicyList;
    if (dto == null || list == null || list.isEmpty) {
      throw StateError('청년센터 데이터를 가져오지 못했습니다.');
    }
    return dto;
  }

  static String _normalizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }
}
