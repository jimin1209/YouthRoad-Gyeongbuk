// FILE: lib/domain/search/usecases/get_search_history.dart

import '../entities/search_history_entry.dart';
import '../repositories/search_history_repository.dart';

class GetSearchHistory {
  const GetSearchHistory(this._repository);

  final SearchHistoryRepository _repository;

  Future<List<SearchHistoryEntry>> call() {
    return _repository.fetchHistory();
  }
}
