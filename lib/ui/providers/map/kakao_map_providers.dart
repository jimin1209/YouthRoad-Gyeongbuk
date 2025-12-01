import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/env.dart';
import '../../controllers/map/kakao_map_controller.dart';
import '../../screens/map/kakao_map_html_builder.dart';

final kakaoMapHtmlBuilderProvider = Provider<KakaoMapHtmlBuilder>(
  (ref) => const KakaoMapHtmlBuilder(),
);

final kakaoMapControllerProvider = Provider.autoDispose<KakaoMapController>((ref) {
  final builder = ref.watch(kakaoMapHtmlBuilderProvider);
  final controller = KakaoMapController(
    apiKey: Env.kakaoMapApiKey,
    builder: builder,
  );
  ref.onDispose(controller.dispose);
  return controller;
});
