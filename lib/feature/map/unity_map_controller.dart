import 'dart:convert';

import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityMapController {
  UnityWidgetController? _controller;

  void attach(UnityWidgetController controller) {
    _controller = controller;
  }

  Future<void> focusRegion(String regionCode) async {
    final controller = _controller;
    if (controller == null) return;
    final String message = jsonEncode({
      'action': 'focusRegion',
      'regionCode': regionCode,
    });
    await controller.postMessage(
      'MapManager',
      'OnFlutterMessage',
      message,
    );
  }
}
