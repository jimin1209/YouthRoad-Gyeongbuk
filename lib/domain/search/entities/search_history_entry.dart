// FILE: lib/domain/search/entities/search_history_entry.dart

class SearchHistoryEntry {
  const SearchHistoryEntry({
    required this.query,
    required this.timestamp,
  });

  final String query;
  final DateTime timestamp;
}
