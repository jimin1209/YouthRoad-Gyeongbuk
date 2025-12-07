// lib/features/kakaomap/kakao_map_screen.dart

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers.dart';
import '../../debug/debug_settings_provider.dart';
import '../../navigation/route_paths.dart';
import '../../ui/widgets/app_appbar.dart';
import '../../env/app_env.dart';
import '../center/presentation/center_detail_bottom_sheet.dart';
import '../policy_new/data/mappers/youth_center_mapper.dart';
import '../policy_new/presentation/map/youth_center_map_provider.dart';
import 'kakao_map_html_builder.dart';
import 'kakao_map_webview.dart';

// flutter run
//   --dart-define=YOUTH_CENTER_KEY=$YOUTH_CENTER_KEY
//   --dart-define=YOUTH_API_KEY=$YOUTH_API_KEY
//   --dart-define=KAKAO_MAP_API_KEY=$KAKAO_MAP_API_KEY
//   --dart-define=KAKAO_REST_API_KEY=$KAKAO_REST_API_KEY
//   --dart-define=CHAT_ENDPOINT=$CHAT_ENDPOINT

class KakaoMapScreen extends ConsumerStatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen> {
  static final _defaultCenter = KakaoMapLatLng(36.4919, 128.8889);
  static const _debounceMs = 800;

  bool _loading = true;
  String? _errorCode;
  String? _lastLog;
  KakaoMapLatLng? _latestCenter;
  int? _latestZoom;
  CenterFetchRequest? _currentRequest;
  Timer? _moveDebounce;

  @override
  void initState() {
    super.initState();

    // ─────────────────────────────────────────────────────────────────────────
    // ENV 체크 (KAKAO_REST_API_KEY, KAKAO_MAP_API_KEY) — 키 전달 여부 디버깅용
    // ─────────────────────────────────────────────────────────────────────────
    debugPrint('[KakaoMapScreen] initState() 완료');
    debugPrint(
        '[KakaoMapScreen][ENV] kakaoRestApiKey isEmpty=${AppEnv.kakaoRestApiKey.isEmpty} len=${AppEnv.kakaoRestApiKey.length}');
    // 다른 ENV 값들도 필요하면 여기서 같이 찍을 수 있음 (예: kakaoMapApiKey 등)

    _latestCenter = _defaultCenter;
    _currentRequest = const CenterFetchRequest(
      lat: 36.4919,
      lng: 128.8889,
      radiusKm: kCenterRangeKm,
    );

    debugPrint(
        '[KakaoMapScreen] 초기 요청 CenterFetchRequest(lat=${_currentRequest!.lat}, lng=${_currentRequest!.lng}, radius=${_currentRequest!.radiusKm})');
  }

  @override
  void dispose() {
    _moveDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regionName = ref.watch(regionProvider);
    final policyState = ref.watch(policyListNotifierProvider);
    final request = _currentRequest!;
    final centerMarkersAsync = ref.watch(youthCenterMapProvider(request));
    final debugPanelEnabled = ref.watch(debugPanelEnabledProvider);

    debugPrint('────────────────────────────────────────');
    debugPrint('[KakaoMapScreen] build() 호출');
    debugPrint(' └ regionName: $regionName');
    debugPrint(
        ' └ currentRequest: center=(${request.lat}, ${request.lng}), radius=${request.radiusKm}');
    debugPrint(
        ' └ latestCenter: ${_latestCenter != null ? '(${_latestCenter!.lat}, ${_latestCenter!.lng})' : 'null'}');
    debugPrint(' └ latestZoom: ${_latestZoom ?? -1}');
    debugPrint(' └ 정책 개수: ${policyState.policies.length}');
    debugPrint(' └ centerMarkersAsync = $centerMarkersAsync');
    debugPrint('────────────────────────────────────────');

    final defaultCenter = _centerForRegion(regionName);
    final effectiveRequestCenter =
        _latestCenter ?? KakaoMapLatLng(request.lat, request.lng);

    debugPrint(
        '[KakaoMapScreen] region 기반 defaultCenter=(${defaultCenter.lat}, ${defaultCenter.lng})');
    debugPrint(
        '[KakaoMapScreen] effectiveRequestCenter=(${effectiveRequestCenter.lat}, ${effectiveRequestCenter.lng})');

    return centerMarkersAsync.when(
      // ───────────────────────────────────────────────────────────────────────
      // LOADING 상태
      // ───────────────────────────────────────────────────────────────────────
      loading: () {
        debugPrint('[YCMAP] centerMarkersAsync: LOADING');
        final fallbackCenter = effectiveRequestCenter;
        final policies = _policyMarkers(fallbackCenter, policyState);
        final polylines = _polylinesFromMarkers(policies);

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: fallbackCenter,
                markers: policies,
                polylines: polylines,
                enableClustering: true,
                options: const KakaoMapOptions(
                  level: 6,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMarkerTap: (id) {
                  debugPrint('[KakaoMap] markerTap(LOADING_CENTER) -> $id');
                  if (!id.startsWith('CENTER-')) {
                    context.push(RoutePaths.policyDetail(id));
                  }
                },
                onReady: () {
                  debugPrint('[KakaoMap] WebView Ready! (LOADING state)');
                  _setLoading(false);
                },
                onLoadingChanged: (isLoading) {
                  debugPrint(
                      '[KakaoMap] WebView LoadingChanged(LOADING) → $isLoading');
                  _setLoading(isLoading);
                },
                onError: (code) {
                  debugPrint(
                      '[KakaoMap:ERROR][LOADING] WebView error code=$code');
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint(
                      '[KakaoMap:LOG][LOADING] ${event.logMessage ?? ''}');
                  setState(() => _lastLog = event.logMessage);
                },
                showDebugPanel: kDebugMode && debugPanelEnabled,
              ),
              if (_loading) const Center(child: CircularProgressIndicator()),
              if (_errorCode != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _buildErrorBanner(),
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
      },

      // ───────────────────────────────────────────────────────────────────────
      // ERROR 상태 (FutureProvider 실패)
      // ───────────────────────────────────────────────────────────────────────
      error: (err, stack) {
        debugPrint('[YCMAP] centerMarkersAsync: ERROR = $err');
        if (stack != null) {
          debugPrint('[YCMAP] ERROR stack = $stack');
        }

        final fallbackCenter = effectiveRequestCenter;
        final policies = _policyMarkers(fallbackCenter, policyState);
        final polylines = _polylinesFromMarkers(policies);

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: fallbackCenter,
                markers: policies,
                polylines: polylines,
                enableClustering: true,
                options: const KakaoMapOptions(
                  level: 6,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMarkerTap: (id) {
                  debugPrint('[KakaoMap] markerTap(CENTER_ERROR) -> $id');
                  if (!id.startsWith('CENTER-')) {
                    context.push(RoutePaths.policyDetail(id));
                  }
                },
                onReady: () {
                  debugPrint('[KakaoMap] WebView Ready! (ERROR state)');
                  _setLoading(false);
                },
                onLoadingChanged: (isLoading) {
                  debugPrint(
                      '[KakaoMap] WebView LoadingChanged(ERROR) → $isLoading');
                  _setLoading(isLoading);
                },
                onError: (code) {
                  debugPrint(
                      '[KakaoMap:ERROR][ERROR_STATE] WebView error code=$code');
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint(
                      '[KakaoMap:LOG][ERROR_STATE] ${event.logMessage ?? ''}');
                  setState(() => _lastLog = event.logMessage);
                },
                showDebugPanel: kDebugMode && debugPanelEnabled,
              ),
              if (_loading) const Center(child: CircularProgressIndicator()),
              if (_errorCode != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _buildErrorBanner(),
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
      },

      // ───────────────────────────────────────────────────────────────────────
      // DATA 상태 (센터 좌표 로딩 완료)
      // ───────────────────────────────────────────────────────────────────────
      data: (centerPoints) {
        debugPrint(
            '[YCMAP] centerMarkersAsync: DATA, rawCount=${centerPoints.length}');

        final validCenters =
            centerPoints.where((c) => c.lat != null && c.lng != null).toList();

        final currentCenter = _latestCenter ?? defaultCenter;
        debugPrint(
            '[YCMAP] DATA currentCenter=(${currentCenter.lat}, ${currentCenter.lng})');

        final sortedCenters = validCenters
            .map(
              (c) => (
                point: c,
                distance: _distanceFrom(
                  currentCenter.lat,
                  currentCenter.lng,
                  c.lat,
                  c.lng,
                ),
              ),
            )
            .toList()
          ..sort((a, b) => a.distance.compareTo(b.distance));

        final centerMarkers = List.generate(sortedCenters.length, (index) {
          final entry = sortedCenters[index];
          final c = entry.point;
          final markerId = 'CENTER-$index-${c.name}';
          return KakaoMapMarker(
            id: markerId,
            title: c.name,
            position: KakaoMapLatLng(c.lat, c.lng),
            image: const KakaoMapMarkerImage(
              url: 'https://developers.kakao.com/docs/static/images/marker.png',
              width: 26,
              height: 37,
            ),
          );
        });

        debugPrint(
            '[YCMAP] centerPoints=${centerPoints.length} validCenters=${validCenters.length}');
        debugPrint(
            '[YCMAP] centerMarkers=${centerMarkers.length} (지도에 찍을 센터 마커 수)');

        final policyMarkers = _policyMarkers(currentCenter, policyState);
        final mergedMarkers = <KakaoMapMarker>[
          ...centerMarkers,
          ...policyMarkers,
        ];

        debugPrint(
            '[YCMAP] policyMarkers=${policyMarkers.length}, mergedMarkers=${mergedMarkers.length}');

        final polylines = centerMarkers.isNotEmpty
            ? <KakaoMapPolyline>[]
            : _polylinesFromMarkers(policyMarkers);

        if (centerMarkers.isNotEmpty) {
          debugPrint('[YCMAP] polyline disabled due to center markers');
        }

        KakaoMapLatLng mapCenter = currentCenter;
        int mapLevel = _latestZoom ?? 6;

        if (validCenters.isNotEmpty) {
          final avgLat = validCenters
                  .map((c) => c.lat)
                  .fold<double>(0, (prev, lat) => prev + lat) /
              validCenters.length;
          final avgLng = validCenters
                  .map((c) => c.lng)
                  .fold<double>(0, (prev, lng) => prev + lng) /
              validCenters.length;

          mapCenter = KakaoMapLatLng(avgLat, avgLng);
          mapLevel = _latestZoom ?? 12;

          debugPrint(
              '[YCMAP] mapInitialCenter(centersBased)=(${mapCenter.lat}, ${mapCenter.lng}) zoom=$mapLevel');
        } else {
          debugPrint(
              '[YCMAP] mapInitialCenter(default/current)=(${mapCenter.lat}, ${mapCenter.lng}) zoom=$mapLevel (default)');
        }

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: mapCenter,
                markers: mergedMarkers,
                polylines: polylines,
                enableClustering: true,
                options: KakaoMapOptions(
                  level: mapLevel,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMapMoved: (center, zoom) {
                  debugPrint(
                      '[YCMAP] onMapMoved center=(${center.lat}, ${center.lng}) zoom=$zoom');
                  _latestCenter = center;
                  _latestZoom = zoom;

                  // 디바운스 로그
                  _moveDebounce?.cancel();
                  debugPrint(
                      '[YCMAP] onMapMoved → debounce ${_debounceMs}ms 후 CenterFetchRequest 갱신 예정');

                  _moveDebounce = Timer(
                    const Duration(milliseconds: _debounceMs),
                    () {
                      final req = CenterFetchRequest(
                        lat: center.lat,
                        lng: center.lng,
                        radiusKm: kCenterRangeKm,
                      );
                      debugPrint(
                          '[YCMAP] debounce 완료 → provider 재요청 CenterFetchRequest(lat=${req.lat}, lng=${req.lng}, radius=${req.radiusKm})');

                      setState(() {
                        _currentRequest = req;
                      });

                      ref.refresh(youthCenterMapProvider(req));
                    },
                  );
                },
                onMarkerTap: (id) {
                  if (id.startsWith('CENTER-')) {
                    debugPrint('[YCMAP] CENTER marker tapped -> $id');
                    final selectedName = id.replaceFirst('CENTER-', '');
                    if (centerPoints.isEmpty) {
                      debugPrint(
                          '[YCMAP] CENTER marker tapped but centerPoints is empty');
                      return;
                    }
                    final selected = centerPoints.firstWhere(
                      (c) => c.name == selectedName,
                      orElse: () {
                        debugPrint(
                            '[YCMAP] CENTER marker name mismatch, fallback to first center');
                        return centerPoints.first;
                      },
                    );

                    if (mounted) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => CenterDetailBottomSheet(
                          name: selected.name,
                          address: selected.fullAddress,
                          phone: selected.phone,
                          homepageUrl: selected.url,
                          regionLabel: selected.regionLabel,
                        ),
                      );
                    }
                    return;
                  }

                  debugPrint('[KakaoMap] POLICY marker tapped -> $id');
                  context.push(RoutePaths.policyDetail(id));
                },
                onReady: () {
                  debugPrint('[KakaoMap] WebView Ready! 지도 로딩 완료 (DATA)');
                  _setLoading(false);
                },
                onLoadingChanged: (isLoading) {
                  debugPrint(
                      '[KakaoMap] WebView LoadingChanged(DATA) → $isLoading');
                  _setLoading(isLoading);
                },
                onError: (code) {
                  debugPrint('[KakaoMap:ERROR][DATA] SDK Fail code=$code');
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint('[KakaoMap:LOG][DATA] ${event.logMessage ?? ''}');
                  setState(() => _lastLog = event.logMessage);
                },
                showDebugPanel: kDebugMode && debugPanelEnabled,
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
                  child: _buildErrorBanner(),
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
      },
    );
  }

  void _setLoading(bool value) {
    if (_loading == value) return;
    debugPrint('[KakaoMap] 로딩 상태 변경 → $_loading → $value');
    setState(() {
      _loading = value;
    });
  }

  List<KakaoMapMarker> _policyMarkers(
    KakaoMapLatLng center,
    PolicyListState asyncPolicies,
  ) {
    final policies = asyncPolicies.policies;

    debugPrint('[KakaoMap] 정책 마커 생성 요청');
    debugPrint(' └ 정책 개수: ${policies.length}');

    if (policies.isEmpty) {
      debugPrint(' └ 정책 없음 → 마커 생성 안함');
      return const [];
    }

    final markerOffsets = _markerOffsets(center);
    final limitedPolicies = policies.take(markerOffsets.length).toList();

    debugPrint(
        ' └ 실제 마커 생성 개수: ${limitedPolicies.length} (offset 패턴 길이=${markerOffsets.length})');

    return List.generate(limitedPolicies.length, (index) {
      final policy = limitedPolicies[index];
      final offset = markerOffsets[index];

      debugPrint(
          ' ⤷ PolicyMarker[$index] ${policy.policyNm} (${offset.lat}/${offset.lng})');

      return KakaoMapMarker(
        id: policy.id,
        title: policy.policyNm,
        position: offset,
        image: index == 0
            ? const KakaoMapMarkerImage(
                url:
                    'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png',
                width: 24,
                height: 35,
              )
            : null,
      );
    });
  }

  List<KakaoMapPolyline> _polylinesFromMarkers(List<KakaoMapMarker> markers) {
    if (markers.length < 2) {
      debugPrint('[KakaoMap] 마커가 1개 이하 → 폴리라인 생성 안함');
      return const [];
    }

    debugPrint('[KakaoMap] 폴리라인 생성 [${markers.length}개 마커 연결]');
    return [
      KakaoMapPolyline(
        id: 'policy-path',
        path: markers.map((m) => m.position).toList(),
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

    debugPrint('[KakaoMap] 마커 Offset 계산중');
    debugPrint(' └ base center: (${base.lat}, ${base.lng})');

    return deltas
        .map(
          (delta) => KakaoMapLatLng(
            base.lat + delta.lat,
            base.lng + delta.lng,
          ),
        )
        .toList();
  }

  double _distanceFrom(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180.0);

  KakaoMapLatLng _centerForRegion(String? regionName) {
    debugPrint('[KakaoMap] 지역 선택됨: $regionName');

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
        return _defaultCenter;
    }
  }

  Widget _buildOverlay(PolicyListState state) {
    if (state.isLoading && state.policies.isEmpty) {
      debugPrint('[KakaoMap] 정책 로딩중 (Overlay)');
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.policies.isEmpty) {
      debugPrint('[KakaoMap] 정책 로딩 실패 (Overlay) → ${state.error}');
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

  Widget _buildErrorBanner() {
    return Container(
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
    );
  }
}
