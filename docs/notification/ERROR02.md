lib/features/policy_new/presentation/detail/widgets/policy_action_bar.dart:12:8: Error: Error when reading 'lib/features/ui/theme/app_text.dart': No such file or directory
import '../../../../ui/theme/app_text.dart';
       ^
lib/features/policy_new/presentation/explore/policy_explore_screen.dart:49:31: Error: This expression has type 'void' and can't beused.
    _regionSubscription = ref.listen<String?>(
                              ^
lib/features/policy_new/presentation/detail/widgets/policy_action_bar.dart:223:44: Error: The method 'toggleReminder' isn't defined for the class 'PolicyActionController'.
 - 'PolicyActionController' is from 'package:youth_road_app/features/policy_new/application/controllers/policy_action_controller.dart' ('lib/features/policy_new/application/controllers/policy_action_controller.dart').
Try correcting the name to the name of an existing method, or defining a method named 'toggleReminder'.
                  : () async => controller.toggleReminder(policy),
                                           ^^^^^^^^^^^^^^
lib/features/policy_new/presentation/detail/widgets/policy_action_bar.dart:389:32: Error: The getter 'AppText' isn't defined for the class 'PolicyActionButton'.
 - 'PolicyActionButton' is from 'package:youth_road_app/features/policy_new/presentation/detail/widgets/policy_action_bar.dart' ('lib/features/policy_new/presentation/detail/widgets/policy_action_bar.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppText'.
                        style: AppText.textTheme.labelLarge?.copyWith(
                               ^^^^^^^
lib/features/policy_new/presentation/detail/widgets/policy_action_bar.dart:399:34: Error: The getter 'AppText' isn't defined for the class 'PolicyActionButton'.
 - 'PolicyActionButton' is from 'package:youth_road_app/features/policy_new/presentation/detail/widgets/policy_action_bar.dart' ('lib/features/policy_new/presentation/detail/widgets/policy_action_bar.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppText'.
                          style: AppText.textTheme.bodySmall?.copyWith(
                                 ^^^^^^^
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

BUILD FAILED in 18s
