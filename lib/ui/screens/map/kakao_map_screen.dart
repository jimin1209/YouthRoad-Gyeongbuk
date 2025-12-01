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

  @override
  Widget build(BuildContext context) {
    final regionName = ref.watch(regionProvider);
    final policyState = ref.watch(policyListNotifierProvider);

    final center = _centerForRegion(regionName);
    final markers = _policyMarkers(center, policyState);

    return Scaffold(
      appBar: const AppAppBar(title: '카카오맵 보기'),
      body: Stack(
        children: [
          KakaoMapWebView(
            center: center,
            markers: markers,
            onMarkerTap: (id) => context.push(RoutePaths.policyDetail(id)),
            onReady: () => _setLoading(false),
            onLoadingChanged: _setLoading,
          ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
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

  void _setLoading(bool value) {
    if (_loading == value) return;
    setState(() {
      _loading = value;
    });
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
      return Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '정책을 불러오지 못했습니다.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
