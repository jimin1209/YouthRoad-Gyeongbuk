import 'package:dio/dio.dart';

import '../../models/inst_model.dart';
import '../../../core/constants/env.dart';

class InstRemoteSource {
  InstRemoteSource(this._dio, {String? apiKey})
      : _apiKey = apiKey ?? Env.youthApiKey;

  final Dio _dio;
  final String _apiKey;

  Future<List<InstModel>> fetchInstList({String? keyword}) async {
    if (_apiKey.isEmpty) {
      throw StateError('YOUTH_API_KEY is not provided');
    }

    final query = <String, dynamic>{'apiKey': _apiKey};
    if (keyword != null && keyword.isNotEmpty) {
      query['srchInstNm'] = keyword;
    }

    final response = await _dio.get(
      'https://gbyouth.co.kr/openapi/inst/list.json',
      queryParameters: query,
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw StateError('Invalid inst list response');
    }

    final resultList = data['resultList'];
    if (resultList is! List) {
      throw StateError('Missing resultList in inst response');
    }

    return resultList
        .map((item) => InstModel.fromJson((item as Map).cast<String, dynamic>()))
        .toList();
  }
}
