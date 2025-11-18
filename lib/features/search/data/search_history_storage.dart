import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryStorage {
  SearchHistoryStorage._(this._prefs);

  static const storageKey = 'recent_search_terms';
  static const limit = 8;

  final SharedPreferences _prefs;

  static Future<SearchHistoryStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SearchHistoryStorage._(prefs);
  }

  List<String> load() {
    return _prefs.getStringList(storageKey) ?? const [];
  }

  Future<void> save(List<String> terms) async {
    await _prefs.setStringList(storageKey, terms);
  }
}
