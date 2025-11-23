import 'package:flutter/foundation.dart';
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

  PolicyDetailState copyWith({
    Policy? policy,
    List<Policy>? similar,
    bool? isLoading,
    String? error,
  }) {
    return PolicyDetailState(
      policy: policy ?? this.policy,
      similar: similar ?? this.similar,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PolicyDetailNotifier extends AutoDisposeNotifier<PolicyDetailState> {
  late final PolicyRepository _repo;
  static const String errorMessage = '정책을 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  PolicyDetailState build() {
    _repo = ref.read(policyRepositoryProvider);
    return const PolicyDetailState(isLoading: false);
  }

  Future<void> load(String id) async {
    state = state.copyWith(isLoading: true, error: null, similar: const []);
    try {
      final policy = await _repo.fetchPolicyById(id);
      final similar = await _repo.fetchSimilarPolicies(id);
      state = state.copyWith(
        policy: policy,
        similar: similar,
        isLoading: false,
      );
    } catch (e, st) {
      debugPrint('Failed to load policy detail: $e');
      debugPrint('$st');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        similar: const [],
      );
    }
  }
}
