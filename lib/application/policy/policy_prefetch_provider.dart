// FILE: lib/application/policy/policy_prefetch_provider.dart
// 앱 실행 직후 캐시 상태를 확인하고, 비어 있다면 전체 정책을 백그라운드에서
// 받아오는 Provider. UI 스레드는 절대 블로킹하지 않도록 remote fetch를
// 기다리지 않고 즉시 반환한다.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/policy_repository.dart';
import '../di.dart';

final policyPrefetchProvider =
    AsyncNotifierProvider.autoDispose<PolicyPrefetchNotifier, void>(
  PolicyPrefetchNotifier.new,
);

class PolicyPrefetchNotifier extends AutoDisposeAsyncNotifier<void> {
  PolicyRepository get _repository => ref.read(policyRepositoryInterfaceProvider);

  bool _started = false;

  @override
  Future<void> build() async {
    // build에서 바로 시작하되, 호출자는 결과를 기다릴 필요가 없다.
    _startPrefetchIfNeeded();
  }

  /// 외부에서 명시적으로 프리패치를 요청할 때 사용하는 메서드.
  Future<void> prefetchPolicies() async {
    _startPrefetchIfNeeded();
  }

  void _startPrefetchIfNeeded() {
    if (_started) return;
    _started = true;

    // 비동기로 진행하여 UI를 블로킹하지 않는다.
    unawaited(_prefetch());
  }

  Future<void> _prefetch() async {
    // 두 단계: 캐시 확인 -> 필요 시 원격 전체 로딩
    state = const AsyncLoading();

    try {
      final cached = await _repository.loadCachedPolicies();
      if (cached.isNotEmpty) {
        // 캐시에 데이터가 있으면 더 이상의 원격 로딩 없이 종료.
        state = const AsyncData(null);
        return;
      }

      final result = await _repository.getPolicies();
      final remoteFuture = result.remoteRefresh;
      if (remoteFuture == null) {
        state = const AsyncData(null);
        return;
      }

      // remote 결과는 백그라운드에서 Isar에 저장되고 자동 반영된다.
      remoteFuture.then((_) {
        if (!ref.mounted) return;
        state = const AsyncData(null);
        debugPrint('[PolicyPrefetchNotifier] remote prefetch completed');
      }).catchError((error, stack) {
        if (!ref.mounted) return;
        debugPrint('[PolicyPrefetchNotifier] remote prefetch failed: $error');
        debugPrint('$stack');
        state = AsyncError(error, stack);
      });
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] cache preload failed: $e\n$st');
      state = AsyncError(e, st);
    }
  }
}
