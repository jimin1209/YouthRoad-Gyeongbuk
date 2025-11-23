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
  String _status = '지도를 준비 중입니다';

  void _onUnityCreated(UnityWidgetController controller) {
    _controller = controller;
    setState(() => _status = '지도 연결 완료');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Unity View'),
      body: Column(
        children: [
          Expanded(
            child: UnityWidget(
              onUnityCreated: _onUnityCreated,
              onUnityMessage: (_) {},
              useAndroidViewSurface: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(_status),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _controller == null
                      ? null
                      : () => _controller?.postMessage(
                            'GameObjectName',
                            'MethodName',
                            'Hello from Flutter',
                          ),
                  icon: const Icon(Icons.send),
                  label: const Text('메시지 보내기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
