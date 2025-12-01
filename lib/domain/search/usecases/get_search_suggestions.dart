// FILE: lib/domain/search/usecases/get_search_suggestions.dart

import '../entities/search_suggestion.dart';
import '../repositories/search_suggestion_repository.dart';

class GetSearchSuggestions {
  const GetSearchSuggestions(this._repository);

  final SearchSuggestionRepository _repository;

  Future<List<SearchSuggestion>> call(String query) {
    return _repository.fetchSuggestions(query);
  }
}
