// FILE: lib/data/search/repositories/search_suggestion_repository_impl.dart

import '../../../domain/search/entities/search_suggestion.dart';
import '../../../domain/search/repositories/search_suggestion_repository.dart';
import '../models/search_suggestion_model.dart';
import '../sources/local/search_history_local_source.dart';

class SearchSuggestionRepositoryImpl implements SearchSuggestionRepository {
  SearchSuggestionRepositoryImpl(this._historyLocalSource);

  final SearchHistoryLocalSource _historyLocalSource;

  @override
  Future<List<SearchSuggestion>> fetchSuggestions(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return const [];

    final history = await _historyLocalSource.fetchHistory();
    final matchedHistory = history
        .where((entry) => entry.query.contains(normalized))
        .map((entry) => SearchSuggestionModel(
              text: entry.query,
              source: 'history',
            ))
        .toList();

    final combined = <SearchSuggestionModel>[...matchedHistory];
    final deduped = <String>{};
    final suggestions = <SearchSuggestion>[];
    for (final suggestion in combined) {
      if (deduped.add(suggestion.text)) {
        suggestions.add(suggestion.toDomain());
      }
    }
    return suggestions;
  }
}
