import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di.dart';

class RegionNotifier extends AutoDisposeNotifier<String?> {
  static const _key = 'selected_region';
  late final SharedPreferences _prefs;

  @override
  String? build() {
    _prefs = ref.read(sharedPreferencesProvider);
    return _prefs.getString(_key);
  }

  void select(String region) {
    _prefs.setString(_key, region);
    state = region;
  }

  void clear() {
    _prefs.remove(_key);
    state = null;
  }
}
