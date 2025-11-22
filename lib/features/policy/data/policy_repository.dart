import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/result.dart';
import '../api/policy_api.dart';
import '../model/policy_item.dart';
import '../provider/policy_filter.dart';

/// 정책 목록 조회 전용 리포지토리 (신규 UX 흐름용).
class PolicyRepository {
  PolicyRepository({
    required PolicyApi api,
    required String Function() apiKeyResolver,
  })  : _api = api,
        _apiKeyResolver = apiKeyResolver;

  final PolicyApi _api;
  final String Function() _apiKeyResolver;

  Future<Result<PolicyListResponse>> fetchList(PolicyFilter filter) async {
    try {
      final response = await _api.fetchPolicies(
        apiKey: _apiKeyResolver(),
        searchRgnSe: filter.searchRgnSe,
        searchPolicyType: filter.searchPolicyType,
        searchKeyword: filter.searchKeyword,
        pageIndex: filter.pageIndex,
        pageSize: filter.pageSize,
        yyyy: filter.yyyy,
        applyAbleFilter: filter.applyAbleFilter,
      );
      // 일부 응답 호환을 위한 보정
      final items = response.items.isNotEmpty
          ? response.items
          : (response.items.isEmpty && response.totalCount == 0 ? (response.items) : response.items);
      return Success(response.copyWith(items: items));
    } catch (e, st) {
      return Failure(
        AppError(
          message: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }
}

final policyApiProvider = Provider<PolicyApi>((ref) {
  final dio = ref.watch(dioClientProvider);
  return PolicyApi(dio, baseUrl: 'https://gbyouth.co.kr');
});

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  return PolicyRepository(
    api: ref.watch(policyApiProvider),
    apiKeyResolver: () => const String.fromEnvironment('YOUTH_API_KEY', defaultValue: ''),
  );
});
