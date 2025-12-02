// FILE: lib/domain/search/usecases/save_search_history_entry.dart

import '../repositories/search_history_repository.dart';

class SaveSearchHistoryEntry {
  const SaveSearchHistoryEntry(this._repository);

  final SearchHistoryRepository _repository;

  Future<void> call(String query) {
    return _repository.saveQuery(query);
  }
}
