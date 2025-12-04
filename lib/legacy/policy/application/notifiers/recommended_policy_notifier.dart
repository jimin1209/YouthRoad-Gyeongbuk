import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_feed_controllers.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_paging_state.dart';
import 'package:youth_road_app/features/policy_new/domain/entities/policy.dart';

class RecommendedPolicyNotifier extends AutoDisposeNotifier<AsyncValue<List<Policy>>> {
  @override
  AsyncValue<List<Policy>> build() {
    final state = ref.watch(recommendFeedControllerProvider);
    return _mapState(state);
  }

  AsyncValue<List<Policy>> _mapState(PolicyPagingState state) {
    if (state.failure != null) {
      return AsyncValue.error(state.failure!, StackTrace.current);
    }
    if (state.isLoading) {
      return const AsyncValue.loading();
    }
    return AsyncValue.data(state.items);
  }
}

final recommendedPolicyProvider =
    AutoDisposeNotifierProvider<RecommendedPolicyNotifier, AsyncValue<List<Policy>>>(
  RecommendedPolicyNotifier.new,
);
