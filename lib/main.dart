import 'package:flutter/foundation.dart';
import 'core/error/error_reporter.dart';
import 'main_prod.dart' as prod;

Future<void> main() async {
  final reporter = ErrorReporter.instance;

  FlutterError.onError = (details) {
    reporter.captureFlutterError(details);
  };

  // runZonedGuarded 제거 → Zone mismatch 방지
  await prod.main();
}
