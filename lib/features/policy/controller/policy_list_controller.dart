import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/policy_repository.dart';
import '../data/models/policy.dart';
import '../../../providers/global_providers.dart';

class PolicyFilter {
  final String? region;
  final int? age;
  final List<String> categories;
  final String? status;

  const PolicyFilter({
    this.region,
    this.age,
    List<String> categories = const [],
    this.status,
  }) : categories = List.unmodifiable(categories);

  PolicyFilter copyWith({
    String? region,
    int? age,
    List<String>? categories,
    String? status,
  }) {
    return PolicyFilter(
      region: region ?? this.region,
      age: age ?? this.age,
      categories: categories ?? this.categories,
      status: status ?? this.status,
    );
  }

  factory PolicyFilter.initial() => const PolicyFilter();
}

final filterStateProvider = StateProvider<PolicyFilter>((ref) {
  return PolicyFilter.initial();
});

final policyListControllerProvider =
    AutoDisposeAsyncNotifierProvider<PolicyListController, List<Policy>>(
        PolicyListController.new);

class PolicyListController extends AutoDisposeAsyncNotifier<List<Policy>> {
  late final PolicyRepository _repository;

  @override
  Future<List<Policy>> build() async {
    _repository = ref.watch(policyRepositoryProvider);
    final filter = ref.watch(filterStateProvider);
    final categories = filter.categories.isEmpty ? null : filter.categories;
    final status = (filter.status == null || filter.status!.isEmpty)
        ? null
        : filter.status;
    final policies = await _repository.getPolicies(
      region: filter.region,
      age: filter.age,
      categories: categories,
      status: status,
    );
    return _sortedByScore(policies, filter.categories);
  }

  List<Policy> _sortedByScore(List<Policy> policies, List<String> interests) {
    final scored = policies
        .map((p) => MapEntry(p, computePolicyScore(p, interests)))
        .toList();
    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((e) => e.key).toList();
  }
}
