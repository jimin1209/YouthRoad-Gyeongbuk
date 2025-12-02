import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../providers.dart';

class PolicyDetailController extends StateNotifier<AsyncValue<Policy>> {
  PolicyDetailController({
    required this.ref,
    required this.policyId,
  }) : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref ref;
  final String policyId;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    final repo = ref.read(policyRepositoryProvider);
    final result = await repo.fetchPolicyDetail(policyId);

    result.fold(
      onSuccess: (policy) => state = AsyncValue.data(policy),
      onFailure: (failure) => state = AsyncValue.error(
        failure,
        StackTrace.current,
      ),
    );
  }

  Future<void> refresh() => _load();
}
