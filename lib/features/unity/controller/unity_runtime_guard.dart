import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnityRuntimeAvailability {
  final bool isSupported;
  final bool requiresX86Reexport;
  final bool isEmulator;
  final List<String> supportedAbis;

  const UnityRuntimeAvailability({
    required this.isSupported,
    required this.requiresX86Reexport,
    required this.isEmulator,
    required this.supportedAbis,
  });

  String? blockingReason() {
    if (isSupported) return null;
    if (requiresX86Reexport) {
      return 'x86_64 에뮬레이터에서는 Unity 라이브러리가 포함되지 않아 비활성화되었습니다. Unity Export 시 Target Architecture에 x86_64를 추가하고 재빌드하세요.';
    }
    if (supportedAbis.isEmpty) {
      return '지원 ABI를 알 수 없어 Unity 뷰를 비활성화했습니다.';
    }
    return '현재 ABI(${supportedAbis.join(', ')})에서 Unity가 지원되지 않습니다.';
  }
}

class UnityRuntimeGuard {
  UnityRuntimeGuard({DeviceInfoPlugin? deviceInfo})
      : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _deviceInfo;

  Future<UnityRuntimeAvailability> evaluate() async {
    if (!Platform.isAndroid) {
      return const UnityRuntimeAvailability(
        isSupported: false,
        requiresX86Reexport: false,
        isEmulator: false,
        supportedAbis: <String>[],
      );
    }

    final androidInfo = await _deviceInfo.androidInfo;
    final supportedAbis = (androidInfo.supportedAbis ?? const <String>[])
        .where((abi) => abi.isNotEmpty)
        .toList(growable: false);
    final hasArm64 =
        supportedAbis.any((abi) => abi.toLowerCase().contains('arm64'));
    final hasX86_64 =
        supportedAbis.any((abi) => abi.toLowerCase().contains('x86_64'));
    final isEmulator = androidInfo.isPhysicalDevice == false;

    final requiresX86Reexport = isEmulator && hasX86_64 && !hasArm64;

    return UnityRuntimeAvailability(
      isSupported: hasArm64 && !requiresX86Reexport,
      requiresX86Reexport: requiresX86Reexport,
      isEmulator: isEmulator,
      supportedAbis: supportedAbis,
    );
  }
}

final unityRuntimeAvailabilityProvider =
    FutureProvider<UnityRuntimeAvailability>((ref) async {
  final guard = UnityRuntimeGuard();
  return guard.evaluate();
});
