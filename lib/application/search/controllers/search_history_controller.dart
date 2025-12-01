// FILE: lib/application/search/controllers/search_history_controller.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/search/entities/search_history_entry.dart';
import '../../../domain/search/usecases/clear_search_history.dart';
import '../../../domain/search/usecases/get_search_history.dart';
import '../../../domain/search/usecases/remove_search_history_entry.dart';
import '../providers.dart';

class SearchHistoryState {
  const SearchHistoryState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  final List<SearchHistoryEntry> items;
  final bool isLoading;
  final Object? error;

  SearchHistoryState copyWith({
    List<SearchHistoryEntry>? items,
    bool? isLoading,
    Object? error = _noUpdate,
  }) {
    return SearchHistoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error == _noUpdate ? this.error : error,
    );
  }

  static const _noUpdate = Object();
}

class SearchHistoryController extends AutoDisposeNotifier<SearchHistoryState> {
  GetSearchHistory get _getHistory => ref.read(getSearchHistoryProvider);
  ClearSearchHistory get _clearHistory => ref.read(clearSearchHistoryProvider);
  RemoveSearchHistoryEntry get _removeEntry =>
      ref.read(removeSearchHistoryProvider);

  @override
  SearchHistoryState build() {
    Future.microtask(_load);
    return const SearchHistoryState();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _getHistory();
      state = state.copyWith(
        items: items,
        isLoading: false,
        error: null,
      );
    } catch (e, st) {
      debugPrint('[SearchHistoryController] load failed: $e\n$st');
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> refresh() async {
    await _load();
  }

  Future<void> remove(String query) async {
    await _removeEntry(query);
    await _load();
  }

  Future<void> clear() async {
    await _clearHistory();
    await _load();
  }
}
