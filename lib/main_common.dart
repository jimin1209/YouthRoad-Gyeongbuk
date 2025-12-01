import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'application/di.dart';
import 'core/logging/app_log_level.dart';
import 'devtools/devtools_provider.dart';
import 'devtools/panels/provider_tracker_panel.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final observers = <ProviderObserver>[];

  if (!kReleaseMode) {
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) {
        DevtoolsBinding.instance.addLog(AppLogLevel.info, message);
      }
      originalDebugPrint(message, wrapWidth: wrapWidth);
    };
    observers.add(AppProviderObserver());
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      observers: observers,
      child: const App(),
    ),
  );
}
