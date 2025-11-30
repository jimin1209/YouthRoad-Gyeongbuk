import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';

class CompareNotifier extends AsyncNotifier<List<Policy>> {
  static const _key = 'compare';
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);
  PolicyRepository get _repo => ref.read(policyRepositoryInterfaceProvider);

  @override
  Future<List<Policy>> build() async {
    final ids = _prefs.getStringList(_key) ?? [];
    final normalized = _normalize(ids);
    if (normalized.length != ids.length) {
      await _prefs.setStringList(_key, normalized);
    }
    return _loadPolicies(normalized);
  }

  Future<List<Policy>> _loadPolicies(List<String> ids) async {
    final list = <Policy>[];
    for (final id in ids) {
      try {
        final p = await _repo.fetchPolicyById(id);
        list.add(p);
      } catch (_) {
        // ignore broken ids
      }
    }
    return list;
  }

  List<String> _normalize(List<String> ids) {
    final unique = <String>[];
    for (final id in ids) {
      if (!unique.contains(id)) {
        unique.add(id);
      }
    }
    while (unique.length > 2) {
      unique.removeAt(0);
    }
    return unique;
  }

  Future<void> toggle(String id) async {
    final currentIds = _prefs.getStringList(_key) ?? [];
    final updated = List<String>.from(currentIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    await _persistAndReload(updated);
  }

  Future<void> add(String id) async {
    final currentIds = _prefs.getStringList(_key) ?? [];
    if (currentIds.contains(id)) return;
    final updated = [...currentIds, id];
    await _persistAndReload(updated);
  }

  Future<void> remove(String id) async {
    final currentIds = _prefs.getStringList(_key) ?? [];
    final updated = List<String>.from(currentIds)..remove(id);
    await _persistAndReload(updated);
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
    state = const AsyncData([]);
  }

  Future<void> _persistAndReload(List<String> ids) async {
    final normalized = _normalize(ids);
    await _prefs.setStringList(_key, normalized);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadPolicies(normalized));
  }
}
