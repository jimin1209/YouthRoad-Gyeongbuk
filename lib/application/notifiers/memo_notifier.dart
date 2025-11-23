import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di.dart';

class MemoNotifier extends AutoDisposeNotifier<Map<String, String>> {
  static const _key = 'policy_memos';
  late final SharedPreferences _prefs;

  @override
  Map<String, String> build() {
    _prefs = ref.read(sharedPreferencesProvider);
    final json = _prefs.getString(_key);
    if (json == null) return {};
    try {
      final map = Map<String, dynamic>.from(jsonDecode(json) as Map);
      return map.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  void save(String policyId, String memo) {
    final updated = {...state, policyId: memo};
    _prefs.setString(_key, jsonEncode(updated));
    state = updated;
  }

  String? getMemo(String policyId) => state[policyId];
}
