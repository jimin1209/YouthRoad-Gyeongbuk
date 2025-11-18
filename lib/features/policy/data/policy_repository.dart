import 'package:dio/dio.dart';

import '../../../core/api/dto/policy_request_dto.dart';
import '../../../core/api/models/policy.dart' as remote;
import '../../../core/api/youth_api_service.dart';
import 'models/category.dart';
import 'models/policy.dart';
import 'models/region.dart';

class PolicyRepository {
  PolicyRepository(YouthApiService api) : _api = api;

  final YouthApiService _api;
  final Map<String, Policy> _policyCache = {};

  Future<List<Region>> getRegions() async {
    return List<Region>.unmodifiable(_regionPresets);
  }

  Future<List<Category>> getCategories() async {
    return List<Category>.unmodifiable(_categoryPresets);
  }

  Future<List<Policy>> getPolicies({
    String? region,
    int? age,
    List<String>? categories,
    String? status,
    String? keyword,
    int page = 1,
    int size = 20,
  }) async {
    final normalizedRegion = (region == null || region == 'ALL') ? null : region;
    final normalizedCategories = _joinCategories(categories);
    final normalizedStatus = status?.trim().isEmpty ?? true ? null : status?.trim();
    final normalizedAge = age == null || age <= 0 ? null : age;
    final normalizedKeyword = keyword?.trim().isEmpty ?? true ? null : keyword?.trim();
    try {
      final response = await _api.fetchPolicies(
        PolicyRequestDto(
          apiKey: apiKey,
          searchRgnSe: normalizedRegion,
          searchPolicyType: normalizedCategories,
          searchPolicyStatus: normalizedStatus,
          searchAge: normalizedAge,
          searchKeyword: normalizedKeyword,
          pageIndex: page <= 0 ? 1 : page,
          pageSize: size,
        ),
      );
      final policies = (response.resultList ?? const <remote.Policy>[])
          .map(Policy.fromRemote)
          .toList(growable: false);
      for (final policy in policies) {
        _policyCache[policy.id] = policy;
      }
      return policies;
    } on DioException catch (error) {
      throw _mapDioException(error, 'Failed to load policy list');
    }
  }

  Future<Policy> getPolicyDetail(String id) async {
    final cached = _policyCache[id];
    if (cached != null) {
      return cached;
    }
    try {
      final response = await _api.fetchPolicies(
        PolicyRequestDto(
          apiKey: apiKey,
          searchKeyword: id,
          pageIndex: 1,
          pageSize: 5,
        ),
      );
      final candidates = response.resultList ?? const <remote.Policy>[];
      if (candidates.isEmpty) {
        throw StateError('Policy not found');
      }
      final remotePolicy = candidates.firstWhere(
        (item) => item.id == id || item.policyName == id,
        orElse: () => candidates.first,
      );
      final policy = Policy.fromRemote(remotePolicy);
      _policyCache[policy.id] = policy;
      return policy;
    } on DioException catch (error) {
      throw _mapDioException(error, 'Failed to load policy detail');
    }
  }

  String? _joinCategories(List<String>? categories) {
    if (categories == null || categories.isEmpty) {
      return null;
    }
    final nonEmpty = categories
        .map((category) => category.trim())
        .where((category) => category.isNotEmpty)
        .toList();
    if (nonEmpty.isEmpty) {
      return null;
    }
    return nonEmpty.join(',');
  }

  StateError _mapDioException(DioException error, String context) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 429) {
      return StateError('$context: rate limited (429). Please try again.');
    }
    if (statusCode != null && statusCode >= 500) {
      return StateError('$context: server unavailable (HTTP $statusCode).');
    }
    return StateError('$context: ${error.message}');
  }
}

const List<Region> _regionPresets = <Region>[
  Region(code: 'ALL', name: '전국'),
  Region(code: '11', name: '서울특별시'),
  Region(code: '26', name: '부산광역시'),
  Region(code: '27', name: '대구광역시'),
  Region(code: '28', name: '인천광역시'),
  Region(code: '29', name: '광주광역시'),
  Region(code: '30', name: '대전광역시'),
  Region(code: '31', name: '울산광역시'),
  Region(code: '36', name: '세종특별자치시'),
  Region(code: '41', name: '경기도'),
  Region(code: '42', name: '강원특별자치도'),
  Region(code: '43', name: '충청북도'),
  Region(code: '44', name: '충청남도'),
  Region(code: '45', name: '전북특별자치도'),
  Region(code: '46', name: '전라남도'),
  Region(code: '47', name: '경상북도'),
  Region(code: '48', name: '경상남도'),
  Region(code: '49', name: '제주특별자치도'),
];

const List<Category> _categoryPresets = <Category>[
  Category(code: 'EMPLOYMENT', name: '취업·일자리'),
  Category(code: 'ENTREPRENEUR', name: '창업·비즈니스'),
  Category(code: 'EDUCATION', name: '교육·역량'),
  Category(code: 'HOUSING', name: '주거·금융'),
  Category(code: 'WELFARE', name: '생활·복지'),
  Category(code: 'CULTURE', name: '문화·활동'),
];
