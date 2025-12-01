// FILE: lib/domain/search/usecases/execute_search.dart

import '../entities/search_query.dart';
import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

class ExecuteSearch {
  const ExecuteSearch(this._repository);

  final SearchRepository _repository;

  Future<SearchResult> call(SearchQuery query) {
    return _repository.search(query);
  }
}
