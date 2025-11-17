import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../../widgets/app_appbar.dart';

class UnityScreen extends StatefulWidget {
  const UnityScreen({super.key});

  @override
  State<UnityScreen> createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> {
  UnityWidgetController? _controller;

  void _onUnityCreated(UnityWidgetController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Unity View'),
      body: UnityWidget(
        onUnityCreated: _onUnityCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller?.postMessage(
            'GameObjectName',
            'MethodName',
            'Hello from Flutter',
          );
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
