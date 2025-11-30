import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/policy.dart';
import 'di.dart';
import 'repository_providers.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/compare_notifier.dart';
import 'notifiers/favorites_notifier.dart';
import 'notifiers/policy_detail_notifier.dart';
import 'notifiers/policy_list_notifier.dart';
import 'notifiers/policy_paging_notifier.dart';

export 'di.dart';
export 'repository_providers.dart';
export 'notifiers/region_notifier.dart' show regionProvider, RegionNotifier;
export '../features/policy/providers/policy_prefetch_provider.dart'
    show policyPrefetchProvider, PolicyPrefetchNotifier;

final policyListNotifierProvider =
    AsyncNotifierProvider<PolicyListNotifier, List<Policy>>(
  PolicyListNotifier.new,
);

final policyPagingProvider =
    NotifierProvider.autoDispose<PolicyPagingNotifier, PolicyPagingState>(
  PolicyPagingNotifier.new,
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
