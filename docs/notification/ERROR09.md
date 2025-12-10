lib/debug/debug_panel_host.dart:25:23: Error: This expression has type 'void' and can't be used.
    _enabledSub = ref.listen<bool>(debugPanelEnabledProvider, (prev, next) {
                      ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:117:47: Error: Member not found: 'columnWidth'.
              columnWidth: CompareDiffService.columnWidth,
                                              ^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:158:65: Error: Member not found: 'columnWidth'.
                                columnWidth: CompareDiffService.columnWidth,
                                                                ^^^^^^^^^^^
lib/features/map_v2/kakao_map_controller.dart:489:45: Error: The getter 'ConsoleMessageLevel' isn't defined for the class 'KakaoMapController'.
 - 'KakaoMapController' is from 'package:youth_road_app/features/map_v2/kakao_map_controller.dart' ('lib/features/map_v2/kakao_map_controller.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'ConsoleMessageLevel'.
          final levelTag = message.level == ConsoleMessageLevel.error
                                            ^^^^^^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command '/home/ssm-user/flutter/bin/flutter'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 15s

## 조치 내역
- `ref.listen` 이 반환값이 없는 API라서 구독을 변수에 담을 수 없어 발생한 오류 → `ref.listenManual`로 교체하여 `ProviderSubscription`을 획득하고 `dispose` 시 안전하게 정리하도록 수정.
- 비교 테이블에서 참조하던 `CompareDiffService.columnWidth` 상수가 누락되어 있었음 → 서비스에 `columnWidth` 상수(240.0)를 추가하여 헤더/테이블에서 동일한 폭을 사용하도록 함.
- `WebViewController`의 콘솔 레벨 enum 이름이 변경되어 참조 실패 → `ConsoleMessageLevel` 대신 `JavaScriptConsoleMessageLevel`을 사용하도록 변경하여 콘솔 메시지 레벨 비교가 동작하도록 수정.
