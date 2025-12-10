import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'kakao_map_html_builder.dart';
import 'services/gps_service.dart';
import 'services/location_permission_service.dart';

class CurrentLocationState {
  const CurrentLocationState({
    this.location,
    this.isLoading = false,
    this.error,
    this.serviceDisabled = false,
    this.permissionIssue,
  });

  final KakaoMapLatLng? location;
  final bool isLoading;
  final String? error;
  final bool serviceDisabled;
  final LocationPermissionIssue? permissionIssue;

  static const _unset = Object();

  CurrentLocationState copyWith({
    KakaoMapLatLng? location,
    bool? isLoading,
    Object? error = _unset,
    bool? serviceDisabled,
    Object? permissionIssue = _unset,
  }) {
    return CurrentLocationState(
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
      serviceDisabled: serviceDisabled ?? this.serviceDisabled,
      permissionIssue: permissionIssue == _unset
          ? this.permissionIssue
          : permissionIssue as LocationPermissionIssue?,
    );
  }

  static CurrentLocationState initial() => const CurrentLocationState();
}

final currentLocationProvider =
    StateNotifierProvider<CurrentLocationNotifier, CurrentLocationState>(
  (_) => CurrentLocationNotifier(),
);

class CurrentLocationNotifier extends StateNotifier<CurrentLocationState> {
  CurrentLocationNotifier() : super(CurrentLocationState.initial());

  final _gpsService = const GpsService();
  final _permissionService = const LocationPermissionService();

  Future<void> fetch() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      permissionIssue: null,
      serviceDisabled: false,
    );

    try {
      final serviceEnabled = await _gpsService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          serviceDisabled: true,
          error: '위치 서비스가 꺼져 있습니다.',
        );
        return;
      }

      final permissionResult = await _permissionService.ensurePermission();
      if (permissionResult != LocationPermissionIssue.granted) {
        state = state.copyWith(
          isLoading: false,
          permissionIssue: permissionResult,
          error: _permissionMessage(permissionResult),
        );
        return;
      }

      final position = await _gpsService.getCurrentPosition();
      state = state.copyWith(
        isLoading: false,
        location: KakaoMapLatLng(position.latitude, position.longitude),
        error: null,
      );
    } catch (error, stack) {
      debugPrint('[CurrentLocation] 위치 로드 실패: $error');
      if (stack != null) debugPrint(stack.toString());
      state = state.copyWith(
        isLoading: false,
        error: '현재 위치를 가져오지 못했습니다.',
      );
    }
  }

  String _permissionMessage(LocationPermissionIssue issue) {
    switch (issue) {
      case LocationPermissionIssue.denied:
        return '위치 권한이 거부되었습니다.';
      case LocationPermissionIssue.deniedForever:
        return '위치 권한이 영구히 거부되었습니다.';
      case LocationPermissionIssue.granted:
        return '';
    }
  }
}
