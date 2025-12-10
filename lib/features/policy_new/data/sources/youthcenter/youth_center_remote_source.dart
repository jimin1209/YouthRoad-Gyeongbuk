import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:youth_road_app/core/constants/env.dart';
import 'package:youth_road_app/env/app_env.dart';
import '../../dto/center_youthcenter_dto.dart';

class YouthCenterApiException implements Exception {
  YouthCenterApiException({
    required this.userMessage,
    this.statusCode,
    this.reason,
  });

  final String userMessage;
  final int? statusCode;
  final String? reason;

  @override
  String toString() => reason ?? userMessage;
}

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

    final url = '$_baseUrl/center.json';
    _logRequest(
      'GET',
      url,
      query: parameters,
      maskedApiKey: _mask(_apiKey),
      extraHeaders: _dio.options.headers,
    );

    final response = await _safeRequest(
      () => _dio.get<Map<String, dynamic>>(
        url,
        queryParameters: parameters,
        cancelToken: cancelToken,
      ),
      fallbackMessage: '청년센터 데이터를 불러오지 못했습니다.',
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

    const url = 'https://www.youthcenter.go.kr/go/ythip/getSpace';
    _logRequest(
      'GET',
      url,
      query: params,
      maskedApiKey: _mask(AppEnv.youthCenterApiKey),
      extraHeaders: _dio.options.headers,
    );

    final response = await _safeRequest(
      () => _dio.get<Map<String, dynamic>>(
        url,
        queryParameters: params,
        cancelToken: cancelToken,
      ),
      fallbackMessage: '청년센터 데이터를 불러오지 못했습니다.',
    );

    final data = response.data;
    final dto = data != null ? CenterYouthcenterDto.fromJson(data) : null;
    final list = dto?.result?.youthPolicyList;
    if (dto == null || list == null || list.isEmpty) {
      throw StateError('청년센터 데이터를 가져오지 못했습니다.');
    }
    return dto;
  }

  Future<Response<T>> _safeRequest<T>(
    Future<Response<T>> Function() runRequest, {
    required String fallbackMessage,
  }) async {
    try {
      final response = await runRequest();
      _logResponse(response);
      return response;
    } on DioException catch (e, stack) {
      _logDioError(e, stack);
      final status = e.response?.statusCode;
      final reason = e.response?.statusMessage ?? e.message;
      throw YouthCenterApiException(
        userMessage: fallbackMessage,
        statusCode: status,
        reason: reason,
      );
    }
  }

  void _logRequest(
    String method,
    String url, {
    Map<String, dynamic>? query,
    String? maskedApiKey,
    Map<String, dynamic>? extraHeaders,
  }) {
    if (!kDebugMode) return;
    debugPrint('[YOUTH_CENTER_API][REQ] $method $url');
    debugPrint('[YOUTH_CENTER_API][REQ] query=$query');
    if (maskedApiKey != null) {
      debugPrint('[YOUTH_CENTER_API][REQ] apiKey(masked)=$maskedApiKey');
    }
    if (extraHeaders != null && extraHeaders.isNotEmpty) {
      debugPrint('[YOUTH_CENTER_API][REQ] headers=$extraHeaders');
    }
  }

  void _logResponse(Response response) {
    if (!kDebugMode) return;
    debugPrint(
      '[YOUTH_CENTER_API][RES] status=${response.statusCode} uri=${response.requestOptions.uri}',
    );
  }

  void _logDioError(DioException e, StackTrace stack) {
    if (!kDebugMode) return;
    final request = e.requestOptions;
    debugPrint('[YOUTH_CENTER_API][ERR] url=${request.uri}');
    debugPrint('[YOUTH_CENTER_API][ERR] method=${request.method}');
    debugPrint('[YOUTH_CENTER_API][ERR] headers=${request.headers}');
    debugPrint('[YOUTH_CENTER_API][ERR] query=${request.queryParameters}');
    debugPrint('[YOUTH_CENTER_API][ERR] status=${e.response?.statusCode}');
    debugPrint('[YOUTH_CENTER_API][ERR] body=${e.response?.data}');
    debugPrint('[YOUTH_CENTER_API][ERR] stack=$stack');
  }

  String _mask(String value) {
    if (value.isEmpty) return '<empty>';
    if (value.length <= 6) return '${value[0]}***${value[value.length - 1]}';
    final prefix = value.substring(0, 3);
    final suffix = value.substring(value.length - 3);
    return '$prefix***$suffix(len:${value.length})';
  }

  static String _normalizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }
}
