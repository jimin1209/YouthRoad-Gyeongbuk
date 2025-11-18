import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../../features/unity/controller/unity_runtime_guard.dart';

import '../../widgets/app_appbar.dart';

class UnityScreen extends StatefulWidget {
  const UnityScreen({super.key});

  @override
  State<UnityScreen> createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> {
  UnityWidgetController? _controller;
  late final UnityRuntimeGuard _runtimeGuard;

  @override
  void initState() {
    super.initState();
    _runtimeGuard = UnityRuntimeGuard();
  }

  void _onUnityCreated(UnityWidgetController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UnityRuntimeAvailability>(
      future: _runtimeGuard.evaluate(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            appBar: AppAppBar(title: 'Unity View'),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Text('장치 ABI 정보를 불러오지 못해 Unity가 비활성화되었습니다.'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            appBar: AppAppBar(title: 'Unity View'),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final availability = snapshot.data!;
        if (!availability.isSupported) {
          final reason = availability.blockingReason() ??
              '이 ABI에서는 Unity 라이브러리가 포함되지 않았습니다.';
          return Scaffold(
            appBar: const AppAppBar(title: 'Unity View'),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unity 비활성화',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(reason),
                  const SizedBox(height: 8),
                  const Text(
                    '에뮬레이터(x86_64)에서 Unity가 필요하다면 Unity Export Target Architecture에 x86_64를 추가하고 jniLibs/jniStaticLibs/x86_64를 확인하세요.',
                  ),
                ],
              ),
            ),
          );
        }

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
      },
    );
  }
}
