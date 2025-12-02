// FILE: lib/data/search/models/search_suggestion_model.dart

import '../../../domain/search/entities/search_suggestion.dart';

class SearchSuggestionModel {
  const SearchSuggestionModel({required this.text, this.source});

  final String text;
  final String? source;

  SearchSuggestion toDomain() {
    return SearchSuggestion(text: text, source: source);
  }

  factory SearchSuggestionModel.fromDomain(SearchSuggestion suggestion) {
    return SearchSuggestionModel(text: suggestion.text, source: suggestion.source);
  }
}
