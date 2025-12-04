import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/di.dart';
import '../../core/logging/app_log_level.dart';
import '../../debug/debug_log_collector.dart';
import '../../debug/debug_provider_tracker.dart';
import '../../devtools/devtools_provider.dart';

// ★ 이게 없어서 오류가 났던 것!
import '../providers/app_providers.dart';

typedef AppBuilder = Widget Function();

Future<void> bootstrap({
  required AppBuilder builder,
  List<Override> overrides = const [],
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter error hook 설정
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    (previousOnError ?? FlutterError.presentError).call(details);
    DevtoolsBinding.instance.addLog(
      AppLogLevel.error,
      '[FlutterError] ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // SharedPreferences 초기화
  final prefs = await _initSharedPreferences();
  initializeSharedPreferences(prefs);

  // Provider Observer
  final observers = <ProviderObserver>[];

  if (kDebugMode) {
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) {
        DebugLogCollector.instance.add(message);
        DevtoolsBinding.instance.addLog(AppLogLevel.debug, message);
      }
      originalDebugPrint(message, wrapWidth: wrapWidth);
    };

    observers.add(DebugProviderObserver());
  }

  // Zone중첩 제거: runApp을 최상위 Zone에서 실행
  runApp(
    ProviderScope(
      overrides: [
        ...buildAppOverrides(sharedPreferences: prefs),
        ...overrides,
      ],
      observers: observers,
      child: builder(),
    ),
  );
}

Future<SharedPreferences> _initSharedPreferences() async {
  try {
    return await SharedPreferences.getInstance();
  } catch (e, stackTrace) {
    debugPrint('SharedPreferences 초기화에 실패했습니다: $e');
    debugPrint('$stackTrace');

    SharedPreferences.setMockInitialValues({});
    return SharedPreferences.getInstance();
  }
}
