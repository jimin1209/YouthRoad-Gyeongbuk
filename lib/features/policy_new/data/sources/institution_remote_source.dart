import 'package:dio/dio.dart';

import '../../domain/values/policy_failure.dart';
import '../models/institution_model.dart';

class InstitutionRemoteSource {
  InstitutionRemoteSource(
    this._dio, {
    required this.apiKey,
    required this.baseUrl,
  });

  final Dio _dio;
  final String apiKey;
  final String baseUrl;

  Future<List<InstitutionModel>> fetchInstitutions({String? keyword}) async {
    final query = <String, dynamic>{};
    if (apiKey.isNotEmpty) {
      query['apiKey'] = apiKey;
    }
    if (keyword != null && keyword.isNotEmpty) {
      query['srchInstNm'] = keyword;
    }

    try {
      final res = await _dio.get(
        '$baseUrl/inst/list.json',
        queryParameters: query,
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerFailure('기관 목록 응답이 올바르지 않습니다');
      }

      final resultList = data['resultList'];
      if (resultList is! List) {
        throw const ServerFailure('기관 목록을 찾을 수 없습니다');
      }

      return resultList
          .map((e) => InstitutionModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } on DioError {
      throw const NetworkFailure();
    } catch (e) {
      if (e is PolicyFailure) rethrow;
      throw const UnknownFailure();
    }
  }
}
