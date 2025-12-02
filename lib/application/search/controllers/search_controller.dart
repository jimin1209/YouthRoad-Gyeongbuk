// FILE: lib/application/search/controllers/search_controller.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/search/entities/search_category.dart';
import '../../../domain/search/entities/search_query.dart';
import '../../../domain/search/entities/search_result_item.dart';
import '../../../domain/search/usecases/execute_search.dart';
import '../../../domain/search/usecases/save_search_history_entry.dart';
import '../providers.dart';

enum SearchStatus { idle, loading, success, empty, error }

class SearchState {
  const SearchState({
    this.query = const SearchQuery(text: ''),
    this.results = const [],
    this.status = SearchStatus.idle,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final SearchQuery query;
  final List<SearchResultItem> results;
  final SearchStatus status;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  SearchState copyWith({
    SearchQuery? query,
    List<SearchResultItem>? results,
    SearchStatus? status,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage = _noUpdate,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage == _noUpdate ? this.errorMessage : errorMessage,
    );
  }

  static const _noUpdate = Object();
}

class SearchController extends AutoDisposeNotifier<SearchState> {
  static const _debounceDuration = Duration(milliseconds: 350);
  Timer? _debounce;

  ExecuteSearch get _executeSearch => ref.read(executeSearchProvider);
  SaveSearchHistoryEntry get _saveHistory => ref.read(saveSearchHistoryProvider);

  @override
  SearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const SearchState();
  }

  void updateQuery(String query) {
    final newQuery = state.query.copyWith(text: query, page: 1);
    state = state.copyWith(
      query: newQuery,
      status: SearchStatus.idle,
      hasMore: false,
      isLoadingMore: false,
      errorMessage: null,
    );
    _scheduleSearch();
  }

  void setCategory(SearchCategory category) {
    final newQuery = state.query.copyWith(category: category, page: 1);
    state = state.copyWith(
      query: newQuery,
      status: SearchStatus.idle,
      results: const [],
      hasMore: false,
      isLoadingMore: false,
    );
    _scheduleSearch();
  }

  Future<void> refresh() async {
    await _runSearch(page: 1);
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isLoadingMore) return;
    await _runSearch(page: state.query.page + 1, append: true);
  }

  void _scheduleSearch() {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      unawaited(_runSearch(page: 1));
    });
  }

  Future<void> _runSearch({required int page, bool append = false}) async {
    final targetQuery = state.query.copyWith(page: page);
    if (targetQuery.isEmpty) {
      state = state.copyWith(
        status: SearchStatus.idle,
        results: const [],
        hasMore: false,
        isLoadingMore: false,
      );
      return;
    }

    if (append) {
      state = state.copyWith(isLoadingMore: true, errorMessage: null);
    } else {
      state = state.copyWith(
        status: SearchStatus.loading,
        query: targetQuery,
        errorMessage: null,
        hasMore: false,
        isLoadingMore: false,
      );
    }

    try {
      final result = await _executeSearch(targetQuery);
      final updatedItems = append
          ? [...state.results, ...result.items]
          : result.items;
      final nextStatus = updatedItems.isEmpty
          ? SearchStatus.empty
          : SearchStatus.success;

      state = state.copyWith(
        query: result.query,
        results: updatedItems,
        status: append ? state.status : nextStatus,
        hasMore: result.hasMore,
        isLoadingMore: false,
        errorMessage: null,
      );

      if (!append && result.query.text.isNotEmpty) {
        await _saveHistory(result.query.text);
      }
    } catch (e, st) {
      debugPrint('[SearchController] search failed: $e\n$st');
      state = state.copyWith(
        status: append ? state.status : SearchStatus.error,
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }
}
