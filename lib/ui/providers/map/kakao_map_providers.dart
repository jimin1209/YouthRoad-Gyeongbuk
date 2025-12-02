import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/env.dart';
import '../../controllers/map/kakao_map_controller.dart';
import '../../controllers/map/kakao_map_commands.dart';
import '../../models/map/kakao_map_models.dart';
import '../../models/map/kakao_map_options.dart';

final kakaoMapOptionsProvider = StateProvider<KakaoMapOptions>((ref) {
  return KakaoMapOptions(
    center: const KakaoMapLatLng(lat: 36.4919, lng: 128.8889),
    level: 6,
    mapType: KakaoMapMapType.roadmap,
  );
});

final kakaoMapControllerProvider = Provider.autoDispose<KakaoMapController>((ref) {
  final options = ref.watch(kakaoMapOptionsProvider);
  final controller = KakaoMapController(
    apiKey: Env.kakaoMapApiKey,
    initialOptions: options,
  );
  ref.onDispose(controller.dispose);
  return controller;
});

final kakaoMapEventStreamProvider = StreamProvider.autoDispose<KakaoMapEvent>((ref) {
  final controller = ref.watch(kakaoMapControllerProvider);
  return controller.events;
});

class KakaoMapState {
  const KakaoMapState({
    required this.status,
    this.selectedMarkerId,
    this.lastError,
    this.lastEvent,
  });

  factory KakaoMapState.initial() {
    return const KakaoMapState(status: KakaoMapStatus.loading);
  }

  final KakaoMapStatus status;
  final String? selectedMarkerId;
  final String? lastError;
  final KakaoMapEvent? lastEvent;

  KakaoMapState copyWith({
    KakaoMapStatus? status,
    String? selectedMarkerId,
    String? lastError,
    KakaoMapEvent? lastEvent,
  }) {
    return KakaoMapState(
      status: status ?? this.status,
      selectedMarkerId: selectedMarkerId ?? this.selectedMarkerId,
      lastError: lastError ?? this.lastError,
      lastEvent: lastEvent ?? this.lastEvent,
    );
  }
}

class KakaoMapStateNotifier extends StateNotifier<KakaoMapState> {
  KakaoMapStateNotifier(this._controller) : super(KakaoMapState.initial()) {
    _subscription = _controller.events.listen(_onEvent);
  }

  final KakaoMapController _controller;
  StreamSubscription<KakaoMapEvent>? _subscription;

  void markLoading() {
    state = state.copyWith(status: KakaoMapStatus.loading, lastError: null);
  }

  void markError(String message) {
    state = state.copyWith(
      status: KakaoMapStatus.error,
      lastError: message,
    );
  }

  void _onEvent(KakaoMapEvent event) {
    KakaoMapStatus? nextStatus;
    switch (event.type) {
      case KakaoMapEventType.sdkLoading:
        nextStatus = KakaoMapStatus.sdkLoading;
        break;
      case KakaoMapEventType.sdkLoaded:
        nextStatus = KakaoMapStatus.sdkLoaded;
        break;
      case KakaoMapEventType.ready:
        nextStatus = KakaoMapStatus.ready;
        break;
      case KakaoMapEventType.error:
      case KakaoMapEventType.sdkFailed:
        nextStatus = KakaoMapStatus.error;
        break;
      default:
        break;
    }

    final selected = event.type == KakaoMapEventType.markerClick
        ? (event.payload['id'] as String?)
        : state.selectedMarkerId;

    state = state.copyWith(
      status: nextStatus ?? state.status,
      selectedMarkerId: selected,
      lastError: nextStatus == KakaoMapStatus.error ? '지도 오류' : state.lastError,
      lastEvent: event,
    );
  }

  Future<void> reload() async {
    state = state.copyWith(status: KakaoMapStatus.reloading, lastError: null);
    await _controller.reload();
  }

  Future<KakaoMapCommandResult> setMarkers(List<KakaoMapMarker> markers) {
    return _controller.setMarkers(markers);
  }

  Future<KakaoMapCommandResult> moveTo(KakaoMapLatLng target) {
    return _controller.moveTo(target, animate: true);
  }

  Future<KakaoMapCommandResult> changeLevel(int level) {
    return _controller.setLevel(level);
  }

  Future<KakaoMapCommandResult> changeMapType(KakaoMapMapType mapType) {
    return _controller.setMapType(mapType);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final kakaoMapStateProvider =
    StateNotifierProvider.autoDispose<KakaoMapStateNotifier, KakaoMapState>((ref) {
  final controller = ref.watch(kakaoMapControllerProvider);
  final notifier = KakaoMapStateNotifier(controller);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final kakaoSelectedMarkerProvider = StateProvider<String?>((ref) => null);
