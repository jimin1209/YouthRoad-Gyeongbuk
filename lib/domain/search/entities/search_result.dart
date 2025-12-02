// FILE: lib/domain/search/entities/search_result.dart

import 'search_query.dart';
import 'search_result_item.dart';

class SearchResult {
  const SearchResult({
    required this.query,
    required this.items,
    required this.hasMore,
  });

  final SearchQuery query;
  final List<SearchResultItem> items;
  final bool hasMore;

  SearchResult copyWith({
    SearchQuery? query,
    List<SearchResultItem>? items,
    bool? hasMore,
  }) {
    return SearchResult(
      query: query ?? this.query,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
