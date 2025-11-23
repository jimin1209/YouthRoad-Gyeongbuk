import 'package:shared_preferences/shared_preferences.dart';

class MemoRepository {
  MemoRepository(this._prefs);

  final SharedPreferences _prefs;

  static String _key(String policyId) => 'memo_$policyId';

  Future<void> saveMemo(String policyId, String text) async {
    final key = _key(policyId);
    if (text.isEmpty) {
      await _prefs.remove(key);
      return;
    }
    await _prefs.setString(key, text);
  }

  Future<String?> loadMemo(String policyId) async {
    return _prefs.getString(_key(policyId));
  }

  Future<void> clearMemo(String policyId) async {
    await _prefs.remove(_key(policyId));
  }
}
