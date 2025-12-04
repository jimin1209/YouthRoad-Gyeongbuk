import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di.dart';

class FavoritesNotifier extends Notifier<Set<String>> {
  SharedPreferences? _prefs;
  static const _key = 'favorites';

  @override
  Set<String> build() {
    _prefs ??= ref.read(sharedPreferencesProvider);
    final stored = _prefs?.getStringList(_key) ?? [];
    return stored.toSet();
  }

  void toggle(String id) {
    if (state.contains(id)) {
      remove(id);
    } else {
      add(id);
    }
  }

  bool isFavorite(String id) => state.contains(id);

  void add(String id) {
    if (state.contains(id)) return;
    final updated = {...state, id};
    _persist(updated);
    state = updated;
  }

  void remove(String id) {
    if (!state.contains(id)) return;
    final updated = {...state}..remove(id);
    _persist(updated);
    state = updated;
  }

  void clear() {
    if (state.isEmpty) {
      _persist(const <String>{});
      return;
    }
    _persist(const <String>{});
    state = <String>{};
  }

  void _persist(Set<String> ids) {
    final prefs = _prefs ?? ref.read(sharedPreferencesProvider);
    _prefs = prefs;
    prefs.setStringList(_key, ids.toList());
  }
}
