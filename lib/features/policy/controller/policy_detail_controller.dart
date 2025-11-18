import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/policy_repository.dart';
import '../data/models/policy.dart';
import '../../../providers/global_providers.dart';

/// Family provider to load policy detail by id.
final policyDetailControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<PolicyDetailController, Policy, String>(
        PolicyDetailController.new);

class PolicyDetailController extends AutoDisposeFamilyAsyncNotifier<Policy, String> {
  late final PolicyRepository _repository;

  @override
  Future<Policy> build(String arg) async {
    _repository = ref.watch(policyRepositoryProvider);
    return _repository.getPolicyDetail(arg);
  }
}

final relatedPoliciesProvider = FutureProvider.autoDispose.family<List<Policy>, Policy>(
  (ref, policy) async {
    final repository = ref.watch(policyRepositoryProvider);
    final candidates = await repository.getPolicies(
      region: policy.regionCode,
      categories: policy.categories.isEmpty ? null : policy.categories,
      size: 20,
    );
    final filtered = candidates.where((item) => item.id != policy.id).toList();
    return filtered.take(6).toList();
  },
);
