import 'package:dio/dio.dart';

import '../../domain/values/policy_failure.dart';
import '../models/department_model.dart';

class DepartmentRemoteSource {
  DepartmentRemoteSource(
    this._dio, {
    required this.apiKey,
    required this.baseUrl,
  });

  final Dio _dio;
  final String apiKey;
  final String baseUrl;

  Future<List<DepartmentModel>> fetchDepartments({
    required String instNo,
    String? keyword,
  }) async {
    final query = <String, dynamic>{'instNo': instNo};
    if (apiKey.isNotEmpty) {
      query['apiKey'] = apiKey;
    }
    if (keyword != null && keyword.isNotEmpty) {
      query['srchDeptNm'] = keyword;
    }

    try {
      final res = await _dio.get(
        '$baseUrl/dept/list.json',
        queryParameters: query,
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerFailure('부서 목록 응답이 올바르지 않습니다');
      }

      final resultList = data['resultList'];
      if (resultList is! List) {
        throw const ServerFailure('부서 목록을 찾을 수 없습니다');
      }

      return resultList
          .map(
            (e) => DepartmentModel.fromJson(
              (e as Map).cast<String, dynamic>(),
              instNo: instNo,
            ),
          )
          .toList();
    } on DioError {
      throw const NetworkFailure();
    } catch (e) {
      if (e is PolicyFailure) rethrow;
      throw const UnknownFailure();
    }
  }
}
