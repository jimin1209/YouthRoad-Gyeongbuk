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

  PolicyFilterUiState applyFromDetail({
    required Policy policy,
    required PolicyReExploreMode mode,
    required PolicyFeedType feedType,
    required PolicyFilterUiState filter,
  }) {
    final queryState = PolicyReExploreBuilder.buildQueryState(
      policy,
      mode,
      filter,
      feedType: feedType,
    );
    state = PolicyQueryOverride(queryState: queryState);
    return filter;
  }

  void clear() {
    state = null;
  }
}

final policyQueryOverrideProvider = StateNotifierProvider.family<
    PolicyQueryOverrideNotifier, PolicyQueryOverride?, PolicyFeedType>(
  (ref, feedType) => PolicyQueryOverrideNotifier(ref, feedType),
);
