import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/policy.dart';
import '../domain/repositories/policy_repository.dart';
import '../domain/repositories/reminder_repository.dart';
import '../domain/values/policy_event.dart';
import '../domain/values/policy_failure.dart';
import '../domain/values/policy_feed_type.dart';
import '../domain/values/policy_logger.dart';
import '../domain/values/policy_region.dart';
import '../domain/values/policy_settings.dart';
import '../domain/values/policy_sort.dart';
import 'controllers/base_feed_controller.dart';
import 'controllers/notification_center_controller.dart';
import 'controllers/policy_detail_controller.dart';
import 'controllers/policy_event_bus.dart';
import 'controllers/policy_feed_controllers.dart';
import 'controllers/policy_paging_controller.dart';
import 'controllers/policy_paging_state.dart';
import 'controllers/policy_query_engine.dart';
import 'controllers/reminder_controller.dart';
import 'filters/policy_filter_ui_state.dart';
import '../data/cache/policy_cache.dart';
import '../data/repositories/policy_repository_impl.dart';
import '../data/repositories/reminder_repository_impl.dart';
import '../data/sources/policy_remote_source.dart';
import '../data/sources/policy_remote_source_mock.dart';
import '../data/sources/reminder_local_source.dart';
import '../infrastructure/notification/local_notification_gateway.dart';
import '../infrastructure/notification/notification_gateway.dart';

class UserProfile {
  final PolicyRegion region;
  final int? age;
  final List<String> recommendTags;

  const UserProfile({
    required this.region,
    this.age,
    this.recommendTags = const [],
  });
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

final notificationGatewayProvider = Provider<NotificationGateway>((ref) {
  return LocalNotificationGateway();
});

final reminderLocalSourceProvider =
    Provider<PolicyReminderLocalSource>((ref) {
  return InMemoryPolicyReminderLocalSource();
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepositoryImpl(
    localSource: ref.watch(reminderLocalSourceProvider),
    notificationGateway: ref.watch(notificationGatewayProvider),
  );
});

final userProfileProvider = Provider<UserProfile>((ref) {
  return const UserProfile(
    region: PolicyRegion.gyeongbuk,
    age: null,
    recommendTags: ['청년', '창업', '주거'],
  );
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return const FavoriteRepository();
});

final compareRepositoryProvider = Provider<CompareRepository>((ref) {
  return const CompareRepository();
});

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

final policyPagingControllerProvider =
    StateNotifierProvider<PolicyPagingController, AsyncValue<List<Policy>>>(
        (ref) {
  return PolicyPagingController(
    repository: ref.watch(policyRepositoryProvider),
    logger: ref.watch(policyLoggerProvider),
    policySettings: ref.watch(policySettingsProvider),
    eventBus: ref.read(policyEventBusProvider.notifier),
  );
});

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

final reminderControllerProvider =
    StateNotifierProvider<ReminderController, ReminderState>(
  (ref) => ReminderController(
    repository: ref.watch(reminderRepositoryProvider),
    eventBus: ref.read(policyEventBusProvider.notifier),
  ),
);

final notificationCenterControllerProvider =
    StateNotifierProvider<NotificationCenterController, NotificationCenterState>(
  (ref) => NotificationCenterController(
    repository: ref.watch(reminderRepositoryProvider),
  ),
);

final policyDetailProvider =
    StateNotifierProvider.family<PolicyDetailController, AsyncValue<Policy>, String>(
  (ref, policyId) => PolicyDetailController(
    ref: ref,
    policyId: policyId,
  ),
);
