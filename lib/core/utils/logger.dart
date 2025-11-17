class Logger {
  const Logger._();

  static void debug(String message) {
    // Simple debug logger that can be enhanced later.
    // ignore: avoid_print
    print('[DEBUG] $message');
  }
}
