import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/policy.dart';

class PolicyEngagementStorage {
  PolicyEngagementStorage._(this._prefs);

  static const _clickCountsKey = 'policy_click_counts';
  static const _recentPoliciesKey = 'recent_policies';
  static const recentLimit = 10;

  final SharedPreferences _prefs;

  static Future<PolicyEngagementStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PolicyEngagementStorage._(prefs);
  }

  Map<String, int> loadClickCounts() {
    final raw = _prefs.getString(_clickCountsKey);
    if (raw == null || raw.isEmpty) {
      return <String, int>{};
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  Future<void> saveClickCounts(Map<String, int> counts) async {
    await _prefs.setString(_clickCountsKey, jsonEncode(counts));
  }

  List<Policy> loadRecentPolicies() {
    final raw = _prefs.getStringList(_recentPoliciesKey) ?? const [];
    return raw
        .map((item) => Policy.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRecentPolicies(List<Policy> policies) async {
    final encoded = policies.map((policy) => jsonEncode(policy.toJson())).toList();
    await _prefs.setStringList(_recentPoliciesKey, encoded);
  }
}
