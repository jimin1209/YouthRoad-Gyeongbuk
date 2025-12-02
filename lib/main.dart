import 'dart:async';

import 'package:flutter/foundation.dart';

import 'core/error/error_reporter.dart';
import 'main_prod.dart' as prod;

Future<void> main() async {
  final reporter = ErrorReporter.instance;

  FlutterError.onError = (details) {
    reporter.captureFlutterError(details);
  };

  await runZonedGuarded(
    () async {
      await prod.main();
    },
    (error, stackTrace) {
      reporter.record(
        error,
        stackTrace: stackTrace,
        hint: 'Uncaught zone error',
      );
    },
  );
}
