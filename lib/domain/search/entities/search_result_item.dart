// FILE: lib/domain/search/entities/search_result_item.dart

import 'search_category.dart';

class SearchResultItem {
  const SearchResultItem({
    required this.id,
    required this.title,
    required this.category,
    this.subtitle,
    this.region,
    this.latitude,
    this.longitude,
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String? subtitle;
  final SearchCategory category;
  final String? region;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic> metadata;
}
