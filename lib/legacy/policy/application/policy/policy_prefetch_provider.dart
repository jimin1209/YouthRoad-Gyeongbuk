import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_feed_controllers.dart';

class PolicyPrefetchNotifier extends AutoDisposeNotifier<void> {
  @override
  void build() {}

  Future<void> prefetchPolicies() async {
    await Future.wait([
      ref.read(recommendFeedControllerProvider.notifier).ensureInitialized(),
      ref.read(allFeedControllerProvider.notifier).ensureInitialized(),
      ref.read(regionFeedControllerProvider.notifier).ensureInitialized(),
      ref.read(searchFeedControllerProvider.notifier).ensureInitialized(),
      ref.read(favoriteFeedControllerProvider.notifier).ensureInitialized(),
    ]);
  }
}

final policyPrefetchProvider =
    AutoDisposeNotifierProvider<PolicyPrefetchNotifier, void>(
  PolicyPrefetchNotifier.new,
);
