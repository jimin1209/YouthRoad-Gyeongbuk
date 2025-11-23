import 'package:flutter/foundation.dart';

class Logger {
  const Logger._();

  static void debug(String message) {
    if (!kDebugMode) return;
    // ignore: avoid_print
    print('[DEBUG] $message');
  }
}
