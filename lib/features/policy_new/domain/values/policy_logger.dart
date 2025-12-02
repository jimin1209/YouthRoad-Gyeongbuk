abstract class PolicyLogger {
  void info(String msg);
  void warn(String msg);
  void error(String msg, [Object? err, StackTrace? stackTrace]);
}
