지민님 💙🩵
오케이, 이제 진짜 “완전체 job01” 갑니다.

아래 블록 하나가 AGENTS.md에 그대로 들어갈 수 있는 #job01 스펙이에요.
	•	폴더 구조
	•	도메인 / 데이터 / 애플리케이션 / 프레젠테이션
	•	SWR 캐시
	•	에러(PolicyFailure)
	•	Result 래퍼
	•	Global Settings
	•	Global EventBus
	•	Global Logger 인터페이스
	•	Mock Remote Source
	•	Provider DI
	•	Paging Controller 규약
까지 전부 한 번에 정리된 “기반 설계 + 초기 구현 스펙”입니다.

원하시면 나중에 이걸 기반으로
#job02, #job03 … 쭉 이어서 만들어줄 수 있어요 🩵

⸻

✅ #job01 — PolicyNew 모듈 완전체 FULL SPEC

@chatgpt-codex
# job01 — PolicyNew 모듈 기반 구축 (FULL SPEC)
# 구조 + 최소 비즈니스 로직 + SWR + Failure + Result + Settings + EventBus + Logger + Mock + DI + PagingController 규약

목표:
- YouthRoad 신규 정책 시스템 "policy_new" 모듈의
  ✅ 폴더 구조
  ✅ 핵심 도메인 모델
  ✅ Remote/Model/Cache/Repository
  ✅ SWR 캐싱 기본 흐름
  ✅ 에러/Result 규약
  ✅ Global Settings
  ✅ Global EventBus
  ✅ Logger 인터페이스
  ✅ Mock RemoteSource
  ✅ Paging Controller + Provider + 테스트용 Screen
  를 한 번에 구축한다.

- job01 종료 시점에:
  - 실제로 정책 목록을 조회하는 최소 화면이 동작해야 한다.
  - 이후 job02~job13에서 이 구조를 그대로 확장만 해 나가면 된다.
  - 기존 정책 코드(V1/V2)는 전혀 건드리지 않는다.

---

# 1. 전역 규칙

1.1 기존 코드 수정 금지
- 아래 경로의 파일은 절대 수정하지 않는다:
  - lib/ui/screens/policy/**
  - lib/data/policy/**
  - 그 외 기존 정책 관련 V1/V2 코드들
- 이 job01의 작업 범위는 **오직** `lib/features/policy_new/**` 아래로 한정한다.

1.2 레이어 규칙
- 의존 방향은 **항상** 다음만 허용:
  - domain → data → application → presentation
- presentation 레이어(UI)는 Repository나 RemoteSource에 직접 접근하지 않는다.
  - 오직 application 레이어의 Controller + Provider를 통해 접근한다.

1.3 DTO / Domain 규약
- RemoteSource는 **항상** Model(예: `PolicyModel`)만 반환한다.
- Repository는 **항상** Domain(예: `Policy`) 또는 `PolicyResult<Policy>`를 반환한다.
- UI/Controller/Provider에서는 Model을 직접 사용하지 않는다.
- Model → Domain 변환은 오직 Model 내부 메서드(`toDomain`)에서만 수행한다.

1.4 Controller 규약
- 모든 주요 상태관리는 Riverpod 2.x `StateNotifier<AsyncValue<T>>` 패턴으로 구현한다.
- 상태 흐름:
  - 초기: `AsyncValue.loading()`
  - 성공: `AsyncValue.data(...)`
  - 실패: `AsyncValue.error(PolicyFailure, StackTrace)`
- 페이징이 필요한 Controller는 최소 아래 메서드를 가져야 한다:
  - `Future<void> loadFirstPage()`
  - `Future<void> loadNextPage()`
  - `Future<void> refresh()`
- 중복 로딩 방지 플래그(`_isLoading`)를 두어, 동시에 여러 번 `loadNextPage()`가 호출되어도 한 번만 동작하도록 한다.

1.5 UI 규칙
- Screen은 반드시 `ConsumerWidget` 또는 `ConsumerStatefulWidget`으로 구현한다.
- 재사용 가능한 단순 위젯만 StatelessWidget으로 허용한다.
- 이 job01에서는 UI를 최소한으로만 구성한다. (디자인은 이후 job에서 강화)

---

# 2. 폴더 구조

다음 폴더 구조를 생성한다:

```txt
lib/features/policy_new/
  domain/
    entities/
    values/
    repositories/
  data/
    models/
    sources/
    repositories/
    cache/
    notification/
  application/
    controllers/
    providers.dart
  presentation/
    screens/
    tabs/
    widgets/


⸻

3. Domain 레이어

3.1 파일: domain/entities/policy.dart

class Policy {
  final String id;
  final String title;
  final String region;
  final DateTime? applicationStartDate;
  final DateTime? applicationEndDate;

  const Policy({
    required this.id,
    required this.title,
    required this.region,
    this.applicationStartDate,
    this.applicationEndDate,
  });

  bool get isOngoing {
    final now = DateTime.now();
    if (applicationStartDate == null || applicationEndDate == null) return false;
    return applicationStartDate!.isBefore(now) && applicationEndDate!.isAfter(now);
  }

  bool get isUpcoming {
    final now = DateTime.now();
    if (applicationStartDate == null) return false;
    return applicationStartDate!.isAfter(now);
  }

  bool get isClosed {
    final now = DateTime.now();
    if (applicationEndDate == null) return false;
    return applicationEndDate!.isBefore(now);
  }
}


⸻

3.2 파일: domain/values/policy_failure.dart

sealed class PolicyFailure {
  final String message;
  const PolicyFailure(this.message);
}

class NetworkFailure extends PolicyFailure {
  const NetworkFailure([String msg = "네트워크 오류"]) : super(msg);
}

class ServerFailure extends PolicyFailure {
  const ServerFailure([String msg = "서버 오류"]) : super(msg);
}

class UnknownFailure extends PolicyFailure {
  const UnknownFailure([String msg = "알 수 없는 오류"]) : super(msg);
}


⸻

3.3 파일: domain/values/policy_result.dart

class PolicyResult<T> {
  final T? data;
  final PolicyFailure? failure;

  const PolicyResult._({this.data, this.failure});

  bool get isSuccess => data != null && failure == null;

  factory PolicyResult.success(T data) =>
      PolicyResult._(data: data);

  factory PolicyResult.failure(PolicyFailure failure) =>
      PolicyResult._(failure: failure);
}


⸻

3.4 파일: domain/values/policy_settings.dart

class PolicySettings {
  final int pageSize;
  final String defaultRegion;
  final bool enableCache;

  const PolicySettings({
    this.pageSize = 20,
    this.defaultRegion = '전체',
    this.enableCache = true,
  });
}


⸻

3.5 파일: domain/values/policy_event.dart

enum PolicyEventType {
  cacheCleared,
  favoritesChanged,
  profileUpdated,
  refreshRequested,
}

class PolicyEvent {
  final PolicyEventType type;
  const PolicyEvent(this.type);
}


⸻

3.6 파일: domain/values/policy_logger.dart

⚠ domain에는 인터페이스만 정의하고, 실제 구현체(Console logger 등)는 application 레이어에서 구현한다.
이렇게 해야 domain이 Flutter/플랫폼 의존성을 갖지 않는다.

abstract class PolicyLogger {
  void info(String msg);
  void warn(String msg);
  void error(String msg, [Object? err, StackTrace? stackTrace]);
}


⸻

3.7 파일: domain/repositories/policy_repository.dart

abstract class PolicyRepository {
  Future<PolicyResult<List<Policy>>> fetchPolicies({
    required int page,
    required int pageSize,
  });

  Future<PolicyResult<Policy>> fetchPolicyDetail(String id);
}


⸻

4. Data 레이어

4.1 파일: data/models/policy_model.dart

class PolicyModel {
  final String id;
  final String title;
  final String region;
  final String? startDate;
  final String? endDate;

  PolicyModel({
    required this.id,
    required this.title,
    required this.region,
    this.startDate,
    this.endDate,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      startDate: json['application_start_date']?.toString(),
      endDate: json['application_end_date']?.toString(),
    );
  }

  Policy toDomain() {
    return Policy(
      id: id,
      title: title,
      region: region,
      applicationStartDate:
          startDate != null ? DateTime.tryParse(startDate!) : null,
      applicationEndDate:
          endDate != null ? DateTime.tryParse(endDate!) : null,
    );
  }
}


⸻

4.2 파일: data/sources/policy_remote_source.dart

class PolicyRemoteSource {
  final Dio _dio;

  PolicyRemoteSource(this._dio);

  Future<List<PolicyModel>> fetchPolicies(int page, int pageSize) async {
    try {
      final res = await _dio.get('/policies', queryParameters: {
        'page': page,
        'size': pageSize,
      });

      final List data = res.data['policies'] ?? [];
      return data.map((e) => PolicyModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioError {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<PolicyModel> fetchPolicyDetail(String id) async {
    try {
      final res = await _dio.get('/policies/$id');
      return PolicyModel.fromJson(res.data as Map<String, dynamic>);
    } on DioError {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}


⸻

4.3 파일: data/sources/policy_remote_source_mock.dart

class PolicyRemoteSourceMock extends PolicyRemoteSource {
  PolicyRemoteSourceMock() : super(Dio());

  @override
  Future<List<PolicyModel>> fetchPolicies(int page, int pageSize) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return List.generate(
      pageSize,
      (i) => PolicyModel(
        id: 'mock_${page}_$i',
        title: 'Mock Policy ${page}_$i',
        region: '경북',
        startDate: DateTime.now().toIso8601String(),
        endDate: DateTime.now()
            .add(const Duration(days: 10))
            .toIso8601String(),
      ),
    );
  }

  @override
  Future<PolicyModel> fetchPolicyDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    return PolicyModel(
      id: id,
      title: 'Mock Policy Detail $id',
      region: '경북',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now()
          .add(const Duration(days: 5))
          .toIso8601String(),
    );
  }
}


⸻

4.4 파일: data/cache/policy_cache.dart

class PolicyCache {
  final Map<int, List<Policy>> _pageCache = {};

  List<Policy>? getPage(int page) => _pageCache[page];

  void savePage(int page, List<Policy> policies) {
    _pageCache[page] = policies;
  }

  void clear() {
    _pageCache.clear();
  }
}


⸻

4.5 파일: data/repositories/policy_repository_impl.dart

class PolicyRepositoryImpl implements PolicyRepository {
  final PolicyRemoteSource remote;
  final PolicyCache cache;
  final PolicyLogger logger;
  final PolicySettings settings;

  PolicyRepositoryImpl({
    required this.remote,
    required this.cache,
    required this.logger,
    required this.settings,
  });

  @override
  Future<PolicyResult<List<Policy>>> fetchPolicies({
    required int page,
    int pageSize = 20,
  }) async {
    try {
      final effectivePageSize = pageSize == 0 ? settings.pageSize : pageSize;

      logger.info('fetchPolicies(page: $page, size: $effectivePageSize) 호출');

      if (settings.enableCache) {
        final cached = cache.getPage(page);
        if (cached != null && cached.isNotEmpty) {
          logger.info('캐시된 정책 페이지 사용 (page: $page)');
          return PolicyResult.success(cached);
        }
      }

      final models = await remote.fetchPolicies(page, effectivePageSize);
      final domainList = models.map((e) => e.toDomain()).toList();

      if (settings.enableCache) {
        cache.savePage(page, domainList);
      }

      return PolicyResult.success(domainList);
    } catch (e, st) {
      logger.error('fetchPolicies 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  @override
  Future<PolicyResult<Policy>> fetchPolicyDetail(String id) async {
    try {
      logger.info('fetchPolicyDetail(id: $id) 호출');

      final model = await remote.fetchPolicyDetail(id);
      return PolicyResult.success(model.toDomain());
    } catch (e, st) {
      logger.error('fetchPolicyDetail 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }
}


⸻

5. Application 레이어

5.1 파일: application/controllers/policy_event_bus.dart

class PolicyEventBus extends StateNotifier<PolicyEvent?> {
  PolicyEventBus() : super(null);

  void emit(PolicyEvent event) {
    state = event;
  }
}


⸻

5.2 파일: application/controllers/policy_paging_controller.dart

class PolicyPagingController
    extends StateNotifier<AsyncValue<List<Policy>>> {
  final PolicyRepository repository;
  final PolicyLogger logger;
  final PolicySettings settings;
  final PolicyEventBus eventBus;

  int _page = 1;
  bool _isLast = false;
  bool _isLoading = false;
  final List<Policy> _items = [];

  PolicyPagingController({
    required this.repository,
    required this.logger,
    required PolicySettings policySettings,
    required this.eventBus,
  })  : settings = policySettings,
        super(const AsyncValue.loading()) {
    // 초기 로드
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    _page = 1;
    _isLast = false;
    _items.clear();

    logger.info('PolicyPagingController.loadFirstPage()');
    state = const AsyncValue.loading();

    final result = await repository.fetchPolicies(
      page: _page,
      pageSize: settings.pageSize,
    );

    if (result.isSuccess) {
      _items.addAll(result.data!);
      state = AsyncValue.data(List.from(_items));
    } else {
      state = AsyncValue.error(result.failure!, StackTrace.current);
    }
  }

  Future<void> loadNextPage() async {
    if (_isLast || _isLoading) return;
    _isLoading = true;

    logger.info('PolicyPagingController.loadNextPage(page: ${_page + 1})');

    final result = await repository.fetchPolicies(
      page: _page + 1,
      pageSize: settings.pageSize,
    );

    if (!result.isSuccess) {
      state = AsyncValue.error(result.failure!, StackTrace.current);
      _isLoading = false;
      return;
    }

    final newItems = result.data!;
    if (newItems.isEmpty) {
      _isLast = true;
    } else {
      _page++;
      _items.addAll(newItems);
      state = AsyncValue.data(List.from(_items));
    }

    _isLoading = false;
  }

  Future<void> refresh() async {
    logger.info('PolicyPagingController.refresh() 호출');
    await loadFirstPage();
  }
}


⸻

5.3 파일: application/providers.dart

// Settings
final policySettingsProvider = Provider<PolicySettings>((ref) {
  return const PolicySettings(
    pageSize: 20,
    defaultRegion: '전체',
    enableCache: true,
  );
});

// Logger 구현체 (application 레이어에서 구현)
class ConsolePolicyLogger implements PolicyLogger {
  @override
  void info(String msg) {
    debugPrint('[Policy][INFO] $msg');
  }

  @override
  void warn(String msg) {
    debugPrint('[Policy][WARN] $msg');
  }

  @override
  void error(String msg, [Object? err, StackTrace? stackTrace]) {
    debugPrint('[Policy][ERROR] $msg ${err ?? ""} ${stackTrace ?? ""}');
  }
}

final policyLoggerProvider = Provider<PolicyLogger>((ref) {
  return ConsolePolicyLogger();
});

// EventBus
final policyEventBusProvider =
    StateNotifierProvider<PolicyEventBus, PolicyEvent?>(
  (ref) => PolicyEventBus(),
);

// Mock 모드 플래그
final isMockModeProvider = Provider<bool>((ref) => false);

// Dio
final dioProvider = Provider((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.youthroad-chat.workers.dev',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
      headers: const {
        'Content-Type': 'application/json',
      },
    ),
  );
});

// RemoteSource (real & mock)
final policyRemoteSourceProvider = Provider((ref) {
  return PolicyRemoteSource(ref.watch(dioProvider));
});

final mockPolicyRemoteSourceProvider = Provider((ref) {
  return PolicyRemoteSourceMock();
});

final activePolicyRemoteProvider = Provider<PolicyRemoteSource>((ref) {
  final isMock = ref.watch(isMockModeProvider);
  return isMock
      ? ref.watch(mockPolicyRemoteSourceProvider)
      : ref.watch(policyRemoteSourceProvider);
});

// Cache
final policyCacheProvider = Provider((ref) => PolicyCache());

// Repository
final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  return PolicyRepositoryImpl(
    remote: ref.watch(activePolicyRemoteProvider),
    cache: ref.watch(policyCacheProvider),
    logger: ref.watch(policyLoggerProvider),
    settings: ref.watch(policySettingsProvider),
  );
});

// PagingController
final policyPagingControllerProvider =
    StateNotifierProvider<PolicyPagingController, AsyncValue<List<Policy>>>(
        (ref) {
  return PolicyPagingController(
    repository: ref.watch(policyRepositoryProvider),
    logger: ref.watch(policyLoggerProvider),
    policySettings: ref.watch(policySettingsProvider),
    eventBus:
        ref.read(policyEventBusProvider.notifier),
  );
});


⸻

6. Presentation 레이어 (테스트용 화면)

6.1 파일: presentation/screens/policy_home_new_screen.dart

class PolicyHomeNewScreen extends ConsumerWidget {
  const PolicyHomeNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyPagingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("새 정책 홈 (PolicyNew)"),
      ),
      body: state.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text(
            e is PolicyFailure ? e.message : e.toString(),
          ),
        ),
        data: (policies) {
          if (policies.isEmpty) {
            return const Center(
              child: Text("표시할 정책이 없습니다."),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(policyPagingControllerProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: policies.length,
              itemBuilder: (context, index) {
                final p = policies[index];
                return ListTile(
                  title: Text(p.title),
                  subtitle: Text(
                    '${p.region} / '
                    '${p.applicationStartDate?.toIso8601String() ?? "-"}'
                    ' ~ '
                    '${p.applicationEndDate?.toIso8601String() ?? "-"}',
                  ),
                  onTap: () {
                    // 이후 job에서 상세 화면 라우팅 연결 예정
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref
              .read(policyPagingControllerProvider.notifier)
              .loadNextPage();
        },
        child: const Icon(Icons.expand_more),
      ),
    );
  }
}


⸻

7. Acceptance Criteria (job01이 완료된 상태 정의)
	•	lib/features/policy_new/ 아래에 명시된 폴더와 파일이 모두 생성되어 있다.
	•	Domain 레이어에 Policy / PolicyFailure / PolicyResult / PolicySettings / PolicyEvent / PolicyLogger / PolicyRepository 인터페이스가 정의돼 있다.
	•	Data 레이어에 PolicyModel / PolicyRemoteSource / PolicyRemoteSourceMock / PolicyCache / PolicyRepositoryImpl이 정의돼 있고, 규약대로 동작한다.
	•	Application 레이어에 PolicyEventBus / PolicyPagingController / providers.dart(DI) 구성이 완료되어 있다.
	•	Presentation 레이어의 PolicyHomeNewScreen에서:
	•	앱 실행 시 새 정책 홈 화면에서 정책 목록을 불러올 수 있다.
	•	네트워크 에러 시 적절한 메시지가 표시된다.
	•	Mock 모드를 true로 변경하면 실제 API 없이도 목록이 뜬다.
	•	SWR 캐시가 활성화되어, 동일 페이지 재조회 시 캐시를 우선 사용한다.
	•	Controller의 상태 흐름이 AsyncValue.loading() → AsyncValue.data() 또는 AsyncValue.error() 패턴을 따른다.
	•	기존 정책 관련 코드(V1/V2)는 전혀 변경되지 않았다.

---
지민님… 💙🩵
맞아요. 지금 딱 다시 봤는데 **job01의 완성도(아키텍처 + 비즈니스 + 규약 + 도메인 규칙 + DI + Mock + Logger + EventBus)**에 비하면
제가 만든 job02는 그 “단단한 느낌”이 조금 부족했어요.

그래서 **job01과 동일한 압도적 퀄리티로, 새 정책 시스템의 도메인/필드/필터/정렬/검색/추천 체계까지 완전히 설계한 “풀 아키텍처 기반 job02 완전체”**를 지금부터 다시 만들어드릴게요.

아예 job01의 구조적 흐름, 규약 수준, 문서 완성도, 안정성, 확장성 기준 그대로 맞추겠습니다.
아래 블록이 바로 Codex-ready 최종판 job02입니다.

⸻

🟦 #job02 — Domain 확장 + Filter/Sort/FeedType 아키텍처 통합 완전체 (job01 급 퀄리티)

이 job02는 job01 위에 바로 접합되도록 설계되었고,
실제 운영환경에서도 오래 버틸 수 있는 구조적 안정성을 갖춘 ‘정책 시스템 핵심 도메인 레이어 구축 작업’입니다.

이 job02의 목표는 다음 네 가지입니다:

⸻

🎯 job02 목표
	1.	Policy Domain 구조를 최종 확정
	•	정책 상세, 필터링, 정렬, 검색, 추천, 지역·나이·조건 정보 등을 모두 담을 수 있는 수준으로 확장
	•	이후 모든 기능의 기반이 되므로 “수정 없는 불변 구조”로 완성해야 함
	2.	Filter/Sort/Query/FeedType의 정교한 규약 확립
	•	Controller, UI, Repository가 동일한 규칙을 사용하도록 설계
	3.	Domain 내부의 책임 범위 결정
	•	Domain은 데이터 구조만
	•	변환/비즈니스 로직은 Model/Repository/Controller에 위치
	4.	job03~job05에서의 혼란 방지용 Domain 안정화
	•	Codex가 Domain을 흔들거나 필드 추가/삭제 하지 못하도록 아키텍처적 가이드라인 포함

⸻

🟥 1. 전역 규칙 (job02 전용 규약)

■ 1) Domain은 “변경 불가 구조(Immutable Architecture)”로 확정한다

이후 job(03~13)에서 Domain 구조를 건드리는 작업은 절대 하지 않는다.

이유: Domain 흔들리면
	•	Model 변환
	•	Repository
	•	Controller
	•	Search
	•	UI 전체가 모두 무너짐.

Domain은 시스템 전체의 ‘진실의 근원(Single source of truth)’이므로 job02에서 딱 고정한다.

⸻

■ 2) Domain 내 로직은 계산(computed)만 허용
	•	API 요청/필터/검색 로직은 Domain에 두지 않는다
	•	Domain은 항상 불변 객체 + 계산 프로퍼티(get)만 보유

→ 이렇게 해야 Domain이 비즈니스 로직과 분리돼 유지보수가 쉬워짐

⸻

■ 3) Filter/Sort/Query 구조는 “Controller가 이해하는 단일 표준 인터페이스”로 설계
	•	UI ↔ Controller ↔ Repository ↔ Remote 전체에서 일관되게 작동하도록
	•	구조체는 단 하나의 PolicyQuery로 통합

⸻

🟧 2. Policy Domain 확장 (완전체)

파일:
lib/features/policy_new/domain/entities/policy.dart

job01의 필드를 유지하면서, 실제 정책 시스템에 필요한 모든 필드 + 가이드라인을 완성한 버전:

class Policy {
  // ─────────────────────────────
  // ① 정책 기본 정보
  // ─────────────────────────────
  final String id;                       // 정책 고유 ID
  final String title;                    // 정책 제목
  final String summary;                  // 한 줄 요약
  final String description;              // 상세 설명 (HTML 가능)
  final String category;                 // 정책 분야 (도메인 enum으로 매핑됨)
  final String region;                   // 지역

  // ─────────────────────────────
  // ② 태그/키워드/AI 추천 기반 메타 정보
  // ─────────────────────────────
  final List<String> tags;               // AI 추천 태그
  final List<String> keywords;           // 검색 키워드(원본 필드)

  // ─────────────────────────────
  // ③ 신청 관련 정보
  // ─────────────────────────────
  final DateTime? applicationStartDate;
  final DateTime? applicationEndDate;
  final DateTime? announceDate;          // 합격/선정 발표일

  final bool isOnline;                   // 온라인 신청 가능
  final bool isOffline;                  // 오프라인 제출 필요

  final String applyUrl;                 // 신청 페이지 URL
  final String? attachmentUrl;           // 제출 서류 다운로드 URL

  // ─────────────────────────────
  // ④ 대상자 조건
  // ─────────────────────────────
  final int? minAge;
  final int? maxAge;
  final bool isForYouth;

  final String? incomeCondition;         // 소득 조건
  final String? educationCondition;      // 학력 조건
  final String? employmentCondition;     // 고용/창업/직장 여부

  // ─────────────────────────────
  // ⑤ 기관 정보
  // ─────────────────────────────
  final String institution;              // 주관 기관
  final String department;               // 담당 부서
  final String? contact;                 // 문의처/전화번호

  // ─────────────────────────────
  // ⑥ 메타데이터
  // ─────────────────────────────
  final DateTime createdAt;
  final DateTime updatedAt;

  // ─────────────────────────────
  // ⑦ 계산 프로퍼티
  // ─────────────────────────────
  bool get isOngoing {
    final now = DateTime.now();
    if (applicationStartDate == null || applicationEndDate == null) return false;
    return applicationStartDate!.isBefore(now) && applicationEndDate!.isAfter(now);
  }

  bool get isUpcoming {
    final now = DateTime.now();
    if (applicationStartDate == null) return false;
    return applicationStartDate!.isAfter(now);
  }

  bool get isClosed {
    final now = DateTime.now();
    if (applicationEndDate == null) return false;
    return applicationEndDate!.isBefore(now);
  }

  const Policy({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.region,
    required this.category,
    required this.tags,
    required this.keywords,
    required this.applicationStartDate,
    required this.applicationEndDate,
    required this.announceDate,
    required this.isOnline,
    required this.isOffline,
    required this.minAge,
    required this.maxAge,
    required this.isForYouth,
    required this.incomeCondition,
    required this.educationCondition,
    required this.employmentCondition,
    required this.applyUrl,
    required this.attachmentUrl,
    required this.institution,
    required this.department,
    required this.contact,
    required this.createdAt,
    required this.updatedAt,
  });
}

이 Domain은 앞으로 절대 수정되지 않는 정책 시스템의 핵심 기반입니다.

⸻

🟦 3. Category / Region / Sort / FeedType 고정 규약

3.1 Category

파일: policy_category.dart

enum PolicyCategory {
  employment,   // 취업
  startup,      // 창업
  housing,      // 주거
  life,         // 생활안정
  education,    // 교육/스킬업
  welfare,      // 복지제도
  culture,      // 문화·여가
  other,        // 기타
}


⸻

3.2 Region

파일: policy_region.dart

enum PolicyRegion {
  all,
  seoul,
  busan,
  daegu,
  incheon,
  gwangju,
  daejeon,
  ulsan,
  gyeongbuk,
  // 필요 시 23개 시군/동 단위 확장 가능 (job05에서 매핑)
}


⸻

3.3 SortOption

파일: policy_sort.dart

enum PolicySortOption {
  latest,          // 최신 등록순
  deadline,        // 마감 임박순
  popularity,      // 인기순
  recommendation,  // AI 추천 점수 기반
}


⸻

3.4 FeedType (탭 구조)

파일: policy_feed_type.dart

enum PolicyFeedType {
  recommend,   // 추천 정책
  all,         // 전체 정책
  region,      // 지역별
  search,      // 검색 결과
  favorite,    // 즐겨찾기
  compare,     // 비교 모아보기
}


⸻

🟩 4. Filter 구조 — Controller/Repository/Remote가 공통적으로 사용할 구조적 기준

파일: policy_filter.dart

class PolicyFilter {
  final PolicyRegion region;
  final PolicyCategory? category;
  final bool? isOnline;
  final bool? isOngoing;
  final bool? isOffline;
  final int? age;
  final List<String> tags;

  const PolicyFilter({
    this.region = PolicyRegion.all,
    this.category,
    this.isOnline,
    this.isOngoing,
    this.isOffline,
    this.age,
    this.tags = const [],
  });

  PolicyFilter copyWith({
    PolicyRegion? region,
    PolicyCategory? category,
    bool? isOnline,
    bool? isOngoing,
    bool? isOffline,
    int? age,
    List<String>? tags,
  }) {
    return PolicyFilter(
      region: region ?? this.region,
      category: category ?? this.category,
      isOnline: isOnline ?? this.isOnline,
      isOngoing: isOngoing ?? this.isOngoing,
      isOffline: isOffline ?? this.isOffline,
      age: age ?? this.age,
      tags: tags ?? this.tags,
    );
  }
}


⸻

🟦 5. 검색/추천 Query 구조 — 정책 시스템 핵심

이 구조 하나로
	•	검색
	•	추천
	•	지역별
	•	모든 정렬 기준
	•	페이징
	•	필터링
을 통합 처리합니다.

파일: policy_query.dart

class PolicyQuery {
  final String? keyword;               // 검색 키워드
  final List<String> tags;             // 추천 기반 태그
  final PolicyFilter filter;           // 필터 조건
  final PolicySortOption sort;         // 정렬 옵션
  final PolicyFeedType feedType;       // 탭의 유형

  const PolicyQuery({
    this.keyword,
    this.tags = const [],
    required this.filter,
    this.sort = PolicySortOption.latest,
    required this.feedType,
  });

  PolicyQuery copyWith({
    String? keyword,
    List<String>? tags,
    PolicyFilter? filter,
    PolicySortOption? sort,
    PolicyFeedType? feedType,
  }) {
    return PolicyQuery(
      keyword: keyword ?? this.keyword,
      tags: tags ?? this.tags,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      feedType: feedType ?? this.feedType,
    );
  }
}


⸻

🟩 6. 즐겨찾기 · 비교 · 추천 점수 구조

⸻

6.1 Favorite 구조

파일: policy_favorite.dart

class PolicyFavorite {
  final String policyId;
  final DateTime savedAt;

  const PolicyFavorite({
    required this.policyId,
    required this.savedAt,
  });
}


⸻

6.2 Compare 구조

파일: policy_compare.dart

class PolicyCompareItem {
  final String policyId;
  final DateTime addedAt;

  const PolicyCompareItem({
    required this.policyId,
    required this.addedAt,
  });
}


⸻

6.3 추천 점수 구조

파일: policy_recommendation_score.dart

class PolicyRecommendationScore {
  final String policyId;
  final double score;            // 0~1
  final List<String> matchedTags;

  const PolicyRecommendationScore({
    required this.policyId,
    required this.score,
    required this.matchedTags,
  });
}


⸻

🟦 7. Domain 설계의 아키텍처적 고정 규약

job01의 안정성과 동일한 레벨을 유지하기 위해
job02 Domain 모듈 전체에 아래 규약을 추가한다.

⸻

✔ 1) Domain은 “불변(immutable) + 계층 분리” 유지
	•	Domain 객체는 절대 수정되지 않음
	•	Model/Remote/Repository가 Domain을 직접 변경하지 않음

⸻

✔ 2) Domain은 비즈니스 로직을 포함하지 않는다
	•	검색/필터/정렬 로직은 Controller에서 처리
	•	Domain은 계산(get)만 가짐

⸻

✔ 3) Domain 필드를 수정할 필요가 없도록 “최대한 풍부하고 충분한 필드’를 job02에서 모두 정의
	•	이후 job04~job12에서 모든 기능을 Domain 기반으로 개발 가능하게 보장

⸻

✔ 4) Domain enum은 앱 전체에서 UI/Controller/Repository가 공유하는 ‘표준 인터페이스’
	•	Category/Region/Sort/FeedType은 변경 금지

⸻

✔ 5) PolicyQuery는 “정책 요청에 대한 단일 통합 표준 형태”

→ Repository에서 캐싱, RemoteSource 요청, Controller 구성까지 통일된 방식으로 운용 가능

⸻

🟩 8. Acceptance Criteria — job02 완성 기준
	•	Policy Domain이 상세 필드 + 계산 프로퍼티까지 완성된 상태
	•	Category/Region/Sort/FeedType enum이 모두 정의됨
	•	Filter 구조가 Controller/Repository/Remote 방식과 충돌 없이 설계됨
	•	Query 구조가 검색/추천/지역별/전체 탭을 관통하는 통합 표준 형태
	•	Favorite/Compare/RecommendationScore 구조가 정의됨
	•	job01과 완벽히 이어지며 구조적 충돌이 없음
	•	이후 job03~job13에서 Domain 수정 없이 기능 확장 가능
	•	Codex가 Domain을 오염시키지 않도록 규약이 충분히 강제됨

---
좋아요 지민님 💙🩵
이제 job01이랑 완전히 같은 급으로, 진짜 “엔진 업그레이드” 느낌의 job03 완전체 만들어볼게요.

컨셉은 이거예요:

job03 = Data/Repository 엔진 확장 단계
	•	job01에서 만든 단순 page 기반 fetch →
	•	job02에서 설계한 Policy, PolicyFilter, PolicyQuery 기반으로
	•	Model/Remote/Cache/Repository를 제대로 설계하고, Query·Filter·Sort를 실제 API 파라미터로 묶어주는 레이어 만들기.

그리고 아주 중요하게:
	•	✅ job01 코드랑 “깨지지 않게” 호환 유지
	•	✅ 기존 fetchPolicies(page, pageSize)는 그대로 두고
	•	➕ 그 위에 “Query 기반 메서드”를 추가하는 방식으로 갑니다.

아래 블록 전체가 AGENTS.md에 바로 넣을 수 있는 Codex-ready #job03 FULL SPEC이에요.

⸻

🟦 #job03 — PolicyNew Data/Repository 엔진 업그레이드 (Query/Filter/Sort 통합 + SWR 확장)

@chatgpt-codex
# job03 — PolicyNew Data/Repository 엔진 업그레이드
# Model 확장 + Query/Filter/Sort 연동 + Remote/Repository/Cache 업그레이드 (job01과 완전 호환)

목표:
- job01에서 만든 기본 엔진 위에, job02에서 설계한 Domain 구조(Policy, PolicyFilter, PolicyQuery 등)를
  실제 동작하는 Data/Repository 계층으로 연결한다.
- 핵심 작업:
  1) PolicyModel을 Policy Domain과 1:1로 매핑 가능한 수준으로 확장
  2) PolicyQuery → HTTP queryParameters 변환 로직 추가
  3) RemoteSource에 "파라미터 기반 페이지 조회" 기능 추가
  4) Repository에 "Query 기반" 메서드 추가 (기존 fetchPolicies는 유지)
  5) SWR 캐시(PolicyCache)를 Query-aware 구조로 확장 (기존 page 기반도 호환 유지)
- job03 종료 시점:
  - Repository에서 PolicyQuery를 받아, RemoteSource 호출 + 캐시 + Result 래퍼까지 일관된 구조로 동작
  - 기존 job01의 PagingController는 그대로 빌드/동작 가능
  - 향후 job04~job07에서 검색/추천/탭별 피드 구현이 가능한 엔진 상태

---

# 1. 전역 규칙 (job03)

1. 기존 job01의 파일/클래스를 삭제하지 않는다.
   - 대신, 필요한 파일은 "전체 파일 교체" 방식으로 갱신한다.
   - 특히 PolicyCache, PolicyRepositoryImpl, PolicyRemoteSource, PolicyModel은 전체 내용을 새로운 버전으로 교체한다.

2. Domain 구조(job02에서 정의한 Policy/Filter/Query 등)는
   - 이 job03에서 "코드로 반영"하되,
   - 기존 job01에서 사용하던 필드(id/title/region/applicationStartDate/applicationEndDate)도 그대로 포함한다.

3. Repository 인터페이스(PolicyRepository)는 기존 메서드를 유지하면서 확장한다.
   - 기존:
     - fetchPolicies({required int page, int pageSize})
     - fetchPolicyDetail(String id)
   - job03에서 추가:
     - fetchPoliciesByQuery(PolicyQuery query, {required int page, required int pageSize})

4. RemoteSource는 Domain 타입(PolicyQuery 등)을 직접 알지 못한다.
   - Repository에서 Query → Map<String, dynamic> 으로 변환 후 RemoteSource에 넘긴다.
   - Data 레이어는 Domain에 의존하지 않도록 유지한다.

5. SWR 캐시는 "기존 page-only 캐시" + "Query-aware 캐시" 두 가지를 동시에 지원한다.
   - 기존 job01 코드에 영향 없음.
   - 새로운 Query 기반 메서드는 Query + page 단위로 캐싱한다.

---

# 2. Domain side — PolicyQuery 유틸 (가벼운 보완)

파일: `lib/features/policy_new/domain/entities/policy_query.dart`

> job02에서 선언한 PolicyQuery에, Repository에서 쓰기 쉬운 헬퍼를 정의한다.  
> (이 파일이 없다면 새로 생성, 있다면 전체 교체)

```dart
class PolicyQuery {
  final String? keyword;               // 검색 키워드
  final List<String> tags;             // 추천 기반 태그
  final PolicyFilter filter;           // 필터 조건
  final PolicySortOption sort;         // 정렬 옵션
  final PolicyFeedType feedType;       // 피드 유형(탭)

  const PolicyQuery({
    this.keyword,
    this.tags = const [],
    required this.filter,
    this.sort = PolicySortOption.latest,
    required this.feedType,
  });

  PolicyQuery copyWith({
    String? keyword,
    List<String>? tags,
    PolicyFilter? filter,
    PolicySortOption? sort,
    PolicyFeedType? feedType,
  }) {
    return PolicyQuery(
      keyword: keyword ?? this.keyword,
      tags: tags ?? this.tags,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      feedType: feedType ?? this.feedType,
    );
  }

  /// Repository에서 캐시 key/로그 용도로 사용할 간단한 식별자 문자열
  String get cacheScopeKey {
    final buffer = StringBuffer()
      ..write(feedType.name)
      ..write('|')
      ..write(filter.region.name)
      ..write('|')
      ..write(filter.category?.name ?? 'all')
      ..write('|')
      ..write(sort.name)
      ..write('|')
      ..write(keyword ?? '');

    return buffer.toString();
  }
}


⸻

3. Data/model — PolicyModel 확장 (Domain과 매핑)

파일 전체 교체:
lib/features/policy_new/data/models/policy_model.dart

class PolicyModel {
  final String id;
  final String title;
  final String summary;
  final String description;
  final String category;
  final String region;
  final List<String> tags;
  final List<String> keywords;

  final String? applicationStartDate;
  final String? applicationEndDate;
  final String? announceDate;

  final bool isOnline;
  final bool isOffline;

  final int? minAge;
  final int? maxAge;
  final bool isForYouth;

  final String? incomeCondition;
  final String? educationCondition;
  final String? employmentCondition;

  final String applyUrl;
  final String? attachmentUrl;

  final String institution;
  final String department;
  final String? contact;

  final String? createdAt;
  final String? updatedAt;

  const PolicyModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.category,
    required this.region,
    required this.tags,
    required this.keywords,
    required this.applicationStartDate,
    required this.applicationEndDate,
    required this.announceDate,
    required this.isOnline,
    required this.isOffline,
    required this.minAge,
    required this.maxAge,
    required this.isForYouth,
    required this.incomeCondition,
    required this.educationCondition,
    required this.employmentCondition,
    required this.applyUrl,
    required this.attachmentUrl,
    required this.institution,
    required this.department,
    required this.contact,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    // API 필드 이름은 백엔드 스펙에 맞춰 이후 job에서 튜닝 가능.
    // 여기서는 최대한 방어적으로 파싱한다.
    List<String> _toStringList(dynamic v) {
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      if (v is String && v.isNotEmpty) {
        return [v];
      }
      return const [];
    }

    bool _toBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final lower = v.toLowerCase();
        return lower == 'y' || lower == 'yes' || lower == 'true' || lower == '1';
      }
      return false;
    }

    return PolicyModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? json['description_short']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'other',
      region: json['region']?.toString() ?? '전체',
      tags: _toStringList(json['tags']),
      keywords: _toStringList(json['keywords']),
      applicationStartDate: json['application_start_date']?.toString(),
      applicationEndDate: json['application_end_date']?.toString(),
      announceDate: json['announce_date']?.toString(),
      isOnline: _toBool(json['is_online']),
      isOffline: _toBool(json['is_offline']),
      minAge: json['min_age'] == null ? null : int.tryParse(json['min_age'].toString()),
      maxAge: json['max_age'] == null ? null : int.tryParse(json['max_age'].toString()),
      isForYouth: _toBool(json['is_for_youth']),
      incomeCondition: json['income_condition']?.toString(),
      educationCondition: json['education_condition']?.toString(),
      employmentCondition: json['employment_condition']?.toString(),
      applyUrl: json['apply_url']?.toString() ?? '',
      attachmentUrl: json['attachment_url']?.toString(),
      institution: json['institution']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      contact: json['contact']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  /// Domain Policy로 변환
  Policy toDomain() {
    DateTime? _parse(String? v) {
      if (v == null || v.isEmpty) return null;
      return DateTime.tryParse(v);
    }

    return Policy(
      id: id,
      title: title,
      summary: summary,
      description: description,
      region: region,
      category: category,
      tags: tags,
      keywords: keywords,
      applicationStartDate: _parse(applicationStartDate),
      applicationEndDate: _parse(applicationEndDate),
      announceDate: _parse(announceDate),
      isOnline: isOnline,
      isOffline: isOffline,
      minAge: minAge,
      maxAge: maxAge,
      isForYouth: isForYouth,
      incomeCondition: incomeCondition,
      educationCondition: educationCondition,
      employmentCondition: employmentCondition,
      applyUrl: applyUrl,
      attachmentUrl: attachmentUrl,
      institution: institution,
      department: department,
      contact: contact,
      createdAt: _parse(createdAt) ?? DateTime.now(),
      updatedAt: _parse(updatedAt) ?? DateTime.now(),
    );
  }
}

⚠ 주의: Policy Domain 클래스는 job02에서 확장한 버전과 일치해야 한다.
만약 아직 최소 버전만 있다면, 이 toDomain에서 사용하는 필드를 기준으로 Policy를 업데이트하는 것이 job02의 역할이다.

⸻

4. Data/source — RemoteSource 업그레이드

파일 전체 교체:
lib/features/policy_new/data/sources/policy_remote_source.dart

class PolicyRemoteSource {
  final Dio _dio;

  PolicyRemoteSource(this._dio);

  /// 기존 job01용 단순 페이지 조회 (하위 호환 유지)
  Future<List<PolicyModel>> fetchPolicies(int page, int pageSize) async {
    final params = <String, dynamic>{
      'page': page,
      'size': pageSize,
    };
    return fetchPoliciesWithParams(params);
  }

  /// job03에서 추가: QueryParameter 기반 페이지 조회
  Future<List<PolicyModel>> fetchPoliciesWithParams(
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final res = await _dio.get(
        '/policies',
        queryParameters: queryParameters,
      );

      final List data = (res.data['policies'] ?? []) as List;
      return data
          .map((e) => PolicyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioError {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<PolicyModel> fetchPolicyDetail(String id) async {
    try {
      final res = await _dio.get('/policies/$id');
      return PolicyModel.fromJson(res.data as Map<String, dynamic>);
    } on DioError {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}


⸻

5. Data/cache — PolicyCache를 Query-aware로 확장

파일 전체 교체:
lib/features/policy_new/data/cache/policy_cache.dart

class PolicyCache {
  /// key: scope|page 형태
  final Map<String, List<Policy>> _cache = {};

  /// 기본 scope는 'default'
  String _keyForPage(int page, {String scope = 'default'}) =>
      '$scope|$page';

  /// job01 하위 호환: page만 사용하는 캐시 (scope = 'default')
  List<Policy>? getPage(int page) => _cache[_keyForPage(page)];

  void savePage(int page, List<Policy> policies) {
    _cache[_keyForPage(page)] = policies;
  }

  /// job03: PolicyQuery 기반 scope 키 사용
  List<Policy>? getPageForScope(String scopeKey, int page) {
    return _cache[_keyForPage(page, scope: scopeKey)];
  }

  void savePageForScope(
    String scopeKey,
    int page,
    List<Policy> policies,
  ) {
    _cache[_keyForPage(page, scope: scopeKey)] = policies;
  }

  void clear() {
    _cache.clear();
  }
}


⸻

6. Domain/repository — 인터페이스 확장

파일 전체 교체:
lib/features/policy_new/domain/repositories/policy_repository.dart

abstract class PolicyRepository {
  /// job01: 단순 페이지 기반 조회 (기본 탭/기본 필터)
  Future<PolicyResult<List<Policy>>> fetchPolicies({
    required int page,
    required int pageSize,
  });

  /// job03: Query 기반 조회 (검색/추천/지역/정렬 등 포함)
  Future<PolicyResult<List<Policy>>> fetchPoliciesByQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  });

  Future<PolicyResult<Policy>> fetchPolicyDetail(String id);
}


⸻

7. Data/repository 구현 — Query/Filter/Sort/SWR 통합

파일 전체 교체:
lib/features/policy_new/data/repositories/policy_repository_impl.dart

class PolicyRepositoryImpl implements PolicyRepository {
  final PolicyRemoteSource remote;
  final PolicyCache cache;
  final PolicyLogger logger;
  final PolicySettings settings;

  PolicyRepositoryImpl({
    required this.remote,
    required this.cache,
    required this.logger,
    required this.settings,
  });

  Map<String, dynamic> _buildQueryParameters({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) {
    final params = <String, dynamic>{
      'page': page,
      'size': pageSize,
      'sort': query.sort.name,
    };

    if (query.keyword != null && query.keyword!.isNotEmpty) {
      params['keyword'] = query.keyword;
    }

    // Filter → API 파라미터 매핑 (키 이름은 백엔드 스펙에 맞게 이후 job에서 조정 가능)
    final filter = query.filter;

    if (filter.region != PolicyRegion.all) {
      params['region'] = filter.region.name;
    }

    if (filter.category != null) {
      params['category'] = filter.category!.name;
    }

    if (filter.age != null) {
      params['age'] = filter.age;
    }

    if (filter.isOnline != null) {
      params['is_online'] = filter.isOnline! ? 'Y' : 'N';
    }

    if (filter.isOffline != null) {
      params['is_offline'] = filter.isOffline! ? 'Y' : 'N';
    }

    if (filter.isOngoing != null) {
      params['is_ongoing'] = filter.isOngoing! ? 'Y' : 'N';
    }

    if (query.tags.isNotEmpty) {
      params['tags'] = query.tags.join(',');
    }

    // feedType에 따라 backend에서 다른 endpoint를 사용한다면,
    // 여기서 'feed_type'을 힌트로 넘길 수 있다.
    params['feed_type'] = query.feedType.name;

    return params;
  }

  @override
  Future<PolicyResult<List<Policy>>> fetchPolicies({
    required int page,
    required int pageSize,
  }) async {
    // 기본 Query: 전체 탭, 기본 지역/정렬
    final defaultFilter = PolicyFilter(
      region: PolicyRegion.all,
    );

    final defaultQuery = PolicyQuery(
      filter: defaultFilter,
      feedType: PolicyFeedType.all,
    );

    return fetchPoliciesByQuery(
      query: defaultQuery,
      page: page,
      pageSize: pageSize == 0 ? settings.pageSize : pageSize,
    );
  }

  @override
  Future<PolicyResult<List<Policy>>> fetchPoliciesByQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    final effectivePageSize = pageSize == 0 ? settings.pageSize : pageSize;
    final scopeKey = query.cacheScopeKey;

    try {
      logger.info(
        'fetchPoliciesByQuery(scope: $scopeKey, page: $page, size: $effectivePageSize)',
      );

      if (settings.enableCache) {
        final cached = cache.getPageForScope(scopeKey, page);
        if (cached != null && cached.isNotEmpty) {
          logger.info('캐시 히트 (scope: $scopeKey, page: $page)');
          return PolicyResult.success(cached);
        }
      }

      final params = _buildQueryParameters(
        query: query,
        page: page,
        pageSize: effectivePageSize,
      );

      final models = await remote.fetchPoliciesWithParams(params);
      final domainList = models.map((e) => e.toDomain()).toList();

      if (settings.enableCache) {
        cache.savePageForScope(scopeKey, page, domainList);
      }

      return PolicyResult.success(domainList);
    } catch (e, st) {
      logger.error('fetchPoliciesByQuery 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  @override
  Future<PolicyResult<Policy>> fetchPolicyDetail(String id) async {
    try {
      logger.info('fetchPolicyDetail(id: $id) 호출');
      final model = await remote.fetchPolicyDetail(id);
      return PolicyResult.success(model.toDomain());
    } catch (e, st) {
      logger.error('fetchPolicyDetail 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }
}


⸻

8. Controller/Provider 영향도 (job03에서 직접 수정하지 않는 규칙)
	•	PolicyPagingController (job01에서 생성된)는
	•	계속 fetchPolicies(page: _page, pageSize: settings.pageSize)를 사용한다.
	•	job03에서는 Controller를 수정하지 않는다.
	•	job04~job05에서 FeedType/Query/Filter를 이해하는 새 Controller를 만들거나, 기존 Controller를 확장한다.
	•	providers.dart에서 policyRepositoryProvider는
	•	job01과 동일한 방식으로 PolicyRepositoryImpl을 생성하지만,
	•	job03에서 교체된 PolicyRepositoryImpl을 자연스럽게 사용하게 된다 (시그니처 동일).

⸻

9. Acceptance Criteria — job03 완료 기준
	•	PolicyModel이 Domain Policy와 매핑 가능한 전체 필드를 보유하고, fromJson/toDomain이 정의됐다.
	•	PolicyRemoteSource가 fetchPoliciesWithParams 메서드를 제공하고, 기존 fetchPolicies(page, size)는 이를 래핑하도록 구현됐다.
	•	PolicyCache가 Query-aware 구조( scopeKey + page )로 확장되었으며, 기존 getPage/savePage도 그대로 동작한다.
	•	PolicyRepository 인터페이스가 fetchPoliciesByQuery를 추가로 제공하며, 기존 메서드를 유지한다.
	•	PolicyRepositoryImpl이 Query/Filter/Sort/FeedType → HTTP queryParameters → RemoteSource → Model → Domain → 캐시 → PolicyResult 흐름을 구현한다.
	•	기존 PolicyPagingController는 아무 수정 없이 빌드가 가능하며, 동작 방식은 job01과 동일하다.
	•	새로운 Query 기반 경로를 사용하기 위한 준비가 완료되었다(향후 job04에서 Controller/UI와 연결 예정).
	•	빌드 시 타입 에러/레퍼런스 에러가 없어야 한다.

---

