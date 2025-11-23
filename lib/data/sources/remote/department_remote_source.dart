import 'package:dio/dio.dart';

import '../../../core/api/models/department_model.dart';

class DepartmentRemoteSource {
  DepartmentRemoteSource(this._dio, {String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('YOUTH_API_KEY');

  final Dio _dio;
  final String _apiKey;

  Future<List<DepartmentModel>> fetchDepartments({
    required String instId,
    String? keyword,
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError('YOUTH_API_KEY is not provided');
    }

    if (instId.isEmpty) {
      throw ArgumentError('instId is required');
    }

    final query = <String, dynamic>{
      'apiKey': _apiKey,
      'instNo': instId,
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
            DepartmentModel.fromJson((item as Map).cast<String, dynamic>()))
        .toList();
  }
}
