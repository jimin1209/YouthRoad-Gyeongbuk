import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../application/providers.dart';
import '../../../core/constants/env.dart';
import '../../../domain/entities/policy.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';
import 'kakao_map_html_builder.dart';

class KakaoMapScreen extends ConsumerStatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen> {
  static const _htmlBuilder = KakaoMapHtmlBuilder();
  static const _bridgeName = 'KakaoBridge';
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _mapReady = false;

  static const _defaultCenter = KakaoMapLatLng(36.4919, 128.8889); // Gyeongbuk
  AsyncValue<List<Policy>>? _lastPolicies;
  ProviderSubscription<String?>? _regionSubscription;
  ProviderSubscription<AsyncValue<List<Policy>>>? _policySubscription;

  @override
  void initState() {
    super.initState();
    _regionSubscription =
        ref.listenManual<String?>(regionProvider, (_, __) => _reloadMap());
    _policySubscription = ref.listenManual<AsyncValue<List<Policy>>>(
      policyListNotifierProvider,
      (prev, next) {
        if (next.hasValue && next.valueOrNull != prev?.valueOrNull) {
          _lastPolicies = next;
          _reloadMap();
        }
      },
    );
    final center = _centerForRegion(ref.read(regionProvider));
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(_bridgeName, onMessageReceived: _onMapMessage)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _mapReady = false;
          }),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadHtmlString(
        _htmlBuilder.build(
          apiKey: Env.kakaoMapApiKey,
          center: center,
          markers: _policyMarkers(center, ref.read(policyListNotifierProvider)),
          bridgeName: _bridgeName,
        ),
      );
  }

  @override
  void dispose() {
    _regionSubscription?.close();
    _policySubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: '카카오맵 보기'),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: _buildOverlay(ref.watch(policyListNotifierProvider)),
          ),
        ],
      ),
    );
  }

  void _reloadMap() {
    final center = _centerForRegion(ref.read(regionProvider));
    final markers = _policyMarkers(center, ref.read(policyListNotifierProvider));

    setState(() {
      _isLoading = true;
      _mapReady = false;
    });

    _controller.loadHtmlString(
      _htmlBuilder.build(
        apiKey: Env.kakaoMapApiKey,
        center: center,
        markers: markers,
        bridgeName: _bridgeName,
      ),
    );
  }

  Widget _buildOverlay(AsyncValue<List<Policy>> policies) {
    return policies.when(
      data: (_) => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Center(
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
      ),
    );
  }

  List<KakaoMapPolicyMarker> _policyMarkers(
    KakaoMapLatLng center,
    AsyncValue<List<Policy>> asyncPolicies,
  ) {
    final policies = asyncPolicies.valueOrNull ?? _lastPolicies?.valueOrNull;
    if (policies == null || policies.isEmpty) return const [];

    final markerOffsets = _markerOffsets(center);
    final limitedPolicies = policies.take(markerOffsets.length).toList();

    return List.generate(limitedPolicies.length, (index) {
      final policy = limitedPolicies[index];
      final offset = markerOffsets[index];
      return KakaoMapPolicyMarker(
        id: policy.id,
        title: policy.policyNm,
        lat: offset.lat,
        lng: offset.lng,
      );
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

  void _onMapMessage(JavaScriptMessage message) {
    final content = message.message;
    if (content == 'ready') {
      setState(() {
        _mapReady = true;
        _isLoading = false;
      });
      return;
    }
    if (content.startsWith('marker:')) {
      if (!_mapReady) return;
      final policyId = content.replaceFirst('marker:', '');
      if (policyId.isNotEmpty && mounted) {
        context.push(RoutePaths.policyDetail(policyId));
      }
    }
  }
}
