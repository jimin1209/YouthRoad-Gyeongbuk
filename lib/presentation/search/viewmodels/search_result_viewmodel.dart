// FILE: lib/presentation/search/viewmodels/search_result_viewmodel.dart

import '../../../domain/search/entities/search_category.dart';
import '../../../domain/search/entities/search_result_item.dart';

class SearchResultViewModel {
  const SearchResultViewModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.region,
  });

  final String id;
  final String title;
  final String? subtitle;
  final SearchCategory category;
  final String? region;

  factory SearchResultViewModel.fromDomain(SearchResultItem item) {
    return SearchResultViewModel(
      id: item.id,
      title: item.title,
      subtitle: item.subtitle,
      category: item.category,
      region: item.region,
    );
  }
}
