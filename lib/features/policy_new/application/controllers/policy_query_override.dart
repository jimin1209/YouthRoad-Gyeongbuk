import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filters/policy_filter_ui_state.dart';
import '../reexplore/policy_reexplore.dart';
import '../../domain/entities/policy.dart';
import '../../domain/values/policy_feed_type.dart';
import 'policy_query_state.dart';

class PolicyQueryOverride {
  const PolicyQueryOverride({required this.queryState});

  final PolicyQueryState queryState;
}

class PolicyQueryOverrideNotifier
    extends StateNotifier<PolicyQueryOverride?> {
  PolicyQueryOverrideNotifier(this.ref, PolicyFeedType _) : super(null);

  final Ref ref;

  String? _hash;

  PolicyFilterUiState applyFromDetail(Policy policy, PolicyReExploreMode mode) {
    final filter = ref.read(globalFilterProvider.notifier).applyFromDetail(
          policy,
          mode,
          PolicyReExploreBuilder.buildFilter,
        );
    final queryState =
        PolicyReExploreBuilder.buildQueryState(policy, mode, filter);
    _hash = queryState.hash;
    state = PolicyQueryOverride(queryState: queryState);
    return filter;
  }

  void ensureActiveForHash(String hash) {
    if (_hash != null && _hash != hash) {
      _hash = null;
      state = null;
    }
  }

  void clear() {
    _hash = null;
    state = null;
  }
}

final policyQueryOverrideProvider = StateNotifierProvider.family<
    PolicyQueryOverrideNotifier, PolicyQueryOverride?, PolicyFeedType>(
  (ref, feedType) => PolicyQueryOverrideNotifier(ref, feedType),
);
