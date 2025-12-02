// FILE: lib/application/search/controllers/search_suggestion_controller.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/search/entities/search_suggestion.dart';
import '../../../domain/search/usecases/get_search_suggestions.dart';
import '../providers.dart';

class SearchSuggestionController
    extends AutoDisposeAsyncNotifier<List<SearchSuggestion>> {
  static const _debounceDuration = Duration(milliseconds: 300);
  Timer? _debounce;

  GetSearchSuggestions get _getSearchSuggestions =>
      ref.read(getSearchSuggestionsProvider);

  @override
  FutureOr<List<SearchSuggestion>> build() {
    ref.onDispose(() => _debounce?.cancel());
    return const [];
  }

  void request(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }

    _debounce = Timer(_debounceDuration, () async {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        try {
          return await _getSearchSuggestions(query);
        } catch (e, st) {
          debugPrint('[SearchSuggestionController] failed: $e\n$st');
          rethrow;
        }
      });
    });
  }
}
