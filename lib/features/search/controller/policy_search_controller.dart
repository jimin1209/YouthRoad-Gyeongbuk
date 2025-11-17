import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../policy/data/policy_repository.dart';
import '../../policy/data/models/policy.dart';
import '../../policy/controller/policy_list_controller.dart';
import '../../../providers/global_providers.dart';

class PolicySearchParams {
  final String? query;
  final String? region;
  final List<String> categories;
  final String? status;

  const PolicySearchParams({
    this.query,
    this.region,
    this.categories = const [],
    this.status,
  });
}

final policySearchControllerProvider =
    AutoDisposeAsyncNotifierProvider<PolicySearchController, List<Policy>>(
        PolicySearchController.new);

class PolicySearchController extends AutoDisposeAsyncNotifier<List<Policy>> {
  late final PolicyRepository _repository;
  PolicySearchParams _params = const PolicySearchParams();

  void setParams(PolicySearchParams params) {
    _params = params;
    ref.invalidateSelf();
  }

  @override
  Future<List<Policy>> build() async {
    _repository = ref.watch(policyRepositoryProvider);
    final globalFilter = ref.watch(filterStateProvider);
    final region = _params.region ?? globalFilter.region;
    final categories =
        _params.categories.isNotEmpty ? _params.categories : globalFilter.categories;
    final status = _params.status ?? globalFilter.status;

    final results = await _repository.getPolicies(
      region: region,
      categories: categories.isEmpty ? null : categories,
      status: (status == null || status.isEmpty) ? null : status,
    );
    final filtered = _applyTextQuery(results, _params.query);
    final interests = categories.isNotEmpty ? categories : globalFilter.categories;
    return _sortByRecommendation(filtered, interests);
  }

  List<Policy> _applyTextQuery(List<Policy> policies, String? query) {
    if (query == null || query.trim().isEmpty) {
      return policies;
    }
    final lowerQuery = query.toLowerCase();
    return policies
        .where((policy) =>
            policy.title.toLowerCase().contains(lowerQuery) ||
            policy.summary.toLowerCase().contains(lowerQuery) ||
            policy.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  List<Policy> _sortByRecommendation(List<Policy> policies, List<String> interests) {
    final scored = policies
        .map((policy) => MapEntry(policy, computePolicyScore(policy, interests)))
        .toList();
    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((entry) => entry.key).toList();
  }
}
