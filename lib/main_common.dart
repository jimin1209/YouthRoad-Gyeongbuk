import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'application/di.dart';
import 'debug/debug_provider_tracker.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final observers = <ProviderObserver>[];

  if (kDebugMode) {
    observers.add(DebugProviderObserver());
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
