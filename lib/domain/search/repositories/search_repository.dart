// FILE: lib/domain/search/repositories/search_repository.dart

import '../entities/search_query.dart';
import '../entities/search_result.dart';

abstract class SearchRepository {
  Future<SearchResult> search(SearchQuery query);
}
