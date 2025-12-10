// lib/features/kakaomap/kakao_map_screen.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../application/di.dart' as app_di;
import '../../debug/debug_settings_provider.dart';
import '../../navigation/route_paths.dart';
import '../../ui/widgets/app_appbar.dart';
import '../../env/app_env.dart';
import '../center/presentation/center_detail_bottom_sheet.dart';
import '../policy_new/data/mappers/youth_center_mapper.dart';
import '../policy_new/presentation/map/youth_center_map_provider.dart';
import 'current_location_provider.dart';
import 'kakao_map_controller.dart';
import 'kakao_map_html_builder.dart';
import 'kakao_map_providers.dart';
import 'kakao_map_webview.dart';
import 'services/location_permission_service.dart';
import '../../ui/components/app_common_bottom_sheets.dart';
import 'widgets/center_list_bottom_sheet.dart';
import 'widgets/center_marker_tooltip.dart';

// flutter run
//   --dart-define=YOUTH_CENTER_KEY=$YOUTH_CENTER_KEY
//   --dart-define=YOUTH_API_KEY=$YOUTH_API_KEY
//   --dart-define=KAKAO_MAP_API_KEY=$KAKAO_MAP_API_KEY
//   --dart-define=KAKAO_REST_API_KEY=$KAKAO_REST_API_KEY
//   --dart-define=CHAT_ENDPOINT=$CHAT_ENDPOINT

enum KakaoMapViewStatus { locating, mapReady, markersReady, locationError }

class KakaoMapScreen extends ConsumerStatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen>
    with WidgetsBindingObserver {
  static final _defaultCenter = KakaoMapLatLng(36.4919, 128.8889);
  static const _locationZoomLevel = 6;
  static const _locationTimeout = Duration(seconds: 8);
  static const _debounceDuration = Duration(milliseconds: 400);
  static const _centerMarkerFallbackBase64 =
      'CjxzdmcgeG1sbnM9J2h0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnJyB3aWR0aD0nMzYnIGhlaWdodD0nMzYnIHZpZXdCb3g9JzAgMCAzNiAzNic+CjxwYXRoIGZpbGw9JyMzNDc4RjYnIGQ9J00xOCAyYy02LjA4IDAtMTEgNC45Mi0xMSAxMSAwIDcuNTQgOS4wNyAxOS40NyA5LjQ2IDE5Ljk3LjM0LjQzLjg4LjY4IDEuNDQuNjguNTcgMCAxLjEtLjI1IDEuNDUtLjY4QzE5LjkzIDMyLjQ3IDI5IDIwLjU0IDI5IDEzYzAtNi4wOC00LjkyLTExLTExLTExeicvPgo8Y2lyY2xlIGN4PScxOCcgY3k9JzEzJyByPSc0LjUnIGZpbGw9J3doaXRlJy8+Cjwvc3ZnPgo=';
  static const _userLocationMarkerBase64 =
      'PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MCIgaGVpZ2h0PSI0MCIgdmV3Qm94PSIwIDAgNDAgNDAiPgogIDxjaXJjbGUgY3g9IjIwIiBjeT0iMjAiIHI9IjciIGZpbGw9IiMwMDdhZmYiIHN0cm9rZT0id2hpdGUiIHN0cm9rZS13aWR0aD0iMiIvPgogIDxjaXJjbGUgY3g9IjIwIiBjeT0iMjAiIHI9IjQiIGZpbGw9IndoaXRlIi8+Cjwvc3ZnPg==';

  KakaoMapViewStatus _viewStatus = KakaoMapViewStatus.locating;
  KakaoMapLatLng _mapCenter = _defaultCenter;
  double _currentRadius = kCenterRangeKm;
  bool _mapReady = false;
  KakaoMapLatLng? _deviceLocation;
  KakaoMapLatLng? _latestCenterFromMove;
  int? _latestZoom;
  String? _errorCode;
  String? _lastLog;
  String? _centerMarkerIconBase64;
  String? _activeTooltipName;
  String? _activeCenterSheetId;
  List<CenterMarkerPoint> _cachedCenterPoints = const [];
  bool _showLoadingOverlay = false;
  bool _locationResolved = false;
  bool _authErrorShown = false;
  LocationPermissionIssue? _lastPermissionIssue;
  bool _serviceGuideShown = false;
  ProviderSubscription<CurrentLocationState>? _locationSubscription;
  ProviderSubscription<YouthCenterMapState>? _centerErrorSubscription;
  final Map<String, DateTime> _snackTimestamps = {};
  static const _snackThrottle = Duration(seconds: 5);

  Timer? _moveDebounce;
  Timer? _tooltipTimer;
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        _startLocationRequest();
      }
    });
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addObserver(this);
    debugPrint('[KakaoMapScreen] initState() 완료');
    debugPrint(
      '[KakaoMapScreen][ENV] kakaoRestApiKey isEmpty=${AppEnv.kakaoRestApiKey.isEmpty} '
      'len=${AppEnv.kakaoRestApiKey.length}',
    );

    _setupLocationListener();
    _setupCenterErrorListener();
    _prepareCenterMarkerIcon();
    _preloadCachedCenterMarkers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _moveDebounce?.cancel();
    _tooltipTimer?.cancel();
    _locationTimer?.cancel();
    _locationSubscription?.close();
    _centerErrorSubscription?.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final KakaoMapController controller =
          ref.read(kakaoMapControllerProvider);
      controller.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final centerState = ref.watch(youthCenterMapStateProvider);
    final debugPanelEnabled = ref.watch(debugPanelEnabledProvider);
    final isAuthError = centerState.errorMessage
            ?.contains('센터 인증 정보가 올바르지 않습니다') ??
        false;
    final retryHandler = isAuthError ? null : _retryLoadCenters;

    _cachedCenterPoints = centerState.filteredCenters;

    final markers = _buildMarkers(centerState.filteredCenters);
    final polylines = _polylinesFromMarkers(markers);

    return Scaffold(
      appBar: const AppAppBar(title: '카카오맵 보기'),
      body: Stack(
        children: [
          Positioned.fill(
            child: KakaoMapWebView(
              center: _mapCenter,
              markers: markers,
              polylines: polylines,
              enableClustering: false,
              options: KakaoMapOptions(
                level: _latestZoom ?? _locationZoomLevel,
                mapType: KakaoMapType.roadmap,
                showZoomControl: true,
                showMapTypeControl: true,
              ),
              onMarkerTap: (id) => _handleMarkerTap(id),
              onMarkerClicked: _handleCenterMarkerClicked,
              onMapMoved: _handleMapMoved,
              onReady: _onWebViewReady,
              onLoadingChanged: _onWebViewLoadingChanged,
              onError: (code) {
                setState(() => _errorCode = code);
              },
              onLog: (log) {
                if (kDebugMode) debugPrint(log.toString());
                setState(() => _lastLog = log.message.toString());
              },
              showDebugPanel: debugPanelEnabled,
              radiusKm: _currentRadius,
            ),
          ),
          if (_viewStatus == KakaoMapViewStatus.locating)
            _buildLocatingOverlay(),
          if (_showLoadingOverlay && _viewStatus == KakaoMapViewStatus.mapReady)
            _buildLocatingOverlay(),
          if (_activeTooltipName != null)
            CenterMarkerTooltip(name: _activeTooltipName!),
          _buildCenterStatusOverlay(
            centerState,
            onRetry: retryHandler,
          ),
          Positioned(
            left: 16,
            top: 16 + MediaQuery.of(context).padding.top,
            child: _buildGpsButton(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CenterListBottomSheet(
              centers: centerState.filteredCenters,
              radiusKm: _currentRadius,
              onCenterTap: _onCenterCardTap,
              status: centerState.status,
              errorMessage: centerState.errorMessage,
              onRetry: retryHandler,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocatingOverlay() {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withOpacity(0.35),
        child: const Center(
          child: Text(
            '현재 위치 확인중...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterStatusOverlay(
    YouthCenterMapState centerState, {
    VoidCallback? onRetry,
  }) {
    final status = centerState.status;
    final shouldShow = status == YouthCenterMapStatus.loading ||
        status == YouthCenterMapStatus.empty;
    final allowInteraction = status != YouthCenterMapStatus.loading;

    final hasRetry = status == YouthCenterMapStatus.error && onRetry != null;

    String? message;
    switch (status) {
      case YouthCenterMapStatus.loading:
        message = '주변 센터 정보를 불러오는 중입니다.';
        break;
      case YouthCenterMapStatus.empty:
        message = '반경 20km 내 센터가 없습니다. 가장 가까운 센터 3곳을 보여드려요.';
        break;
      case YouthCenterMapStatus.error:
        message = null;
        break;
      case YouthCenterMapStatus.loaded:
      case YouthCenterMapStatus.initial:
        message = null;
    }

    return IgnorePointer(
      ignoring: allowInteraction,
      child: AnimatedOpacity(
        opacity: shouldShow ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: message == null
            ? const SizedBox.shrink()
            : SafeArea(
                minimum: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (hasRetry) ...[
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: onRetry,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildGpsButton() {
    return FloatingActionButton(
      heroTag: 'gps-btn',
      onPressed: _startLocationRequest,
      mini: true,
      child: const Icon(Icons.my_location),
    );
  }

  void _setupLocationListener() {
    _locationSubscription = ref.listenManual<CurrentLocationState>(
      currentLocationProvider,
      (previous, next) {
        if (next.location != null && !_locationResolved) {
          debugPrint(
            '[Location][INFO] 위치 획득 성공 lat=${next.location!.lat}, lng=${next.location!.lng}',
          );
          _locationResolved = true;
          _locationTimer?.cancel();
          _deviceLocation = next.location;
          _applyNewCenter(next.location!, animate: true, fromLocation: true);
          return;
        }

        if (!next.isLoading && !_locationResolved) {
          debugPrint('[Location][ERROR] 위치 요청 실패: ${next.error ?? 'unknown'}');
          _handleLocationIssues(next);
          if (next.error != null) {
            _locationResolved = true;
            _locationTimer?.cancel();
            _applyFallbackCenter(locationError: next.error);
          }
        }
      },
    );
  }

  void _setupCenterErrorListener() {
    _centerErrorSubscription = ref.listenManual<YouthCenterMapState>(
      youthCenterMapStateProvider,
      (previous, next) {
        final message = next.errorMessage;
        final isAuthError = message != null &&
            message.contains('센터 인증 정보가 올바르지 않습니다');
        if (next.status == YouthCenterMapStatus.error && isAuthError) {
          debugPrint('[Center][Auth] 인증 오류 감지: $message');
          _showAuthErrorOnce(message!);
        }
      },
    );
  }

  void _handleLocationIssues(CurrentLocationState state) {
    if (!mounted) return;
    if (state.serviceDisabled && !_serviceGuideShown) {
      debugPrint('[Location][ERROR] 위치 서비스 비활성화 감지, 안내 표시');
      _serviceGuideShown = true;
      _showLocationPermissionGuide(LocationBottomSheetIssue.serviceDisabled);
      return;
    }

    if (state.permissionIssue == null) return;
    if (_lastPermissionIssue == state.permissionIssue) return;
    _lastPermissionIssue = state.permissionIssue;

    if (state.permissionIssue == LocationPermissionIssue.denied) {
      debugPrint('[Location][ERROR] 권한 거부 감지, 안내 표시');
      _showLocationPermissionGuide(LocationBottomSheetIssue.permissionDenied);
    } else if (state.permissionIssue == LocationPermissionIssue.deniedForever) {
      debugPrint('[Location][ERROR] 권한 영구 거부 감지, 안내 표시');
      _showLocationPermissionGuide(
        LocationBottomSheetIssue.permissionPermanentlyDenied,
      );
    }
  }

  void _showAuthErrorOnce(String message) {
    if (_authErrorShown) return;
    _authErrorShown = true;
    if (!mounted) return;
    _showSnackOnce(
      key: 'center-auth',
      message: '센터 정보를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.',
      action: SnackBarAction(
        label: '다시 시도',
        onPressed: _retryLoadCenters,
      ),
    );
  }

  void _startLocationRequest() {
    debugPrint('[Location][INFO] 위치 요청 시작 (timeout=${_locationTimeout.inSeconds}s)');
    _locationTimer?.cancel();
    _locationTimer = Timer(_locationTimeout, () {
      if (!mounted) return;
      if (_locationResolved) return;
      debugPrint('[Location][ERROR] 위치 요청 타임아웃 발생, 기본 위치로 이동');
      _locationResolved = true;
      _applyFallbackCenter(locationError: '위치 확인 시간이 초과되었습니다.');
    });

    _lastPermissionIssue = null;
    _serviceGuideShown = false;
    setState(() {
      _viewStatus = KakaoMapViewStatus.locating;
      _showLoadingOverlay = true;
      _locationResolved = false;
    });
    ref.read(currentLocationProvider.notifier).fetch();
  }

  Future<void> _applyNewCenter(
    KakaoMapLatLng center, {
    bool animate = false,
    bool fromLocation = false,
  }) async {
    debugPrint('[Location][INFO] 지도 중심 적용 lat=${center.lat}, lng=${center.lng}, fromLocation=$fromLocation');
    _mapCenter = center;
    _latestZoom = _locationZoomLevel;
    _deviceLocation = fromLocation ? center : _deviceLocation;

    await _refreshCentersFor(center, forceFetch: true);

    setState(() {
      _viewStatus = _mapReady
          ? KakaoMapViewStatus.markersReady
          : KakaoMapViewStatus.mapReady;
      _showLoadingOverlay = false;
    });

    await _moveMap(center, level: _locationZoomLevel, animate: animate);
    await _updateSearchCircle(_mapCenter);
  }

  Future<void> _retryLoadCenters() async {
    if (!mounted) return;
    setState(() {
      _showLoadingOverlay = true;
    });

    final searchCenter = _deviceLocation ?? _mapCenter;
    await _refreshCentersFor(searchCenter, forceFetch: true);

    if (!mounted) return;
    await _updateSearchCircle(_mapCenter);

    setState(() {
      _showLoadingOverlay = false;
      _viewStatus = _mapReady
          ? KakaoMapViewStatus.markersReady
          : KakaoMapViewStatus.mapReady;
    });
  }

  Future<void> _applyFallbackCenter({String? locationError}) async {
    if (!mounted) return;
    _locationTimer?.cancel();
    final fallback = _defaultCenter;
    debugPrint('[Location][INFO] 위치 실패로 기본 좌표 사용: $fallback, error=$locationError');

    await _applyNewCenter(fallback, animate: false);

    setState(() {
      _viewStatus = _mapReady
          ? KakaoMapViewStatus.markersReady
          : KakaoMapViewStatus.mapReady;
      _errorCode = locationError;
      _showLoadingOverlay = false;
    });

    _showLocationFallbackNotice(locationError);
  }

  Future<void> _refreshCentersFor(
    KakaoMapLatLng center, {
    bool forceFetch = false,
  }) async {
    final notifier = ref.read(youthCenterMapStateProvider.notifier);
    final state = ref.read(youthCenterMapStateProvider);
    final shouldFetch =
        forceFetch || state.allCenters.isEmpty || state.status == YouthCenterMapStatus.error;

    debugPrint(
      '[Map][INFO] 중심 좌표 기준 센터 갱신 요청 center=(${center.lat}, ${center.lng}), '
      'radiusKm=$_currentRadius, fetch=$shouldFetch',
    );

    if (shouldFetch) {
      await notifier.loadCenters(center: center, radiusKm: _currentRadius);
      return;
    }

    notifier.updateCenter(center, radiusKm: _currentRadius);
  }

  void _handleMarkerTap(String id) {
    if (id.startsWith('CENTER-')) return;
    context.push(RoutePaths.policyDetail(id));
  }

  Future<void> _handleCenterMarkerClicked(
    String markerId,
    Map<String, dynamic>? _,
  ) async {
    final normalizedId = markerId.replaceFirst('CENTER-', '');
    CenterMarkerPoint? candidate;
    for (final center in _cachedCenterPoints) {
      if (center.id == normalizedId || 'CENTER-${center.id}' == markerId) {
        candidate = center;
        break;
      }
    }

    if (candidate == null) return;

    _showMarkerTooltip(candidate.name);
    _openCenterDetailPanel(
      candidate,
      'markerTap',
      markerId: markerId,
    );
  }

  Future<void> _onCenterCardTap(
    CenterMarkerPoint center,
    int index,
  ) async {
    final target = KakaoMapLatLng(center.lat, center.lng);
    await _moveMap(target, animate: true);
    _showMarkerTooltip(center.name);
    _openCenterDetailPanel(center, 'cardTap');
    setState(() => _mapCenter = target);
  }

  void _handleMapMoved(KakaoMapLatLng center, int zoom) {
    debugPrint('[Map][INFO] onMapMoved lat=${center.lat}, lng=${center.lng}, zoom=$zoom');
    _latestCenterFromMove = center;
    _latestZoom = zoom;
    _moveDebounce?.cancel();
    _moveDebounce = Timer(_debounceDuration, _onMapIdle);
  }

  Future<void> _onMapIdle() async {
    final target = _latestCenterFromMove;
    if (target == null) return;
    debugPrint('[Map][INFO] map idle reached, center=(${target.lat}, ${target.lng}), zoom=$_latestZoom');
    setState(() {
      _mapCenter = target;
      _viewStatus = _mapReady
          ? KakaoMapViewStatus.markersReady
          : KakaoMapViewStatus.mapReady;
    });
    _latestCenterFromMove = null;
    await _refreshCentersFor(target);
    await _updateSearchCircle(target);
  }

  Future<void> _moveMap(
    KakaoMapLatLng location, {
    int? level,
    bool animate = false,
  }) async {
    if (!_mapReady) {
      _mapCenter = location;
      return;
    }
    try {
      final KakaoMapController controller =
          ref.read(kakaoMapControllerProvider);
      if (animate) {
        await controller.animateTo(location, level: level);
      } else {
        await controller.moveMapTo(location, level: level);
      }
      final myLocation = _deviceLocation ?? location;
      await controller.showMyPosition(myLocation);
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] moveMap error: $error');
      if (stack != null) debugPrint(stack.toString());
    }
  }

  Future<void> _updateSearchCircle(
    KakaoMapLatLng? center,
  ) async {
    if (!_mapReady || center == null) return;
    try {
      debugPrint(
        '[Map][INFO] drawMyLocationCircle(center: ${center.lat}, ${center.lng}, '
        'radiusM: ${(_currentRadius * 1000).round()})',
      );
      final KakaoMapController controller =
          ref.read(kakaoMapControllerProvider);
      await controller.updateCircle(
        center,
        radiusMeters: _currentRadius * 1000,
      );
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] updateCircle failed: $error');
      if (stack != null) debugPrint(stack.toString());
    }
  }

  void _showLocationFallbackNotice(String? locationError) {
    final detail = locationError != null ? ' ($locationError)' : '';
    debugPrint('[Location][INFO] 기본 위치로 대체 표시$detail');
    _showSnackOnce(
      key: 'location-fallback',
      message: '현재 위치를 확인할 수 없어 기본 위치(경북 중심)로 표시합니다.',
    );
  }

  void _onWebViewReady() {
    final centerState = ref.read(youthCenterMapStateProvider);
    final nextStatus = centerState.isLoading
        ? KakaoMapViewStatus.mapReady
        : KakaoMapViewStatus.markersReady;

    setState(() {
      _mapReady = true;
      if (_viewStatus != KakaoMapViewStatus.locationError) {
        _viewStatus = nextStatus;
      }
    });
    debugPrint('[Map][INFO] WebView ready, updating overlays and position markers');
    if (_locationResolved) {
      _updateSearchCircle(_mapCenter);
    }
    final KakaoMapController controller =
        ref.read(kakaoMapControllerProvider);
    if (_deviceLocation != null) {
      controller.showMyPosition(_deviceLocation!);
    } else {
      controller.showMyPosition(_mapCenter);
    }
  }

  void _onWebViewLoadingChanged(bool isLoading) {
    setState(() {
      _showLoadingOverlay = isLoading;
    });
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

  void _openCenterDetailPanel(
    CenterMarkerPoint center,
    String source, {
    String? markerId,
  }) {
    final resolvedMarkerId = markerId ?? 'CENTER-${center.id}';
    debugPrint('[Center][Tap] source=$source centerId=$resolvedMarkerId');
    _showCenterDetailSheet(
      markerId: resolvedMarkerId,
      name: center.name,
      address: center.fullAddress,
      phone: center.phone,
      homepageUrl: center.url,
      regionLabel: center.regionLabel,
    );
  }

  void _showSnackOnce({
    required String key,
    required String message,
    SnackBarAction? action,
  }) {
    final now = DateTime.now();
    final lastShown = _snackTimestamps[key];
    if (lastShown != null && now.difference(lastShown) < _snackThrottle) {
      return;
    }

    _snackTimestamps[key] = now;
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          action: action,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showCenterDetailSheet({
    required String markerId,
    required String name,
    required String address,
    String? phone,
    String? homepageUrl,
    required String regionLabel,
  }) {
    if (!mounted) return;
    if (_activeCenterSheetId == markerId) {
      debugPrint('[Center][Panel] already open centerId=$markerId');
      return;
    }
    debugPrint('[Center][Panel] open centerId=$markerId');
    _activeCenterSheetId = markerId;

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
    ).whenComplete(() {
      if (!mounted) return;
      setState(() {
        _activeCenterSheetId = null;
      });
    });
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

  List<KakaoMapMarker> _buildMarkers(List<CenterMarkerPoint> centers) {
    final markers = <KakaoMapMarker>[];
    final centerMarkers = _buildCenterMarkers(centers);
    markers.addAll(centerMarkers);

    final userMarker = _currentLocationMarker;
    if (userMarker != null) markers.add(userMarker);
    return markers;
  }

  List<KakaoMapMarker> _buildCenterMarkers(List<CenterMarkerPoint> centers) {
    final iconBase64 = _centerMarkerIconBase64 ?? _centerMarkerFallbackBase64;
    final markerImage = KakaoMapMarkerImage(
      url: 'data:image/png;base64,$iconBase64',
      width: 36,
      height: 36,
    );

    return centers
        .map(
          (center) => KakaoMapMarker(
            id: 'CENTER-${center.id}',
            position: KakaoMapLatLng(center.lat, center.lng),
            title: center.name,
            image: markerImage,
          ),
        )
        .toList();
  }

  List<KakaoMapPolyline> _polylinesFromMarkers(List<KakaoMapMarker> markers) {
    if (markers.length < 2) return const [];
    final points = markers
        .map((m) => KakaoMapLatLng(m.position.lat, m.position.lng))
        .toList(growable: false);
    final hull = _convexHull(points);
    return [
      KakaoMapPolyline(
        id: 'center-hull',
        points: hull,
        strokeColor: '#3B82F6',
        strokeOpacity: 0.5,
        strokeWeight: 2,
      ),
    ];
  }

  KakaoMapMarker? get _currentLocationMarker {
    final location = _deviceLocation;
    if (location == null) return null;
    return KakaoMapMarker(
      id: 'USER-LOCATION',
      position: KakaoMapLatLng(location.lat, location.lng),
      title: '내 위치',
      image: KakaoMapMarkerImage(
        url: 'data:image/png;base64,$_userLocationMarkerBase64',
        width: 36,
        height: 36,
      ),
    );
  }

  Future<void> _prepareCenterMarkerIcon() async {
    final prefs = ref.read(app_di.sharedPreferencesProvider);
    final cached = prefs.getString('center_marker_base64_v1');
    if (cached != null && cached.isNotEmpty) {
      setState(() => _centerMarkerIconBase64 = cached);
      return;
    }

    try {
      final rawData = await rootBundle.load('assets/images/center_marker.png');
      final bytes = rawData.buffer.asUint8List();
      final encoded = base64Encode(bytes);
      await prefs.setString('center_marker_base64_v1', encoded);
      if (!mounted) return;
      setState(() => _centerMarkerIconBase64 = encoded);
    } catch (e) {
      debugPrint('[KakaoMapScreen] Failed to preload marker icon: $e');
    }
  }

  Future<void> _preloadCachedCenterMarkers() async {
    final prefs = ref.read(app_di.sharedPreferencesProvider);
    final markerRaw = prefs.getString('yc_center_marker_cache_v1');
    if (markerRaw == null) return;
    try {
      final decoded = jsonDecode(markerRaw) as List<dynamic>;
      final markers = decoded
          .map((e) => _decodeCachedMarker(e as Map<String, dynamic>))
          .whereType<CenterMarkerPoint>()
          .toList();
      setState(() {
        _cachedCenterPoints = markers;
      });
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] preload cache failed: $error');
      if (stack != null) debugPrint(stack.toString());
    }
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
      if (stack != null) debugPrint(stack.toString());
      return null;
    }
  }

  List<KakaoMapLatLng> _convexHull(List<KakaoMapLatLng> points) {
    if (points.length < 3) return points;

    final sorted = [...points]
      ..sort((a, b) => a.lat == b.lat
          ? a.lng.compareTo(b.lng)
          : a.lat.compareTo(b.lat));

    final cross = (KakaoMapLatLng o, KakaoMapLatLng a, KakaoMapLatLng b) {
      return (a.lat - o.lat) * (b.lng - o.lng) - (a.lng - o.lng) * (b.lat - o.lat);
    };

    final lower = <KakaoMapLatLng>[];
    for (final p in sorted) {
      while (lower.length >= 2 && cross(
            lower[lower.length - 2],
            lower[lower.length - 1],
            p,
          ) <=
          0) {
        lower.removeLast();
      }
      lower.add(p);
    }

    final upper = <KakaoMapLatLng>[];
    for (final p in sorted.reversed) {
      while (upper.length >= 2 && cross(
            upper[upper.length - 2],
            upper[upper.length - 1],
            p,
          ) <=
          0) {
        upper.removeLast();
      }
      upper.add(p);
    }

    lower.removeLast();
    upper.removeLast();
    return [...lower, ...upper];
  }
}
