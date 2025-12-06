import 'package:flutter/foundation.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_failure.dart';

@immutable
class PolicyPagingState {
  final bool isLoading;
  final List<Policy> currentResults;
  final List<Policy>? previousResults;
  final PolicyFailure? failure;
  final bool hasMore;

  const PolicyPagingState({
    required this.isLoading,
    required this.currentResults,
    required this.previousResults,
    required this.failure,
    required this.hasMore,
  });

  const PolicyPagingState.initial()
      : isLoading = false,
        currentResults = const [],
        previousResults = null,
        failure = null,
        hasMore = true;

  const PolicyPagingState.loading({List<Policy>? previousResults})
      : isLoading = true,
        currentResults = previousResults ?? const [],
        previousResults = previousResults,
        failure = null,
        hasMore = true;

  factory PolicyPagingState.data({
    required List<Policy> items,
    required bool hasMore,
  }) =>
      PolicyPagingState(
        isLoading: false,
        currentResults: items,
        previousResults: null,
        failure: null,
        hasMore: hasMore,
      );

  factory PolicyPagingState.error(
    PolicyFailure failure, {
    List<Policy>? previousResults,
  }) =>
      PolicyPagingState(
        isLoading: false,
        currentResults: previousResults ?? const [],
        previousResults: null,
        failure: failure,
        hasMore: false,
      );

  List<Policy> get visibleItems =>
      currentResults.isNotEmpty ? currentResults : (previousResults ?? const []);
}
