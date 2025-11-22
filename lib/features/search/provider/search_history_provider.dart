import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super(const []) {
    _load();
  }

  static const _key = 'search_history';
  static const _max = 20;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList(_key) ?? <String>[];
  }

  Future<void> add(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? <String>[];
    final updated = [trimmed, ...current.where((e) => e != trimmed)].take(_max).toList();
    await prefs.setStringList(_key, updated);
    state = updated;
  }

  Future<void> remove(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? <String>[];
    current.remove(keyword);
    await prefs.setStringList(_key, current);
    state = current;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = const [];
  }
}

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>(
  (ref) => SearchHistoryNotifier(),
);
