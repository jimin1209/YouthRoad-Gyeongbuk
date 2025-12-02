import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/map/kakao_map_controller.dart';
import '../../models/map/kakao_map_models.dart';
import '../../models/map/kakao_map_options.dart';
import '../../providers/map/kakao_map_providers.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/map/kakao_map_webview.dart';
import '../../../application/providers.dart';
import '../../../navigation/route_paths.dart';

class KakaoMapScreen extends ConsumerStatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen> {
  final List<KakaoMapEvent> _logs = [];

  static const _defaultCenter = KakaoMapLatLng(lat: 36.4919, lng: 128.8889);

  @override
  void initState() {
    super.initState();
    _listenToEvents();
    _listenToRegion();
    _listenToPolicies();
  }

  void _listenToEvents() {
    ref.listen<AsyncValue<KakaoMapEvent>>(kakaoMapEventStreamProvider, (prev, next) {
      next.when(
        data: _handleEvent,
        error: (_, __) {},
        loading: () {},
      );
    });
  }

  void _listenToRegion() {
    ref.listen<String?>(regionProvider, (prev, next) {
      final center = _centerForRegion(next);
      _updateOptions((options) => options.copyWith(center: center));
      ref.read(kakaoMapControllerProvider).moveTo(center, animate: true);
    });
  }

  void _listenToPolicies() {
    ref.listen<PolicyListState>(policyListNotifierProvider, (prev, next) {
      _refreshMarkers(next);
    });
  }

  void _handleEvent(KakaoMapEvent event) {
    setState(() {
      _logs.insert(0, event);
      if (_logs.length > 50) {
        _logs.removeLast();
      }
    });

    if (event.type == KakaoMapEventType.markerClick) {
      final policyId = event.payload['id'] as String?;
      if (policyId != null && policyId.isNotEmpty && mounted) {
        context.push(RoutePaths.policyDetail(policyId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(kakaoMapControllerProvider);
    final options = ref.watch(kakaoMapOptionsProvider);

    return Scaffold(
      appBar: const AppAppBar(title: '카카오맵 리빌드'),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: KakaoMapWebView(
              controller: controller,
              options: options,
            ),
          ),
          const Divider(height: 1),
          _buildControls(controller, options),
          const Divider(height: 1),
          _buildLogPanel(),
        ],
      ),
    );
  }

  Widget _buildControls(KakaoMapController controller, KakaoMapOptions options) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => controller.moveTo(_defaultCenter, animate: true),
                child: const Text('경북 중심 이동'),
              ),
              ElevatedButton(
                onPressed: () => _changeLevel(1),
                child: const Text('줌 아웃'),
              ),
              ElevatedButton(
                onPressed: () => _changeLevel(-1),
                child: const Text('줌 인'),
              ),
              ElevatedButton(
                onPressed: () => _changeMapType(KakaoMapMapType.roadmap),
                child: const Text('지도타입: 일반'),
              ),
              ElevatedButton(
                onPressed: () => _changeMapType(KakaoMapMapType.skyview),
                child: const Text('지도타입: 스카이뷰'),
              ),
              ElevatedButton(
                onPressed: () => controller.reload(),
                child: const Text('맵 리로드'),
              ),
              ElevatedButton(
                onPressed: () => _refreshMarkers(ref.read(policyListNotifierProvider)),
                child: const Text('마커 동기화'),
              ),
              ElevatedButton(
                onPressed: _applyPolylineSample,
                child: const Text('경로 표시'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogPanel() {
    return Container(
      height: 220,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('이벤트 로그', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('총 ${_logs.length}건'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _logs.isEmpty
                  ? const Center(child: Text('아직 이벤트가 없습니다.'))
                  : ListView.builder(
                      reverse: false,
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final event = _logs[index];
                        return ListTile(
                          dense: true,
                          title: Text(event.type.name),
                          subtitle: Text(jsonEncode(event.payload)),
                          trailing: Text(
                            DateTime.fromMillisecondsSinceEpoch(event.timestamp)
                                .toIso8601String(),
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeLevel(int delta) {
    final notifier = ref.read(kakaoMapOptionsProvider.notifier);
    final nextLevel = (notifier.state.level + delta).clamp(1, 13);
    final updated = notifier.state.copyWith(level: nextLevel);
    notifier.state = updated;
    ref.read(kakaoMapControllerProvider).setLevel(updated.level);
  }

  void _changeMapType(KakaoMapMapType type) {
    final notifier = ref.read(kakaoMapOptionsProvider.notifier);
    notifier.state = notifier.state.copyWith(mapType: type);
    ref.read(kakaoMapControllerProvider).setMapType(type);
  }

  void _refreshMarkers(PolicyListState policyState) {
    final center = _centerForRegion(ref.read(regionProvider));
    final markers = _policyMarkers(center, policyState);
    final optionsNotifier = ref.read(kakaoMapOptionsProvider.notifier);
    optionsNotifier.state = optionsNotifier.state.copyWith(center: center, markers: markers);
    ref.read(kakaoMapStateProvider.notifier).setMarkers(markers);
    ref.read(kakaoMapControllerProvider).fitToMarkers();
  }

  void _applyPolylineSample() {
    final center = _centerForRegion(ref.read(regionProvider));
    final offsets = _markerOffsets(center);
    final polyline = KakaoMapPolyline(
      id: 'route',
      points: offsets,
      strokeColor: '#FF6B6B',
      strokeWeight: 4,
      strokeOpacity: 0.9,
    );
    final optionsNotifier = ref.read(kakaoMapOptionsProvider.notifier);
    optionsNotifier.state = optionsNotifier.state.copyWith(polylines: [polyline]);
    ref.read(kakaoMapControllerProvider).setPolylines([polyline]);
  }

  void _updateOptions(KakaoMapOptions Function(KakaoMapOptions) update) {
    final notifier = ref.read(kakaoMapOptionsProvider.notifier);
    notifier.state = update(notifier.state);
  }

  KakaoMapLatLng _centerForRegion(String? regionName) {
    final normalized = (regionName ?? '').trim();
    switch (normalized) {
      case '포항시':
        return const KakaoMapLatLng(lat: 36.0190, lng: 129.3435);
      case '구미시':
        return const KakaoMapLatLng(lat: 36.1195, lng: 128.3446);
      case '경산시':
        return const KakaoMapLatLng(lat: 35.8252, lng: 128.7415);
      case '안동시':
        return const KakaoMapLatLng(lat: 36.5684, lng: 128.7294);
      case '김천시':
        return const KakaoMapLatLng(lat: 36.1398, lng: 128.1136);
      case '경북 전체':
        return _defaultCenter;
      default:
        if (normalized.isEmpty) return _defaultCenter;
        return _defaultCenter;
    }
  }

  List<KakaoMapMarker> _policyMarkers(
    KakaoMapLatLng center,
    PolicyListState asyncPolicies,
  ) {
    final policies = asyncPolicies.policies;
    if (policies.isEmpty) return const [];

    final markerOffsets = _markerOffsets(center);
    final limitedPolicies = policies.take(markerOffsets.length).toList();

    return List.generate(limitedPolicies.length, (index) {
      final policy = limitedPolicies[index];
      final offset = markerOffsets[index];
      return KakaoMapMarker(
        id: policy.id,
        title: policy.policyNm,
        position: offset,
      );
    });
  }

  List<KakaoMapLatLng> _markerOffsets(KakaoMapLatLng base) {
    const deltas = <KakaoMapLatLng>[
      KakaoMapLatLng(lat: 0, lng: 0),
      KakaoMapLatLng(lat: 0.005, lng: 0.003),
      KakaoMapLatLng(lat: -0.003, lng: 0.006),
      KakaoMapLatLng(lat: 0.006, lng: -0.004),
      KakaoMapLatLng(lat: -0.005, lng: -0.002),
      KakaoMapLatLng(lat: 0.002, lng: 0.007),
    ];

    return deltas
        .map(
          (delta) => KakaoMapLatLng(
            lat: base.lat + delta.lat,
            lng: base.lng + delta.lng,
          ),
        )
        .toList();
  }
}
