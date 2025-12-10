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
