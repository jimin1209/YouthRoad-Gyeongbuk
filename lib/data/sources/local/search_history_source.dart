import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/di.dart';
import '../../models/search_history_model.dart';

class SearchHistorySource {
  SearchHistorySource(this._prefs);

  final SharedPreferences _prefs;
  static const String _storageKey = 'search_history';
  static const int _maxItems = 10;
  static const int _popularLimit = 5;

  Future<List<SearchHistory>> fetchHistory() async {
    try {
      final raw = _prefs.getString(_storageKey);
      final list = SearchHistory.decodeList(raw);
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    } catch (e) {
      debugPrint('Failed to load search history: $e');
      return const [];
    }
  }

  Future<List<String>> fetchTopKeywords({int limit = _popularLimit}) async {
    final history = await fetchHistory();
    if (history.isEmpty) return const [];

    final counts = <String, int>{};
    final latestAt = <String, DateTime>{};
    for (final entry in history) {
      final normalized = entry.query.trim();
      if (normalized.isEmpty) continue;
      counts.update(normalized, (value) => value + 1, ifAbsent: () => 1);
      final currentLatest = latestAt[normalized];
      if (currentLatest == null || entry.timestamp.isAfter(currentLatest)) {
        latestAt[normalized] = entry.timestamp;
      }
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) {
        final countCompare = b.value.compareTo(a.value);
        if (countCompare != 0) return countCompare;
        final latestA = latestAt[a.key];
        final latestB = latestAt[b.key];
        if (latestA == null && latestB == null) return 0;
        if (latestA == null) return 1;
        if (latestB == null) return -1;
        return latestB.compareTo(latestA);
      });

    return sorted.take(limit).map((e) => e.key).toList();
  }

  Future<void> saveQuery(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return;
    final current = await fetchHistory();
    final filtered = current.where((e) => e.query != normalized).toList();
    filtered.insert(
      0,
      SearchHistory(query: normalized, timestamp: DateTime.now()),
    );
    final limited = filtered.take(_maxItems).toList();
    await _prefs.setString(_storageKey, SearchHistory.encodeList(limited));
  }
}

final searchHistorySourceProvider = Provider<SearchHistorySource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SearchHistorySource(prefs);
});

final searchHistoryListProvider =
    FutureProvider.autoDispose<List<SearchHistory>>((ref) async {
  final source = ref.watch(searchHistorySourceProvider);
  return source.fetchHistory();
});

final popularSearchKeywordListProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final source = ref.watch(searchHistorySourceProvider);
  return source.fetchTopKeywords();
});
