import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di.dart';

class FavoritesNotifier extends AutoDisposeNotifier<Set<String>> {
  late final SharedPreferences _prefs;
  static const _key = 'favorite_policies';

  @override
  Set<String> build() {
    _prefs = ref.read(sharedPreferencesProvider);
    final stored = _prefs.getStringList(_key) ?? [];
    return stored.toSet();
  }

  void toggle(String id) {
    final updated = {...state};
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    _persist(updated);
    state = updated;
  }

  bool isFavorite(String id) => state.contains(id);

  void _persist(Set<String> ids) {
    _prefs.setStringList(_key, ids.toList());
  }
}
