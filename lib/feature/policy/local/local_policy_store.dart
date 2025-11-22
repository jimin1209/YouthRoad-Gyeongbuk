import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/prefs_keys.dart';
import '../../../core/utils/shared_prefs_provider.dart';
import '../../../data/model/policy_models.dart';

class LocalPolicyStore {
  const LocalPolicyStore(this._ref);

  final Ref _ref;
  static const int _recentLimit = 20;

  Future<List<PolicyItem>> loadRecent() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    final List<String> raw = prefs.getStringList(PrefsKeys.recentPolicies) ?? <String>[];
    return raw
        .map((json) => PolicyItem.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> loadFavorites() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    return prefs.getStringList(PrefsKeys.favoritePolicies) ?? <String>[];
  }

  Future<void> addRecent(PolicyItem item) async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    final List<PolicyItem> current = await loadRecent();
    final String id = _policyId(item);
    final List<PolicyItem> next = [
      item,
      ...current.where((element) => _policyId(element) != id),
    ];
    final List<PolicyItem> limited = next.take(_recentLimit).toList();
    final List<String> serialized =
        limited.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(PrefsKeys.recentPolicies, serialized);
  }

  Future<void> toggleFavorite(String policyId) async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    final List<String> favorites =
        prefs.getStringList(PrefsKeys.favoritePolicies) ?? <String>[];
    if (favorites.contains(policyId)) {
      favorites.remove(policyId);
    } else {
      favorites.add(policyId);
    }
    await prefs.setStringList(PrefsKeys.favoritePolicies, favorites);
  }

  Future<bool> isFavorite(String policyId) async {
    final favorites = await loadFavorites();
    return favorites.contains(policyId);
  }

  Future<void> clearAll() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.remove(PrefsKeys.recentPolicies);
    await prefs.remove(PrefsKeys.favoritePolicies);
  }

  String _policyId(PolicyItem item) => item.no ?? item.policyNm ?? '';
}

final localPolicyStoreProvider = Provider<LocalPolicyStore>(
  (ref) => LocalPolicyStore(ref),
);
