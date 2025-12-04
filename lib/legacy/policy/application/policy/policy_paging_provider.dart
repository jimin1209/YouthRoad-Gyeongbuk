import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_feed_controllers.dart';

import '../notifiers/policy_paging_notifier.dart';

final policyPagingProvider =
    Provider.autoDispose<PolicyFeedsNotifier>((ref) {
  final controller = PolicyFeedsNotifier();
  ref.onDispose(controller.dispose);
  // 초기화: 추천/전체/지역/검색 탭에 대한 기본 로딩을 트리거합니다.
  ref.read(recommendFeedControllerProvider.notifier).ensureInitialized();
  ref.read(allFeedControllerProvider.notifier).ensureInitialized();
  ref.read(regionFeedControllerProvider.notifier).ensureInitialized();
  ref.read(searchFeedControllerProvider.notifier).ensureInitialized();
  ref.read(favoriteFeedControllerProvider.notifier).ensureInitialized();
  return controller;
});
