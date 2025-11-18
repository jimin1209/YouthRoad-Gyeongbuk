import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run tool/check_unity_bridge_logs.dart <log_file>');
    exitCode = 64;
    return;
  }
  final file = File(args.first);
  if (!await file.exists()) {
    stderr.writeln('Log file not found: ${file.path}');
    exitCode = 66;
    return;
  }

  var mapReadySeen = false;
  var regionSelectedSeen = false;

  final lines = await file.readAsLines();
  for (final line in lines) {
    try {
      final json = jsonDecode(line) as Map<String, dynamic>;
      final event = json['event']?.toString();
      final success = json['success'] != false;
      if (success && event == 'MAP_READY') {
        mapReadySeen = true;
      }
      if (success && event == 'REGION_SELECTED') {
        regionSelectedSeen = true;
      }
    } catch (_) {
      continue;
    }
  }

  if (!mapReadySeen || !regionSelectedSeen) {
    stderr.writeln(
      'Missing bridge events: MAP_READY=${mapReadySeen}, REGION_SELECTED=${regionSelectedSeen}',
    );
    exitCode = 1;
    return;
  }
  stdout.writeln('Unity bridge log validation passed.');
}
