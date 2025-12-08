// lib/features/kakaomap/kakao_map_screen.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers.dart';
import '../../application/di.dart' as app_di;
import '../../debug/debug_settings_provider.dart';
import '../../navigation/route_paths.dart';
import '../../ui/widgets/app_appbar.dart';
import '../../env/app_env.dart';
import '../center/presentation/center_detail_bottom_sheet.dart';
import '../policy_new/data/mappers/youth_center_mapper.dart';
import '../policy_new/presentation/map/youth_center_map_provider.dart';
import 'kakao_map_html_builder.dart';
import 'kakao_map_providers.dart';
import 'kakao_map_webview.dart';
import 'services/gps_service.dart';
import 'services/location_permission_service.dart';
import '../../ui/components/app_common_bottom_sheets.dart';
import 'widgets/center_card_item.dart';
import 'widgets/center_marker_tooltip.dart';

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
  static const _debounceMs = 400;
  static const _centerListHeight = 210.0;
  static const _gpsService = GpsService();
  static const _permissionService = LocationPermissionService();
  static const _locationZoomLevel = 6;
  static const _centerMarkerFallbackBase64 =
      'CjxzdmcgeG1sbnM9J2h0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnJyB3aWR0aD0nMzYnIGhlaWdodD0nMzYnIHZpZXdCb3g9JzAgMCAzNiAzNic+CjxwYXRoIGZpbGw9JyMzNDc4RjYnIGQ9J00xOCAyYy02LjA4IDAtMTEgNC45Mi0xMSAxMSAwIDcuNTQgOS4wNyAxOS40NyA5LjQ2IDE5Ljk3LjM0LjQzLjg4LjY4IDEuNDQuNjguNTcgMCAxLjEtLjI1IDEuNDUtLjY4QzE5LjkzIDMyLjQ3IDI5IDIwLjU0IDI5IDEzYzAtNi4wOC00LjkyLTExLTExLTExeicvPgo8Y2lyY2xlIGN4PScxOCcgY3k9JzEzJyByPSc0LjUnIGZpbGw9J3doaXRlJy8+Cjwvc3ZnPgo=';
  static const _userLocationMarkerBase64 =
      'PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MCIgaGVpZ2h0PSI0MCIgdmV3Qm94PSIwIDAgNDAgNDAiPgogIDxjaXJjbGUgY3g9IjIwIiBjeT0iMjAiIHI9IjciIGZpbGw9IiMwMDdhZmYiIHN0cm9rZT0id2hpdGUiIHN0cm9rZS13aWR0aD0iMiIvPgogIDxjaXJjbGUgY3g9IjIwIiBjeT0iMjAiIHI9IjQiIGZpbGw9IndoaXRlIi8+Cjwvc3ZnPg==';

  bool _loading = true;
  String? _errorCode;
  String? _lastLog;
  KakaoMapLatLng? _latestCenter;
  int? _latestZoom;
  CenterFetchRequest? _currentRequest;
  KakaoMapLatLng? _deviceLocation;
  bool _isRequestingLocation = false;
  String? _locationError;
  String? _centerMarkerIconBase64;
  Timer? _moveDebounce;
  Timer? _tooltipTimer;
  String? _activeTooltipName;
  List<CenterMarkerPoint> _cachedCenterPoints = const [];
  bool _mapReady = false;
  _PendingMove? _pendingMove;
  _PendingHighlight? _pendingHighlight;

  @override
  void initState() {
    super.initState();

    // ENV 체크 (KAKAO_REST_API_KEY, KAKAO_MAP_API_KEY) — 키 전달 여부 디버깅용
    debugPrint('[KakaoMapScreen] initState() 완료');
    debugPrint(
      '[KakaoMapScreen][ENV] kakaoRestApiKey isEmpty=${AppEnv.kakaoRestApiKey.isEmpty} '
      'len=${AppEnv.kakaoRestApiKey.length}',
    );

    _initRequestWithRegion();
    _prepareCenterMarkerIcon();
    _preloadCachedCenterMarkers();
    _loadInitialPosition();
  }

  @override
  void dispose() {
    _moveDebounce?.cancel();
    _tooltipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regionName = ref.watch(regionProvider);
    final policyState = ref.watch(policyListNotifierProvider);
    final debugPanelEnabled = ref.watch(debugPanelEnabledProvider);

    // 아직 요청 객체가 없으면 로딩 화면
    if (_currentRequest == null) {
      return Scaffold(
        appBar: const AppAppBar(title: '카카오맵 보기'),
        body: Stack(
          children: [
            const Center(child: CircularProgressIndicator()),
            if (_locationError != null) _buildLocationErrorBanner(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: _buildPositionedGpsButton(),
      );
    }

    final request = _currentRequest!;
    final centerMarkersAsync = ref.watch(youthCenterMapProvider(request));

    debugPrint('────────────────────────────────────────');
    debugPrint('[KakaoMapScreen] build() 호출');
    debugPrint(' └ regionName: $regionName');
    debugPrint(
      ' └ currentRequest: center=(${request.lat}, ${request.lng}), radius=${request.radiusKm}',
    );
    debugPrint(
      ' └ latestCenter: ${_latestCenter != null ? '(${_latestCenter!.lat}, ${_latestCenter!.lng})' : 'null'}',
    );
    debugPrint(' └ latestZoom: ${_latestZoom ?? -1}');
    debugPrint(' └ 정책 개수: ${policyState.policies.length}');
    debugPrint(' └ centerMarkersAsync = $centerMarkersAsync');
    debugPrint('────────────────────────────────────────');

    final defaultCenter = _centerForRegion(regionName);
    final effectiveRequestCenter =
        _latestCenter ?? KakaoMapLatLng(request.lat, request.lng);

    debugPrint(
      '[KakaoMapScreen] region 기반 defaultCenter=(${defaultCenter.lat}, ${defaultCenter.lng})',
    );
    debugPrint(
      '[KakaoMapScreen] effectiveRequestCenter=(${effectiveRequestCenter.lat}, ${effectiveRequestCenter.lng})',
    );

    return centerMarkersAsync.when(
      // LOADING 상태
      loading: () {
        debugPrint('[YCMAP] centerMarkersAsync: LOADING');

        final fallbackCenter = effectiveRequestCenter;
        final policies = _policyMarkers(fallbackCenter, policyState);
        final polylines = _polylinesFromMarkers(policies);
        final locationMarker = _currentLocationMarker;
        final cachedCenters = _buildCenterMarkers(_cachedCenterPoints);
        final fallbackMarkers = <KakaoMapMarker>[
          if (locationMarker != null) locationMarker,
          ...cachedCenters,
          ...policies,
        ];

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: fallbackCenter,
                markers: fallbackMarkers,
                polylines: polylines,
                enableClustering: false, // 클러스터러 비활성화 (아이콘 깨짐 방지 + 단일 마커 UX)
                options: const KakaoMapOptions(
                  level: 6,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMarkerTap: (id) {
                  debugPrint('[KakaoMap] markerTap(LOADING_CENTER) -> $id');
                  if (id.startsWith('CENTER-')) {
                    debugPrint(
                      '[KakaoMap] CENTER marker tap routed to handler',
                    );
                    return;
                  }
                  context.push(RoutePaths.policyDetail(id));
                },
                onMarkerClicked: _handleCenterMarkerClicked,
                onReady: _onWebViewReady,
                onLoadingChanged: _onWebViewLoadingChanged,
                onError: (code) {
                  debugPrint(
                    '[KakaoMap:ERROR][LOADING] WebView error code=$code',
                  );
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint(
                    '[KakaoMap:LOG][LOADING] ${event.logMessage ?? ''}',
                  );
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
              if (_locationError != null) _buildLocationErrorBanner(),
              Positioned(
                left: 0,
                right: 0,
                top: 16,
                child: _buildOverlay(policyState),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: _buildPositionedGpsButton(),
        );
      },

      // ERROR 상태
      error: (err, stack) {
        debugPrint('[YCMAP] centerMarkersAsync: ERROR = $err');
        if (stack != null) {
          debugPrint('[YCMAP] ERROR stack = $stack');
        }

        final fallbackCenter = effectiveRequestCenter;
        final policies = _policyMarkers(fallbackCenter, policyState);
        final polylines = _polylinesFromMarkers(policies);
        final locationMarker = _currentLocationMarker;
        final cachedCenters = _buildCenterMarkers(_cachedCenterPoints);
        final fallbackMarkers = <KakaoMapMarker>[
          if (locationMarker != null) locationMarker,
          ...cachedCenters,
          ...policies,
        ];

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: fallbackCenter,
                markers: fallbackMarkers,
                polylines: polylines,
                enableClustering: false,
                options: const KakaoMapOptions(
                  level: 6,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMarkerTap: (id) {
                  debugPrint('[KakaoMap] markerTap(CENTER_ERROR) -> $id');
                  if (id.startsWith('CENTER-')) {
                    debugPrint(
                      '[KakaoMap] CENTER marker tap routed to handler',
                    );
                    return;
                  }
                  context.push(RoutePaths.policyDetail(id));
                },
                onMarkerClicked: _handleCenterMarkerClicked,
                onReady: _onWebViewReady,
                onLoadingChanged: _onWebViewLoadingChanged,
                onError: (code) {
                  debugPrint(
                    '[KakaoMap:ERROR][ERROR_STATE] WebView error code=$code',
                  );
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint(
                    '[KakaoMap:LOG][ERROR_STATE] ${event.logMessage ?? ''}',
                  );
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
              if (_locationError != null) _buildLocationErrorBanner(),
              Positioned(
                left: 0,
                right: 0,
                top: 16,
                child: _buildOverlay(policyState),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: _buildPositionedGpsButton(),
        );
      },

      // DATA 상태
      data: (centerPoints) {
        debugPrint(
          '[YCMAP] centerMarkersAsync: DATA, rawCount=${centerPoints.length}',
        );

        final currentCenter = _latestCenter ?? defaultCenter;
        debugPrint(
          '[YCMAP] DATA currentCenter=(${currentCenter.lat}, ${currentCenter.lng})',
        );

        final sortedCenters = centerPoints
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

        final sortedCenterPoints =
            sortedCenters.map((entry) => entry.point).toList();

        final hasNewCenters = sortedCenterPoints.isNotEmpty;
        final visibleCenterPoints =
            hasNewCenters ? sortedCenterPoints : _cachedCenterPoints;

        if (hasNewCenters) {
          _cachedCenterPoints = sortedCenterPoints;
        } else if (_cachedCenterPoints.isNotEmpty) {
          debugPrint('[YCMAP] 새 데이터 없음 → 캐시된 센터 마커 유지');
        }

        final centerIconBase64 =
            _centerMarkerIconBase64 ?? _centerMarkerFallbackBase64;
        final centerMarkerImage = KakaoMapMarkerImage(
          url: 'data:image/png;base64,$centerIconBase64',
          width: 36,
          height: 36,
          offset: const Offset(18, 36),
        );

        final centerMarkers =
            _buildCenterMarkers(visibleCenterPoints, image: centerMarkerImage);

        debugPrint(
          '[YCMAP] centerPoints=${centerPoints.length} '
          'validCenters=${centerPoints.length}',
        );
        debugPrint(
          '[YCMAP] centerMarkers=${centerMarkers.length} (지도에 찍을 센터 마커 수)',
        );

        final policyMarkers = _policyMarkers(currentCenter, policyState);
        final locationMarker = _currentLocationMarker;
        final mergedMarkers = <KakaoMapMarker>[
          if (locationMarker != null) locationMarker,
          ...centerMarkers,
          ...policyMarkers,
        ];

        debugPrint(
          '[YCMAP] policyMarkers=${policyMarkers.length}, '
          'mergedMarkers=${mergedMarkers.length}',
        );

        final polylines = centerMarkers.isNotEmpty
            ? <KakaoMapPolyline>[] // 센터 마커가 있으면 정책 경로는 숨김
            : _polylinesFromMarkers(policyMarkers);

        if (centerMarkers.isNotEmpty) {
          debugPrint('[YCMAP] polyline disabled due to center markers');
        }

        KakaoMapLatLng mapCenter = currentCenter;
        int mapLevel = _latestZoom ?? 6;

        if (_latestCenter == null && visibleCenterPoints.isNotEmpty) {
          final nearest = visibleCenterPoints.first;
          mapCenter = KakaoMapLatLng(nearest.lat, nearest.lng);
          mapLevel = _locationZoomLevel;

          debugPrint(
            '[YCMAP] mapInitialCenter(centersBased)=(${mapCenter.lat}, ${mapCenter.lng}) zoom=$mapLevel',
          );
        } else {
          debugPrint(
            '[YCMAP] mapInitialCenter(default/current)=(${mapCenter.lat}, ${mapCenter.lng}) zoom=$mapLevel (default)',
          );
        }

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: mapCenter,
                markers: mergedMarkers,
                polylines: polylines,
                enableClustering: false,
                options: KakaoMapOptions(
                  level: mapLevel,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMapMoved: _handleMapMoved,
                onMarkerTap: (id) {
                  if (id.startsWith('CENTER-')) {
                    debugPrint(
                      '[KakaoMap] CENTER marker tap routed to handler -> $id',
                    );
                    return;
                  }
                  debugPrint('[KakaoMap] POLICY marker tapped -> $id');
                  context.push(RoutePaths.policyDetail(id));
                },
                onMarkerClicked: _handleCenterMarkerClicked,
                onReady: _onWebViewReady,
                onLoadingChanged: _onWebViewLoadingChanged,
                onError: (code) {
                  debugPrint('[KakaoMap:ERROR][DATA] SDK Fail code=$code');
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint(
                    '[KakaoMap:LOG][DATA] ${event.logMessage ?? ''}',
                  );
                  setState(() => _lastLog = event.logMessage);
                },
                showDebugPanel: kDebugMode && debugPanelEnabled,
              ),
              if (_activeTooltipName != null)
                Positioned(
                  top: 32,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CenterMarkerTooltip(name: _activeTooltipName!),
                  ),
                ),

              // 전역 로딩 인디케이터
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),

              // 에러 배너
              if (_errorCode != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _buildErrorBanner(),
                ),

              // 위치 에러 배너
              if (_locationError != null) _buildLocationErrorBanner(),

              // 정책 로딩 상태 오버레이
              Positioned(
                left: 0,
                right: 0,
                top: 16,
                child: _buildOverlay(policyState),
              ),

              // ✅ 센터 목록 카드 리스트 (지도 하단에 고정)
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildCenterList(
                  visibleCenterPoints,
                  radiusKm: _currentRequest?.radiusKm ?? kCenterRangeKm,
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: _buildPositionedGpsButton(),
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

  void _initRequestWithRegion() {
    final regionName = ref.read(regionProvider);
    final regionCenter = _centerForRegion(regionName);

    _latestCenter ??= regionCenter;
    _latestZoom ??= _locationZoomLevel;
    _currentRequest ??= CenterFetchRequest(
      lat: regionCenter.lat,
      lng: regionCenter.lng,
      radiusKm: kCenterRangeKm,
    );
  }

  List<KakaoMapMarker> _policyMarkers(
    KakaoMapLatLng center,
    PolicyListState asyncPolicies,
  ) {
    debugPrint(
        '[KakaoMap] Policy markers disabled (replacement logic removed)');
    return const [];
  }

  List<KakaoMapMarker> _buildCenterMarkers(
    List<CenterMarkerPoint> points, {
    KakaoMapMarkerImage? image,
  }) {
    final markerImage = image ??
        KakaoMapMarkerImage(
          url:
              'data:image/png;base64,${_centerMarkerIconBase64 ?? _centerMarkerFallbackBase64}',
          width: 36,
          height: 36,
          offset: const Offset(18, 36),
        );

    return List.generate(points.length, (index) {
      final center = points[index];
      final markerId = 'CENTER-${center.id}';
      return KakaoMapMarker(
        id: markerId,
        title: center.name,
        position: KakaoMapLatLng(center.lat, center.lng),
        image: markerImage,
        extra: {
          'id': center.id,
          'name': center.name,
          'fullAddress': center.fullAddress,
          'phone': center.phone,
          'url': center.url,
          'regionLabel': center.regionLabel,
        },
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

  Widget _buildCenterList(
    List<CenterMarkerPoint> centers, {
    required double radiusKm,
  }) {
    return SafeArea(
      top: false,
      child: Container(
        height: _centerListHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.0),
              Colors.white.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _buildRadiusPill(radiusKm),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: centers.isEmpty
                  ? const Center(
                      child: Text('주변 센터 정보를 불러오는 중입니다.'),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      itemCount: centers.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) {
                        final center = centers[index];
                        return CenterCardItem(
                          center: center,
                          onTap: () => _onCenterCardTap(center, index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadInitialPosition() async {
    if (_isRequestingLocation) return;
    setState(() {
      _isRequestingLocation = true;
      _locationError = null;
    });

    try {
      final serviceEnabled = await _gpsService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _showLocationPermissionGuide(
          LocationBottomSheetIssue.serviceDisabled,
        );
        throw '위치 서비스가 꺼져 있습니다. 설정에서 활성화해주세요.';
      }

      final permissionResult = await _permissionService.ensurePermission();
      if (permissionResult == LocationPermissionIssue.denied) {
        await _showLocationPermissionGuide(
          LocationBottomSheetIssue.permissionDenied,
        );
        throw '위치 권한이 거부되었습니다.';
      }

      if (permissionResult == LocationPermissionIssue.deniedForever) {
        await _showLocationPermissionGuide(
          LocationBottomSheetIssue.permissionPermanentlyDenied,
        );
        throw '위치 권한이 영구히 거부되었으며, 설정에서 위치 권한을 허용해 주세요.';
      }

      final position = await _gpsService.getCurrentPosition();

      if (!mounted) return;

      final location = KakaoMapLatLng(position.latitude, position.longitude);
      final request = CenterFetchRequest(
        lat: location.lat,
        lng: location.lng,
        radiusKm: kCenterRangeKm,
      );

      setState(() {
        _deviceLocation = location;
        _latestCenter = _deviceLocation;
        _latestZoom = _locationZoomLevel;
        _currentRequest = request;
      });

      await _moveMapToLocation(
        location,
        level: _locationZoomLevel,
        animate: true,
      );
      await _updateSearchCircle(location);
      ref.refresh(youthCenterMapProvider(request));
      debugPrint(
        '[KakaoMapScreen] GPS 위치 읽기 완료 (${position.latitude}, ${position.longitude})',
      );
      await _showMyPositionOnMap();
    } catch (error, stack) {
      final message = error?.toString() ?? '위치 정보를 가져오는 동안 문제가 발생했습니다.';
      debugPrint('[KakaoMapScreen] GPS 위치 읽기 실패: $message');
      if (stack != null) {
        debugPrint(stack.toString());
      }
      if (mounted) {
        setState(() {
          _locationError = message;
        });
      }
      if (_currentRequest == null) {
        await _applyFallbackCenter();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingLocation = false;
        });
      }
    }
  }

  Future<void> _showMyPositionOnMap() async {
    final location = _deviceLocation;
    if (location == null) return;
    if (!_mapReady) {
      debugPrint('[KakaoMapScreen] map not ready → skip showMyPosition');
      return;
    }
    try {
      final controller = ref.read(kakaoMapControllerProvider);
      await controller.showMyPosition(location);
      await controller.updateCircle(location);
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] showMyPosition failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  Future<void> _updateSearchCircle(KakaoMapLatLng center) async {
    if (!mounted) return;
    if (!_mapReady) {
      debugPrint('[KakaoMapScreen] map not ready → circle update skipped');
      return;
    }
    try {
      final controller = ref.read(kakaoMapControllerProvider);
      await controller.updateCircle(center);
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] updateCircle failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  Future<void> _showLocationPermissionGuide(
    LocationBottomSheetIssue issue,
  ) async {
    if (!mounted) return;
    await showLocationPermissionBottomSheet(
      context,
      issue: issue,
    );
  }

  Future<void> _applyFallbackCenter() async {
    if (!mounted) return;
    final fallback = _centerForRegion(ref.read(regionProvider));
    final request = CenterFetchRequest(
      lat: fallback.lat,
      lng: fallback.lng,
      radiusKm: kCenterRangeKm,
    );

    setState(() {
      _deviceLocation = null;
      _latestCenter = fallback;
      _latestZoom = _locationZoomLevel;
      _currentRequest = request;
      _locationError ??= '기본 위치(경북 중심)를 기준으로 지도를 표시합니다.';
    });

    await _moveMapToLocation(fallback, level: _locationZoomLevel);
    await _updateSearchCircle(fallback);
    ref.refresh(youthCenterMapProvider(request));
  }

  Future<void> _moveMapToLocation(
    KakaoMapLatLng location, {
    int? level,
    bool updateMyPosition = true,
    bool updateCircle = true,
    bool animate = false,
  }) async {
    _latestCenter = location;
    if (level != null) {
      _latestZoom = level;
    }

    if (!_mapReady) {
      _pendingMove = _PendingMove(
        target: location,
        level: level,
        updateMyPosition: updateMyPosition,
        updateCircle: updateCircle,
        animate: animate,
      );
      debugPrint('[KakaoMapScreen] map not ready → move queued $_pendingMove');
      return;
    }

    try {
      final controller = ref.read(kakaoMapControllerProvider);
      if (animate) {
        await controller.animateTo(location, level: level);
      } else {
        await controller.moveMapTo(location, level: level);
      }
      if (updateMyPosition) {
        await controller.showMyPosition(location);
      }
      if (updateCircle) {
        await controller.updateCircle(location);
      }
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] moveMapTo failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  Future<void> _prepareCenterMarkerIcon() async {
    try {
      final data = await rootBundle.load('assets/map/center_marker.png');
      final encoded = base64Encode(data.buffer.asUint8List());
      if (!mounted) return;
      setState(() {
        _centerMarkerIconBase64 = encoded;
      });
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] center marker icon load failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
      if (mounted) {
        setState(() {
          _centerMarkerIconBase64 ??= _centerMarkerFallbackBase64;
        });
      }
    }
  }

  Future<void> _preloadCachedCenterMarkers() async {
    try {
      final prefs = ref.read(app_di.sharedPreferencesProvider);
      final cached = prefs.getString('yc_center_marker_cache_v1');
      if (cached == null || cached.isEmpty) return;

      final decoded = jsonDecode(cached) as List<dynamic>;
      final markers = decoded
          .map((e) => _decodeCachedMarker(e as Map<String, dynamic>))
          .whereType<CenterMarkerPoint>()
          .toList();

      if (markers.isEmpty || !mounted) return;

      setState(() {
        _cachedCenterPoints = markers;
      });
      debugPrint('[KakaoMapScreen] preload marker cache -> ${markers.length} entries');
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] preload marker cache failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  Future<KakaoMapLatLng?> _loadLastKnownPosition() async {
    try {
      final position = await _gpsService.getLastKnownPosition();
      if (position == null) return null;

      final location = KakaoMapLatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _deviceLocation ??= location;
        });
      }
      return location;
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] last known location unavailable: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
      return null;
    }
  }

  KakaoMapMarker? get _currentLocationMarker {
    final location = _deviceLocation;
    if (location == null) return null;
    return KakaoMapMarker(
      id: 'CURRENT_LOCATION',
      title: '현재 위치',
      position: location,
      image: const KakaoMapMarkerImage(
        url: 'data:image/svg+xml;base64,$_userLocationMarkerBase64',
        width: 28,
        height: 28,
        offset: Offset(14, 14),
      ),
    );
  }

  Widget _buildLocationErrorBanner() {
    final message = _locationError ?? '위치 정보를 사용할 수 없습니다.';
    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: _isRequestingLocation ? null : _loadInitialPosition,
              child: const Text(
                '다시 시도',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGpsButton() {
    return FloatingActionButton(
      heroTag: 'kakao_map_gps',
      onPressed: _handleGpsButtonPressed,
      tooltip: '내 위치로 이동',
      child: _isRequestingLocation
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.my_location),
    );
  }

  Widget _buildPositionedGpsButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 8,
        ),
        child: _buildGpsButton(),
      ),
    );
  }

  Future<void> _handleGpsButtonPressed() async {
    final cached = _deviceLocation ?? await _loadLastKnownPosition();
    final anchor = cached ?? _latestCenter ?? _centerForRegion(ref.read(regionProvider));
    final request = CenterFetchRequest(
      lat: anchor.lat,
      lng: anchor.lng,
      radiusKm: kCenterRangeKm,
    );

    setState(() {
      _latestCenter = anchor;
      _latestZoom = _locationZoomLevel;
      _currentRequest = request;
    });

    await _moveMapToLocation(
      anchor,
      level: _locationZoomLevel,
      updateMyPosition: cached != null,
      updateCircle: true,
      animate: true,
    );

    unawaited(_updateSearchCircle(anchor));
    ref.refresh(youthCenterMapProvider(request));
    if (cached == null && _currentRequest == null) {
      setState(() {
        _currentRequest = CenterFetchRequest(
          lat: anchor.lat,
          lng: anchor.lng,
          radiusKm: kCenterRangeKm,
        );
      });
    }

    if (_isRequestingLocation) return;
    await _loadInitialPosition();
  }

  void _handleMapMoved(KakaoMapLatLng center, int zoom) {
    debugPrint('[YCMAP] onMapMoved center=(${center.lat}, ${center.lng}) zoom=$zoom');
    _latestCenter = center;
    _latestZoom = zoom;

    unawaited(_updateSearchCircle(center));

    final nextRequest = CenterFetchRequest(
      lat: center.lat,
      lng: center.lng,
      radiusKm: kCenterRangeKm,
    );

    if (_currentRequest == nextRequest) {
      debugPrint('[YCMAP] onMapMoved → 요청 변경 없음, provider refresh 생략');
      return;
    }

    _moveDebounce?.cancel();
    debugPrint(
      '[YCMAP] onMapMoved → debounce ${_debounceMs}ms 후 CenterFetchRequest 갱신 예정',
    );

    _moveDebounce = Timer(
      const Duration(milliseconds: _debounceMs),
      () {
        if (!mounted) return;
        debugPrint(
          '[YCMAP] debounce 완료 → provider 재요청 '
          'CenterFetchRequest(lat=${nextRequest.lat}, lng=${nextRequest.lng}, radius=${nextRequest.radiusKm})',
        );

        setState(() {
          _currentRequest = nextRequest;
        });

        ref.refresh(youthCenterMapProvider(nextRequest));
        final req = CenterFetchRequest(
          lat: center.lat,
          lng: center.lng,
          radiusKm: kCenterRangeKm,
        );
        debugPrint(
          '[YCMAP] debounce 완료 → provider 재요청 '
          'CenterFetchRequest(lat=${req.lat}, lng=${req.lng}, radius=${req.radiusKm})',
        );

        setState(() {
          _currentRequest = req;
        });

        final circleCenter = _deviceLocation ?? center;
        unawaited(_updateSearchCircle(circleCenter));
        ref.refresh(youthCenterMapProvider(req));
      },
    );
  }

  void _onWebViewLoadingChanged(bool isLoading) {
    unawaited(() async {
      debugPrint('[KakaoMap] WebView LoadingChanged → $isLoading');
      _setLoading(isLoading);
      if (isLoading) {
        _mapReady = false;
        final anchor = _latestCenter ??
            (_currentRequest != null
                ? KakaoMapLatLng(
                    _currentRequest!.lat,
                    _currentRequest!.lng,
                  )
                : _deviceLocation ?? _centerForRegion(ref.read(regionProvider)));

        if (_pendingMove == null && anchor != null) {
          _pendingMove = _PendingMove(
            target: anchor,
            level: _latestZoom,
            updateMyPosition: _deviceLocation != null,
            updateCircle: true,
            animate: false,
          );
          debugPrint('[KakaoMap] 로딩 시작 → 현재 지도 상태를 큐에 보관: $_pendingMove');
        }
      } else {
        final controller = ref.read(kakaoMapControllerProvider);
        if (controller.isReady) {
          debugPrint('[KakaoMap] 로딩 종료 → 준비 상태 복구 및 대기 작업 반영');
          _mapReady = true;
          await _flushPendingMove();
          await _flushPendingHighlight();
          final request = _currentRequest;
          final circleCenter = _latestCenter ??
              (request != null
                  ? KakaoMapLatLng(request.lat, request.lng)
                  : _deviceLocation);
          if (circleCenter != null) {
            await _showMyPositionOnMap();
            await _updateSearchCircle(circleCenter);
          }
        }
      }
    }());
    debugPrint('[KakaoMap] WebView LoadingChanged → $isLoading');
    if (isLoading) {
      _mapReady = false;
    }
    _setLoading(isLoading);
  }

  Future<void> _onWebViewReady() async {
    debugPrint('[KakaoMap] WebView Ready!');
    _mapReady = true;
    _setLoading(false);
    await _flushPendingMove();
    await _flushPendingHighlight();
    await _showMyPositionOnMap();
    final request = _currentRequest;
    final circleCenter = _latestCenter ??
        (request != null
            ? KakaoMapLatLng(request.lat, request.lng)
            : _deviceLocation);
    if (circleCenter != null) {
      await _updateSearchCircle(circleCenter);
    }
  }

  Future<void> _flushPendingMove() async {
    final pending = _pendingMove;
    if (!_mapReady || pending == null) return;

    debugPrint('[KakaoMapScreen] applying queued move: $pending');
    _pendingMove = null;
    await _moveMapToLocation(
      pending.target,
      level: pending.level,
      updateMyPosition: pending.updateMyPosition,
      updateCircle: pending.updateCircle,
      animate: pending.animate,
    );
  }

  Future<void> _flushPendingHighlight() async {
    final pending = _pendingHighlight;
    if (!_mapReady || pending == null) return;

    debugPrint('[KakaoMapScreen] applying queued highlight: $pending');
    _pendingHighlight = null;
    await _highlightCenterMarker(
      pending.markerId,
      pending.position,
      tooltipName: pending.tooltipName,
    );
    if (pending.tooltipName != null) _showMarkerTooltip(pending.tooltipName!);
  }

  Widget _buildRadiusPill(double radiusKm) {
    final colors = Theme.of(context).colorScheme;
    final roundedRadius = radiusKm.round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.primary.withOpacity(0.2)),
      ),
      child: Text(
        '내 위치 기준 반경 ${roundedRadius}km',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Future<void> _onCenterCardTap(
    CenterMarkerPoint center,
    int index,
  ) async {
    final markerId = 'CENTER-${center.id}';
    final position = KakaoMapLatLng(center.lat, center.lng);
    final radius = _currentRequest?.radiusKm ?? kCenterRangeKm;
    final request = CenterFetchRequest(
      lat: position.lat,
      lng: position.lng,
      radiusKm: radius,
    );
    setState(() {
      _latestCenter = position;
      _latestZoom = _locationZoomLevel;
      _currentRequest = request;
    });
    await _moveMapToLocation(
      position,
      level: _locationZoomLevel,
      updateMyPosition: false,
      updateCircle: true,
      animate: true,
    );
    ref.refresh(youthCenterMapProvider(request));
    await _highlightCenterMarker(
      markerId,
      position,
      tooltipName: center.name,
    );
    await _updateSearchCircle(position);
    ref.refresh(youthCenterMapProvider(request));
    await _highlightCenterMarker(markerId, position);
    _showMarkerTooltip(center.name);
    _showCenterDetailSheet(
      name: center.name,
      address: center.fullAddress,
      phone: center.phone,
      homepageUrl: center.url,
      regionLabel: center.regionLabel,
    );
  }

  Future<void> _highlightCenterMarker(
    String markerId,
    KakaoMapLatLng position,
    {String? tooltipName},
  ) async {
    if (!_mapReady) {
      _pendingHighlight = _PendingHighlight(
        markerId: markerId,
        position: position,
        tooltipName: tooltipName,
      );
      debugPrint('[KakaoMapScreen] map not ready → highlight queued: $_pendingHighlight');
      return;
    }

    try {
      final controller = ref.read(kakaoMapControllerProvider);
      await controller.highlightMarker(markerId, position);
    } catch (error, stackTrace) {
      debugPrint('[KakaoMapScreen] highlightCenterMarker failed: $error');
      debugPrint(stackTrace.toString());
    }
  }

  void _showCenterDetailSheet({
    required String name,
    required String address,
    String? phone,
    String? homepageUrl,
    required String regionLabel,
  }) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CenterDetailBottomSheet(
        name: name,
        address: address,
        phone: phone,
        homepageUrl: homepageUrl,
        regionLabel: regionLabel,
      ),
    );
  }

  void _showMarkerTooltip(String name) {
    _tooltipTimer?.cancel();
    setState(() {
      _activeTooltipName = name;
    });
    _tooltipTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _activeTooltipName = null;
      });
    });
  }

  void _handleCenterMarkerClicked(
    String markerId,
    Map<String, dynamic>? extra,
  ) {
    debugPrint('[KakaoMap] markerClicked event -> $markerId');
    if (extra == null) {
      debugPrint('[KakaoMap] center marker payload missing, ignoring');
      return;
    }

    final tooltipName = extra['name']?.toString();
    if (tooltipName != null && tooltipName.isNotEmpty) {
      _showMarkerTooltip(tooltipName);
    }

    _showCenterDetailSheet(
      name: extra['name']?.toString() ?? '청년센터',
      address: extra['fullAddress']?.toString() ?? '',
      phone: extra['phone']?.toString(),
      homepageUrl: extra['url']?.toString(),
      regionLabel: extra['regionLabel']?.toString() ?? '',
    );
  }

  CenterMarkerPoint? _decodeCachedMarker(Map<String, dynamic> json) {
    try {
      return CenterMarkerPoint(
        id: json['id'] as String,
        name: json['name'] as String,
        rawAddress: json['rawAddress'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        fullAddress: json['fullAddress'] as String,
        phone: json['phone'] as String?,
        url: json['url'] as String?,
        regionLabel: json['regionLabel'] as String,
      );
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] marker cache decode failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
      return null;
    }
  }
}

class _PendingMove {
  const _PendingMove({
    required this.target,
    this.level,
    this.updateMyPosition = true,
    this.updateCircle = true,
    this.animate = false,
  });

  final KakaoMapLatLng target;
  final int? level;
  final bool updateMyPosition;
  final bool updateCircle;
  final bool animate;

  @override
  String toString() {
    return 'target=(${target.lat}, ${target.lng}), level=$level, '
        'updateMyPosition=$updateMyPosition, updateCircle=$updateCircle, animate=$animate';
  }
}

class _PendingHighlight {
  const _PendingHighlight({
    required this.markerId,
    required this.position,
    this.tooltipName,
  });

  final String markerId;
  final KakaoMapLatLng position;
  final String? tooltipName;

  @override
  String toString() {
    return 'markerId=$markerId, position=(${position.lat}, ${position.lng}), '
        'tooltip=${tooltipName ?? 'none'}';
  }
}
