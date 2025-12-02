// FILE: lib/data/search/sources/local/search_history_local_source.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/search_history_entry_model.dart';

class SearchHistoryLocalSource {
  SearchHistoryLocalSource(this._prefs);

  final SharedPreferences _prefs;
  static const String _storageKey = 'search_history_v2';
  static const int _maxItems = 20;

  Future<List<SearchHistoryEntryModel>> fetchHistory() async {
    try {
      final raw = _prefs.getString(_storageKey);
      final list = SearchHistoryEntryModel.decodeList(raw);
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    } catch (e, st) {
      debugPrint('[SearchHistoryLocalSource] load failed: $e\n$st');
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
      SearchHistoryEntryModel(
        query: normalized,
        timestamp: DateTime.now(),
      ),
    );
    final limited = filtered.take(_maxItems).toList();
    await _prefs.setString(
      _storageKey,
      SearchHistoryEntryModel.encodeList(limited),
    );
  }

  Future<void> removeQuery(String query) async {
    final normalized = query.trim();
    final current = await fetchHistory();
    final filtered = current.where((e) => e.query != normalized).toList();
    await _prefs.setString(
      _storageKey,
      SearchHistoryEntryModel.encodeList(filtered),
    );
  }

  Future<void> clear() async {
    await _prefs.remove(_storageKey);
  }
}
