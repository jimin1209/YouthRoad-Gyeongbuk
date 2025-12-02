// FILE: lib/domain/search/repositories/search_suggestion_repository.dart

import '../entities/search_suggestion.dart';

abstract class SearchSuggestionRepository {
  Future<List<SearchSuggestion>> fetchSuggestions(String query);
}
