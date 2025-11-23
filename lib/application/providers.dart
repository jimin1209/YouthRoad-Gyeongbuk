import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/dept_model.dart';
import '../data/models/inst_model.dart';
import '../data/repositories/dept_repository_impl.dart';
import '../data/repositories/inst_repository_impl.dart';
import '../data/sources/remote/dept_remote_source.dart';
import '../data/sources/remote/inst_remote_source.dart';
import '../domain/repositories/dept_repository.dart';
import '../domain/repositories/inst_repository.dart';
import '../domain/entities/policy.dart';
import 'di.dart';
import 'notifiers/chat_notifier.dart';
import 'notifiers/compare_notifier.dart';
import 'notifiers/favorites_notifier.dart';
import 'notifiers/policy_detail_notifier.dart';
import 'notifiers/policy_list_notifier.dart';
import 'notifiers/policy_paging_notifier.dart';

export 'di.dart';
export 'notifiers/region_notifier.dart' show regionProvider, RegionNotifier;

final policyListNotifierProvider =
    AsyncNotifierProvider.autoDispose<PolicyListNotifier, List<Policy>>(
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

final instRemoteSourceProvider = Provider<InstRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return InstRemoteSource(dio);
});

final instRepositoryProvider = Provider<InstRepository>((ref) {
  final remote = ref.watch(instRemoteSourceProvider);
  return InstRepositoryImpl(remote);
});

final instListProvider =
    AutoDisposeFutureProvider<List<InstModel>>((ref) async {
  final repository = ref.watch(instRepositoryProvider);
  return repository.fetchInstList();
});

final deptRemoteSourceProvider = Provider<DeptRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return DeptRemoteSource(dio);
});

final deptRepositoryProvider = Provider<DeptRepository>((ref) {
  final remote = ref.watch(deptRemoteSourceProvider);
  return DeptRepositoryImpl(remote);
});

final deptListProvider = AutoDisposeFutureProvider.family<List<DeptModel>, String>(
  (ref, instNo) async {
    final repository = ref.watch(deptRepositoryProvider);
    return repository.fetchDeptList(instNo: instNo);
  },
);
