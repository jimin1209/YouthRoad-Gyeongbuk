
lib/features/policy_new/application/filters/policy_filter_ui_state.dart:179:36: Error: The method 'listenManual' isn't defined for the class 'StateNotifierProviderRef<PolicyFilterUiStateNotifier, PolicyFilterUiState>'.
 - 'StateNotifierProviderRef' is from 'package:riverpod/src/state_notifier_provider.dart' ('../.pub-cache/hosted/pub.dev/riverpod-2.6.1/lib/src/state_notifier_provider.dart').
 - 'PolicyFilterUiStateNotifier' is from 'package:youth_road_app/features/policy_new/application/filters/policy_filter_ui_state.dart' ('lib/features/policy_new/application/filters/policy_filter_ui_state.dart').
 - 'PolicyFilterUiState' is from 'package:youth_road_app/features/policy_new/application/filters/policy_filter_ui_state.dart' ('lib/features/policy_new/application/filters/policy_filter_ui_state.dart').
Try correcting the name to the name of an existing method, or defining a method named 'listenManual'.
    final regionSubscription = ref.listenManual<String?>(
                                   ^^^^^^^^^^^^
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
