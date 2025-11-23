import 'package:dio/dio.dart';

import '../../../core/api/models/institution_model.dart';
import '../../../core/constants/env.dart';

class InstitutionRemoteSource {
  InstitutionRemoteSource(this._dio, {String? apiKey})
      : _apiKey = apiKey ?? Env.youthApiKey;

  final Dio _dio;
  final String _apiKey;

  Future<List<InstitutionModel>> fetchInstitutions({String? keyword}) async {
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
        .map((item) =>
            InstitutionModel.fromJson((item as Map).cast<String, dynamic>()))
        .toList();
  }
}
