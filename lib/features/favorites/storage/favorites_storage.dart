import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const _key = 'favorite_policies';

  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? <String>[];
  }

  Future<void> toggle(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? <String>[];
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    await prefs.setStringList(_key, current);
  }
}
