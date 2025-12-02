// FILE: lib/domain/search/entities/search_suggestion.dart

class SearchSuggestion {
  const SearchSuggestion({required this.text, this.source});

  final String text;
  final String? source;
}
