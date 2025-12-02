import 'package:flutter/foundation.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_failure.dart';

@immutable
class PolicyPagingState {
  final bool isLoading;
  final List<Policy> items;
  final PolicyFailure? failure;
  final bool hasMore;

  const PolicyPagingState({
    required this.isLoading,
    required this.items,
    required this.failure,
    required this.hasMore,
  });

  const PolicyPagingState.initial()
      : isLoading = false,
        items = const [],
        failure = null,
        hasMore = true;

  const PolicyPagingState.loading()
      : isLoading = true,
        items = const [],
        failure = null,
        hasMore = true;

  factory PolicyPagingState.data({
    required List<Policy> items,
    required bool hasMore,
  }) =>
      PolicyPagingState(
        isLoading: false,
        items: items,
        failure: null,
        hasMore: hasMore,
      );

  factory PolicyPagingState.error(PolicyFailure failure) => PolicyPagingState(
        isLoading: false,
        items: const [],
        failure: failure,
        hasMore: false,
      );
}
