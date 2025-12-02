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
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': pageSize,
        'keyword': query.keyword,
        'tags': query.tags.isEmpty ? null : query.tags.join(','),
        'feedType': query.feedType.name,
        'region': query.filter.region.name,
        'category': query.filter.category?.name,
        'filterTags': query.filter.tags.isEmpty
            ? null
            : query.filter.tags.join(','),
        'isOnline': query.filter.isOnline,
        'isOffline': query.filter.isOffline,
        'isOngoing': query.filter.isOngoing,
        'age': query.filter.age,
        'sort': query.sort.name,
      };

      queryParameters.removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty),
      );

      final res = await _dio.get('/policies', queryParameters: queryParameters);

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
