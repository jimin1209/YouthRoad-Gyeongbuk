import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di.dart';

final regionProvider =
    NotifierProvider.autoDispose<RegionNotifier, String?>(RegionNotifier.new);

class RegionNotifier extends AutoDisposeNotifier<String?> {
  static const _key = 'selected_region';
  SharedPreferences? _prefs;

  @override
  String? build() {
    _prefs ??= ref.read(sharedPreferencesProvider);
    return _prefs?.getString(_key);
  }

  void select(String region) {
    final prefs = _prefs ?? ref.read(sharedPreferencesProvider);
    _prefs = prefs;
    prefs.setString(_key, region);
    state = region;
  }

  void clear() {
    final prefs = _prefs ?? ref.read(sharedPreferencesProvider);
    _prefs = prefs;
    prefs.remove(_key);
    state = null;
  }
}
