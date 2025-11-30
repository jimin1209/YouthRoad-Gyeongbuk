// FILE: lib/ui/screens/unity/unity_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../application/controllers/unity_map_controller.dart';
import '../../../application/providers.dart';
import '../../../domain/entities/policy.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';

class UnityScreen extends ConsumerStatefulWidget {
  const UnityScreen({super.key});

  @override
  ConsumerState<UnityScreen> createState() => _UnityScreenState();
}

class _UnityScreenState extends ConsumerState<UnityScreen> {
  String _status = '지도를 준비 중입니다';

  @override
  void initState() {
    super.initState();
  }

  void _handlePolicySelection(Policy policy) {
    if (!mounted) return;
    context.push(RoutePaths.policyDetail(policy.id));
  }

  @override
  Widget build(BuildContext context) {
    /// Listen to policy list state changes
    ref.listen(policyListNotifierProvider, (previous, next) {
      final policies = next.policies; // ← valueOrNull → policies로 변경된 핵심 부분

      if (policies.isNotEmpty) {
        final controller = ref.read(unityMapControllerProvider);
        controller.sendMarkersForPolicies(policies);

        if (controller.isUnityReady) {
          if (mounted) {
            setState(() => _status = '마커 정보를 Unity에 전송했습니다');
          }
        }
      }
    });

    final mapController = ref.watch(unityMapControllerProvider);
    mapController.onPolicySelected ??= _handlePolicySelection;

    return Scaffold(
      appBar: const AppAppBar(title: 'Unity View'),
      body: Column(
        children: [
          Expanded(
            child: UnityWidget(
              onUnityCreated: (controller) {
                mapController.onUnityCreated(controller);
                if (mounted) {
                  setState(() => _status = '지도 연결 완료');
                }
              },
              onUnityMessage: mapController.onUnityMessage,
              useAndroidViewSurface: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: Text(_status)),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {
                    /// Pull all current policies
                    final policies =
                        ref.read(policyListNotifierProvider).policies;

                    mapController.sendMarkersForPolicies(policies);

                    if (mapController.isUnityReady) {
                      if (mounted) {
                        setState(() => _status = '마커 정보를 Unity에 전송했습니다');
                      }
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('마커 다시 보내기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
