// FILE: lib/domain/search/usecases/clear_search_history.dart

import '../repositories/search_history_repository.dart';

class ClearSearchHistory {
  const ClearSearchHistory(this._repository);

  final SearchHistoryRepository _repository;

  Future<void> call() {
    return _repository.clear();
  }
}
