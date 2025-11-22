import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:go_router/go_router.dart';

import '../../features/map/controller/unity_init_fix.dart';
import '../../features/map/ui/unity_message_handler.dart';
import 'unity_map_controller.dart';

final unityMapControllerProvider = Provider<UnityMapController>((ref) {
  return UnityMapController();
});

class YouthUnityMapView extends ConsumerStatefulWidget {
  const YouthUnityMapView({super.key});

  @override
  ConsumerState<YouthUnityMapView> createState() => _YouthUnityMapViewState();
}

class _YouthUnityMapViewState extends ConsumerState<YouthUnityMapView> {
  @override
  Widget build(BuildContext context) {
    final handler = ref.read(unityMessageHandlerProvider);
    final initFix = UnityInitFix(ref);
    return UnityWidget(
      onUnityCreated: (controller) {
        // Unity 준비 상태 설정 후 컨트롤러 부착
        initFix.onCreated(controller);
        ref.read(unityMapControllerProvider).attach(controller);
        // 초기 포커스/로그용 메시지 (렌더 실패 대비)
        controller.postMessage('MapManager', 'OnFlutterMessage', '{"event":"ping"}')?.catchError((_) {});
      },
      onUnityMessage: (message) {
        handler.handle(message);
        // 메시지 수신 시 렌더 확인을 위해 로그 출력
        debugPrint('Unity message: $message');
        if (mounted) {
          context.go('/policy/list');
        }
      },
      onUnitySceneLoaded: (scene) {
        // 씬 로드 후 resume 보장
        debugPrint('Unity scene loaded: ${scene?.name}');
      },
    );
  }
}
