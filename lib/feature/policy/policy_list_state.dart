import '../../core/network/result.dart';
import 'policy_filter.dart';
import '../../data/model/policy_models.dart';

class PolicyListState {
  const PolicyListState({
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.error,
    required this.filter,
    required this.hasNext,
  });

  factory PolicyListState.initial(PolicyFilter filter) => PolicyListState(
        items: const [],
        isLoading: false,
        isLoadingMore: false,
        error: null,
        filter: filter,
        hasNext: false,
      );

  final List<PolicyItem> items;
  final bool isLoading;
  final bool isLoadingMore;
  final AppError? error;
  final PolicyFilter filter;
  final bool hasNext;

  PolicyListState copyWith({
    List<PolicyItem>? items,
    bool? isLoading,
    bool? isLoadingMore,
    AppError? error,
    PolicyFilter? filter,
    bool? hasNext,
  }) {
    return PolicyListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      filter: filter ?? this.filter,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
