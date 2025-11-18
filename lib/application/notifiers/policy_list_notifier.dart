import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../../providers/global_providers.dart';

class PolicyListNotifier extends AsyncNotifier<List<Policy>> {
  late final PolicyRepository _repo;

  @override
  Future<List<Policy>> build() async {
    _repo = ref.read(policyRepositoryProvider);
    return _repo.fetchPolicies();
  }

  Future<void> refreshPolicies() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.fetchPolicies);
  }
}
