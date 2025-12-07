import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/policy.dart';
import '../domain/repositories/policy_repository.dart';
import '../domain/values/policy_failure.dart';
import '../domain/values/policy_logger.dart';
import '../domain/values/policy_filter.dart';
import '../domain/values/policy_query.dart';
import '../domain/values/policy_region.dart';
import '../domain/values/policy_settings.dart';
import '../domain/values/policy_sort.dart';
import 'controllers/base_feed_controller.dart';
import 'controllers/policy_detail_controller.dart';
import 'controllers/policy_behavior_controller.dart';
import 'controllers/policy_event_bus.dart';
import 'controllers/policy_feed_controllers.dart';
import 'controllers/policy_paging_state.dart';
import 'controllers/policy_query_controller.dart';
import 'controllers/policy_query_engine.dart';
import 'controllers/policy_scoring_controller.dart';
import '../data/cache/policy_cache.dart';
import '../data/repositories/policy_repository_impl.dart';
import '../data/sources/policy_remote_source.dart';
import '../data/sources/policy_remote_source_mock.dart';

class UserProfile {
  final PolicyRegion region;
  const UserProfile({required this.region});
}

class FavoriteRepository {
  final List<String> allIds;
  const FavoriteRepository({this.allIds = const []});
}

class CompareRepository {
  final List<String> ids;
  const CompareRepository({this.ids = const []});
}

class ConsolePolicyLogger implements PolicyLogger {
  @override
  void info(String msg) {
    debugPrint('[Policy][INFO] $msg');
  }

  @override
  void warn(String msg) {
    debugPrint('[Policy][WARN] $msg');
  }

  @override
  void error(String msg, [Object? err, StackTrace? stackTrace]) {
    debugPrint('[Policy][ERROR] $msg ${err ?? ''} ${stackTrace ?? ''}');
  }
}

final policySettingsProvider = Provider<PolicySettings>((ref) {
  return const PolicySettings(
    pageSize: 20,
    defaultRegion: PolicyRegion.gyeongbuk,
    enableCache: true,
  );
});

final policyLoggerProvider = Provider<PolicyLogger>((ref) {
  return ConsolePolicyLogger();
});

final policyEventBusProvider =
    StateNotifierProvider<PolicyEventBus, PolicyEvent?>(
  (ref) => PolicyEventBus(),
);

final userProfileProvider = Provider<UserProfile>((ref) {
  return const UserProfile(region: PolicyRegion.gyeongbuk);
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return const FavoriteRepository();
});

final compareRepositoryProvider = Provider<CompareRepository>((ref) {
  return const CompareRepository();
});

final policyBehaviorProvider =
    StateNotifierProvider<PolicyBehaviorController, PolicyBehaviorState>(
  (ref) => PolicyBehaviorController(),
);

final policyScoreProvider =
    StateNotifierProvider<PolicyScoreController, Map<String, double>>(
  (ref) => PolicyScoreController(ref),
);

final policyDebugModeProvider = StateProvider<bool>((ref) => false);

final isMockModeProvider = Provider<bool>((ref) => false);

final dioProvider = Provider((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.youthroad-chat.workers.dev',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
      headers: const {
        'Content-Type': 'application/json',
      },
    ),
  );
});

final policyRemoteSourceProvider = Provider((ref) {
  return PolicyRemoteSource(ref.watch(dioProvider));
});

final mockPolicyRemoteSourceProvider = Provider((ref) {
  return PolicyRemoteSourceMock();
});

final activePolicyRemoteProvider = Provider<PolicyRemoteSource>((ref) {
  final isMock = ref.watch(isMockModeProvider);
  return isMock
      ? ref.watch(mockPolicyRemoteSourceProvider)
      : ref.watch(policyRemoteSourceProvider);
});

final policyCacheProvider = Provider((ref) => PolicyCache());

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  return PolicyRepositoryImpl(
    remote: ref.watch(activePolicyRemoteProvider),
    cache: ref.watch(policyCacheProvider),
    logger: ref.watch(policyLoggerProvider),
    settings: ref.watch(policySettingsProvider),
  );
});

final policyQueryEngineProvider = Provider(
  (ref) => PolicyQueryEngine(ref),
);

PolicyQuery _initialQueryFor(Ref ref, PolicyFeedType type) {
  final settings = ref.read(policySettingsProvider);
  switch (type) {
    case PolicyFeedType.recommend:
      return PolicyQuery(
        feedType: type,
        filter: PolicyFilter(region: settings.defaultRegion),
        sort: PolicySortOption.recommendation,
      );
    case PolicyFeedType.all:
      return PolicyQuery(
        feedType: type,
        filter: const PolicyFilter(),
        sort: PolicySortOption.latest,
      );
    case PolicyFeedType.region:
      final user = ref.read(userProfileProvider);
      return PolicyQuery(
        feedType: type,
        filter: PolicyFilter(region: user.region),
        sort: PolicySortOption.latest,
      );
    case PolicyFeedType.search:
      return const PolicyQuery(
        feedType: PolicyFeedType.search,
        filter: PolicyFilter(),
        sort: PolicySortOption.latest,
      );
    case PolicyFeedType.favorite:
      final favIds = ref.read(favoriteRepositoryProvider).allIds;
      return PolicyQuery(
        feedType: type,
        filter: const PolicyFilter(),
        tags: favIds,
        sort: PolicySortOption.latest,
      );
    case PolicyFeedType.compare:
      final compareIds = ref.read(compareRepositoryProvider).ids;
      return PolicyQuery(
        feedType: type,
        filter: const PolicyFilter(),
        tags: compareIds,
        sort: PolicySortOption.latest,
      );
  }
}

final policyQueryProvider =
    StateNotifierProvider.family<PolicyQueryController, PolicyQuery, PolicyFeedType>(
  (ref, feedType) =>
      PolicyQueryController(initialQuery: _initialQueryFor(ref, feedType)),
);

final recommendFeedControllerProvider =
    StateNotifierProvider<RecommendFeedController, PolicyPagingState>(
  (ref) => RecommendFeedController(
    ref: ref,
    queryEngine: ref.read(policyQueryEngineProvider),
  ),
);

final allFeedControllerProvider =
    StateNotifierProvider<AllFeedController, PolicyPagingState>(
  (ref) => AllFeedController(
    ref: ref,
    queryEngine: ref.read(policyQueryEngineProvider),
  ),
);

final regionFeedControllerProvider =
    StateNotifierProvider<RegionFeedController, PolicyPagingState>(
  (ref) => RegionFeedController(
    ref: ref,
    queryEngine: ref.read(policyQueryEngineProvider),
  ),
);

final searchFeedControllerProvider =
    StateNotifierProvider<SearchFeedController, PolicyPagingState>(
  (ref) => SearchFeedController(
    ref: ref,
    queryEngine: ref.read(policyQueryEngineProvider),
  ),
);

final favoriteFeedControllerProvider =
    StateNotifierProvider<FavoriteFeedController, PolicyPagingState>(
  (ref) => FavoriteFeedController(
    ref: ref,
    queryEngine: ref.read(policyQueryEngineProvider),
  ),
);

final compareFeedControllerProvider =
    StateNotifierProvider<CompareFeedController, PolicyPagingState>(
  (ref) => CompareFeedController(
    ref: ref,
    queryEngine: ref.read(policyQueryEngineProvider),
  ),
);

final policyDetailProvider =
    StateNotifierProvider.family<PolicyDetailController, AsyncValue<Policy>, String>(
  (ref, policyId) => PolicyDetailController(
    ref: ref,
    policyId: policyId,
  ),
);
