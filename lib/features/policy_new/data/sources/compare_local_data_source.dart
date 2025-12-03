import 'package:shared_preferences/shared_preferences.dart';

class CompareLocalDataSource {
  CompareLocalDataSource(this.prefs);

  final SharedPreferences prefs;

  static const _compareIdsKey = 'policy_compare_ids';

  List<String> loadIds() {
    return prefs.getStringList(_compareIdsKey) ?? <String>[];
  }

  Future<void> saveIds(List<String> ids) async {
    await prefs.setStringList(_compareIdsKey, ids);
  }

  Future<void> clear() async {
    await prefs.remove(_compareIdsKey);
  }
}
