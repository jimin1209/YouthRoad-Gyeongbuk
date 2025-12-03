import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/policy_repository.dart';
import '../../features/policy/providers/policy_list_provider.dart';
import '../di.dart';
import '../notifiers/policy_paging_notifier.dart';
import 'policy_paging_provider.dart';

final policyPrefetchProvider =
    AsyncNotifierProvider<PolicyPrefetchNotifier, void>(
  PolicyPrefetchNotifier.new,
);

class PolicyPrefetchNotifier extends AsyncNotifier<void> {
  PolicyRepository get _repository => ref.read(policyRepositoryInterfaceProvider);

  PolicyFeedsNotifier get _pagingNotifier =>
      ref.read(policyPagingProvider.notifier);

  PolicyListNotifier get _listNotifier => ref.read(policyListProvider.notifier);

  @override
  FutureOr<void> build() {
    // 초기 로직이 필요 없으면 비워둔다
  }

  Future<void> prefetchPolicies() async {
    // 이미 prefetch 중이면 중복 실행 방지
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    _listNotifier.setLoading();

    // 1) 캐시 우선 로드
    try {
      final cached = await _repository.loadCachedPolicies(
        filter: _pagingNotifier.currentFilter,
      );

      if (cached.isNotEmpty) {
        _pagingNotifier.seedFromCache(cached);
        _listNotifier.setPolicies(cached);
      } else {
        _listNotifier.clear();
      }
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] cache preload failed: $e\n$st');
      _listNotifier.setError(e, st);
    }

    // 2) 원격 최신 데이터로 갱신
    try {
      final remote = await _repository.refreshPolicies(
        filter: _pagingNotifier.currentFilter,
      );
      _pagingNotifier.replaceWithFresh(remote);
      _listNotifier.setPolicies(remote);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] remote prefetch failed: $e\n$st');
      _listNotifier.setError(e, st);
      state = AsyncValue.error(e, st);
    }
  }
}
