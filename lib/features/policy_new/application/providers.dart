import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/env.dart';
import '../domain/entities/department.dart';
import '../domain/entities/institution.dart';
import '../domain/entities/policy.dart';
import '../domain/entities/policy_reminder.dart';
import '../domain/repositories/department_repository.dart';
import '../domain/repositories/institution_repository.dart';
import '../domain/repositories/policy_favorite_repository.dart';
import '../domain/repositories/policy_reminder_repository.dart';
import '../domain/repositories/policy_repository.dart';
import '../domain/values/policy_event.dart';
import '../domain/values/policy_failure.dart';
import '../domain/values/policy_feed_type.dart';
import '../domain/values/policy_logger.dart';
import '../domain/values/policy_query.dart';
import '../domain/values/policy_region.dart';
import '../domain/values/policy_reminder_config.dart';
import '../domain/values/policy_reminder_status.dart';
import '../domain/values/policy_settings.dart';
import '../domain/values/policy_sort.dart';
import 'behavior/policy_behavior_tracker.dart';
import 'controllers/base_feed_controller.dart';
import 'controllers/policy_detail_controller.dart';
import 'controllers/policy_event_bus.dart';
import 'controllers/policy_feed_controllers.dart';
import 'controllers/policy_reminder_controller.dart';
import 'controllers/notification_center_controller.dart';
import 'controllers/policy_action_controller.dart';
import 'controllers/policy_paging_controller.dart';
import 'controllers/policy_paging_state.dart';
import 'controllers/policy_query_engine.dart';
import 'controllers/policy_selection_controller.dart';
import 'gateways/notification_gateway.dart';
import 'services/policy_favorite_service.dart';
import 'services/policy_reminder_scheduler.dart';
import 'services/policy_reminder_service.dart';
import 'filters/policy_filter_ui_state.dart';
import 'models/user_collections.dart';
import '../data/cache/policy_cache.dart';
import '../data/repositories/department_repository_impl.dart';
import '../data/repositories/institution_repository_impl.dart';
import '../data/repositories/policy_favorite_repository_impl.dart';
import '../data/repositories/policy_reminder_repository_impl.dart';
import '../data/repositories/policy_repository_impl.dart';
import '../data/sources/department_remote_source.dart';
import '../data/sources/institution_remote_source.dart';
import '../data/sources/policy_favorite_local_data_source.dart';
import '../data/sources/policy_reminder_local_data_source.dart';
import '../data/sources/policy_remote_source.dart';
import '../data/sources/policy_remote_source_mock.dart';
import '../../application/di.dart' as app_di;

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
    apiKey: Env.youthApiKey,
    baseUrl: Env.policyApiBaseUrl,
  );
});

final policyLoggerProvider = Provider<PolicyLogger>((ref) {
  return ConsolePolicyLogger();
});

final userProfileProvider = Provider<UserProfile>((ref) {
  return const UserProfile(
    region: PolicyRegion.gyeongbuk,
    age: null,
    recommendTags: ['청년', '창업', '주거'],
  );
});

final compareRepositoryProvider =
    StateNotifierProvider<CompareController, CompareRepository>(
  (ref) => CompareController(ref),
);

final policyFavoriteLocalDataSourceProvider =
    Provider<PolicyFavoriteLocalDataSource>((ref) {
  final prefs = ref.watch(app_di.sharedPreferencesProvider);
  return SharedPrefsPolicyFavoriteLocalDataSource(prefs);
});

final policyFavoriteRepositoryProvider = Provider<PolicyFavoriteRepository>(
  (ref) => PolicyFavoriteRepositoryImpl(
    ref.watch(policyFavoriteLocalDataSourceProvider),
  ),
);

final favoriteIdsProvider =
    StateNotifierProvider<FavoriteIdsNotifier, Set<String>>((ref) {
  final notifier = FavoriteIdsNotifier(
    repository: ref.watch(policyFavoriteRepositoryProvider),
  );
  notifier.initialize();
  return notifier;
});

final policyFavoriteServiceProvider = Provider<PolicyFavoriteService>((ref) {
  return PolicyFavoriteService(
    repository: ref.watch(policyFavoriteRepositoryProvider),
    eventBus: ref.read(policyEventBusProvider.notifier),
    behaviorTracker: ref.read(policyBehaviorTrackerProvider.notifier),
    favoriteIdsNotifier: ref.read(favoriteIdsProvider.notifier),
  );
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
  final settings = ref.watch(policySettingsProvider);
  return PolicyRemoteSource(
    ref.watch(dioProvider),
    apiKey: settings.apiKey,
    baseUrl: settings.baseUrl,
  );
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

final institutionRemoteSourceProvider = Provider((ref) {
  final settings = ref.watch(policySettingsProvider);
  return InstitutionRemoteSource(
    ref.watch(dioProvider),
    apiKey: settings.apiKey,
    baseUrl: settings.baseUrl,
  );
});

final departmentRemoteSourceProvider = Provider((ref) {
  final settings = ref.watch(policySettingsProvider);
  return DepartmentRemoteSource(
    ref.watch(dioProvider),
    apiKey: settings.apiKey,
    baseUrl: settings.baseUrl,
  );
});

final institutionRepositoryProvider = Provider<InstitutionRepository>((ref) {
  return InstitutionRepositoryImpl(ref.watch(institutionRemoteSourceProvider));
});

final departmentRepositoryProvider = Provider<DepartmentRepository>((ref) {
  return DepartmentRepositoryImpl(ref.watch(departmentRemoteSourceProvider));
});

final institutionListProvider = FutureProvider<List<Institution>>((ref) {
  return ref.watch(institutionRepositoryProvider).fetchInstitutions();
});

final departmentListProvider = FutureProvider.family<List<Department>, String>(
  (ref, instNo) {
    return ref
        .watch(departmentRepositoryProvider)
        .fetchDepartments(instNo: instNo);
  },
);

final policyCacheProvider = Provider((ref) => PolicyCache());

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  return PolicyRepositoryImpl(
    remote: ref.watch(activePolicyRemoteProvider),
    cache: ref.watch(policyCacheProvider),
    logger: ref.watch(policyLoggerProvider),
    settings: ref.watch(policySettingsProvider),
  );
});

final policyReminderConfigProvider =
    Provider<PolicyReminderConfig>((ref) => const PolicyReminderConfig());

final policyReminderSchedulerProvider =
    Provider<PolicyReminderScheduler>((ref) {
  return PolicyReminderScheduler(
    config: ref.watch(policyReminderConfigProvider),
  );
});

final policyReminderLocalDataSourceProvider =
    Provider<PolicyReminderLocalDataSource>((ref) {
  return InMemoryPolicyReminderLocalDataSource();
});

final notificationGatewayProvider = Provider<NotificationGateway>((ref) {
  return NoOpNotificationGateway();
});

final policyReminderRepositoryProvider =
    Provider<PolicyReminderRepository>((ref) {
  return PolicyReminderRepositoryImpl(
    ref.watch(policyReminderLocalDataSourceProvider),
  );
});

final policyReminderServiceProvider = Provider<PolicyReminderService>((ref) {
  return PolicyReminderService(
    repository: ref.watch(policyReminderRepositoryProvider),
    notificationGateway: ref.watch(notificationGatewayProvider),
    eventBus: ref.read(policyEventBusProvider.notifier),
    scheduler: ref.watch(policyReminderSchedulerProvider),
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

final policyDetailProvider =
    StateNotifierProvider.family<PolicyDetailController, AsyncValue<Policy>, String>(
  (ref, policyId) => PolicyDetailController(
    ref: ref,
    policyId: policyId,
  ),
);

final policyReminderControllerProvider = StateNotifierProvider.family<
    PolicyReminderController, AsyncValue<PolicyReminder?>, String>(
  (ref, policyId) => PolicyReminderController(
    ref: ref,
    policyId: policyId,
  ),
);

final policyActionControllerProvider = StateNotifierProvider.family<
    PolicyActionController, PolicyActionState, String>(
  (ref, policyId) => PolicyActionController(
    ref: ref,
    policyId: policyId,
  ),
);

final policyReminderStatusProvider =
    Provider.family<PolicyReminderStatus?, String>((ref, policyId) {
  final reminderState = ref.watch(policyReminderControllerProvider(policyId));
  return reminderState.maybeWhen(
    data: (reminder) => reminder?.status,
    orElse: () => null,
  );
});

final notificationCenterControllerProvider = StateNotifierProvider<
    NotificationCenterController, AsyncValue<NotificationCenterState>>(
  (ref) => NotificationCenterController(ref: ref),
);

final policyQueryProvider = Provider.family<PolicyQuery, PolicyFeedType>(
  (ref, feedType) {
    // dependencies to rebuild query on changes
    ref.watch(policyFilterUiStateProvider);
    ref.watch(userProfileProvider);
    ref.watch(policyBehaviorTrackerProvider);
    ref.watch(favoriteIdsProvider);
    ref.watch(compareRepositoryProvider);

    final orchestrator = ref.read(policyQueryOrchestratorProvider);
    return orchestrator.buildQuery(feedType);
  },
);
