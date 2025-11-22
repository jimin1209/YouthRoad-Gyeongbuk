import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../policy/provider/policy_list_provider.dart';
import '../../region/provider/region_provider.dart';

/// 지도 선택 이벤트를 정책 필터와 현재 지역에 반영하는 컨트롤러.
class MapController {
  MapController(this.ref);

  final Ref ref;

  void onRegionSelected(String regionCode) {
    // 지역 상태 반영
    ref.read(selectedRegionProvider.notifier).selectRegionCode(regionCode);
    // 정책 필터 적용
    ref.read(policyListProvider.notifier).setRegion(regionCode);
  }
}

final mapControllerProvider = Provider<MapController>((ref) {
  return MapController(ref);
});
