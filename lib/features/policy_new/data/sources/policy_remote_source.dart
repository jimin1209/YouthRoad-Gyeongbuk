import 'package:dio/dio.dart';

import '../../domain/values/policy_failure.dart';
import '../../domain/values/policy_query.dart';
import '../models/policy_model.dart';

class PolicyRemoteSource {
  final Dio _dio;

  PolicyRemoteSource(this._dio);

  Future<List<PolicyModel>> fetchPolicies({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    try {
      final res = await _dio.get('/policies', queryParameters: {
        'page': page,
        'size': pageSize,
        'keyword': query.keyword,
        'tags': query.tags.join(','),
        'feedType': query.feedType.name,
        'region': query.filter.region.name,
        'sort': query.sort.name,
      });

      final List data = res.data['policies'] ?? [];
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
