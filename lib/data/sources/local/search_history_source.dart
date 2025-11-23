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
