import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application/di.dart';

const _debugPanelEnabledKey = 'debug_panel_enabled';

class DebugPanelSettingsNotifier extends StateNotifier<bool> {
  DebugPanelSettingsNotifier(this._prefs) : super(_initialValue(_prefs));

  final SharedPreferences _prefs;

  static bool _initialValue(SharedPreferences prefs) {
    if (!kDebugMode) {
      return false;
    }
    return prefs.getBool(_debugPanelEnabledKey) ?? false;
  }

  void setEnabled(bool value) {
    if (!kDebugMode) {
      state = false;
      return;
    }
    state = value;
    _prefs.setBool(_debugPanelEnabledKey, value);
  }

  void toggle() {
    setEnabled(!state);
  }
}

final debugPanelEnabledProvider =
    StateNotifierProvider<DebugPanelSettingsNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DebugPanelSettingsNotifier(prefs);
});
