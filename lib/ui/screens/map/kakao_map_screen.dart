import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/map/kakao_map_webview.dart';
import 'kakao_map_html_builder.dart';

class KakaoMapScreen extends ConsumerStatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen> {
  static const _defaultCenter = KakaoMapLatLng(36.4919, 128.8889);

  bool _loading = true;
  String? _errorCode;
  String? _lastLog;

  @override
  Widget build(BuildContext context) {
    final regionName = ref.watch(regionProvider);
    final policyState = ref.watch(policyListNotifierProvider);

    final center = _centerForRegion(regionName);
    final markers = _policyMarkers(center, policyState);
    final polylines = _polylinesFromMarkers(markers);
    const options = KakaoMapOptions(
      level: 6,
      mapType: KakaoMapType.roadmap,
      showZoomControl: true,
      showMapTypeControl: true,
    );

    return Scaffold(
      appBar: const AppAppBar(title: '카카오맵 보기'),
      body: Stack(
        children: [
          KakaoMapWebView(
            center: center,
            markers: markers,
            polylines: polylines,
            enableClustering: true,
            options: options,
            onMarkerTap: (id) => context.push(RoutePaths.policyDetail(id)),
            onReady: () => _setLoading(false),
            onLoadingChanged: _setLoading,
            onError: (code) => setState(() => _errorCode = code),
            onLog: (event) => setState(() => _lastLog = event.logMessage),
            showDebugPanel: true,
          ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_errorCode != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '지도 로딩 중 문제가 발생했습니다.',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '오류 코드: ${_errorCode ?? ''}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (_lastLog != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        '최근 로그: $_lastLog',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: _buildOverlay(policyState),
          ),
        ],
      ),
    );
  }

  void _setLoading(bool value) {
    if (_loading == value) return;
    setState(() {
      _loading = value;
    });
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
        image: index == 0
            ? const KakaoMapMarkerImage(
                url: 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png',
                width: 24,
                height: 35,
              )
            : null,
      );
    });
  }

  List<KakaoMapPolyline> _polylinesFromMarkers(List<KakaoMapMarker> markers) {
    if (markers.length < 2) return const [];
    final path = markers.map((m) => m.position).toList();
    return [
      KakaoMapPolyline(
        id: 'policy-path',
        path: path,
        strokeColor: '#3478f6',
        strokeWeight: 5,
        strokeOpacity: 0.8,
      ),
    ];
  }

  List<KakaoMapLatLng> _markerOffsets(KakaoMapLatLng base) {
    const deltas = <KakaoMapLatLng>[
      KakaoMapLatLng(0, 0),
      KakaoMapLatLng(0.005, 0.003),
      KakaoMapLatLng(-0.003, 0.006),
      KakaoMapLatLng(0.006, -0.004),
      KakaoMapLatLng(-0.005, -0.002),
      KakaoMapLatLng(0.002, 0.007),
    ];

    return deltas
        .map(
          (delta) => KakaoMapLatLng(base.lat + delta.lat, base.lng + delta.lng),
        )
        .toList();
  }

  KakaoMapLatLng _centerForRegion(String? regionName) {
    final normalized = (regionName ?? '').trim();
    switch (normalized) {
      case '포항시':
        return const KakaoMapLatLng(36.0190, 129.3435);
      case '구미시':
        return const KakaoMapLatLng(36.1195, 128.3446);
      case '경산시':
        return const KakaoMapLatLng(35.8252, 128.7415);
      case '안동시':
        return const KakaoMapLatLng(36.5684, 128.7294);
      case '김천시':
        return const KakaoMapLatLng(36.1398, 128.1136);
      case '경북 전체':
        return _defaultCenter;
      default:
        if (normalized.isEmpty) return _defaultCenter;
        return _defaultCenter;
    }
  }

  Widget _buildOverlay(PolicyListState state) {
    if (state.isLoading && state.policies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.policies.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '정책을 불러오지 못했습니다.',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
