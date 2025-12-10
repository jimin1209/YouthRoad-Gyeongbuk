import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../env/app_env.dart';
import 'kakao_map_controller.dart';
import 'kakao_map_html_builder.dart';

final kakaoMapHtmlBuilderProvider = Provider<KakaoMapHtmlBuilder>(
  (ref) => const KakaoMapHtmlBuilder(),
);

final kakaoMapOptionsProvider = Provider<KakaoMapOptions>(
  (_) => const KakaoMapOptions(),
);

final kakaoMapAdditionalScriptsProvider = Provider<String?>(
  (_) => null,
);

final kakaoMapEnableClusteringProvider = Provider<bool>(
  (_) => false,
);

final kakaoMapControllerProvider = Provider.autoDispose<KakaoMapController>((ref) {
  final builder = ref.watch(kakaoMapHtmlBuilderProvider);
  final controller = KakaoMapController(
    apiKey: AppEnv.kakaoMapApiKey,
    builder: builder,
    baseUrl: AppEnv.kakaoMapBaseUrl,
  );
  ref.onDispose(controller.dispose);
  return controller;
});
