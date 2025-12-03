import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/legacy/policy/application/notifiers/policy_detail_notifier.dart';
import 'package:youth_road_app/legacy/policy/application/notifiers/recommended_policy_notifier.dart';

import '../domain/entities/policy.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/compare_notifier.dart';
import 'notifiers/favorites_notifier.dart';

export 'di.dart';
export 'repository_providers.dart';
export 'notifiers/region_notifier.dart' show regionProvider, RegionNotifier;
export 'package:youth_road_app/legacy/policy/application/policy/policy_list_notifier.dart'
    show policyListNotifierProvider, PolicyListNotifier, PolicyListState;
export 'package:youth_road_app/legacy/policy/application/policy/policy_paging_provider.dart'
    show policyPagingProvider;
export 'package:youth_road_app/legacy/policy/application/policy/policy_prefetch_provider.dart'
    show policyPrefetchProvider, PolicyPrefetchNotifier;

final policyDetailProvider =
    NotifierProvider.autoDispose<PolicyDetailNotifier, PolicyDetailState>(
  PolicyDetailNotifier.new,
);

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);

final compareProvider = AsyncNotifierProvider<CompareNotifier, List<Policy>>(
  CompareNotifier.new,
);

final chatProvider =
    NotifierProvider.autoDispose<ChatNotifier, ChatState>(ChatNotifier.new);
