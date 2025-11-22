import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

/// Unity 준비 상태를 관리하여 준비 전에 메시지 전송을 막기 위한 헬퍼.
final unityReadyProvider = StateProvider<bool>((_) => false);

class UnityInitFix {
  UnityInitFix(this.ref);
  final WidgetRef ref;

  void onCreated(UnityWidgetController controller) {
    ref.read(unityReadyProvider.notifier).state = true;
    // 컨트롤러 보관/활용은 외부에서 처리
  }

  bool get isReady => ref.read(unityReadyProvider);
}
