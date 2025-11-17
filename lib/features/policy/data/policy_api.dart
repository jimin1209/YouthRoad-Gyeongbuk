import 'package:dio/dio.dart';
import 'models/policy.dart';
import 'models/region.dart';
import 'models/category.dart';

class PolicyApi {
  PolicyApi(this._dio);

  final Dio _dio;

  Future<List<Region>> fetchRegions() async {
    final response = await _dio.get('/api/regions');
    final list = response.data as List<dynamic>? ?? const [];
    return list.map((e) => Region.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Category>> fetchCategories() async {
    final response = await _dio.get('/api/categories');
    final list = response.data as List<dynamic>? ?? const [];
    return list.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Policy>> fetchPolicies({
    String? region,
    int? age,
    List<String>? categories,
    String? status,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _dio.get(
      '/api/policies',
      queryParameters: {
        'region': region,
        'age': age,
        'categories': categories?.join(','),
        'status': status,
        'page': page,
        'size': size,
      }..removeWhere((key, value) => value == null),
    );
    final data = response.data['content'] as List<dynamic>? ?? const [];
    return data.map((e) => Policy.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Policy> fetchPolicyDetail(String id) async {
    final response = await _dio.get('/api/policies/$id');
    return Policy.fromJson(response.data as Map<String, dynamic>);
  }
}
