import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';

class CompareNotifier extends AutoDisposeAsyncNotifier<List<Policy>> {
  static const _key = 'compare_policies';
  late final SharedPreferences _prefs;
  late final PolicyRepository _repo;

  @override
  Future<List<Policy>> build() async {
    _prefs = ref.read(sharedPreferencesProvider);
    _repo = ref.read(policyRepositoryProvider);
    final ids = _prefs.getStringList(_key) ?? [];
    return _loadPolicies(ids);
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

  Future<void> add(String id) async {
    final currentIds = _prefs.getStringList(_key) ?? [];
    if (currentIds.contains(id)) return;
    currentIds.add(id);
    await _prefs.setStringList(_key, currentIds);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadPolicies(currentIds));
  }

  Future<void> remove(String id) async {
    final currentIds = _prefs.getStringList(_key) ?? []..remove(id);
    await _prefs.setStringList(_key, currentIds);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadPolicies(currentIds));
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
    state = const AsyncData([]);
  }
}
