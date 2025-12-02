// FILE: lib/data/search/repositories/search_history_repository_impl.dart

import '../../search/sources/local/search_history_local_source.dart';
import '../../../domain/search/entities/search_history_entry.dart';
import '../../../domain/search/repositories/search_history_repository.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  SearchHistoryRepositoryImpl(this._localSource);

  final SearchHistoryLocalSource _localSource;

  @override
  Future<void> clear() {
    return _localSource.clear();
  }

  @override
  Future<List<SearchHistoryEntry>> fetchHistory() async {
    final entries = await _localSource.fetchHistory();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> removeQuery(String query) {
    return _localSource.removeQuery(query);
  }

  @override
  Future<void> saveQuery(String query) {
    return _localSource.saveQuery(query);
  }
}
