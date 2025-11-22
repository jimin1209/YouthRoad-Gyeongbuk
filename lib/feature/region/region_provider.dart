import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/prefs_keys.dart';
import '../../core/utils/shared_prefs_provider.dart';
import 'region_model.dart';

class RegionNotifier extends StateNotifier<Region?> {
  RegionNotifier(this._ref) : super(null) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    final saved = prefs.getString(PrefsKeys.lastSelectedRegionCode);
    if (saved == null || saved.isEmpty) {
      state = regionAll;
      return;
    }
    final Region? region = gyeongbukRegions.firstWhere(
      (r) => r.code == saved,
      orElse: () => regionAll,
    );
    state = region;
  }

  Future<void> selectRegion(Region region) async {
    state = region;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setString(PrefsKeys.lastSelectedRegionCode, region.code);
  }

  Future<void> clear() async {
    state = regionAll;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.remove(PrefsKeys.lastSelectedRegionCode);
  }
}

final selectedRegionProvider = StateNotifierProvider<RegionNotifier, Region?>(
  (ref) => RegionNotifier(ref),
);

final regionListProvider = Provider<List<Region>>((ref) {
  return [regionAll, ...gyeongbukRegions];
});
