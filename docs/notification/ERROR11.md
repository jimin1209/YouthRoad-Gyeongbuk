lib/debug/debug_log_collector.dart:95:8: Error: '_isErrorEntry' is already declared in this scope.
  bool _isErrorEntry(DebugLogEntry entry) {
       ^^^^^^^^^^^^^
lib/debug/debug_log_collector.dart:83:8: Context: Previous declaration of '_isErrorEntry'.
  bool _isErrorEntry(DebugLogEntry entry) {
       ^^^^^^^^^^^^^
lib/debug/debug_log_collector.dart:404:7: Error: 'DebugErrorLogPanel' is already declared in this scope.
class DebugErrorLogPanel extends StatelessWidget {
      ^^^^^^^^^^^^^^^^^^
lib/debug/debug_log_collector.dart:206:7: Context: Previous declaration of 'DebugErrorLogPanel'.
class DebugErrorLogPanel extends StatelessWidget {
      ^^^^^^^^^^^^^^^^^^
lib/debug/debug_log_collector.dart:514:8: Error: '_formatLogTimestamp' is already declared in this scope.
String _formatLogTimestamp(DateTime time) {
       ^^^^^^^^^^^^^^^^^^^
lib/debug/debug_log_collector.dart:334:8: Context: Previous declaration of '_formatLogTimestamp'.
String _formatLogTimestamp(DateTime time) {
       ^^^^^^^^^^^^^^^^^^^
lib/debug/debug_log_collector.dart:63:9: Error: Can't use '_isErrorEntry' because it is declared more than once.
    if (_isErrorEntry(entry)) {
        ^
lib/debug/debug_log_collector.dart:73:9: Error: Can't use '_isErrorEntry' because it is declared more than once.
    if (_isErrorEntry(entry)) {
        ^
lib/debug/debug_log_collector.dart:178:23: Error: Can't use '_formatLogTimestamp' because it is declared more than once.
                      _formatLogTimestamp(log.timestamp),
                      ^
lib/debug/debug_log_collector.dart:295:45: Error: Can't use '_formatLogTimestamp' because it is declared more than once.
                                            _formatLogTimestamp(entry.timestamp),
                                            ^
lib/debug/debug_log_collector.dart:478:41: Error: Can't use '_formatLogTimestamp' because it is declared more than once.
                                        _formatLogTimestamp(entry.timestamp),
                                        ^
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

BUILD FAILED in 13s
