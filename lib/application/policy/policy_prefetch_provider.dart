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
    _startPrefetchIfNeeded();
  }

  Future<void> prefetchPolicies() async {
    _startPrefetchIfNeeded();
  }

  void _startPrefetchIfNeeded() {
    if (_started) return;
    _started = true;

    unawaited(_prefetch());
  }

  Future<void> _prefetch() async {
    state = const AsyncLoading();

    try {
      final cached = await _repository.loadCachedPolicies();
      if (cached.isNotEmpty) {
        state = const AsyncData(null);
        return;
      }

      final result = await _repository.getPolicies();
      final remoteFuture = result.remoteRefresh;
      if (remoteFuture == null) {
        state = const AsyncData(null);
        return;
      }

      remoteFuture.then((_) {
        if (!mounted) return;
        state = const AsyncData(null);
        debugPrint('[PolicyPrefetchNotifier] remote prefetch completed');
      }).catchError((error, stack) {
        if (!mounted) return;
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
