import 'package:dio/dio.dart';
import 'policy_api.dart';
import 'models/policy.dart';
import 'models/region.dart';
import 'models/category.dart';

class PolicyRepository {
  PolicyRepository(Dio dio) : _api = PolicyApi(dio);

  final PolicyApi _api;

  Future<List<Region>> getRegions() => _api.fetchRegions();

  Future<List<Category>> getCategories() => _api.fetchCategories();

  Future<List<Policy>> getPolicies({
    String? region,
    int? age,
    List<String>? categories,
    String? status,
    int page = 0,
    int size = 20,
  }) =>
      _api.fetchPolicies(
        region: region,
        age: age,
        categories: categories,
        status: status,
        page: page,
        size: size,
      );

  Future<Policy> getPolicyDetail(String id) => _api.fetchPolicyDetail(id);
}
