// FILE: lib/domain/search/usecases/remove_search_history_entry.dart

import '../repositories/search_history_repository.dart';

class RemoveSearchHistoryEntry {
  const RemoveSearchHistoryEntry(this._repository);

  final SearchHistoryRepository _repository;

  Future<void> call(String query) {
    return _repository.removeQuery(query);
  }
}
