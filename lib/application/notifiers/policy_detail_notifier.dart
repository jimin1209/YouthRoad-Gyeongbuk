import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';

class PolicyDetailState {
  const PolicyDetailState({
    this.policy,
    this.similar = const [],
    this.isLoading = false,
    this.error,
  });

  final Policy? policy;
  final List<Policy> similar;
  final bool isLoading;
  final String? error;
}

class PolicyDetailNotifier extends AutoDisposeNotifier<PolicyDetailState> {
  late final PolicyRepository _repo;

  @override
  PolicyDetailState build() {
    _repo = ref.read(policyRepositoryProvider);
    return const PolicyDetailState(isLoading: false);
  }

  Future<void> load(String id) async {
    state = const PolicyDetailState(isLoading: true);
    try {
      final policy = await _repo.fetchPolicyById(id);
      final similar = await _repo.fetchSimilarPolicies(id);
      state = PolicyDetailState(policy: policy, similar: similar);
    } catch (e) {
      state = PolicyDetailState(policy: state.policy, similar: state.similar, error: '$e');
    }
  }
}
