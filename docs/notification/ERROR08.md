lib/features/policy_new/presentation/compare/policy_compare_screen.dart:4:8: Error: Error when reading 'lib/features/policy_new/compare/application/providers.dart': No such file or directory
import '../../compare/application/providers.dart';
       ^
lib/features/policy_new/presentation/compare/policy_compare_screen.dart:5:8: Error: Error when reading 'lib/features/policy_new/compare/domain/values/policy_failure.dart': No such file or directory
import '../../compare/domain/values/policy_failure.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:5:8: Error: Error when reading 'lib/features/compare/controllers/compare_diff_service.dart': No such file or directory
import '../../../../compare/controllers/compare_diff_service.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:6:8: Error: Error when reading 'lib/features/compare/models/compare_state.dart': No such file or directory
import '../../../../compare/models/compare_state.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:7:8: Error: Error when reading 'lib/features/compare/presentation/widgets/compare_diff_table_widget.dart': No such file or directory
import '../../../../compare/presentation/widgets/compare_diff_table_widget.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:8:8: Error: Error when reading 'lib/features/compare/presentation/widgets/compare_header_row_widget.dart': No such file or directory
import '../../../../compare/presentation/widgets/compare_header_row_widget.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:9:8: Error: Error when reading 'lib/features/compare/presentation/widgets/compare_summary_highlight.dart': No such file or directory
import '../../../../compare/presentation/widgets/compare_summary_highlight.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:10:8: Error: Error when reading 'lib/features/compare/presentation/widgets/policy_compare_zoom_controls.dart': No such file or directory
import '../../../../compare/presentation/widgets/policy_compare_zoom_controls.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:11:8: Error: Error when reading 'lib/features/ui/components/horizontal_overflow_container.dart': No such file or directory
import '../../../../ui/components/horizontal_overflow_container.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:12:8: Error: Error when reading 'lib/features/ui/theme/app_spacing.dart': No such file or directory
import '../../../../ui/theme/app_spacing.dart';
       ^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:24:9: Error: Type 'CompareState' not found.
  final CompareState state;
        ^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:40:9: Error: Type 'HorizontalOverflowController' not found.
  final HorizontalOverflowController _overflowController =
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/policy_compare_screen.dart:17:34: Error: The getter 'compareRepositoryProvider' isn't defined for the class 'PolicyCompareScreen'.
 - 'PolicyCompareScreen' is from 'package:youth_road_app/features/policy_new/presentation/compare/policy_compare_screen.dart' ('lib/features/policy_new/presentation/compare/policy_compare_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'compareRepositoryProvider'.
    final compareIds = ref.watch(compareRepositoryProvider).ids;
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/policy_compare_screen.dart:18:29: Error: The getter 'compareFeedControllerProvider' isn't defined for the class 'PolicyCompareScreen'.
 - 'PolicyCompareScreen' is from 'package:youth_road_app/features/policy_new/presentation/compare/policy_compare_screen.dart' ('lib/features/policy_new/presentation/compare/policy_compare_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'compareFeedControllerProvider'.
    final state = ref.watch(compareFeedControllerProvider);
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/policy_compare_screen.dart:19:33: Error: The getter 'compareFeedControllerProvider' isn't defined for the class 'PolicyCompareScreen'.
 - 'PolicyCompareScreen' is from 'package:youth_road_app/features/policy_new/presentation/compare/policy_compare_screen.dart' ('lib/features/policy_new/presentation/compare/policy_compare_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'compareFeedControllerProvider'.
    final controller = ref.read(compareFeedControllerProvider.notifier);
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/policy_compare_screen.dart:20:40: Error: The getter 'compareRepositoryProvider' isn't defined for the class 'PolicyCompareScreen'.
 - 'PolicyCompareScreen' is from 'package:youth_road_app/features/policy_new/presentation/compare/policy_compare_screen.dart' ('lib/features/policy_new/presentation/compare/policy_compare_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'compareRepositoryProvider'.
    final compareController = ref.read(compareRepositoryProvider.notifier);
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/policy_compare_screen.dart:62:30: Error: 'PolicyFailure' isn't a type.
    final message = error is PolicyFailure ? error.message : error.toString();
                             ^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:24:9: Error: 'CompareState' isn't a type.
  final CompareState state;
        ^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:40:9: Error: 'HorizontalOverflowController' isn't a type.
  final HorizontalOverflowController _overflowController =
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:41:7: Error: Method not found: 'HorizontalOverflowController'.
      HorizontalOverflowController();
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:81:15: Error: Undefined name 'AppSpacing'.
              AppSpacing.lg,
              ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:82:15: Error: Undefined name 'AppSpacing'.
              AppSpacing.md,
              ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:83:15: Error: Undefined name 'AppSpacing'.
              AppSpacing.lg,
              ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:84:15: Error: Undefined name 'AppSpacing'.
              AppSpacing.sm,
              ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:108:27: Error: Undefined name 'AppSpacing'.
              horizontal: AppSpacing.lg,
                          ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:109:25: Error: Undefined name 'AppSpacing'.
              vertical: AppSpacing.sm,
                        ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:123:49: Error: Undefined name 'AppSpacing'.
            padding: const EdgeInsets.only(top: AppSpacing.md),
                                                ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:142:41: Error: Undefined name 'AppSpacing'.
                            horizontal: AppSpacing.lg,
                                        ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:143:39: Error: Undefined name 'AppSpacing'.
                            vertical: AppSpacing.md,
                                      ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:151:54: Error: Undefined name 'AppSpacing'.
                              const SizedBox(height: AppSpacing.md),
                                                     ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:70:21: Error: The method 'CompareDiffService' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing method, or defining a method named 'CompareDiffService'.
    final service = CompareDiffService();
                    ^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:111:20: Error: The method 'CompareHeaderRowWidget' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing method, or defining a method named 'CompareHeaderRowWidget'.
            child: CompareHeaderRowWidget(
                   ^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:117:28: Error: The getter 'CompareDiffService' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'CompareDiffService'.
              columnWidth: CompareDiffService.columnWidth,
                           ^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:148:31: Error: The method 'CompareSummaryHighlight' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing method, or defining a method named 'CompareSummaryHighlight'.
                              CompareSummaryHighlight(
                              ^^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:152:31: Error: The method 'CompareDiffTableWidget' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing method, or defining a method named 'CompareDiffTableWidget'.
                              CompareDiffTableWidget(
                              ^^^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:158:46: Error: The getter 'CompareDiffService' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'CompareDiffService'.
                                columnWidth: CompareDiffService.columnWidth,
                                             ^^^^^^^^^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:167:30: Error: The getter 'AppSpacing' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppSpacing'.
                      right: AppSpacing.lg,
                             ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:168:28: Error: The getter 'AppSpacing' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppSpacing'.
                      top: AppSpacing.sm,
                           ^^^^^^^^^^
lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart:169:30: Error: The method 'PolicyCompareZoomControls' isn't defined for the class '_PolicyCompareCanvasState'.
 - '_PolicyCompareCanvasState' is from 'package:youth_road_app/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart' ('lib/features/policy_new/presentation/compare/widgets/policy_compare_canvas.dart').
Try correcting the name to the name of an existing method, or defining a method named 'PolicyCompareZoomControls'.
                      child: PolicyCompareZoomControls(
                             ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/features/map_v2/kakao_map_controller.dart:488:45: Error: The getter 'ConsoleMessageLevel' isn't defined for the class 'KakaoMapController'.
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
