// FILE: lib/domain/search/entities/search_query.dart

import 'search_category.dart';

class SearchQuery {
  const SearchQuery({
    required this.text,
    this.category = SearchCategory.all,
    this.page = 1,
    this.pageSize = 20,
    this.region,
    this.useLocalIndex = true,
  });

  final String text;
  final SearchCategory category;
  final int page;
  final int pageSize;
  final String? region;
  final bool useLocalIndex;

  SearchQuery copyWith({
    String? text,
    SearchCategory? category,
    int? page,
    int? pageSize,
    String? region = _noValue,
    bool? useLocalIndex,
  }) {
    return SearchQuery(
      text: text ?? this.text,
      category: category ?? this.category,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      region: region == _noValue ? this.region : region,
      useLocalIndex: useLocalIndex ?? this.useLocalIndex,
    );
  }

  bool get isEmpty => text.trim().isEmpty;

  static const _noValue = Object();
}
