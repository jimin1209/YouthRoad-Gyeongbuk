import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';

class PolicyListNotifier extends AsyncNotifier<List<Policy>> {
  late final PolicyRepository _repo;

  @override
  Future<List<Policy>> build() async {
    _repo = ref.read(policyRepositoryProvider);
    return _repo.fetchPolicies(filter: const PolicyFilter());
  }

  Future<void> refreshPolicies() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.fetchPolicies(filter: const PolicyFilter()),
    );
  }
}
