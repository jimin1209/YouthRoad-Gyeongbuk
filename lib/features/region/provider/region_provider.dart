import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../region_model.dart';

class RegionNotifier extends StateNotifier<Region?> {
  RegionNotifier() : super(null);

  void selectRegionCode(String code) {
    final region = gyeongbukRegions.firstWhere(
      (r) => r.code == code,
      orElse: () => regionAll,
    );
    state = region;
  }
}

final selectedRegionProvider = StateNotifierProvider<RegionNotifier, Region?>(
  (ref) => RegionNotifier(),
);
