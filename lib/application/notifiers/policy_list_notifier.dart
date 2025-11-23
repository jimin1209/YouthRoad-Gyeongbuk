import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';
import 'region_notifier.dart';

class PolicyListNotifier extends AutoDisposeAsyncNotifier<List<Policy>> {
  late final PolicyRepository _repo;
  static const String errorMessage = '정책을 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  Future<List<Policy>> build() async {
    _repo = ref.read(policyRepositoryProvider);
    final selectedRegion = ref.watch(regionProvider);
    return _fetchPolicies(selectedRegion);
  }

  Future<List<Policy>> _fetchPolicies(String? region) async {
    try {
      final policies = await _repo.fetchPolicies(
        filter: PolicyFilter(searchRgnSe: region),
      );
      return policies;
    } catch (e, st) {
      debugPrint('Failed to fetch policies: $e');
      debugPrint('$st');
      throw Exception(errorMessage);
    }
  }

  Future<void> refreshPolicies() async {
    final selectedRegion = ref.read(regionProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPolicies(selectedRegion));
  }
}
