import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';
import 'region_notifier.dart';

class PolicyListNotifier extends AsyncNotifier<List<Policy>> {
  late final PolicyRepository _repo;

  @override
  Future<List<Policy>> build() async {
    _repo = ref.read(policyRepositoryProvider);
    final selectedRegion = ref.watch(regionProvider);
    return _repo.fetchPolicies(
      filter: PolicyFilter(region: selectedRegion),
    );
  }

  Future<void> refreshPolicies() async {
    final selectedRegion = ref.read(regionProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.fetchPolicies(
        filter: PolicyFilter(region: selectedRegion),
      ),
    );
  }
}
