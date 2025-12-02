// FILE: lib/domain/search/repositories/search_history_repository.dart

import '../entities/search_history_entry.dart';

abstract class SearchHistoryRepository {
  Future<List<SearchHistoryEntry>> fetchHistory();

  Future<void> saveQuery(String query);

  Future<void> removeQuery(String query);

  Future<void> clear();
}
