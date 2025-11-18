import 'dart:convert';

import 'package:flutter/foundation.dart';

class UnityBridgeLogger {
  const UnityBridgeLogger();

  void logEvent({
    required String direction,
    required String event,
    required Map<String, dynamic> payload,
    bool success = true,
    String? note,
  }) {
    final entry = {
      'direction': direction,
      'event': event,
      'payload': payload,
      'success': success,
      'note': note,
      'timestamp': DateTime.now().toIso8601String(),
    };
    debugPrint(jsonEncode(entry), wrapWidth: 0);
  }
}
