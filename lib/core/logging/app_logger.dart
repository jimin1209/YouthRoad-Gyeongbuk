import 'package:flutter/foundation.dart';

import '../../devtools/devtools_provider.dart';
import 'app_log_level.dart';

class AppLogger {
  const AppLogger._();

  static void logInfo(String message, {String? tag}) {
    _log(message, AppLogLevel.info, tag: tag);
  }

  static void logWarning(String message, {String? tag}) {
    _log(message, AppLogLevel.warning, tag: tag);
  }

  static void logError(String message, {String? tag, Object? error}) {
    final errorSuffix = error != null ? ' | error=$error' : '';
    _log(message + errorSuffix, AppLogLevel.error, tag: tag);
  }

  static void _log(String message, AppLogLevel level, {String? tag}) {
    final label = switch (level) {
      AppLogLevel.info => 'INFO',
      AppLogLevel.warning => 'WARN',
      AppLogLevel.error => 'ERROR',
    };
    final prefix = tag != null ? '[$tag]' : '';
    final formatted = '[AppLogger][$label] $prefix$message';

    if (!kReleaseMode) {
      debugPrint(formatted);
      DevtoolsBinding.instance.addLog(level, formatted);
    } else {
      debugPrint(formatted);
    }
  }
}
