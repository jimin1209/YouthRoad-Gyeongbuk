// FILE: lib/application/policy/policy_providers.dart
// 정책 관련 Provider 모음. 앱 기동 시 [policyBootstrapProvider] 를 읽으면
// 캐시 우선 UI 렌더링 + 백그라운드 프리패치 흐름이 자동으로 시작된다.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'policy_list_notifier.dart';
import 'policy_prefetch_provider.dart';

export 'policy_list_notifier.dart'
    show policyListNotifierProvider, PolicyListNotifier, PolicyListState;
export 'policy_prefetch_provider.dart'
    show policyPrefetchProvider, PolicyPrefetchNotifier;

/// 앱이 시작될 때 한번 읽어두면 정책 데이터의 프리패치를 즉시 시도한다.
/// UI는 절대 블로킹되지 않고, 캐시가 이미 존재하면 조용히 종료된다.
final policyBootstrapProvider = Provider<void>((ref) {
  // Provider가 생성되는 시점에 프리패치 Notifier를 초기화한다.
  ref.read(policyPrefetchProvider);
});
