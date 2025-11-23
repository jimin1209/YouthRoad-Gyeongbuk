import 'package:dio/dio.dart';

import '../../models/dept_model.dart';

class DeptRemoteSource {
  DeptRemoteSource(this._dio, {String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('YOUTH_API_KEY');

  final Dio _dio;
  final String _apiKey;

  Future<List<DeptModel>> fetchDeptList({
    required String instNo,
    String? keyword,
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError('YOUTH_API_KEY is not provided');
    }

    if (instNo.isEmpty) {
      throw ArgumentError('instNo is required');
    }

    final query = <String, dynamic>{
      'apiKey': _apiKey,
      'instNo': instNo,
    };
    if (keyword != null && keyword.isNotEmpty) {
      query['srchDeptNm'] = keyword;
    }

    final response = await _dio.get(
      'https://gbyouth.co.kr/openapi/dept/list.json',
      queryParameters: query,
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw StateError('Invalid dept list response');
    }

    final resultList = data['resultList'];
    if (resultList is! List) {
      throw StateError('Missing resultList in dept response');
    }

    return resultList
        .map((item) =>
            DeptModel.fromJson((item as Map).cast<String, dynamic>(), instNo: instNo))
        .toList();
  }
}
