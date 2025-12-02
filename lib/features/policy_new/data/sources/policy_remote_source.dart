import 'package:dio/dio.dart';

import '../../domain/values/policy_failure.dart';
import '../models/policy_model.dart';

class PolicyRemoteSource {
  final Dio _dio;

  PolicyRemoteSource(this._dio);

  /// 기존 job01용 단순 페이지 조회 (하위 호환 유지)
  Future<List<PolicyModel>> fetchPolicies(int page, int pageSize) async {
    final params = <String, dynamic>{
      'page': page,
      'size': pageSize,
    };
    return fetchPoliciesWithParams(params);
  }

  /// job03에서 추가: QueryParameter 기반 페이지 조회
  Future<List<PolicyModel>> fetchPoliciesWithParams(
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final res = await _dio.get(
        '/policies',
        queryParameters: queryParameters,
      );

      final List data = (res.data['policies'] ?? []) as List;
      return data
          .map((e) => PolicyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioError {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<PolicyModel> fetchPolicyDetail(String id) async {
    try {
      final res = await _dio.get('/policies/$id');
      return PolicyModel.fromJson(res.data as Map<String, dynamic>);
    } on DioError {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
