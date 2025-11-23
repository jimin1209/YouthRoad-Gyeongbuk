import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/policy.dart';
import 'di.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/compare_notifier.dart';
import 'notifiers/favorites_notifier.dart';
import 'notifiers/memo_notifier.dart';
import 'notifiers/policy_detail_notifier.dart';
import 'notifiers/policy_list_notifier.dart';
import 'notifiers/policy_paging_notifier.dart';

export 'di.dart';

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

final compareProvider =
    AsyncNotifierProvider.autoDispose<CompareNotifier, List<Policy>>(
  CompareNotifier.new,
);

final memoProvider =
    NotifierProvider.autoDispose<MemoNotifier, Map<String, String>>(
  MemoNotifier.new,
);

final chatProvider =
    NotifierProvider.autoDispose<ChatNotifier, ChatState>(ChatNotifier.new);

export 'notifiers/region_notifier.dart' show regionProvider, RegionNotifier;
