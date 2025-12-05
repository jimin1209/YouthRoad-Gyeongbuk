import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart' as app_di;
import '../domain/youthcenter/paging_entity.dart';
import '../domain/youthcenter/policy_entity.dart';
import '../domain/youthcenter/policy_search_query.dart';
import '../domain/youthcenter/repositories/center_repository.dart';
import '../domain/youthcenter/repositories/content_repository.dart';
import '../domain/youthcenter/repositories/policy_repository.dart';
import '../domain/youthcenter/youth_center_entity.dart';
import '../domain/youthcenter/youth_content_entity.dart';
import '../data/cache/policy_local_cache.dart';
import '../data/repositories/youthcenter/center_repository_impl.dart';
import '../data/repositories/youthcenter/content_repository_impl.dart';
import '../data/repositories/youthcenter/policy_repository_impl.dart';
import '../data/sources/youthcenter/youth_center_remote_source.dart';
import '../data/sources/youthcenter/youth_content_remote_source.dart';
import '../data/sources/youthcenter/youth_policy_remote_source.dart';

final youthcenterDioProvider = Provider<Dio>((ref) {
  return Dio();
});

final policySearchQueryProvider =
    StateProvider<PolicySearchQuery>((ref) => const PolicySearchQuery());

final youthPolicyRemoteSourceProvider = Provider((ref) {
  return YouthPolicyRemoteSource(ref.watch(youthcenterDioProvider));
});

final youthContentRemoteSourceProvider = Provider((ref) {
  return YouthContentRemoteSource(ref.watch(youthcenterDioProvider));
});

final youthCenterRemoteSourceProvider = Provider((ref) {
  return YouthCenterRemoteSource(ref.watch(youthcenterDioProvider));
});

final youthPolicyCacheProvider = Provider((ref) {
  final prefs = ref.watch(app_di.sharedPreferencesProvider);
  return PolicyLocalCache(prefs);
});

final youthPolicyRepositoryProvider = Provider<PolicyRepository>((ref) {
  return PolicyRepositoryImpl(
    remoteSource: ref.watch(youthPolicyRemoteSourceProvider),
    cache: ref.watch(youthPolicyCacheProvider),
  );
});

final youthContentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepositoryImpl(ref.watch(youthContentRemoteSourceProvider));
});

final youthCenterRepositoryProvider = Provider<CenterRepository>((ref) {
  return CenterRepositoryImpl(ref.watch(youthCenterRemoteSourceProvider));
});

final policyListProvider =
    FutureProvider.autoDispose<(List<PolicyEntity>, PagingEntity)>((ref) async {
  final repository = ref.watch(youthPolicyRepositoryProvider);
  final query = ref.watch(policySearchQueryProvider);
  final cancelToken = CancelToken();

  ref.onDispose(() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel('disposed');
      debugPrint('[PROVIDER-DISPOSE:CANCELLED] pending requests for youth policies');
    }
  });

  return repository.getPolicies(query, cancelToken: cancelToken);
});

final contentFeedProvider =
    FutureProvider.autoDispose<(List<YouthContentEntity>, PagingEntity?)>((ref) async {
  final repository = ref.watch(youthContentRepositoryProvider);
  final page = ref.watch(_contentPageProvider);
  final cancelToken = CancelToken();

  ref.onDispose(() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel('disposed');
      debugPrint('[PROVIDER-DISPOSE:CANCELLED] pending requests for youth contents');
    }
  });

  return repository.getContents(
    page,
    cancelToken: cancelToken,
  );
});

final _contentPageProvider = StateProvider<int>((ref) => 1);

final centerProvider =
    FutureProvider.autoDispose<List<YouthCenterEntity>>((ref) async {
  final repository = ref.watch(youthCenterRepositoryProvider);
  final cancelToken = CancelToken();

  ref.onDispose(() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel('disposed');
      debugPrint('[PROVIDER-DISPOSE:CANCELLED] pending requests for youth centers');
    }
  });

  return repository.getCenters(cancelToken: cancelToken);
});
