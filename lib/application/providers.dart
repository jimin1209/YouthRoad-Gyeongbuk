import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/policy.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/compare_notifier.dart';
import 'notifiers/favorites_notifier.dart';

export 'package:youth_road_app/features/policy_new/application/providers.dart'
    show policyEventBusProvider;

export 'di.dart';
export 'repository_providers.dart';
export 'notifiers/region_notifier.dart' show regionProvider, RegionNotifier;
export 'notifiers/policy_list_notifier.dart'
    show policyListNotifierProvider, PolicyListState, PolicyListNotifier;

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);

final compareProvider = AsyncNotifierProvider<CompareNotifier, List<Policy>>(
  CompareNotifier.new,
);

final chatProvider =
    NotifierProvider.autoDispose<ChatNotifier, ChatState>(ChatNotifier.new);
