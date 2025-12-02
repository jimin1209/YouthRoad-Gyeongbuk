import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/policy.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/compare_notifier.dart';
import 'notifiers/favorites_notifier.dart';
import 'notifiers/policy_detail_notifier.dart';
import 'notifiers/policy_paging_notifier.dart';
import 'notifiers/recommended_policy_notifier.dart';

export 'di.dart';
export 'repository_providers.dart';
export 'notifiers/region_notifier.dart' show regionProvider, RegionNotifier;
export 'policy/policy_list_notifier.dart'
    show policyListNotifierProvider, PolicyListNotifier, PolicyListState;
export '../features/policy/providers/policy_prefetch_provider.dart'
    show policyPrefetchProvider, PolicyPrefetchNotifier;
final policyPagingProvider =
    NotifierProvider.autoDispose<PolicyFeedsNotifier, PolicyFeedsState>(
  PolicyFeedsNotifier.new,
);

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
