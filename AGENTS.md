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
지민님… 💙🩵
이번 job04는 절대 대충 만들 수 없는 단계예요.
job01이 엔진, job02가 골격, job03이 데이터 파이프라인이라면…

job04 = “정책 시스템 전체의 두뇌(Brain Layer)”
FeedType(추천/전체/지역/검색/즐겨찾기/비교)을 인식하고,
PolicyQuery(검색·필터·정렬)를 완전히 제어하며,
UI에서 사용자 행동을 받아 Repository와 상호작용하는 “모든 Controller”를 설계하는 단계.

이 단계가 제대로 설계되면
프로젝트는 “절대 엉키지 않는 구조”가 됩니다.

아래 문서는 job01~03급 완성도 그대로,
Codex가 그대로 작성하면 총 6개 Controller + 공통 추상 Base + QueryEngine을 완벽하게 구현할 수 있게 만들었습니다.

지민님이 말한

“제대로 안 하면 다시 시킬거야”
딱 그 기준 맞춰서 아주 정교하게 만들었어요.

⸻

🟦 #job04 — Policy Controller Architecture Upgrade

FeedType 기반 멀티 컨트롤러 + QueryEngine + Paging 통합 + EventBus 반영 (FULL SPEC)

@chatgpt-codex
# job04 — Policy Controller Architecture Upgrade
# FeedType 기반 멀티 컨트롤러 + Query/Filter/Sort 제어 + Paging 통합 + EventBus 연동

목표:
- job01 PagingController 엔진 + job02 Domain + job03 Repository 기반을 조합해
  "추천/전체/지역/검색/즐겨찾기/비교" 6개 피드를 안정적으로 제어할 수 있는
  FeedType-aware Controller들을 설계하고 구현한다.
- Query/Filter/Sort를 조합하여 Repository에 전달하는 QueryEngine을 추가한다.
- EventBus(좋아요, 비교, 캐시초기화 등) 이벤트를 각 피드에 반영한다.
- 이후 job05에서 UI Layer와 자연스럽게 연결되도록 통합된 Controller 패턴을 완성한다.

결과물:
- BasePolicyFeedController (추상)
- PolicyPagingState
- PolicyQueryEngine
- 6개 피드 컨트롤러  
  1) RecommendFeedController  
  2) AllFeedController  
  3) RegionFeedController  
  4) SearchFeedController  
  5) FavoriteFeedController  
  6) CompareFeedController  

---

# 1. 전역 규칙 (job04 Controller Layer 규약)

1. **Controller는 절대 Domain/Model을 수정하지 않는다.**  
   상태(State) 관리 + Repository 호출 + Query 생성만 수행.

2. **모든 Controller는 BasePolicyFeedController를 상속한다.**  
   UI에서 “하나의 규칙”으로 다룰 수 있도록 통일된 API 제공.

3. **SWR 규약 준수**  
   loadFirstPage → 캐시 즉시 사용 → fresh fetch 이후 갱신.

4. **EventBus 연동 필수**  
   - favoritesChanged → favorite feed / recommend feed 등 자동 refresh  
   - refreshRequested → 모든 피드 refresh  
   - cacheCleared → 페이지 1부터 재로드

5. Controller가 가지는 책임  

UI 이벤트 수신 → QueryEngine 변환 → Repository fetch → Paging 업데이트

6. Controller는 Pagination을 ‘자동 관리’해야 한다.  
UI는 단순히 “스크롤 끝 → loadNextPage()”만 호출하면 됨.

---

# 2. BasePolicyFeedController (추상 계층)

파일:  
`lib/features/policy_new/application/controllers/base_feed_controller.dart`

```dart
abstract class BasePolicyFeedController
 extends StateNotifier<PolicyPagingState> {
BasePolicyFeedController({
 required this.ref,
 required this.queryEngine,
}) : super(const PolicyPagingState.initial());

final Ref ref;
final PolicyQueryEngine queryEngine;

int _page = 1;
bool _isLoadingPage = false;

/// 각 피드 컨트롤러가 “자신의 FeedType”을 정의해야 한다.
PolicyFeedType get feedType;

/// 각 피드는 자신의 Query 기본값(필터/정렬/키워드 등)을 제공해야 한다.
PolicyQuery buildBaseQuery();

// ─────────────────────────────
// Load First Page
// ─────────────────────────────
Future<void> loadFirstPage() async {
 _page = 1;
 _isLoadingPage = false;

 final query = buildBaseQuery();
 state = const PolicyPagingState.loading();

 final result =
     await queryEngine.fetch(query, page: _page);

 result.fold(
   onSuccess: (list) {
     state = PolicyPagingState.data(
       items: list,
       hasMore: list.length == queryEngine.pageSize,
     );
   },
   onFailure: (err) {
     state = PolicyPagingState.error(err);
   },
 );
}

// ─────────────────────────────
// Load Next Page
// ─────────────────────────────
Future<void> loadNextPage() async {
 if (_isLoadingPage) return;
 if (!state.hasMore) return;

 _isLoadingPage = true;

 final nextPage = _page + 1;
 final query = buildBaseQuery();

 final result = await queryEngine.fetch(query, page: nextPage);

 result.fold(
   onSuccess: (list) {
     final merged = [...state.items, ...list];
     state = PolicyPagingState.data(
       items: merged,
       hasMore: list.length == queryEngine.pageSize,
     );
     _page = nextPage;
   },
   onFailure: (err) {
     state = PolicyPagingState.error(err);
   },
 );

 _isLoadingPage = false;
}

// ─────────────────────────────
// Refresh (SWR)
// ─────────────────────────────
Future<void> refresh() async {
 await loadFirstPage();
}
}


⸻

3. PolicyPagingState (페이징 통합 상태)

파일 전체:
lib/features/policy_new/application/controllers/policy_paging_state.dart

@immutable
class PolicyPagingState {
  final bool isLoading;
  final List<Policy> items;
  final PolicyFailure? failure;
  final bool hasMore;

  const PolicyPagingState({
    required this.isLoading,
    required this.items,
    required this.failure,
    required this.hasMore,
  });

  const PolicyPagingState.initial()
      : isLoading = false,
        items = const [],
        failure = null,
        hasMore = true;

  const PolicyPagingState.loading()
      : isLoading = true,
        items = const [],
        failure = null,
        hasMore = true;

  factory PolicyPagingState.data({
    required List<Policy> items,
    required bool hasMore,
  }) =>
      PolicyPagingState(
        isLoading: false,
        items: items,
        failure: null,
        hasMore: hasMore,
      );

  factory PolicyPagingState.error(PolicyFailure failure) =>
      PolicyPagingState(
        isLoading: false,
        items: const [],
        failure: failure,
        hasMore: false,
      );
}


⸻

4. PolicyQueryEngine (Query 생성 + Repository 호출)

파일 전체:
lib/features/policy_new/application/controllers/policy_query_engine.dart

class PolicyQueryEngine {
  final Ref ref;

  PolicyQueryEngine(this.ref);

  int get pageSize =>
      ref.read(policySettingsProvider).pageSize;

  Future<PolicyResult<List<Policy>>> fetch(
    PolicyQuery query, {
    required int page,
  }) async {
    final repo = ref.read(policyRepositoryProvider);
    return repo.fetchPoliciesByQuery(
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }
}


⸻

5. 6가지 Feed Controller 설계

5.1 추천 피드 (Recommend)

class RecommendFeedController extends BasePolicyFeedController {
  RecommendFeedController({
    required super.ref,
    required super.queryEngine,
  });

  @override
  PolicyFeedType get feedType => PolicyFeedType.recommend;

  @override
  PolicyQuery buildBaseQuery() {
    final user = ref.read(userProfileProvider);
    return PolicyQuery(
      feedType: feedType,
      filter: PolicyFilter(
        age: user.age,
        region: user.region,
      ),
      tags: user.recommendationTags,
      sort: PolicySortOption.recommendation,
    );
  }
}


⸻

5.2 전체 피드 (All)

class AllFeedController extends BasePolicyFeedController {
  AllFeedController({
    required super.ref,
    required super.queryEngine,
  });

  @override
  PolicyFeedType get feedType => PolicyFeedType.all;

  @override
  PolicyQuery buildBaseQuery() {
    return PolicyQuery(
      feedType: feedType,
      filter: const PolicyFilter(region: PolicyRegion.all),
      sort: PolicySortOption.latest,
    );
  }
}


⸻

5.3 지역 피드 (Region)

class RegionFeedController extends BasePolicyFeedController {
  RegionFeedController({
    required super.ref,
    required super.queryEngine,
  });

  @override
  PolicyFeedType get feedType => PolicyFeedType.region;

  @override
  PolicyQuery buildBaseQuery() {
    final user = ref.read(userProfileProvider);
    return PolicyQuery(
      feedType: feedType,
      filter: PolicyFilter(region: user.region),
      sort: PolicySortOption.latest,
    );
  }
}


⸻

5.4 검색 피드 (Search)

검색 키워드, 필터, 정렬 모두 UI에서 동적 변경.

class SearchFeedController extends BasePolicyFeedController {
  SearchFeedController({
    required super.ref,
    required super.queryEngine,
  });

  String _keyword = '';

  void setKeyword(String v) {
    _keyword = v;
    refresh();
  }

  @override
  PolicyFeedType get feedType => PolicyFeedType.search;

  @override
  PolicyQuery buildBaseQuery() {
    return PolicyQuery(
      feedType: feedType,
      keyword: _keyword,
      filter: const PolicyFilter(),
      sort: PolicySortOption.latest,
    );
  }
}


⸻

5.5 즐겨찾기 피드 (Favorite)

EventBus와 강하게 연동.

class FavoriteFeedController extends BasePolicyFeedController {
  FavoriteFeedController({
    required super.ref,
    required super.queryEngine,
  }) {
    ref.listen(policyEventBusProvider, (prev, next) {
      if (next?.type == PolicyEventType.favoritesChanged) {
        refresh();
      }
    });
  }

  @override
  PolicyFeedType get feedType => PolicyFeedType.favorite;

  @override
  PolicyQuery buildBaseQuery() {
    final favIds = ref.read(favoriteRepositoryProvider).allIds;

    return PolicyQuery(
      feedType: feedType,
      filter: const PolicyFilter(),
      sort: PolicySortOption.latest,
      tags: favIds, // 백엔드에서 favorite 전용 API가 있다면 job06에서 교체
    );
  }
}


⸻

5.6 비교 피드 (Compare)

class CompareFeedController extends BasePolicyFeedController {
  CompareFeedController({
    required super.ref,
    required super.queryEngine,
  }) {
    ref.listen(policyEventBusProvider, (prev, next) {
      if (next?.type == PolicyEventType.refreshRequested) {
        refresh();
      }
    });
  }

  @override
  PolicyFeedType get feedType => PolicyFeedType.compare;

  @override
  PolicyQuery buildBaseQuery() {
    final compareIds = ref.read(compareRepositoryProvider).ids;
    return PolicyQuery(
      feedType: feedType,
      filter: const PolicyFilter(),
      tags: compareIds, // 추후 compare 전용 endpoint 시 변경 가능
      sort: PolicySortOption.latest,
    );
  }
}


⸻

6. Provider 등록 (providers.dart에 추가)

final policyQueryEngineProvider = Provider(
  (ref) => PolicyQueryEngine(ref),
);

final recommendFeedControllerProvider =
    StateNotifierProvider<RecommendFeedController, PolicyPagingState>(
  (ref) => RecommendFeedController(
    ref: ref,
    queryEngine: ref.read(policyQueryEngineProvider),
  ),
);

// 동일 패턴으로 5개 추가


⸻

7. Acceptance Criteria (job04 완료 기준)
	•	BasePolicyFeedController가 존재하며, 통합된 API(loadFirstPage/loadNextPage/refresh)를 제공한다.
	•	PolicyPagingState가 job01과 충돌 없이 통합된다.
	•	PolicyQueryEngine이 Repository와 완전 연동된다.
	•	Recommend/All/Region/Search/Favorite/Compare 피드 컨트롤러가 모두 구현된다.
	•	EventBus가 Favorite/Compare/Refresh 피드에 반영된다.
	•	페이징 + 필터 + 정렬 + Query 기반 fetch가 완전히 동작할 준비가 된다.
	•	UI 연결(job05) 시 컨트롤러들이 충돌 없이 통일된 방식으로 작동한다.
	•	빌드 시 타입 충돌/네이밍 충돌/DI 충돌이 없어야 한다.

---

좋아요 지민님 💙🩵
이번엔 진짜 job01이랑 완전히 같은 급으로, 헷갈리는 거 하나 없이 정확하게 컴파일 가능한 구조로 job05 다시 만들어요.

이 버전은:
	•	경로까지 명확하고
	•	참조하는 provider/controller 전부 정의 위치 명시하고
	•	UI가 실제로 돌아갈 수 있는 형태로 설계된 “완전체 job05”예요.

⸻

🟦 #job05 — PolicyNew UI/UX 아키텍처 (완전체)

아래 블록 그대로 AGENTS.md 에 #job05로 넣고 Codex한테 시키면 됩니다.

@chatgpt-codex
# job05 — PolicyNew UI/UX Architecture
# Swipe 탭 기반 정책 피드 UI + 공통 리스트 + 카드 + 상세 바텀시트 + 실제 정책 페이지 이동까지

목표:
- job01~04에서 구축한 PolicyNew 엔진 위에,
  실제로 사용할 수 있는 **정책 피드 UI 전체 구조**를 구축한다.
- 탭/스와이프 구조, 리스트, 카드, 로딩/에러/빈 상태, 상세 바텀시트,
  "실제 정책 페이지로 이동" 버튼까지 구현한다.
- 기존 V1/V2 정책 화면은 전혀 건드리지 않고,
  `lib/features/policy_new/presentation/**` 아래에만 새 UI를 만든다.

---

# 1. 전역 규칙 (job05)

1. **기존 코드 수정 금지**
   - 아래 경로의 파일은 수정하지 않는다:
     - lib/ui/screens/policy/**
     - lib/data/policy/**
     - 기타 기존 정책 관련 화면

2. **모든 신규 UI 파일 경로**
   - lib/features/policy_new/presentation/**

3. **사용하는 Controller / Provider 전제**
   - job04가 이미 아래 Provider들을 정의했다고 가정한다:

     ```dart
     final recommendFeedControllerProvider
         = StateNotifierProvider<RecommendFeedController, PolicyPagingState>(...);
     final allFeedControllerProvider
         = StateNotifierProvider<AllFeedController, PolicyPagingState>(...);
     final regionFeedControllerProvider
         = StateNotifierProvider<RegionFeedController, PolicyPagingState>(...);
     final searchFeedControllerProvider
         = StateNotifierProvider<SearchFeedController, PolicyPagingState>(...);
     final favoriteFeedControllerProvider
         = StateNotifierProvider<FavoriteFeedController, PolicyPagingState>(...);
     final compareFeedControllerProvider
         = StateNotifierProvider<CompareFeedController, PolicyPagingState>(...);
     ```

   - `PolicyPagingState`는 다음 필드를 가진다고 전제:
     ```dart
     class PolicyPagingState {
       final bool isLoading;
       final List<Policy> items;
       final PolicyFailure? failure;
       final bool hasMore;
       ...
     }
     ```

4. **UI는 오직 Controller/Provider만 의존**
   - Repository/Remote에 직접 접근하지 않는다.
   - Domain 엔티티 `Policy` 만 사용.

5. **디자인**
   - 이 job05에서는 “구조/동작”에 집중하고,
     구체적인 색/폰트/애니메이션 튜닝은 이후 job에서 다룬다.

---

# 2. 디렉토리 구조

아래 디렉토리/파일을 생성한다:

```txt
lib/features/policy_new/presentation/
  screens/
    policy_feed_home_screen.dart        # 상단 탭 + TabBarView (스와이프)
  widgets/
    policy_feed_list_view.dart          # 공통 피드 리스트 (Provider 매핑 + 스크롤/페이징)
    policy_card.dart                    # 정책 카드 UI
    policy_list_loading.dart            # 로딩 위젯
    policy_list_empty.dart              # 빈 상태 위젯
    policy_list_error.dart              # 에러 위젯
  detail/
    policy_detail_bottom_sheet.dart     # 상세 바텀시트 (실제 정책 페이지 링크 포함)


⸻

3. PolicyFeedHomeScreen — 상단 탭 + 스와이프

파일:
lib/features/policy_new/presentation/screens/policy_feed_home_screen.dart

class PolicyFeedHomeScreen extends ConsumerStatefulWidget {
  const PolicyFeedHomeScreen({super.key});

  @override
  ConsumerState<PolicyFeedHomeScreen> createState() =>
      _PolicyFeedHomeScreenState();
}

class _PolicyFeedHomeScreenState
    extends ConsumerState<PolicyFeedHomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<(String label, PolicyFeedType type)> _tabs = const [
    ('추천', PolicyFeedType.recommend),
    ('전체', PolicyFeedType.all),
    ('지역', PolicyFeedType.region),
    ('검색', PolicyFeedType.search),
    ('즐겨찾기', PolicyFeedType.favorite),
    ('비교', PolicyFeedType.compare),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // 초기 탭(추천) 첫 페이지 로딩
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recommendFeedControllerProvider.notifier)
          .loadFirstPage();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 탐색'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((e) => Tab(text: e.label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: _tabs
            .map(
              (tab) => PolicyFeedListView(feedType: tab.type),
            )
            .toList(),
      ),
    );
  }
}


⸻

4. PolicyFeedListView — 피드 타입별로 Provider 매핑 + 리스트 표시

파일:
lib/features/policy_new/presentation/widgets/policy_feed_list_view.dart

class PolicyFeedListView extends ConsumerWidget {
  const PolicyFeedListView({
    super.key,
    required this.feedType,
  });

  final PolicyFeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (state, notifier) = _useController(ref);

    // 에러 우선 처리
    if (state.failure != null) {
      return PolicyListError(
        message: state.failure!.message,
        onRetry: () => notifier.loadFirstPage(),
      );
    }

    if (state.isLoading && state.items.isEmpty) {
      return const PolicyListLoading();
    }

    if (!state.isLoading && state.items.isEmpty) {
      return const PolicyListEmpty();
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < state.items.length) {
            final policy = state.items[index];
            return PolicyCard(
              policy: policy,
              onTap: () => _openDetail(context, policy.id),
            );
          }

          // footer: 다음 페이지 로딩
          notifier.loadNextPage();
          return const PolicyListLoading();
        },
      ),
    );
  }

  /// feedType에 따라 올바른 Provider를 선택한다.
  (PolicyPagingState, BasePolicyFeedController) _useController(WidgetRef ref) {
    switch (feedType) {
      case PolicyFeedType.recommend:
        return (
          ref.watch(recommendFeedControllerProvider),
          ref.read(recommendFeedControllerProvider.notifier),
        );
      case PolicyFeedType.all:
        return (
          ref.watch(allFeedControllerProvider),
          ref.read(allFeedControllerProvider.notifier),
        );
      case PolicyFeedType.region:
        return (
          ref.watch(regionFeedControllerProvider),
          ref.read(regionFeedControllerProvider.notifier),
        );
      case PolicyFeedType.search:
        return (
          ref.watch(searchFeedControllerProvider),
          ref.read(searchFeedControllerProvider.notifier),
        );
      case PolicyFeedType.favorite:
        return (
          ref.watch(favoriteFeedControllerProvider),
          ref.read(favoriteFeedControllerProvider.notifier),
        );
      case PolicyFeedType.compare:
        return (
          ref.watch(compareFeedControllerProvider),
          ref.read(compareFeedControllerProvider.notifier),
        );
    }
  }

  void _openDetail(BuildContext context, String policyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PolicyDetailBottomSheet(policyId: policyId),
    );
  }
}

⚠ BasePolicyFeedController와 PolicyPagingState는 job04에서 정의한 타입을 사용한다.

⸻

5. PolicyCard — 정책 리스트 아이템 UI

파일:
lib/features/policy_new/presentation/widgets/policy_card.dart

class PolicyCard extends StatelessWidget {
  const PolicyCard({
    super.key,
    required this.policy,
    required this.onTap,
  });

  final Policy policy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              policy.title,
              style: theme.textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // 요약
            Text(
              policy.summary,
              style: theme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // 태그 영역
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                _buildChip(policy.region),
                _buildChip(policy.category),
                if (policy.isOngoing) _buildChip('모집중'),
                if (policy.isUpcoming) _buildChip('시작 예정'),
                if (policy.isClosed) _buildChip('마감'),
              ],
            ),

            const SizedBox(height: 8),

            // 신청 기간
            if (policy.applicationStartDate != null ||
                policy.applicationEndDate != null)
              Text(
                _buildPeriodText(),
                style: theme.textTheme.labelSmall,
              ),
          ],
        ),
      ),
    );
  }

  String _buildPeriodText() {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;
    if (start == null && end == null) return '신청 기간 정보 없음';
    if (start != null && end == null) {
      return '신청 시작: ${start.toLocal().toString().split(" ").first}';
    }
    if (start == null && end != null) {
      return '신청 마감: ${end.toLocal().toString().split(" ").first}';
    }
    return '신청 기간: '
        '${start!.toLocal().toString().split(" ").first} ~ '
        '${end!.toLocal().toString().split(" ").first}';
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}


⸻

6. 로딩 / 빈 상태 / 에러 위젯

6.1 로딩

파일:
lib/features/policy_new/presentation/widgets/policy_list_loading.dart

class PolicyListLoading extends StatelessWidget {
  const PolicyListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


⸻

6.2 빈 상태

파일:
lib/features/policy_new/presentation/widgets/policy_list_empty.dart

class PolicyListEmpty extends StatelessWidget {
  const PolicyListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          '표시할 정책이 없습니다.\n필터나 검색 조건을 바꿔보세요.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


⸻

6.3 에러 상태

파일:
lib/features/policy_new/presentation/widgets/policy_list_error.dart

class PolicyListError extends StatelessWidget {
  const PolicyListError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '정책을 불러오는 중 오류가 발생했어요.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}


⸻

7. 정책 상세 바텀시트 + 실제 정책 페이지 이동 버튼

job05에서 상세 보기 + “실제 정책 페이지로 이동” 버튼까지 구현한다.

7.1 Detail용 Provider 추가 (providers.dart 수정)

파일:
lib/features/policy_new/application/providers.dart

맨 아래에 다음 provider를 추가한다:

final policyDetailProvider =
    FutureProvider.family<Policy, String>((ref, policyId) async {
  final repo = ref.read(policyRepositoryProvider);
  final result = await repo.fetchPolicyDetail(policyId);

  if (result.isSuccess && result.data != null) {
    return result.data!;
  }

  throw result.failure ?? const UnknownFailure();
});


⸻

7.2 상세 바텀시트

파일:
lib/features/policy_new/presentation/detail/policy_detail_bottom_sheet.dart

class PolicyDetailBottomSheet extends ConsumerWidget {
  const PolicyDetailBottomSheet({
    super.key,
    required this.policyId,
  });

  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPolicy = ref.watch(policyDetailProvider(policyId));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: asyncPolicy.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  e is PolicyFailure ? e.message : '정책 정보를 불러오지 못했습니다.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (policy) => ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // 제목
                Text(
                  policy.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                // 요약
                Text(
                  policy.summary,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                // 지역/카테고리/상태
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _chip(policy.region),
                    _chip(policy.category),
                    if (policy.isOngoing) _chip('모집중'),
                    if (policy.isUpcoming) _chip('시작 예정'),
                    if (policy.isClosed) _chip('마감'),
                  ],
                ),

                const SizedBox(height: 16),

                // 본문 설명
                Text(
                  policy.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                // 신청 기간
                Text(
                  _buildPeriodText(policy),
                  style: Theme.of(context).textTheme.labelMedium,
                ),

                const SizedBox(height: 16),

                // 버튼 영역
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _openApplyUrl(policy.applyUrl),
                        child: const Text('실제 정책 페이지로 이동'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  String _buildPeriodText(Policy policy) {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;
    if (start == null && end == null) {
      return '신청 기간 정보 없음';
    }
    if (start != null && end == null) {
      return '신청 시작일: ${start.toLocal().toString().split(" ").first}';
    }
    if (start == null && end != null) {
      return '신청 마감일: ${end.toLocal().toString().split(" ").first}';
    }
    return '신청 기간: '
        '${start!.toLocal().toString().split(" ").first} ~ '
        '${end!.toLocal().toString().split(" ").first}';
  }

  Future<void> _openApplyUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

⚠ url_launcher 패키지를 이미 사용 중이 아니라면,
pubspec.yaml에 url_launcher 추가 후 import 'package:url_launcher/url_launcher.dart';를 넣어야 한다.

⸻

8. Acceptance Criteria (job05 완료 기준)
	•	lib/features/policy_new/presentation/** 아래에 명시된 파일과 구조가 모두 생성된다.
	•	PolicyFeedHomeScreen에서 탭 전환 + 좌우 스와이프가 정상 동작한다.
	•	각 탭(추천/전체/지역/검색/즐겨찾기/비교)이 자신의 Controller Provider와 정상적으로 연결된다.
	•	리스트는 Pull-to-Refresh + 무한 스크롤(footer 로딩)이 동작한다.
	•	로딩/빈 상태/에러 상태 UI가 공통 컴포넌트로 구현되어 있다.
	•	정책 카드를 탭하면 상세 바텀시트가 뜨고, Repository를 통해 상세 정보를 로딩한다.
	•	상세 바텀시트에서 “실제 정책 페이지로 이동” 버튼을 누르면 외부 브라우저로 이동한다.
	•	빌드시 타입 에러, Provider 참조 에러, import 에러 없이 통과한다
(단, url_launcher 사용 시 의존성 추가 필요).

---
지민님 💙🩵
알겠어요. 이번 job06은 진짜로 **job01급 “완전 설계 문서”**로 갈게요.
검색/필터/정렬 + 추천 + 탭별 필터 전략까지 한 번에 통합하는 Interaction Layer로 설계합니다.

아래 블록은 AGENTS.md에 그대로 넣어서 Codex에게 시킬 수 있는 최종판이에요.
(job01 스타일로: 문제 정의 → 전역 규칙 → 상태 설계 → Query 오케스트레이션 → Controller/UI 연동 → Acceptance Criteria)

⸻

✅ #job06 — PolicyNew Filter/Search/Sort/Recommendation Interaction (FULL SPEC)

@chatgpt-codex
# job06 — PolicyNew Filter/Search/Sort/Recommendation Interaction
# (FeedType-aware Query Orchestration + Global Filter State + Recommendation Profile + UI 연동)

목표:
- job01~05에서 만든 PolicyNew 시스템에 대해,
  검색/필터/정렬 + 추천 + 탭별 FeedType 전략을
  하나의 일관된 Interaction Layer로 통합한다.
- 이 job06 이후:
  - 상단 필터/검색/정렬 바에서 UI 상태를 바꾸면
  - FeedType(추천/전체/지역/검색/즐겨찾기/비교)에 맞는 PolicyQuery가 자동으로 재조합되고
  - 각 Feed Controller가 적절히 refresh/paging 되는 구조가 완성되어야 한다.
- 기존 Domain/Repository/Controller/Presentation 구조를 깨지 않고,
  “연결 규칙 + 상태 소유권 + Query 빌더”를 추가하는 방식으로 작업한다.

---

# 0. 선행 작업(의존성) 전제

이 job06은 **반드시 아래 작업들이 먼저 적용된 상태를 전제로 한다:**

- job01: PolicyNew 기본 레이어 (Domain/Repository 기본, PagingController, Logger, EventBus, Settings)  
- job02: Policy Domain 확장 (Policy, PolicyFilter, PolicySortOption, PolicyFeedType, PolicyQuery 등)  
- job03: PolicyRepositoryImpl + PolicyModel + RemoteSource + SWR Cache (Query 기반)  
- job04: BasePolicyFeedController + PolicyPagingState + PolicyQueryEngine + Feed별 Controller들  
- job05: PolicyFeedHomeScreen + Swipe 탭 + PolicyFeedListView + PolicyCard + PolicyDetailBottomSheet 등  

**중요:**  
- Domain(Entity/Value) 구조는 job02에서 완전히 확정된 상태이며, job06에서 Domain은 절대 수정하지 않는다.
- Repository/Remote는 job03에서 구현된 시그니처를 변경하지 않는다.

---

# 1. 전역 설계 원칙 (job06 Interaction Layer 규약)

1. **상태 단일 소스 원칙**
   - 검색 키워드, 지역, 카테고리, 정렬, 추천 태그 등 “필터/검색 관련 상태”는
     전역 StateNotifier(PolicyFilterUiState)에서만 관리한다.
   - 어떤 FeedController도 이 UI 상태를 자신의 필드로 복제/보유하지 않는다.

2. **FeedType-aware Query 원칙**
   - 실제 PolicyQuery 생성은 “Query Orchestrator”에서만 수행한다.
   - 각 FeedController는 feedType만 알고, UI 상태와 user profile, favorite/compare 데이터를 고려한 Query 조합은 Orchestrator 책임.

3. **자동 반응(reactive) 원칙**
   - Filter/검색/정렬/추천 태그 상태가 변경되면,
     해당 변경을 지원하는 FeedType(추천/전체/지역/검색)은 자동으로 refresh 되어야 한다.
   - Favorite/Compare Feed는 UI 필터와 분리해서 동작하지만, 정렬(sort) 변경은 영향을 받을 수 있다.

4. **EventBus 연동**
   - favoritesChanged, cacheCleared, refreshRequested 같은 이벤트는
     각 FeedController가 수신해 refresh 또는 캐시 clear를 수행해야 한다.
   - job06에서 EventBus 사용 규칙을 명시하고, Controller에 반영한다.

5. **UI와 로직 분리**
   - UI(위젯)는 오직 FilterUiState/FeedController/DetailProvider에만 의존한다.
   - Repository/Remote/Domain에 직접 접근하지 않는다.

---

# 2. 디렉토리 및 파일 구조

job06에서 추가/수정되는 파일 구조는 다음과 같다.

```txt
lib/features/policy_new/
  application/
    filters/
      policy_filter_ui_state.dart            # 필터/검색/정렬/추천 태그에 대한 전역 UI 상태
    controllers/
      policy_query_orchestrator.dart        # FeedType + UI 상태 + Profile + Favorite/Compare를 조합해 PolicyQuery 생성
      base_feed_controller.dart             # (job06 버전으로 전체 교체) Orchestrator 사용
  presentation/
    filters/
      policy_filter_bar.dart                # 상단 검색/필터/정렬 Bar
      policy_sort_bottom_sheet.dart         # 정렬 옵션 선택 바텀시트
      policy_filter_bottom_sheet.dart       # 지역/카테고리/온/오프라인 등의 필터 시트
      policy_keyword_sheet.dart             # 검색 키워드 입력용 시트
      policy_recommend_tags_bar.dart        # 추천 키워드(chip 리스트) UI
    screens/
      policy_feed_home_screen.dart          # (job06 버전으로 상단 필터 바 + 탭 통합) 전체 교체

규칙:
	•	기존 Domain 레이어 파일은 이 job06에서 절대 건드리지 않는다.
	•	기존 Repository/RemoteSource 파일도 시그니처 변경 없이 사용한다.
	•	BasePolicyFeedController와 PolicyQueryEngine 관련 파일은 job06 버전으로 “전체 교체”한다.

⸻

3. Application: Filter UI 상태 모델 (PolicyFilterUiState)

3.1 파일: application/filters/policy_filter_ui_state.dart

@immutable
class PolicyFilterUiState {
  final PolicyRegion region;             // UI에서 선택한 지역
  final PolicyCategory? category;        // UI에서 선택한 카테고리
  final PolicySortOption sort;           // 정렬 기준
  final String keyword;                  // 검색어
  final List<String> tags;               // 추천 태그 (AI 추천 키워드)
  final bool showOnlyOnline;             // 온라인만 보기
  final bool showOnlyOngoing;            // 모집중만 보기

  const PolicyFilterUiState({
    this.region = PolicyRegion.all,
    this.category,
    this.sort = PolicySortOption.latest,
    this.keyword = '',
    this.tags = const [],
    this.showOnlyOnline = false,
    this.showOnlyOngoing = false,
  });

  PolicyFilterUiState copyWith({
    PolicyRegion? region,
    PolicyCategory? category,
    PolicySortOption? sort,
    String? keyword,
    List<String>? tags,
    bool? showOnlyOnline,
    bool? showOnlyOngoing,
  }) {
    return PolicyFilterUiState(
      region: region ?? this.region,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      keyword: keyword ?? this.keyword,
      tags: tags ?? this.tags,
      showOnlyOnline: showOnlyOnline ?? this.showOnlyOnline,
      showOnlyOngoing: showOnlyOngoing ?? this.showOnlyOngoing,
    );
  }
}

class PolicyFilterUiStateNotifier
    extends StateNotifier<PolicyFilterUiState> {
  PolicyFilterUiStateNotifier() : super(const PolicyFilterUiState());

  void setRegion(PolicyRegion region) =>
      state = state.copyWith(region: region);

  void setCategory(PolicyCategory? category) =>
      state = state.copyWith(category: category);

  void setSort(PolicySortOption sort) =>
      state = state.copyWith(sort: sort);

  void setKeyword(String keyword) =>
      state = state.copyWith(keyword: keyword);

  void setTags(List<String> tags) =>
      state = state.copyWith(tags: tags);

  void toggleOnlineOnly() =>
      state = state.copyWith(showOnlyOnline: !state.showOnlyOnline);

  void toggleOngoingOnly() =>
      state = state.copyWith(showOnlyOngoing: !state.showOnlyOngoing);

  void resetAll() => state = const PolicyFilterUiState();
}

final policyFilterUiStateProvider =
    StateNotifierProvider<PolicyFilterUiStateNotifier, PolicyFilterUiState>(
  (ref) => PolicyFilterUiStateNotifier(),
);


⸻

4. Application: PolicyQueryOrchestrator (핵심)

4.1 파일: application/controllers/policy_query_orchestrator.dart

목표:
	•	FeedType + FilterUiState + 유저 프로필 + Favorite/Compare 정보로부터
Domain의 PolicyQuery를 만들어주는 단일 진입점.
	•	QueryEngine(Repository 호출 담당)과 분리하여 “Query 생성 책임”만 담당한다.

class PolicyQueryOrchestrator {
  PolicyQueryOrchestrator(this.ref);

  final Ref ref;

  PolicyFilterUiState get _ui => ref.read(policyFilterUiStateProvider);

  UserProfile get _profile => ref.read(userProfileProvider);
  // userProfileProvider는 job04 또는 별도 작업에서 정의되었다고 가정 (age, region, recommendTags 등)

  List<String> get _favoriteIds =>
      ref.read(favoriteRepositoryProvider).allIds;

  List<String> get _compareIds =>
      ref.read(compareRepositoryProvider).ids;

  PolicyQuery buildQuery(PolicyFeedType feedType) {
    switch (feedType) {
      case PolicyFeedType.recommend:
        return _buildRecommendQuery();
      case PolicyFeedType.all:
        return _buildAllQuery();
      case PolicyFeedType.region:
        return _buildRegionQuery();
      case PolicyFeedType.search:
        return _buildSearchQuery();
      case PolicyFeedType.favorite:
        return _buildFavoriteQuery();
      case PolicyFeedType.compare:
        return _buildCompareQuery();
    }
  }

  PolicyQuery _buildRecommendQuery() {
    final filter = PolicyFilter(
      region: _ui.region == PolicyRegion.all ? _profile.region : _ui.region,
      category: _ui.category,
      age: _profile.age,
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
    );

    // 추천 태그: UI에서 선택한 태그가 있으면 우선, 없으면 프로필 기반 recommendTags
    final tags = _ui.tags.isNotEmpty
        ? _ui.tags
        : _profile.recommendTags;

    return PolicyQuery(
      feedType: PolicyFeedType.recommend,
      filter: filter,
      tags: tags,
      sort: PolicySortOption.recommendation,
    );
  }

  PolicyQuery _buildAllQuery() {
    final filter = PolicyFilter(
      region: _ui.region,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.all,
      filter: filter,
      sort: _ui.sort,
    );
  }

  PolicyQuery _buildRegionQuery() {
    final region = _ui.region == PolicyRegion.all
        ? _profile.region
        : _ui.region;

    final filter = PolicyFilter(
      region: region,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.region,
      filter: filter,
      sort: _ui.sort,
    );
  }

  PolicyQuery _buildSearchQuery() {
    final filter = PolicyFilter(
      region: _ui.region,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.search,
      keyword: _ui.keyword.isEmpty ? null : _ui.keyword,
      filter: filter,
      tags: _ui.tags,
      sort: _ui.sort,
    );
  }

  PolicyQuery _buildFavoriteQuery() {
    final filter = PolicyFilter(
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.favorite,
      filter: filter,
      tags: _favoriteIds, // 백엔드에서 favorite용 파라미터로 해석
      sort: _ui.sort,
    );
  }

  PolicyQuery _buildCompareQuery() {
    final filter = PolicyFilter(
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.compare,
      filter: filter,
      tags: _compareIds,
      sort: _ui.sort,
    );
  }
}


⸻

5. Application: PolicyQueryEngine 업그레이드

5.1 파일: application/controllers/policy_query_engine.dart (전체 교체)

QueryEngine은 Repository 호출 담당이며, Orchestrator를 통해 Query를 받는다.

class PolicyQueryEngine {
  PolicyQueryEngine(this.ref);

  final Ref ref;

  int get pageSize =>
      ref.read(policySettingsProvider).pageSize;

  PolicyQueryOrchestrator get _orchestrator =>
      ref.read(policyQueryOrchestratorProvider);

  Future<PolicyResult<List<Policy>>> fetch(
    PolicyFeedType feedType, {
    required int page,
  }) async {
    final query = _orchestrator.buildQuery(feedType);
    final repo = ref.read(policyRepositoryProvider);

    return repo.fetchPoliciesByQuery(
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }
}

final policyQueryEngineProvider = Provider<PolicyQueryEngine>(
  (ref) => PolicyQueryEngine(ref),
);

final policyQueryOrchestratorProvider = Provider<PolicyQueryOrchestrator>(
  (ref) => PolicyQueryOrchestrator(ref),
);


⸻

6. Application: BasePolicyFeedController 업그레이드 (job06 버전)

6.1 파일: application/controllers/base_feed_controller.dart (전체 교체)

abstract class BasePolicyFeedController
    extends StateNotifier<PolicyPagingState> {
  BasePolicyFeedController({
    required this.ref,
    required this.feedType,
    required this.queryEngine,
  }) : super(const PolicyPagingState.initial()) {
    // UI 필터 상태 변경 시 자동 refresh
    ref.listen<PolicyFilterUiState>(
      policyFilterUiStateProvider,
      (previous, next) {
        if (supportsFilterAutoApply) {
          refresh();
        }
      },
    );

    // EventBus 연동 (즐겨찾기, 비교, 캐시 초기화 등)
    ref.listen<PolicyEvent?>(
      policyEventBusProvider,
      (previous, next) {
        if (next == null) return;
        switch (next.type) {
          case PolicyEventType.cacheCleared:
            _resetPaging();
            break;
          case PolicyEventType.refreshRequested:
            refresh();
            break;
          case PolicyEventType.favoritesChanged:
            if (feedType == PolicyFeedType.favorite ||
                feedType == PolicyFeedType.recommend) {
              refresh();
            }
            break;
          case PolicyEventType.profileUpdated:
            if (feedType == PolicyFeedType.recommend ||
                feedType == PolicyFeedType.region) {
              refresh();
            }
            break;
        }
      },
    );
  }

  final Ref ref;
  final PolicyFeedType feedType;
  final PolicyQueryEngine queryEngine;

  int _page = 1;
  bool _isLoading = false;

  bool get supportsFilterAutoApply =>
      feedType == PolicyFeedType.recommend ||
      feedType == PolicyFeedType.all ||
      feedType == PolicyFeedType.region ||
      feedType == PolicyFeedType.search;

  void _resetPaging() {
    _page = 1;
    _isLoading = false;
    state = const PolicyPagingState.initial();
  }

  Future<void> loadFirstPage() async {
    _page = 1;
    _isLoading = true;
    state = const PolicyPagingState.loading();

    final result = await queryEngine.fetch(feedType, page: _page);

    result.fold(
      onSuccess: (list) {
        state = PolicyPagingState.data(
          items: list,
          hasMore: list.length == queryEngine.pageSize,
        );
      },
      onFailure: (failure) {
        state = PolicyPagingState.error(failure);
      },
    );

    _isLoading = false;
  }

  Future<void> loadNextPage() async {
    if (_isLoading || !state.hasMore) return;

    _isLoading = true;
    final nextPage = _page + 1;

    final result = await queryEngine.fetch(feedType, page: nextPage);

    result.fold(
      onSuccess: (list) {
        final merged = [...state.items, ...list];
        state = PolicyPagingState.data(
          items: merged,
          hasMore: list.length == queryEngine.pageSize,
        );
        _page = nextPage;
      },
      onFailure: (failure) {
        state = PolicyPagingState.error(failure);
      },
    );

    _isLoading = false;
  }

  Future<void> refresh() async {
    await loadFirstPage();
  }
}


⸻

7. Application: Feed Controller 구현 (job06 규약 적용)

각 Feed Controller는 이제 BasePolicyFeedController를 상속하면서,
생성자에서 feedType만 넘기면 된다.

예시 (나머지도 동일 패턴):

class RecommendFeedController extends BasePolicyFeedController {
  RecommendFeedController({
    required Ref ref,
    required PolicyQueryEngine queryEngine,
  }) : super(
          ref: ref,
          feedType: PolicyFeedType.recommend,
          queryEngine: queryEngine,
        );
}

나머지 All/Region/Search/Favorite/Compare도 같은 방식으로 구현한다.

Provider 등록 예시:

final recommendFeedControllerProvider =
    StateNotifierProvider<RecommendFeedController, PolicyPagingState>(
  (ref) => RecommendFeedController(
    ref: ref,
    queryEngine: ref.read(policyQueryEngineProvider),
  ),
);


⸻

8. Presentation: Filter/Search/Sort UI 연동 (상단 바)

8.1 파일: presentation/filters/policy_filter_bar.dart

이 바는 job05의 PolicyFeedHomeScreen AppBar 아래에 위치한다.

class PolicyFilterBar extends ConsumerWidget {
  const PolicyFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(policyFilterUiStateProvider);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // 검색창
          Expanded(
            child: GestureDetector(
              onTap: () => _openKeywordSheet(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ui.keyword.isEmpty ? '검색어를 입력하세요' : ui.keyword,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ui.keyword.isEmpty
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 정렬 버튼
          _chipButton(
            context,
            label: _sortLabel(ui.sort),
            icon: Icons.swap_vert,
            onTap: () => _openSortSheet(context),
          ),
          const SizedBox(width: 6),

          // 필터 버튼
          _chipButton(
            context,
            label: '필터',
            icon: Icons.filter_alt_outlined,
            onTap: () => _openFilterSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _chipButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  String _sortLabel(PolicySortOption sort) {
    switch (sort) {
      case PolicySortOption.latest:
        return '최신순';
      case PolicySortOption.deadline:
        return '마감 임박';
      case PolicySortOption.popularity:
        return '인기순';
      case PolicySortOption.recommendation:
        return '추천순';
    }
  }

  void _openKeywordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PolicyKeywordSheet(),
    );
  }

  void _openSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const PolicySortBottomSheet(),
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const PolicyFilterBottomSheet(),
    );
  }
}


⸻

9. Presentation: Filter/Search/Sort 시트들 (요약 규격)

각 시트는 다음 규칙을 따른다:
	•	PolicyKeywordSheet
	•	TextField로 keyword 입력
	•	확인 시 policyFilterUiStateProvider.notifier.setKeyword(...) 호출
	•	닫히면 자동으로 Search Feed 등에서 refresh 발생 (BaseController에서 listen)
	•	PolicySortBottomSheet
	•	PolicySortOption 리스트를 보여주고 선택 시 setSort(...) 호출
	•	PolicyFilterBottomSheet
	•	지역(PolicyRegion) + 카테고리(PolicyCategory) + 온라인/모집중 토글 UI 제공
	•	변경 시 각각 setRegion, setCategory, toggleOnlineOnly, toggleOngoingOnly 호출
	•	“초기화” 버튼으로 resetAll() 호출 가능

각 컴포넌트는 policyFilterUiStateProvider만 조작하며,
FeedController는 이 상태 변경을 자동으로 감지해 Query 재조합 + refresh를 수행한다.

⸻

10. Presentation: PolicyFeedHomeScreen 상단에 FilterBar 추가

job05에서 정의한 PolicyFeedHomeScreen을 아래 구조로 업데이트한다.

핵심: 상단 구조를 Column(AppBar 영역 안의 TabBar) + PolicyFilterBar + Expanded(TabView) 로 구성.

(여기서는 전체 파일 교체 지시가 아니라, 상단 구조를 다음처럼 구성할 것을 명시한다.)

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('정책 탐색'),
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _tabs.map((e) => Tab(text: e.label)).toList(),
      ),
    ),
    body: Column(
      children: [
        const PolicyFilterBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: _tabs
                .map((tab) => PolicyFeedListView(feedType: tab.type))
                .toList(),
          ),
        ),
      ],
    ),
  );
}


⸻

11. Acceptance Criteria (job06 완료 기준)
	•	PolicyFilterUiState 및 policyFilterUiStateProvider가 생성되어 있으며,
region/category/keyword/sort/tags/onlineOnly/ongoingOnly 상태를 관리한다.
	•	PolicyQueryOrchestrator가 FeedType + FilterUiState + UserProfile + Favorite/Compare를 입력으로 받아
PolicyQuery를 생성하는 로직을 모두 포함한다.
	•	PolicyQueryEngine이 fetch(feedType, page) 형태로 동작하며,
내부에서 Orchestrator로부터 Query를 받는다.
	•	BasePolicyFeedController가 job06 버전으로 교체되어,
- FilterUiState 변경 시 자동 refresh,
- EventBus 이벤트에 따른 refresh/cache reset 동작,
- 페이징(loadFirstPage/loadNextPage/refresh) 로직을 포함한다.
	•	Recommend/All/Region/Search/Favorite/Compare Feed Controller가
BasePolicyFeedController를 상속하고 feedType만 지정하도록 구현된다.
	•	PolicyFilterBar 및 하위 시트(Keyword/Sort/Filter)가
policyFilterUiStateProvider만 조작하며, Repository나 Domain을 직접 건드리지 않는다.
	•	PolicyFeedHomeScreen 상단에 PolicyFilterBar가 추가되며,
탭 전환, 스와이프, 필터/검색/정렬 변경이 모두 자연스럽게 동작한다.
	•	Filter/Search/Sort 변경 시, 각 FeedType에 맞는 정책 피드가 자동으로 재조회된다.
	•	기존 job01~05의 Domain/Repository/Remote/Detail 화면 등과 충돌 없이 빌드가 성공해야 한다.

---
지민님… 💙🩵
이번 job07은 진짜 “job01 스타일 그대로”, 즉 소프트웨어 엔지니어링 교과서적으로 완성된 ‘설계 문서’ 형식으로 만들게요.
job01이 “코어 시스템 정의서”였다면,
**job07은 “정책 추천 시스템(개인화·AI추천·행동 기반) 전체 설계 문서”**예요.

아래는 AGENTS.md에 바로 넣을 수 있는 완벽한 job01 스타일 job07 완전체입니다.

⸻

🟦 #job07 — PolicyNew Recommendation System (Full Architecture Spec)

(개인화 프로필 + AI 추천 키워드 + 행동 기반 추천 + 추천 피드 구성 전체)

@chatgpt-codex
# job07 — PolicyNew Recommendation System (FULL SYSTEM SPEC)

## 0. 시스템 정의 (System Definition)
PolicyNew의 추천 시스템은 다음을 목표로 한다:
- 사용자의 개인정보(나이/지역/관심 분야/학력/상태) + 행동 데이터(클릭/좋아요/비교/조회) + 선택한 추천 태그를 활용해
  “사용자에게 가장 적합한 정책을 자동으로 추천”하는 Feed를 구성한다.
- 추천 결과는 RecommendFeedController에서 관리되며, QueryOrchestrator가 필터/UI/프로필/태그를 조합해 Query를 만든다.
- 추천 알고리즘은 정적인 rule 기반 + 사용자 선택 태그 + 행동 기반 점수의 가중치를 혼합한 Hybrid 모델이다.
- 앱 내부에서 모든 추천은 클라이언트 Query 기반이며, 서버 측 API는 Query 파라미터(tags/age/region/category)로 정책을 반환한다.

---

## 1. 문제 정의 (Problem Statement)

사용자들은 정책 탐색 시 다음과 같은 문제를 겪는다:
1. 정책이 너무 많아 본인에게 맞는 정책을 찾기 어렵다.
2. 동일 지역·동일 조건이라도 개인의 관심사, 생애주기, 직업군에 따라 필요 정책이 다르다.
3. 사용자는 앱을 여러 번 여는 동안 매번 ‘검색/필터’를 다시 잡아야 해서 피로도가 높다.
4. 즐겨찾기(Favorite)나 비교 리스트에서 선택한 정책이 추천에 반영되지 않아 개인화가 부족하다.
5. 온보딩 시 입력한 기본 정보(지역/나이/직업/카테고리 선호)가 앱 사용 중 실시간으로 추천에 반영되지 않는다.

**job07은 위 문제를 해결하는 “완전한 추천 엔진 구조”를 설계한다.**

---

## 2. 요구사항 분석 (Requirements Analysis)

### 2.1 기능 요구사항 (Functional)
1. 사용자 프로필(나이/지역/관심 분야/직업/학력 등)을 기반으로 추천을 제공한다.
2. 앱 상단에서 선택한 추천 키워드(tags)를 추천 query에 반영한다.
3. 즐겨찾기 변화 → 추천 재계산
4. 비교 목록 변화 → 추천 재계산
5. 정책 상세페이지 진입 기록 → 행동 기반 추천 점수 상승
6. 추천 결과는 RecommendFeedController에서 paging 가능한 형태로 제공
7. 추천 정책은 “추천순” 정렬 방식으로 기본 정렬
8. 추천 태그는 UI 단에서 chip 형태로 표시하며 선택/해제 가능
9. 사용자가 ‘관심 없음’ 처리하는 정책은 추천에서 제외

### 2.2 비기능 요구사항 (Non-Functional)
1. 빠른 응답: 추천은 네트워크/캐시 간 SWR(SWR Cache) 방식으로 빠르게 제공.
2. 확장 용이성: 조합되는 데이터가 늘어나도 Query와 Controller가 깨지지 않아야 함.
3. 상태 일관성: UI → FilterState → QueryOrchestrator → FeedController 흐름이 안정적으로 유지.
4. 중복 없음: 필터/검색/정렬 항목과 추천 알고리즘이 충돌하지 않아야 함.

---

## 3. 아키텍처 설계 (Architecture Specification)

추천 시스템은 다음 6개 레이어로 구성된다:

### 3.1 (L1) User Profile Layer
- 유저가 온보딩에서 입력한 정보 제공  
- 구성 요소:
  - age (나이)
  - region (거주 지역)
  - interestCategories (관심 카테고리 리스트)
  - recommendTags (AI가 제안한 키워드)
  - jobType, education, income 등 확장 가능

Provider:
```dart
final userProfileProvider = Provider<UserProfile>((ref) { ... });


⸻

3.2 (L2) Behavior Tracking Layer (사용자 행동 데이터)

수집되는 데이터:
	•	정책 상세 페이지 진입 횟수
	•	리스트 노출 후 클릭 여부
	•	즐겨찾기 추가/삭제
	•	비교 리스트 추가/삭제

저장은 간단한 local DB (Isar) 또는 memory store로 구현:

final behaviorTrackerProvider = Provider<PolicyBehaviorTracker>((ref) { ... });

Scoring 규칙 예:
	•	상세 보기 → score +4
	•	즐겨찾기 → score +10
	•	비교 추가 → score +6
	•	빠르게 이탈한 정책 → score -2

⸻

3.3 (L3) Recommendation Tag Layer (추천 키워드)
	•	UI에서 보여주는 추천 태그 chip 목록
	•	유저 선택 태그 + 프로필 기반 태그 + AI 제안 태그를 합산한 리스트

Provider:

final recommendationTagProvider = Provider<List<String>>((ref) {
  final profile = ref.watch(userProfileProvider);
  final uiTags = ref.watch(policyFilterUiStateProvider).tags;
  return uiTags.isNotEmpty ? uiTags : profile.recommendTags;
});


⸻

3.4 (L4) Filter/Search/Sort Layer (job06의 FilterUiState)
	•	추천 Feed에서도 동일한 UI 필터를 활용하되,
추천은 SortOption = recommendation 으로 고정함

⸻

3.5 (L5) Query Orchestrator Layer

추천 Feed에서 Query를 조합하는 핵심 로직:

PolicyQuery _buildRecommendQuery() {
  return PolicyQuery(
    feedType: PolicyFeedType.recommend,
    filter: PolicyFilter(
      region: ui.region == PolicyRegion.all ? profile.region : ui.region,
      category: ui.category,
      age: profile.age,
      isOnline: ui.showOnlyOnline ? true : null,
      isOngoing: ui.showOnlyOngoing ? true : null,
    ),
    tags: recommendationTags,
    behaviorScore: behaviorTrackerProvider.getTopBehaviorTags(),
    sort: PolicySortOption.recommendation,
  );
}


⸻

3.6 (L6) RecommendFeedController Layer

역할:
	•	QueryOrchestrator에서 구성한 Query로 첫 페이지/다음 페이지 로딩
	•	FilterUI 변경 리스닝
	•	Behavior 이벤트 리스닝
	•	UserProfile 변경 리스닝
	•	Favorite/Compare 변경 리스닝

Provider:

final recommendFeedControllerProvider =
  StateNotifierProvider<RecommendFeedController, PolicyPagingState>( ... );


⸻

4. 데이터 파이프라인 / 흐름도 (Data Pipeline & Flow)

4.1 추천 피드 데이터 흐름

[User]  
  ↓ (필터 변경, 태그 선택, 검색)
[UI Filter State]  
  ↓  
[PolicyQueryOrchestrator]  
  ↓  
[PolicyQueryEngine]  
  ↓ (page/pageSize)  
[PolicyRepository]  
  ↓ (API 호출 + SWR Cache)  
[PolicyRemoteSource]  
  ↓  
[API Server]  
  ↓  
[Policies + Score + Metadata]  
  ↓  
[PolicyRepository]  
  ↓  
[RecommendFeedController]  
  ↓  
[UI ListView(Render)]


⸻

5. Provider/Controller 상호작용 규칙

5.1 자동 Refresh 규칙

RecommendFeedController는 다음 이벤트에서 자동 refresh:

이벤트	설명
FilterUiState 변경	지역/카테고리/정렬/오는중/온라인 필터 변경
Tag 변경	추천 태그 selected/unselected
UserProfile 변경	나이/지역/관심 분야 변경
Favorite 변경	좋아요 → 추천 반영
Compare 변경	비교 정책 추가/제거
Behavior 점수 변화	새 행동 데이터 발생
cacheCleared	전체 캐시 초기화


⸻

5.2 이벤트 우선순위

1) profileUpdated
2) favoritesChanged
3) compareChanged
4) filterChanged
5) tagsChanged
6) behaviorChanged


⸻

6. UI 상태도 (UI State Machine)

추천 화면의 UI 상태는 아래 4단계:

[Idle]  
  ↓ initial loadFirstPage()
[Loading]  
  ↓ success
[Loaded(items, hasMore)]  
  ↙ error          ↘ scroll
[Error]           [LoadingMore → Loaded]

상태 전이 조건:
	•	Filter 변경 → Loaded → Loading → Loaded
	•	Behavior 업데이트 → Loaded → Loading → Loaded

⸻

7. 이벤트 흐름(Event Flow)

예: 사용자가 추천태그 “창업” 클릭 → 추천 upweight

[User Tap Tag("창업")]
 → policyFilterUiStateProvider.setTags(["창업"])
 → BasePolicyFeedController.listen(FilterChange)
 → RecommendFeedController.refresh()
 → QueryOrchestrator.buildQuery() with tags=["창업"]
 → Repository.fetch()
 → UI 업데이트

즐겨찾기 추가 시:

[FavoriteRepository.add(policyId)]
 → EventBus.emit(favoritesChanged)
 → RecommendFeedController.refresh()

행동 기반 추천:

[PolicyDetail Open(policyId)]
 → BehaviorTracker.increment("detailView", policyId)
 → EventBus.emit(behaviorChanged)
 → RecommendFeedController.refresh()


⸻

8. 파일 구조 (File Structure)

lib/features/policy_new/
  domain/        # (job02)
  data/          # (job03)
  application/
    filters/
      policy_filter_ui_state.dart
    controllers/
      policy_query_orchestrator.dart
      policy_query_engine.dart
      base_feed_controller.dart
      recommend_feed_controller.dart
    behavior/
      policy_behavior_tracker.dart       # job07 신규
    profile/
      user_profile_provider.dart         # 온보딩 사용자 프로필
  presentation/
    filters/
      policy_filter_bar.dart
      policy_recommend_tags_bar.dart
    screens/
      policy_feed_home_screen.dart
      policy_recommend_onboarding_screen.dart   # job07 신규
    widgets/
      policy_recommend_card.dart
      policy_recommend_empty.dart
      policy_recommend_error.dart


⸻

9. Acceptance Criteria
	•	추천 Query는 FeedType.recommend 전용 규칙을 따른다.
	•	RecommendedFeedController는 Filter/Profile/Tag/Favorite/Compare/Behavior/Cache 이벤트를 모두 자동 감지한다.
	•	추천 태그 UI(policy_recommend_tags_bar.dart)가 정상 동작하며, Tag 선택 시 자동 refresh 된다.
	•	BehaviorTracker가 정책 클릭/상세 진입/즐겨찾기/비교 동작을 기록한다.
	•	UserProfile 변경 시 추천 피드가 즉시 재계산된다.
	•	Query Orchestrator가 job07 규칙에 따라 Query를 생성한다.
	•	Repository/Domain/Remote와 충돌 없이 컴파일 성공해야 한다.
	•	UI는 (Loading → Loaded → Paging → Error) 상태 흐름을 유지한다.
	•	추천 피드 UI는 job05의 ListView 구조를 그대로 따른다.

---
좋아 지민님 💙🩵
이번엔 진짜 말 그대로 job01 스타일 풀세트로,
신청일자 알림 시스템을 job08로 잡아서 전체 설계할게요.

컨셉은:

job08 = 정책 신청일자 알림 / 리마인더 시스템 v1 전체 설계
	•	정책 상세에서 “알림 신청”
	•	마감 임박 전 알림
	•	목록에서 “알림 설정됨” 뱃지
	•	앱 내부에서 상태 일관성 유지
	•	나중에 푸시/로컬 알림 플러그인 연결하기 쉬운 구조

아래 블록은 AGENTS.md에 바로 들어가는 Codex용 스펙이고,
지민님이 말한 항목(시스템 정의~Acceptance Criteria)을 전부 포함해놨어요.

⸻


@chatgpt-codex
# job08 — PolicyNew 신청일자 알림(Reminder) 시스템 설계 & 구현

## 0. 시스템 정의 (System Definition)

시스템 이름:
- **PolicyNew Application Reminder System v1**

역할:
- 정책의 **신청 마감일(applicationEndDate)** 기준으로,
  사용자가 선택한 정책에 대해 **마감 이전 알림(Reminder)**을 설정/관리하는 서브 시스템.
- “알림 설정된 정책 목록”을 UI에서 조회할 수 있고,
  정책 카드/상세 화면에서 알림 상태를 일관되게 표시한다.
- 알림 스케줄링은 **로컬 단말 기준(local notifications)**을 1차 목표로 하며,
  백엔드 푸시 등은 향후 확장 포인트로만 고려한다.

레이어 관점:
- **Domain**: Reminder 도메인 모델, 상태 enum
- **Data**: ReminderRepository 인터페이스 + 구현체(로컬 저장소)
- **Application**: ReminderController, ReminderService(예약·취소·동기화)
- **Presentation**: 정책 카드/상세 화면/전용 “알림 관리” 화면 + 상태 뱃지

---

## 1. 문제 정의 (Problem Definition)

현 상태:
- 사용자는 여러 청년 정책을 둘러보고 **“나중에 신청해야지”**라고 생각하지만,
  실제로는 신청 마감일을 잊어버리는 경우가 많다.
- 현재 PolicyNew 시스템에는:
  - 신청 마감일을 보여주는 UI는 있지만,
  - 마감일을 기준으로 **알림을 예약/관리하는 기능이 전혀 없음**.
- 알림 기능 없이 단순 리스트/검색/추천만으로는
  “실질적인 신청 행동”까지 연결되기 어렵다.

해결해야 할 문제:
1. 사용자가 관심 있는 정책에 대해:
   - “마감 하루 전 / 3일 전 / 7일 전” 등
   - 직관적인 시점으로 알림을 설정할 수 있어야 한다.
2. 정책마다 알림 상태를:
   - 카드(리스트)
   - 상세 화면
   에서 **같은 정보로** 보여줘야 한다.
3. 알림 설정/취소/만료/삭제 등 상태 변화가
   다른 화면들에 자연스럽게 반영되어야 한다.
4. Flutter/멀티 플랫폼 구조에서,
   **알림 예약 로직 vs UI/Repository vs 플랫폼 플러그인 연결**을 분리해야 한다.

---

## 2. 요구사항 분석 (Requirements Analysis)

### 2.1 기능 요구사항 (Functional)

1. 알림 설정/변경/삭제
   - 정책 상세 화면에서:
     - “알림 설정” 버튼 / 토글 제공
     - 사용자는 기본 옵션 선택:
       - 마감 하루 전
       - 마감 3일 전
       - 마감 7일 전
     - 선택 즉시 해당 정책에 대한 Reminder가 생성/업데이트 되어야 한다.
   - 이미 설정된 정책은:
     - “설정됨” 상태로 표시되고,
     - 눌렀을 때 옵션 변경/해제 가능해야 한다.

2. 알림 목록 조회
   - “내 알림 관리” 화면에서:
     - 알림 설정된 정책 리스트를 볼 수 있어야 한다.
     - 리스트에는:
       - 정책 제목
       - 마감일
       - 알림 예정 시점
       - 알림 상태(예정/만료/취소)
     - 항목을 눌러 상세 화면으로 이동 가능.

3. 상태 표시
   - 정책 카드(PolicyCard)에서:
     - 알림이 설정된 정책은 작은 아이콘/뱃지로 표시 (예: 🔔)
   - 정책 상세 바텀 시트에서:
     - 알림 설정/변경용 버튼 + 현재 설정 상태 표시.

4. 알림 만료 처리
   - 마감일이 지난 정책에 대해:
     - 해당 Reminder는 상태가 “만료(Expired)”로 전환되며,
     - UI에는 “만료됨” 뱃지 또는 비활성 상태로 표시.

5. 플랫폼 알림 연동 준비
   - 실제 기기 알림(푸시/로컬)을 위해:
     - `ReminderScheduler` 인터페이스 설계
     - 기본 구현은 “no-op”(실제 스케줄러 없음)으로 둔다.
     - 이후 job에서 flutter_local_notifications / FCM 등 연결 가능.

---

### 2.2 비기능 요구사항 (Non-functional)

1. 일관성:
   - 단 하나의 ReminderRepository가 모든 알림 정보를 관리하고,
     모든 화면이 이 정보를 참조해야 한다.

2. 확장성:
   - 나중에 “다음 회차 모집 알림” 같은 기능을 추가할 수 있도록,
     모델/레포 구조를 유연하게 정의할 것.

3. 독립성:
   - Policy Repository, Domain을 수정하지 않고,
     Reminder 시스템은 **정책 ID와 마감일만**을 기반으로 동작하게 설계.

4. 성능:
   - 알림 목록/조회는 전체 정책 리스트와 별도 저장소 사용(로컬 DB/캐시)로 빠르게 동작.

---

## 3. 아키텍처 설계 (Architecture Design)

### 3.1 주요 컴포넌트

- Domain
  - `PolicyReminder`
  - `PolicyReminderStatus` (enum)

- Data
  - `PolicyReminderRepository` (interface)
  - `PolicyReminderLocalRepository` (implementation; e.g. Isar/SharedPreferences 기반)

- Application
  - `PolicyReminderService`
    - UI/Controller 요청을 받아 Repository + Scheduler 호출
  - `PolicyReminderController`
    - 개별 정책 + 리스트에 대한 상태 제공
  - `PolicyReminderListController`
    - “내 알림 관리” 화면용 리스트 상태 제공
  - `ReminderScheduler`
    - 실제 플랫폼 알림 스케줄러 인터페이스 (기본 구현은 no-op)

- Presentation
  - `PolicyReminderBadge` (카드용 뱃지 위젯)
  - `PolicyReminderButton` (상세 화면용 버튼)
  - `PolicyReminderListScreen` (내 알림 관리 화면)

---

### 3.2 의존성 방향

- Presentation → Application (Controller/Service) → Data (Repository) → (Local storage)
- Application → Domain
- ReminderScheduler는 Application 레이어에 주입

---

## 4. 데이터 파이프라인 / 흐름도 (Data Pipeline / Flows)

### 4.1 알림 설정 플로우 (상세 화면에서)

1. 사용자가 정책 상세 바텀시트에서 “알림 설정” 탭
2. UI → `PolicyReminderController.setReminder(...)`
3. Controller → `PolicyReminderService.upsertReminder(policyId, endDate, option)`
4. Service:
   - `PolicyReminderRepository.upsert(...)` 호출 (로컬에 저장)
   - `ReminderScheduler.schedule(reminder)` 호출 (플랫폼 수준 예약)
5. 완료 후:
   - Controller state 업데이트
   - EventBus에 `PolicyReminderEvent.changed(policyId)` 발행
6. 정책 카드/리스트/알림 목록 화면이 EventBus를 구독하여 상태 갱신

---

### 4.2 알림 취소 플로우

1. UI: “알림 취소” 선택
2. Controller → Service.cancelReminder(policyId)
3. Service:
   - Repository.delete(policyId)
   - Scheduler.cancel(policyId)
4. EventBus에 `PolicyReminderEvent.changed(policyId)` 발행

---

### 4.3 알림 목록 조회 플로우

1. “내 알림 관리” 화면 진입
2. `PolicyReminderListController.loadAllReminders()`
3. Repository에서 모든 Reminder 로드
4. 상태에 따라 정렬(마감 임박순) 후 UI에 표시
5. 각 항목 클릭 시 상세 화면으로 이동

---

### 4.4 만료 처리 플로우

1. 앱 시작 시 or 알림 목록 진입 시:
   - `PolicyReminderService.cleanupExpiredReminders(now)`
2. Repository에서 모든 Reminder 조회
3. applicationEndDate < now인 항목들:
   - status를 `expired`로 업데이트
4. UI에는 expired 상태 반영

---

## 5. Provider / Controller 상호작용 규칙

### 5.1 Provider 정의

```dart
// Repository
final policyReminderRepositoryProvider = Provider<PolicyReminderRepository>(
  (ref) => PolicyReminderLocalRepository(ref.read),
);

// Scheduler (기본 no-op 구현)
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => NoOpReminderScheduler(),
);

// Service
final policyReminderServiceProvider = Provider<PolicyReminderService>(
  (ref) => PolicyReminderService(
    repository: ref.read(policyReminderRepositoryProvider),
    scheduler: ref.read(reminderSchedulerProvider),
  ),
);

// 개별 정책용 Controller (policyId 단위)
final policyReminderControllerProvider =
    StateNotifierProvider.family<PolicyReminderController, PolicyReminderState, String>(
  (ref, policyId) => PolicyReminderController(
    policyId: policyId,
    service: ref.read(policyReminderServiceProvider),
    eventBus: ref.read(policyEventBusProvider),
  ),
);

// 알림 목록용 Controller
final policyReminderListControllerProvider =
    StateNotifierProvider<PolicyReminderListController, PolicyReminderListState>(
  (ref) => PolicyReminderListController(
    service: ref.read(policyReminderServiceProvider),
    eventBus: ref.read(policyEventBusProvider),
  ),
);


⸻

5.2 Controller 규칙
	•	PolicyReminderController(policyId):
	•	상태: PolicyReminderState
	•	status: none | scheduled | expired
	•	selectedOption: enum(1일 전/3일 전/7일 전)
	•	scheduledAt: DateTime?
	•	메서드:
	•	load() — 초기 로딩
	•	setOption(ReminderOption) — 설정/변경
	•	cancel() — 알림 취소
	•	PolicyReminderListController:
	•	상태: PolicyReminderListState
	•	목록: List<PolicyReminder>
	•	로딩/에러 상태
	•	메서드:
	•	loadAll() — 전체 알림 목록 조회
	•	refresh() — 다시 로딩
	•	EventBus와 연동:
	•	PolicyReminderEvent 타입 추가
	•	정책 카드/상세/목록에서 PolicyReminderEvent를 통해 부분 업데이트

⸻

6. UI 상태도 (UI State)

6.1 개별 정책 상세 화면의 Reminder 상태

상태 다이어그램 (텍스트):
	•	NONE (알림 없음)
	•	→ [사용자: 옵션 선택 후 “설정”] → SCHEDULED
	•	SCHEDULED
	•	→ [사용자: 옵션 변경] → SCHEDULED(옵션만 변경)
	•	→ [사용자: 취소] → NONE
	•	→ [시간 경과, 마감일 지나감] → EXPIRED
	•	EXPIRED
	•	→ [사용자: 새 알림 설정] → SCHEDULED (새 시점 기준)

UI 표현:
	•	NONE: “알림 설정” 버튼
	•	SCHEDULED: “알림 설정됨 · (예: 마감 3일 전)” + “변경/취소” 액션
	•	EXPIRED: “마감된 정책입니다 · 알림 재설정” (재설정이 가능하면)

⸻

6.2 알림 목록 화면 상태
	•	loading → data(reminders) 또는 error
	•	data 상태:
	•	reminders 비어 있음 → “설정된 알림이 없습니다” 문구
	•	존재함 → 마감 임박순 정렬

⸻

7. 이벤트 흐름 (Event Flow)

7.1 EventBus 이벤트 타입

PolicyEventType에 아래 값 추가 (enum 확장):
	•	reminderChanged — 특정 policyId의 Reminder 상태 변경
	•	reminderBulkUpdated — cleanup/일괄 변경 등

PolicyEvent payload:
	•	type: PolicyEventType
	•	policyId: String?
	•	기타 필요한 데이터

7.2 발행 지점
	•	PolicyReminderService.upsertReminder(...) 완료 후:
	•	PolicyEventType.reminderChanged + policyId
	•	PolicyReminderService.cancelReminder(policyId) 완료 후:
	•	PolicyEventType.reminderChanged + policyId
	•	cleanupExpiredReminders로 여러 건 변경 시:
	•	PolicyEventType.reminderBulkUpdated

7.3 구독 지점
	•	PolicyReminderController:
	•	자기 policyId에 해당하는 이벤트 수신 시 load() 재실행
	•	PolicyFeedListView / PolicyCard:
	•	개별 카드가 직접 EventBus를 구독하기보다는,
해당 화면 진입 시 PolicyReminderController가 초기 로딩해 뱃지를 표시하는 것을 우선.
	•	필요 시 job09에서 “카드 레벨 최적화 구독” 고려.

⸻

8. 파일 구조 (File Structure)

job08에서 새로 추가/수정해야 하는 파일들:

lib/features/policy_new/
  domain/
    entities/
      policy_reminder.dart            # PolicyReminder, ReminderStatus, ReminderOption
  data/
    repositories/
      policy_reminder_repository.dart # 인터페이스
    sources/
      policy_reminder_local_source.dart (선택) # 로컬 저장소 접근
    repositories_impl/
      policy_reminder_local_repository.dart # 구현체
  application/
    services/
      policy_reminder_service.dart    # 비즈니스 로직
    controllers/
      policy_reminder_controller.dart       # 개별 정책용
      policy_reminder_list_controller.dart  # 알림 목록용
    schedulers/
      reminder_scheduler.dart         # 인터페이스 + NoOp 구현
  presentation/
    reminder/
      policy_reminder_badge.dart      # 카드용 뱃지 (🔔 등)
      policy_reminder_button.dart     # 상세 화면 버튼
      policy_reminder_list_screen.dart# “내 알림 관리” 화면

기존 파일(Policy, PolicyRepository 등)은 수정 금지.
단, PolicyEventType enum과 EventBus 타입은 job08에서 확장 가능.

⸻

9. Acceptance Criteria (수용 기준)
	•	PolicyReminder Domain 엔티티와 ReminderStatus, ReminderOption enum이 정의되어 있다.
	•	PolicyReminderRepository 인터페이스와 PolicyReminderLocalRepository 구현체가 존재하며,
최소한 아래 메서드를 제공한다:
- Future<void> upsert(PolicyReminder reminder)
- Future<void> delete(String policyId)
- Future<PolicyReminder?> getByPolicyId(String policyId)
- Future<List<PolicyReminder>> getAll()
	•	ReminderScheduler 인터페이스 및 NoOpReminderScheduler 구현이 존재한다.
	•	PolicyReminderService가 Repository + Scheduler를 사용해
upsert/cancel/cleanupExpired 기능을 제공한다.
	•	policyReminderControllerProvider(policyId)가 개별 정책의 reminder 상태를 관리하고,
setOption/cancel/load 메서드를 제공한다.
	•	policyReminderListControllerProvider가 “알림 관리 화면”을 위한 목록 상태를 제공한다.
	•	정책 상세 바텀시트에 PolicyReminderButton이 추가되어,
- 현재 알림 상태를 표시하고
- 알림 설정/변경/취소 UI를 제공한다.
	•	정책 카드에 PolicyReminderBadge가 추가되어,
알림 설정된 정책에 🔔 같은 아이콘을 일관되게 표시한다.
	•	PolicyEventType에 reminder 관련 이벤트가 추가되고,
PolicyReminderService에서 알맞게 이벤트를 발행한다.
	•	빌드시 타입 에러/순환 참조/Provider 충돌이 없어야 한다.
	•	플러터 앱을 실행했을 때,
- 정책 상세에서 알림을 설정/취소할 수 있고,
- “내 알림 관리” 화면에서 설정된 목록을 볼 수 있으며,
- 마감일이 지난 정책은 expired 상태로 보이는 것까지 동작한다
(실제 OS 레벨 알림 팝업은 NoOp로 처리해도 무방).

---
좋아 지민님, 이번엔 정말 job01식 “설계 문서” 폼 그대로 갈게요 💙🩵
job09는 아예 **“신청일자 알림 & 알림 센터 시스템”**로 잡아서,
지민님이 원했던 **“신청일자 알림 기능”**을 아키텍처 레벨에서 완전히 정의해볼게요.

아래 블록은 그대로 AGENTS.md에 넣고 Codex에게 job09로 시키는 용입니다.

⸻


@chatgpt-codex
# job09 — PolicyNew Application Deadline Reminder & Notification Center
# (신청일자 알림 엔진 + 알림 센터 UI + Event / Provider / Controller 설계)

---

## 0. 시스템 정의 (System Definition)

### 0.1 목적

- PolicyNew 시스템에 **“신청일자 알림(Reminder)” 기능**을 추가한다.
- 정책 상세화면에서 사용자가 **“이 정책 신청 마감 전에 알려줘”**를 누르면:
  - 내부 DB/스토리지에 Reminder가 저장되고
  - 플랫폼별 Notification 스케줄러를 통해 로컬 푸시 알림이 예약되며
  - 앱 내 “알림 센터”에서 이 알림들을 목록/관리(켜기/끄기/삭제)할 수 있게 한다.
- 추후 iOS/Android/웹별 구현 차이는 하위 레이어(Platform Adapter)에서 처리하고,
  이번 job09에서는 **도메인/리포지토리/컨트롤러/Provider/화면 구조**를 정의한다.

### 0.2 범위

- Domain: `PolicyReminder` 엔티티 및 관련 Value Object 정의
- Data: Reminder 저장소(로컬 Persistence) 추상화 인터페이스
- Application:
  - Reminder 관리용 Repository/UseCase/Controller
  - NotificationGateway(알림 스케줄러 추상 포트) 정의
  - EventBus와 연계
- Presentation:
  - 정책 상세 화면에 “알림 설정/해제” 버튼 추가
  - 독립된 “알림 센터” 화면
  - 알림 상태 표시 UI(ON/OFF/만료됨 등)

---

## 1. 문제 정의 (Problem Statement)

1. 현재 PolicyNew 시스템은:
   - 정책의 신청 시작일/마감일/발표일 등 정보는 Domain에 존재하지만
   - 사용자가 “언제 알려줘”를 선택할 수 있는 기능이 없다.
   - 사용자는 마감일을 기억하지 못해서 정책을 놓칠 수 있다.

2. 지민님이 원하는 기능:
   - 정책마다 **“신청일자 알림 기능”**을 켜고 끌 수 있어야 한다.
   - 마감 하루 전, 마감 당일 등 설정된 타이밍에 푸시/로컬 알림이 와야 한다.
   - 어떤 정책들에 알림이 걸려있는지 한눈에 볼 수 있는 “알림 목록 화면”이 필요하다.
   - 즐겨찾기와는 별개로, **“실제 행동(신청)”을 돕는 기능**으로 설계되어야 한다.

3. 제약:
   - 백엔드 Push 서버를 전제하지 않고, **로컬 알림(Local Notification)** 기반으로 설계한다.
   - 플랫폼(iOS/Android/Web)에 따라 실제 스케줄링 구현은 다르므로, job09에서는 **추상 포트(Interface)**만 정의한다.

---

## 2. 요구사항 분석 (Requirements)

### 2.1 기능 요구사항 (Functional Requirements)

1. **Reminder 생성**
   - 정책 상세 화면에서 “신청일자 알림 설정” 버튼 클릭 시,
     해당 정책에 대한 Reminder가 생성되어 로컬 저장 + 알림 스케줄링이 이루어진다.
   - 기본 트리거:
     - 마감 N시간 전 (예: 24시간 전, 3시간 전 등 기본값)
     - 앱 내에서 기본값을 정의하고, 추후 커스터마이징 가능하게 설계만 열어둔다.

2. **Reminder 상태 조회**
   - 특정 정책 ID에 대해 지금 Reminder가 설정되어 있는지 여부를 조회할 수 있어야 한다.
   - 알림 센터에서는 현재 등록된 모든 Reminder 목록을 보여준다:
     - 정책 제목
     - 알림 예정 시각
     - 상태(예정, 만료, 취소 등)

3. **Reminder 수정/삭제**
   - 알림 센터에서 알림을 OFF 하거나 삭제할 수 있어야 한다.
   - 정책 상세 화면에서도 “알림 해제” 버튼으로 끌 수 있어야 한다.
   - 끌 경우:
     - 로컬 저장소에서 Reminder 제거
     - NotificationGateway를 통해 예약된 알림 취소

4. **만료 처리**
   - 과거 시간이 된 Reminder(마감 지남 등)는 “만료됨” 상태로 표시되거나,
     자동으로 삭제/아카이브 처리할 수 있는 정책(Policy)을 정의한다.
   - job09에서는 기본 동작:
     - 앱 진입 시, “현재 시각 < triggerAt” 인 것만 “유효”로 보고,
       과거인 것들은 “만료” 상태로 플래그를 바꾼다.

5. **다중 알림 정책 (옵션)**
   - 한 정책에 대해 복수의 알림(예: 3일 전 / 1일 전 / 당일)을 지원할 수 있게 모델은 설계하되,
     이번 구현은 “1개 알림(마감 N시간 전)”만 실제 사용.

### 2.2 비기능 요구사항 (Non-functional)

- 앱이 재시작되더라도 Reminder 정보는 유지되어야 한다.
  - 로컬 DB/파일/SharedPreferences/Isar 등 디스크 기반 저장 전제.
- 시간대(Timezone) 이슈를 고려하여,
  - 시스템 내부에서는 UTC 저장 + 로컬 시각 변환 규칙을 명시적으로 적어둔다.
- 네트워크가 없어도 알림이 동작해야 한다. (Pure Local)

---

## 3. 아키텍처 설계 (Architecture Design)

### 3.1 레이어별 역할

- **Domain**
  - `PolicyReminder` 엔티티
  - `PolicyReminderStatus` enum
  - `PolicyReminderConfig` (사용자 기본 설정, 예: “마감 24시간 전 알림”)
- **Data**
  - `PolicyReminderRepository` 인터페이스 (Domain에서 사용)
  - `PolicyReminderLocalDataSource` 구현 (로컬 DB/스토리지)
  - `NotificationGateway` 인터페이스 (플랫폼 알림 스케줄러 추상 포트)
- **Application**
  - `PolicyReminderController` (상태 + UI 액션 처리)
  - `PolicyReminderService/UseCase` (Reminder 생성/취소 로직)
  - EventBus와 연계 (알림 생성/삭제 시 이벤트 브로드캐스트)
- **Presentation**
  - 정책 상세 바텀시트에 알림 토글 버튼
  - “알림 센터” 화면 (리스트 + 조작)
  - 상태에 따른 UI 표시(ON/OFF/만료)

---

## 4. 데이터 파이프라인 / 흐름도 (Data Pipeline & Flow)

### 4.1 알림 생성 플로우 (정책 상세 → 알림 스케줄)

1. User: 정책 상세 화면에서 **“신청일자 알림 설정” 버튼 탭**
2. UI: `PolicyReminderController.toggleReminder(policy)` 호출
3. Controller:
   - 정책의 `applicationEndDate` 확인 (없으면 실패)
   - `PolicyReminderService.createReminder(policy)` 호출
4. Service:
   - `PolicyReminderConfig` 로부터 기본 오프셋(예: -24h) 가져옴
   - triggerAt = applicationEndDate - offset 계산
   - `PolicyReminderRepository.saveReminder(...)` 호출
   - 성공 시 `NotificationGateway.scheduleReminder(...)` 호출
5. NotificationGateway:
   - 플랫폼 별 native 스케줄링 (실제 구현은 다른 job에서)
6. EventBus:
   - `PolicyEventType.reminderChanged` 이벤트 발행
7. UI:
   - 정책 상세 화면의 알림 토글 상태 업데이트
   - 알림 센터 화면이 열려 있다면 Provider를 통해 자동 리빌드

### 4.2 알림 취소 플로우

1. User: 정책 상세 혹은 알림 센터에서 “알림 해제” 탭
2. Controller: `cancelReminder(policyId)` 호출
3. Service:
   - `PolicyReminderRepository.getReminderByPolicyId` 조회
   - 있으면 삭제 후 `NotificationGateway.cancelReminder(externalId)`
4. EventBus:
   - `PolicyEventType.reminderChanged` 브로드캐스트
5. UI:
   - 상세/알림 센터 UI 갱신

### 4.3 앱 시작 시 정리 플로우

1. 앱 시작 시 `PolicyReminderController.initialize()` 호출
2. Controller:
   - `Repository.getAllReminders()` 가져옴
   - 현재 시각 기준 `triggerAt < now` 인 것들을 `EXPIRED` 상태로 마킹 또는 삭제 정책 수행
3. 필요한 경우:
   - 만료된 알림에 대해 NotificationGateway에 `cancelReminder` 호출 (잔여 스케줄 정리)

---

## 5. Provider / Controller 상호작용 규칙

### 5.1 Provider 목록

- `policyReminderRepositoryProvider`
- `policyReminderControllerProvider`
- `policyReminderListProvider` (알림 센터용 목록)
- `policyReminderStatusProvider(policyId)` (특정 정책의 알림 상태용)

### 5.2 Controller 책임

- `PolicyReminderController`:
  - `initialize()` : 앱 시작 시 Reminder 상태 싱크
  - `toggleReminder(Policy policy)` : ON/OFF 토글
  - `createReminder(Policy policy)` : 명시적 생성
  - `cancelReminderByPolicyId(String policyId)`
  - `getReminderStatus(String policyId)` : PRESENTATION에서 사용

### 5.3 Provider 간 의존 관계

- `policyReminderControllerProvider`  
  → `policyReminderRepositoryProvider` + `notificationGatewayProvider` 의존
- `policyReminderListProvider`  
  → `policyReminderControllerProvider`를 통해 Repository 결과를 얻어 UI-friendly 리스트로 변환
- `policyReminderStatusProvider(policyId)`  
  → `policyReminderControllerProvider`의 메서드를 통해 해당 정책의 상태 반환

---

## 6. UI 상태도 (UI State Diagram — 논리 설명)

### 6.1 정책 상세 화면(Reminder 부분)

- 상태:
  - `OFF` : 알림 미설정
  - `ON(예정)` : 알림 설정됨 / 미래 triggerAt
  - `EXPIRED` : triggerAt 과거 / 알림 만료
- 상태 전이:
  - `OFF` → [사용자 토글] → `ON`
  - `ON` → [사용자 토글] → `OFF`
  - `ON` → [시간 경과 & 앱 초기화 로직] → `EXPIRED`
  - `EXPIRED` → [사용자 재설정] → `ON`

### 6.2 알림 센터 화면

- 전체 상태:
  - `Loading` : Repository에서 로드 중
  - `Empty` : Reminder 없음
  - `Data(reminderList)` : 하나 이상 존재
- 각 아이템 상태:
  - `Scheduled` (ON + future)
  - `Expired`
  - `Canceled` (옵션: 리스트에서 안 보이게 할 수도 있음)

---

## 7. 이벤트 흐름 (Event Flow)

### 7.1 EventBus 이벤트 타입 확장

- `PolicyEventType.reminderChanged`
  - payload: `policyId`, `newStatus(ON/OFF/EXPIRED)`
- `PolicyEventType.reminderTriggered` (선택)
  - 실제 알림 발생 시 앱이 포그라운드에서 수신하는 경우 사용 가능 (job11 수준에서 구현)

### 7.2 구독자

- 정책 상세 화면:
  - 해당 policyId에 대한 `reminderChanged` 이벤트를 수신해 UI 토글 상태 갱신
- 알림 센터 화면:
  - 전체 `reminderChanged` 이벤트를 수신해 리스트 갱신
- Recommend/All/Region/Search 피드:
  - 직접적인 갱신 필요는 없지만, 나중에 “곧 마감 정책 강조” 등의 UX를 위해 선택적으로 사용할 수 있음 (job10 이후).

---

## 8. 파일 구조 (File Structure)

아래 파일/디렉토리를 새로 생성한다. (기존 파일 삭제/수정 금지, 필요한 경우 전체 교체 명시)

```txt
lib/features/policy_new/
  domain/
    entities/
      policy_reminder.dart               # PolicyReminder 엔티티
    values/
      policy_reminder_status.dart        # ON / OFF / EXPIRED 등
      policy_reminder_config.dart        # 기본 알림 오프셋 설정 등
  data/
    sources/
      policy_reminder_local_data_source.dart   # 로컬 저장소 접근
    repositories/
      policy_reminder_repository_impl.dart     # Domain 인터페이스 구현
  domain/
    repositories/
      policy_reminder_repository.dart          # 추상 인터페이스
  application/
    controllers/
      policy_reminder_controller.dart          # 상태 + 액션
    services/
      policy_reminder_service.dart             # 비즈니스 로직
    gateways/
      notification_gateway.dart                # 플랫폼 알림 스케줄러 추상 인터페이스
    providers.dart (기존 파일에 아래 Provider들 추가)
      - policyReminderRepositoryProvider
      - policyReminderControllerProvider
      - policyReminderListProvider
      - policyReminderStatusProvider
  presentation/
    reminder/
      policy_reminder_center_screen.dart       # 알림 센터 화면
      widgets/
        policy_reminder_list_item.dart         # 리스트 아이템
    detail/
      (기존) policy_detail_bottom_sheet.dart   # 여기에 알림 토글 버튼 추가


⸻

9. Acceptance Criteria
	1.	Domain
	•	PolicyReminder 엔티티가 정의되어 있으며,
id, policyId, triggerAt, status, createdAt, updatedAt 등을 가진다.
	•	PolicyReminderStatus enum이 정의되어 scheduled / expired / canceled 등을 표현한다.
	•	PolicyReminderConfig가 기본 오프셋(예: -24h)을 저장할 수 있게 정의된다.
	2.	Data
	•	PolicyReminderRepository 인터페이스가 정의되고,
create/update/delete/getByPolicyId/getAll API를 제공한다.
	•	PolicyReminderRepositoryImpl이 로컬 데이터소스 + Mapper를 이용해 해당 인터페이스를 구현한다.
	•	실제 저장 매체(SharedPreferences/Isar 등)는 이 job에서 구현 여부를 명시하되,
적어도 in-memory mock 구현은 제공되어야 한다.
	3.	Application
	•	NotificationGateway 인터페이스가 정의되어:
scheduleReminder(PolicyReminder) / cancelReminder(PolicyReminder) 메서드를 제공한다.
	•	PolicyReminderService가 Reminder 생성/취소/만료 처리 핵심 로직을 담당한다.
	•	PolicyReminderController가 UI 액션용 API(toggle/create/cancel/getStatus/initialize)를 제공한다.
	•	EventBus에 reminderChanged 이벤트 타입이 추가되고,
Reminder 생성/삭제 시 발행된다.
	4.	Presentation
	•	정책 상세 바텀시트에 “신청일자 알림” 토글 버튼이 추가되고,
토글 시 Controller를 통해 ON/OFF가 수행된다.
	•	“알림 센터” 화면에서 현재 등록된 모든 Reminder가 리스트로 보이며,
각 항목에 대해 “해제” 기능을 제공한다.
	•	알림 센터는 다음 세 가지 상태를 처리한다:
Loading / Empty / Data(reminders).
	•	알림 토글/해제 후 화면이 즉시 갱신된다(EventBus 또는 Provider 연동).
	5.	통합
	•	앱 시작 시 PolicyReminderController.initialize()가 호출되어
만료된 Reminder를 정리한다는 로직이 존재한다.
	•	전체 빌드가 타입 에러 없이 통과한다.
	•	기존 job01~job08에서 정의한 구조(Domain/Repository/Controller/UI)와 충돌이 없다.

---

좋아요 지민님 💙🩵
이번엔 진짜 처음부터 job01 설계 문서 스타일 그대로 갈게요.
job10은, 우리가 초기에 얘기했던 “신청일자 알림 기능”을 정식 시스템으로 설계하는 걸로 잡을게요.

job10 = 정책 신청일자 기반 알림/리마인더 시스템 전체 설계
(로컬 알림 + 리마인더 저장 + 정책 상세/목록과 연동 + EventBus 통합)

아래 블록은 그대로 AGENTS.md에 넣고 Codex한테 맡길 수 있는 완전 설계 문서예요.

⸻


@chatgpt-codex
# job10 — Policy Application Deadline Reminder & Notification System
# (신청일자 알림/리마인더 시스템: 설계 + 저장 + 로컬 알림 + UI 연동)

---

## 0. 시스템 정의 (System Definition)

### 0.1 목적
- 사용자가 관심 있는 정책에 대해 **신청 마감일/시작일 기준으로 알림을 예약**하고,
- 기한이 다가오면 **디바이스 로컬 알림**으로 알려주는 시스템을 구축한다.
- 이 시스템은:
  - `Policy` 엔티티의 `applicationStartDate` / `applicationEndDate`를 기반으로,
  - 사용자가 선택한 패턴(D-7, D-3, D-1, 당일 등)에 맞춰,
  - 로컬 알림 + 앱 내 “알림 목록 화면”까지 제공하는 것을 목표로 한다.

### 0.2 범위
- 이 job10은 **클라이언트 앱 내 알림/리마인더 레이어**만 다룬다.
- 서버 푸시(Firebase FCM 등)는 고려하지 않고, **디바이스 로컬 알림** 위주로 설계한다.
- Flutter 환경에서 `flutter_local_notifications` 같은 패키지 사용을 전제로 하나,
  구체 패키지 명은 나중에 바꿔도 되도록 **NotificationGateway 인터페이스**로 추상화한다.

---

## 1. 문제 정의 (Problem Statement)

1. 사용자는 정책 상세 페이지를 보고 “좋네, 나중에 신청해야지”라고 생각하지만,
   앱을 닫고 나면 **신청 기한을 잊어버리는 경우가 많다**.
2. 단순 즐겨찾기만으로는 “언제 다시 봐야 하는지”를 알려주지 못한다.
3. 신청 마감일이 정책마다 다르고, D-7 / D-3 / D-1 등 **사용자 선호 알림 시점**도 다를 수 있다.
4. 현재 시스템(job01~job06)에는:
   - `Policy` 도메인 모델은 있지만,
   - “알림/리마인더 엔티티”와 이를 관리하는 Repository/Controller/UI가 없다.
5. 알림/리마인더 기능이 다른 레이어(UI/Controller/Repository)에 흩어지면 유지보수가 어려워진다.
   - 따라서 **전용 도메인 + 데이터 파이프라인 + Interaction 아키텍처**가 필요하다.

---

## 2. 요구사항 분석 (Requirement Analysis)

### 2.1 기능 요구사항 (Functional)

1. **리마인더 생성**
   - 사용자는 정책 상세 화면에서 “신청 알림 설정” 버튼을 누를 수 있다.
   - 옵션 예시:
     - D-7, D-3, D-1, 당일 09:00
     - “직접 날짜/시간 선택”
   - 각 선택은 하나의 또는 여러 개의 `Reminder`로 저장/스케줄링된다.

2. **리마인더 목록 관리**
   - “알림/리마인더” 전용 화면에서 **다가오는 알림 목록**을 볼 수 있어야 한다.
   - 항목: 정책 제목, 알림 예정 시각, 상태(예정/완료/취소), 알림 타입(D-3 등)

3. **리마인더 취소/수정**
   - 사용자는 개별 리마인더를 끄거나 삭제할 수 있어야 한다.
   - 편의상 **정책 단위**로 전체 리마인더를 Off 하는 옵션도 제공할 수 있다.

4. **로컬 알림 트리거**
   - 알림 시각이 되면 디바이스에 푸시(로컬 알림)가 뜬다.
   - 알림을 탭하면 해당 정책 상세 화면으로 이동한다.

5. **정책/알림 상태 동기화**
   - 정책이 이미 마감된 경우:
     - 새 리마인더를 만들 수 없게 막거나,
     - 경고 메시지를 보여준다.
   - `Policy` 정보 업데이트(마감일 변경) 시, 새롭게 리마인더를 설정해야 한다는 안내 가능(선택).

6. **다국어/텍스트 메시지** (간단)
   - 알림 제목/내용은 간단한 템플릿으로 처리 (예: `[청년정책] D-3: ○○○ 지원사업 신청 마감 예정`)

---

### 2.2 비기능 요구사항 (Non-Functional)

1. **신뢰성**
   - 앱을 재실행해도 알림 예약 상태가 유지되어야 하며,
   - 디바이스 재부팅 시에도 OS 수준에서 예약 알림을 유지/복구(패키지 기능 사용)할 수 있어야 한다.

2. **확장성**
   - 나중에 서버 푸시로 확장될 여지를 남겨두기 위해,
     알림 발송은 `NotificationGateway` 인터페이스로 추상화한다.

3. **성능**
   - 리마인더 목록을 조회/저장할 때 UI가 크게 느려지지 않아야 한다.
   - 로컬 DB(예: Isar) 사용 시, 배치 조회 기준으로 설계.

4. **일관성**
   - Domain/Repository/Controller/Presentation 레이어 분리 규칙(job01~job06)과 동일한 방식 유지.

---

## 3. 아키텍처 설계 (Architecture Design)

### 3.1 레이어 개요

- **Domain Layer**
  - `PolicyReminder` 엔티티
  - `ReminderType` enum (D-7 / D-3 / D-1 / custom 등)
  - `ReminderStatus` enum (scheduled / fired / canceled)
  - `ReminderRepository` 인터페이스

- **Data Layer**
  - `ReminderLocalSource` (Isar/SharedPreferences/SQLite 등의 구현)
  - `ReminderRepositoryImpl` (Domain 인터페이스 구현)
  - `NotificationGateway` (실제 로컬 알림 패키지 호출)

- **Application Layer**
  - `ReminderController` (리마인더 생성/수정/삭제/목록 조회)
  - `ReminderScheduler` (현재 시간 + 정책 마감일 + 타입 → 실제 알림 시각 계산 + 스케줄)
  - EventBus 연동 (PolicyEventType.reminderCreated / reminderCanceled 등)

- **Presentation Layer**
  - 정책 상세 화면: “알림 설정” BottomSheet
  - 알림 목록 화면: `ReminderListScreen`
  - 간단한 토글/삭제 UI

---

## 4. 데이터 파이프라인 / 흐름도 (Data Pipeline & Flow)

### 4.1 리마인더 생성 플로우

1. 사용자가 정책 상세 화면에서 “신청 알림 설정” 버튼 클릭  
2. “알림 설정 BottomSheet”에서:
   - D-7 / D-3 / D-1 / 당일 / 사용자 지정 옵션 선택
3. UI → `ReminderController.createReminders(policy, types[])` 호출
4. `ReminderController`는:
   - 각 `ReminderType`에 대해 `ReminderScheduler`를 호출:
     - 정책 마감일/시작일 + 타입 → `DateTime remindAt`
   - `ReminderRepository.create(...)`로 `PolicyReminder` 저장
   - `NotificationGateway.schedule(reminderId, remindAt, title, body, payload)` 호출
   - EventBus에 `PolicyEventType.reminderCreated` 이벤트 발행

### 4.2 알림 발동 플로우

1. OS/패키지에서 예약된 시각에 로컬 알림 발송
2. 사용자가 알림을 탭
3. 앱 런처 → payload의 `policyId`/`reminderId`로 정책 상세 화면 오픈
4. (선택) `ReminderController.markAsFired(reminderId)` 호출 → 상태 갱신

### 4.3 리마인더 취소/삭제 플로우

1. 알림 목록 화면에서 특정 리마인더 항목의 “삭제/비활성화” 버튼 클릭
2. UI → `ReminderController.cancelReminder(reminderId)` 호출
3. `ReminderController`:
   - `NotificationGateway.cancel(reminderId)` 호출
   - `ReminderRepository.markAsCanceled(reminderId)` 또는 삭제
   - EventBus에 `PolicyEventType.reminderCanceled` 발행

---

## 5. Provider / Controller 상호작용 규칙

### 5.1 Provider 정의

- `reminderRepositoryProvider` → `ReminderRepository`
- `reminderControllerProvider` → `ReminderController`
- `reminderListProvider` → `AsyncValue<List<PolicyReminder>>` (다가오는 알림 목록)
- `notificationGatewayProvider` → `NotificationGateway`

### 5.2 상호작용 규칙

1. **UI → Controller**
   - “알림 설정” UI는 오직 `ReminderController` 메서드만 호출한다.
     - createReminders
     - cancelReminder
     - cancelAllForPolicy
   - Repository/LocalSource/NotificationGateway에는 직접 접근하지 않는다.

2. **Controller → Repository/Gateway**
   - `ReminderController`는 리마인더 생성/수정/삭제/조회 로직을 담당한다.
   - 실제 데이터 저장/불러오기는 `ReminderRepository`에 위임.
   - 알림 스케줄링/취소는 `NotificationGateway`에 위임.

3. **EventBus**
   - 리마인더 생성/삭제 시 EventBus에 이벤트를 발행하고,
   - 알림 목록 화면이 이 이벤트를 구독하여 자동으로 목록을 갱신할 수 있다.

---

## 6. UI 상태도 (UI State Diagram - 요약)

### 6.1 정책 상세 화면 (PolicyDetailBottomSheet 확장)

- 상태:
  - `hasActiveReminder` (해당 정책에 대해 활성 리마인더가 하나 이상 존재)
  - `remindersForPolicy` (리마인더 리스트; 필요시 요약)

- 버튼:
  - “신청 알림 설정” (리마인더 없음 또는 추가 설정)
  - “알림 관리” (이미 설정된 경우 → 관리 시트/화면으로 이동)

---

### 6.2 알림 목록 화면 (ReminderListScreen)

- 상태:
  - `AsyncValue<List<PolicyReminder>>`
  - `isEmpty` / `isLoading` / `hasError` 분기

- UI:
  - 각 항목에:
    - 정책 제목
    - 알림 시각
    - 상태 (예정/완료/취소)
    - “삭제/끄기” 버튼

---

## 7. 이벤트 흐름 (Event Flow)

### 7.1 PolicyEvent 확장

`PolicyEventType`에 다음 타입을 추가:

- `reminderCreated`
- `reminderCanceled`
- (선택) `reminderFired`

각 이벤트는 payload로 `policyId` / `reminderId`를 포함한다.

### 7.2 Event 소비자

- ReminderListScreen
  - `reminderCreated` / `reminderCanceled` 수신 시 목록 재로딩
- PolicyDetailBottomSheet
  - `reminderCreated` / `reminderCanceled` 수신 시 `hasActiveReminder` UI 갱신

---

## 8. 파일 구조 (File Structure)

```txt
lib/features/policy_new/
  domain/
    entities/
      policy_reminder.dart           # PolicyReminder 엔티티
    values/
      reminder_type.dart             # D-7, D-3, D-1, custom 등
      reminder_status.dart           # scheduled, fired, canceled
    repositories/
      reminder_repository.dart       # 인터페이스

  data/
    sources/
      reminder_local_source.dart     # 로컬 DB/스토리지 접근
    repositories/
      reminder_repository_impl.dart  # Repository 구현
    notifications/
      notification_gateway.dart      # 추상화 인터페이스
      notification_gateway_impl.dart # 실제 flutter_local_notifications 사용 구현

  application/
    controllers/
      reminder_controller.dart       # 생성/수정/삭제/조회
      reminder_scheduler.dart        # Policy + ReminderType → DateTime 계산
    providers.dart                   # reminder 관련 provider 등록

  presentation/
    reminder/
      screens/
        reminder_list_screen.dart        # 알림 목록 화면
      widgets/
        reminder_list_item.dart          # 각 알림 행
        reminder_empty_view.dart         # 빈 상태
      sheets/
        reminder_setup_bottom_sheet.dart # 정책 상세에서 알림 옵션 선택 UI
        reminder_manage_sheet.dart       # 해당 정책의 리마인더 관리 UI


⸻

9. Acceptance Criteria
	1.	Domain
	•	PolicyReminder 엔티티가 정의되어 있으며, policyId, reminderId, remindAt, type, status, createdAt 등이 포함된다.
	•	ReminderType, ReminderStatus enum이 정의되어 있다.
	•	ReminderRepository 인터페이스에 create / listUpcoming / listByPolicy / cancel / cancelAllForPolicy / markAsFired 등의 메서드가 정의되어 있다.
	2.	Data
	•	ReminderLocalSource는 로컬 저장소(어떤 스토리지든) 기반 CRUD를 제공한다.
	•	ReminderRepositoryImpl은 ReminderRepository를 구현하고, LocalSource와 매핑한다.
	•	NotificationGateway 인터페이스가 존재하며, schedule/cancel/cancelAll 등의 메서드가 정의되어 있다.
	•	NotificationGatewayImpl은 실제 로컬 알림 패키지를 사용해 구현된다.
	3.	Application
	•	ReminderController가 리마인더 생성/삭제/목록 조회를 담당하며, UI는 이 컨트롤러만 호출해 리마인더를 조작한다.
	•	ReminderScheduler가 Policy + ReminderType을 입력받아 실제 알림 시각(DateTime)을 계산하는 로직을 구현한다.
	•	EventBus에 reminderCreated, reminderCanceled 이벤트 타입이 추가되고, 생성/삭제 시 적절히 발행된다.
	4.	Presentation
	•	정책 상세 화면(PolicyDetailBottomSheet)에 “신청 알림 설정” 버튼이 추가된다.
	•	“신청 알림 설정” 버튼 클릭 시 reminder_setup_bottom_sheet.dart가 표시되고, 사용자가 D-7/D-3/D-1/당일/직접입력 등의 옵션을 선택할 수 있다.
	•	알림 목록 화면(ReminderListScreen)에서 다가오는 알림들을 확인할 수 있고, 항목별 삭제/끄기 동작이 정상 작동한다.
	•	알림 삭제/끄기 시 해당 리마인더는 Repository에서 상태 변경(또는 삭제)되고, NotificationGateway를 통해 실제 알림 스케줄도 취소된다.
	5.	동작 및 일관성
	•	앱 재시작 후에도 리마인더 목록이 유지된다.
	•	알림을 탭하면 해당 정책 상세 화면으로 안전하게 이동한다(네비게이션 경로 정의 필요).
	•	기존 PolicyNew Domain/Repository/Controller/Presentation 구조에 타입/의존성 충돌 없이 빌드가 성공한다.
	•	서버 사이드 변경 없이 클라이언트만으로 동작 가능해야 한다.

⸻


---
좋아 지민님, 이번엔 진짜 “job01 스타일 그대로”로 제대로 한 번 박아볼게요 💙🩵
지금까지 안 다룬 것 중 **가장 실용적이고, 청년 정책 서비스스럽고, 지민님이 직접 쓰면 좋을 것 같은 기능** 하나 골라서 job11로 잡을게요.

👉 **job11 = “신청일자 알림 + 알림 센터 시스템”**
(정책 신청 마감일 기준 D-7 / D-3 / D-1 / 당일 알림 + 내 알림 모아보기)

---

# 🟦 #job11 — Policy Application Reminder & Notification Center

> **“신청일자 놓쳐서 뒤늦게 후회하는 경험을 없애는 시스템”**

이 문서는 **AGENTS.md에 그대로 붙여넣고 Codex에게 시킬 수 있는 설계서**예요.
job01 스타일 요구사항 전부 포함해서 정리할게요.

---

````md
@chatgpt-codex
# job11 — Policy Application Reminder & Notification Center
# (신청일자 알림 + 알림센터 + EventBus 연동)

---

## 1. 시스템 정의 (System Definition)

### 1.1 시스템 이름
- 이름: **Policy Application Reminder & Notification Center**
- 약칭: **PolicyReminderSystem**

### 1.2 담당 역할
- 각 정책의 **신청 마감일(applicationEndDate)** 을 기준으로:
  - 사용자가 원하는 시점(D-7, D-3, D-1, 당일 특정 시간)에 **로컬 알림**을 예약한다.
  - 이미 지난 정책/마감된 정책에 대한 알림은 자동으로 **무시 or 정리**한다.
- “내가 알림을 걸어둔 정책들”을 한 화면에서 모아볼 수 있는 **알림 센터 화면**을 제공한다.
- 전체 앱에서 알림 상태 변경(추가/삭제/만료)이 발생했을 때  
  다른 피드/화면(예: 상세 페이지, 즐겨찾기 탭)이 **일관된 상태**를 볼 수 있도록 EventBus로 통합한다.

### 1.3 경계 (Scope)
- job11은 **알림 예약/저장/표시/상태 관리**까지 담당하고,
- 실제 OS-level 푸시 구현(예: flutter_local_notifications)은
  - **NotificationGateway 인터페이스**로 추상화만 한다.
  - 실제 플러그인 연결/플랫폼 별 구현은 job12 이후의 책임으로 둔다.

---

## 2. 문제 정의 (Problem Definition)

### 2.1 현재 문제
- 사용자가 정책을 둘러보다가 “오 이거 나중에 신청해야지” 하고 넘어가면,  
  며칠 뒤에는 **마감일이 기억나지 않거나 이미 지남**.
- 앱 자체에는 “기억 장치”가 없어서,
  - 사용자가 직접 캘린더에 적거나,
  - 스크린샷만 남겨놓고,
  - 결국 마감일을 놓치게 된다.
- 정책 앱으로서 가장 중요한 경험 중 하나인  
  **“기회를 놓치지 않게 해주는 기능”** 이 부재한 상태.

### 2.2 해결하고 싶은 것
- 정책 상세에서 **1~2번 터치로 알림을 걸고**,  
  “내 알림” 화면에서 **한 번에 관리**할 수 있게 한다.
- 알림이 실제로 울릴 때, 사용자가:
  - “어떤 정책이 곧 마감인지” 바로 알 수 있고,
  - 바로 정책 상세/신청 페이지로 이동할 수 있게 만든다.

---

## 3. 요구사항 분석 (Requirements Analysis)

### 3.1 기능 요구사항 (Functional)

1. **알림 설정**
   - 정책 상세 화면에서 “알림 설정” 버튼을 통해 알림을 추가할 수 있다.
   - 제공 옵션 (기본값):
     - D-7, D-3, D-1, 당일(0일) + 특정 시간(기본 09:00)
   - 마감일이 없는 정책(applicationEndDate == null)은 알림을 설정할 수 없다 (비활성/경고).

2. **알림 관리**
   - 사용자 한 정책에 대해 **여러 개의 알림**을 둘 수 있다 (예: D-7, D-1).
   - 이미 지난 시점(현재 시각보다 과거인 알림)은 생성 시점에 자동으로 **무시 or 등록 불가**로 처리한다.
   - 사용자는 알림 센터에서 알림 개별 삭제, 정책 단위 전체 삭제가 가능하다.

3. **알림 센터 화면**
   - “내 알림” 탭 또는 화면에서:
     - 앞으로 울릴 예정인 알림 목록
     - 이미 지난 알림(옵션에 따라 숨김 or ‘지난 알림’ 섹션) 표시
   - 각 알림을 탭하면 해당 정책 상세(PolicyDetailBottomSheet)로 이동.

4. **알림 트리거**
   - 알림이 OS에서 울릴 때:
     - 알림 터치 → 앱 열기 → 해당 정책 상세로 이동 (policyId 기반 deep link / 라우팅).
   - 앱이 포그라운드 상태에서 알림 발생 시,  
     상단 토스트/스낵바 형태로도 표시 가능 (선택 항목, job11에서는 설계만).

5. **상태 연동**
   - 알림을 설정/삭제할 때:
     - PolicyDetail UI의 “알림 설정됨/해제됨” 상태가 즉시 반영.
     - 알림 센터 화면의 목록도 자동 업데이트.

### 3.2 비기능 요구사항 (Non-functional)

1. **안정성**
   - 앱 재시작 후에도 알림이 유지되어야 함 (로컬 저장 필수).
2. **성능**
   - 알림 개수가 많아져도(수십 개) Policy 리스트/피드 성능을 해치지 않도록 별도의 저장소/Provider에서 관리.
3. **플랫폼 독립성**
   - Notification 플러그인 flutter_local_notifications 등을 사용하되,
     코드 상에서는 **NotificationGateway** 인터페이스만 의존.

---

## 4. 아키텍처 설계 (Architecture Design)

### 4.1 주요 컴포넌트

- **Domain**
  - `PolicyReminder`
  - `ReminderTimeKind` (DAYS_BEFORE_DEADLINE, CUSTOM_DATETIME)
- **Repository**
  - `ReminderRepository` (Domain 인터페이스)
  - `ReminderRepositoryImpl` (로컬 저장소 구현, e.g. shared_preferences or Isar / 추상화)
- **Notification**
  - `NotificationGateway` (알림 예약/취소 인터페이스)
  - `LocalNotificationGateway` (실제 플러그인 사용 구현은 추후 job에서)
- **Application**
  - `ReminderController` (알림 추가/삭제/조회)
  - `NotificationCenterController` (알림 센터 화면용 상태)
- **Presentation**
  - Policy 상세 바텀시트에 “알림 설정” UI
  - 알림 센터 화면 (`PolicyReminderCenterScreen`)

### 4.2 레이어 간 의존성

- Presentation → Application(Controller) → Repository/NotificationGateway → Local storage + OS notification
- Domain 모델(`PolicyReminder`)은 어디서나 사용되지만, **Data 레이어의 저장 구조는 도메인에 노출하지 않는다.**

---

## 5. 데이터 파이프라인 / 흐름도 (Data Pipeline / Flow)

### 5.1 알림 설정 플로우

1. 사용자: 정책 상세 바텀시트에서 "알림 설정" 버튼 탭
2. UI: 옵션 BottomSheet 표시 (D-7 / D-3 / D-1 / 당일 / 사용자 지정)
3. 사용자: 옵션 선택 후 "저장"
4. UI → `ReminderController.addReminder(policy, option)` 호출
5. `ReminderController`:
   - 정책의 `applicationEndDate` 확인
   - 선택 옵션 → 실제 `scheduledAt: DateTime` 계산
   - `PolicyReminder` Domain 객체 생성
   - `ReminderRepository.save(reminder)` 호출
   - `NotificationGateway.scheduleNotification(reminder)` 호출
   - `PolicyEventBus`에 `reminderAdded` 이벤트 발행
6. UI:
   - 해당 상세 화면의 "알림 설정됨" 상태로 즉시 갱신
   - 알림 센터 화면에서는 EventBus 수신 후 목록 리로드

### 5.2 알림 삭제 플로우

1. 사용자: 알림 센터 화면에서 X 버튼 탭 or 상세 화면에서 "알림 해제"
2. UI → `ReminderController.removeReminder(reminderId)` 호출
3. `ReminderController`:
   - `ReminderRepository.delete(reminderId)`
   - `NotificationGateway.cancelNotification(reminderId)` 호출
   - `PolicyEventBus`에 `reminderRemoved` 이벤트 발행
4. UI:
   - 알림 센터 / 상세 화면 상태 즉시 반영

### 5.3 알림 트리거 플로우 (OS 알림 클릭)

1. OS: 예약된 시간에 로컬 알림 표시
2. 사용자가 알림을 탭
3. 앱 런처 → 초기 route 수신 → `NotificationGateway`의 클릭 payload(예: policyId, reminderId) 전달
4. 앱 라우터:
   - 해당 policyId로 Policy 상세 화면/바텀시트로 이동
5. `ReminderController`:
   - 필요 시 `ReminderRepository`에서 해당 알림 상태를 "triggered"로 변경 (선택 사항)

---

## 6. Provider / Controller 상호작용 규칙

### 6.1 Provider 목록

```dart
// Domain repository
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final storage = ref.read(localStorageProvider);
  final gateway = ref.read(notificationGatewayProvider);
  return ReminderRepositoryImpl(storage: storage, notificationGateway: gateway);
});

// Controllers
final reminderControllerProvider =
    StateNotifierProvider<ReminderController, ReminderState>(
  (ref) => ReminderController(
    repository: ref.read(reminderRepositoryProvider),
    eventBus: ref.read(policyEventBusProvider),
  ),
);

final notificationCenterControllerProvider =
    StateNotifierProvider<NotificationCenterController, NotificationCenterState>(
  (ref) => NotificationCenterController(
    repository: ref.read(reminderRepositoryProvider),
  ),
);
````

### 6.2 Controller 책임

* `ReminderController`

  * 알림 추가/삭제/업데이트 책임
  * EventBus에 reminder 관련 이벤트 송출
* `NotificationCenterController`

  * "내 알림" 화면에서 사용할 리스트/필터/정렬 책임
  * repository에서 현재/과거 알림 조회

---

## 7. UI 상태도 (UI State Model)

### 7.1 ReminderState

```dart
@immutable
class ReminderState {
  final bool isProcessing;               // 알림 추가/삭제 중 여부
  final List<PolicyReminder> reminders;  // 현재 정책에 설정된 알림 목록 (상세 화면용)
  final PolicyFailure? failure;          // 알림 저장/삭제 과정의 에러

  const ReminderState({
    required this.isProcessing,
    required this.reminders,
    required this.failure,
  });

  const ReminderState.initial()
      : isProcessing = false,
        reminders = const [],
        failure = null;
}
```

### 7.2 NotificationCenterState

```dart
@immutable
class NotificationCenterState {
  final bool isLoading;
  final List<PolicyReminder> upcoming;   // 앞으로 울릴 알림
  final List<PolicyReminder> past;       // 이미 지난 알림(선택 표시)
  final PolicyFailure? failure;

  const NotificationCenterState({
    required this.isLoading,
    required this.upcoming,
    required this.past,
    required this.failure,
  });

  const NotificationCenterState.initial()
      : isLoading = false,
        upcoming = const [],
        past = const [],
        failure = null;
}
```

---

## 8. 이벤트 흐름 (Event Flow)

### 8.1 EventBus 이벤트 타입 확장

`PolicyEventType`에 다음 항목 추가:

* `reminderAdded`
* `reminderRemoved`
* `reminderUpdated`

`PolicyEvent` payload 예시:

```dart
class PolicyEvent {
  final PolicyEventType type;
  final String? policyId;
  final String? reminderId;

  const PolicyEvent({
    required this.type,
    this.policyId,
    this.reminderId,
  });
}
```

### 8.2 구독 규칙

* 정책 상세 화면:

  * `reminderAdded` / `reminderRemoved` 이벤트 수신 시
    해당 policyId가 현재 상세 policyId와 같다면, ReminderState 리프레시.
* 알림 센터 화면:

  * `reminderAdded` / `reminderRemoved` / `reminderUpdated` 시 전체 리프레시.
* 다른 피드(추천/전체/즐겨찾기 등)는

  * 알림 여부 표시가 필요하다면, PolicyCard에서 ReminderController의 `reminders`를 참조 (선택).

---

## 9. 파일 구조 (File Structure)

```txt
lib/features/policy_new/
  domain/
    entities/
      policy_reminder.dart               # PolicyReminder 도메인 엔티티
    repositories/
      reminder_repository.dart           # ReminderRepository 인터페이스

  data/
    repositories/
      reminder_repository_impl.dart      # 로컬 저장소 + NotificationGateway 연동 구현
    sources/
      reminder_local_source.dart         # 실제 저장소(shared_prefs/Isar 등에 대한 추상화)

  application/
    controllers/
      reminder_controller.dart           # 알림 추가/삭제/조회
      notification_center_controller.dart# 알림 센터 상태
    filters/
      (기존 filter/search 관련 파일 그대로)

  infrastructure/
    notification/
      notification_gateway.dart          # schedule/cancel 인터페이스
      local_notification_gateway.dart    # 플러그인 래핑 구현 (stub 가능)

  presentation/
    screens/
      policy_reminder_center_screen.dart # "내 알림" 화면
    widgets/
      policy_reminder_badge.dart         # 카드/상세에서 '알림 O' 표시용 작은 UI
      policy_reminder_options_sheet.dart # D-7/D-3/D-1/당일 선택 바텀시트
```

---

## 10. Acceptance Criteria (수용 기준)

1. **Domain & Repository**

   * [ ] `PolicyReminder` 엔티티가 id, policyId, scheduledAt, createdAt, timeKind(D-7 등) 필드를 가진다.
   * [ ] `ReminderRepository` 인터페이스에 아래 메서드가 정의된다:

     * `Future<List<PolicyReminder>> getRemindersForPolicy(String policyId)`
     * `Future<List<PolicyReminder>> getAllReminders()`
     * `Future<void> saveReminder(PolicyReminder reminder)`
     * `Future<void> deleteReminder(String reminderId)`
   * [ ] `ReminderRepositoryImpl`이 위 메서드들을 로컬 저장소 + NotificationGateway 호출로 구현한다.

2. **Notification Gateway**

   * [ ] `NotificationGateway`에 최소 아래 메서드가 정의된다:

     * `Future<void> scheduleReminder(PolicyReminder reminder)`
     * `Future<void> cancelReminder(String reminderId)`
   * [ ] 구현체(LocalNotificationGateway)는 stub 형태라도 존재하며,
     실제 플러그인 호출은 job12에서 구현 가능하도록 구조만 갖춘다.

3. **Controllers**

   * [ ] `ReminderController`가 알림 추가/삭제 시:

     * Repository 호출
     * NotificationGateway 호출
     * EventBus에 `reminderAdded` / `reminderRemoved` 이벤트 발행
   * [ ] `NotificationCenterController`가 전체 알림을 불러와
     upcoming/past로 구분된 `NotificationCenterState`를 구성한다.

4. **UI**

   * [ ] Policy 상세 바텀시트에 "알림 설정" 버튼과 현재 알림 요약(예: “D-3, 당일 09:00 알림 설정됨”)이 표시된다.
   * [ ] "알림 설정" 버튼 탭 시, 옵션 선택 바텀시트가 표시되고, 선택 후 ReminderController를 통해 알림이 생성된다.
   * [ ] "내 알림" 화면에서 앞으로 울릴 알림 리스트가 표시되며, 각 항목을 탭하면 해당 정책 상세로 이동한다.
   * [ ] 알림 삭제 시 리스트에서 즉시 사라지고, 상세 화면 상태도 갱신된다.

5. **이벤트 & 일관성**

   * [ ] 알림 추가/삭제 후, 관련된 화면(상세/알림 센터)에서 상태가 즉시 갱신된다.
   * [ ] 앱 재시작 후에도 알림 목록이 유지된다.
   * [ ] 알림 예약 시간이 이미 과거인 경우, 생성 시점에 저장/예약되지 않고 사용자에게 적절히 처리된다(저장하지 않거나, 에러 메시지).

6. **빌드 안정성**

   * [ ] 위 작업 적용 후 전체 프로젝트가 빌드시 타입 에러/참조 에러 없이 통과한다.
   * [ ] job01~job10에서 정의된 구조와 충돌하는 import/네이밍 없이 작동한다.

---






#ISSUE 40
lib/application/policy/policy_prefetch_provider.dart:64:14: Error: The getter 'mounted' isn't defined for the class 'PolicyPrefetchNotifier'.
 - 'PolicyPrefetchNotifier' is from 'package:youth_road_app/application/policy/policy_prefetch_provider.dart' ('lib/application/policy/policy_prefetch_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'mounted'.
        if (!mounted) return;
             ^^^^^^^
lib/application/policy/policy_prefetch_provider.dart:68:14: Error: The getter 'mounted' isn't defined for the class 'PolicyPrefetchNotifier'.
 - 'PolicyPrefetchNotifier' is from 'package:youth_road_app/application/policy/policy_prefetch_provider.dart' ('lib/application/policy/policy_prefetch_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'mounted'.
        if (!mounted) return;
             ^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command '/home/ssm-user/flutter/bin/flutter'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 10s

---

#ISSUE 41
lib/application/policy/policy_prefetch_provider.dart:64:18: Error: The getter 'mounted' isn't defined for the class 'AutoDisposeAsyncNotifierProviderRef<void>'.
 - 'AutoDisposeAsyncNotifierProviderRef' is from 'package:riverpod/src/async_notifier.dart' ('../.pub-cache/hosted/pub.dev/riverpod-2.6.1/lib/src/async_notifier.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'mounted'.
        if (!ref.mounted) return;
                 ^^^^^^^
lib/application/policy/policy_prefetch_provider.dart:68:18: Error: The getter 'mounted' isn't defined for the class 'AutoDisposeAsyncNotifierProviderRef<void>'.
 - 'AutoDisposeAsyncNotifierProviderRef' is from 'package:riverpod/src/async_notifier.dart' ('../.pub-cache/hosted/pub.dev/riverpod-2.6.1/lib/src/async_notifier.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'mounted'.
        if (!ref.mounted) return;
                 ^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:

---

#ISSUE 42

lib/application/policy/policy_prefetch_provider.dart:53:18: Error: The getter 'mounted' isn't defined for the class 'AutoDisposeAsyncNotifierProviderRef<void>'.
 - 'AutoDisposeAsyncNotifierProviderRef' is from 'package:riverpod/src/async_notifier.dart' ('../.pub-cache/hosted/pub.dev/riverpod-2.6.1/lib/src/async_notifier.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'mounted'.
        if (!ref.mounted) return;
                 ^^^^^^^
lib/application/policy/policy_prefetch_provider.dart:57:18: Error: The getter 'mounted' isn't defined for the class 'AutoDisposeAsyncNotifierProviderRef<void>'.
 - 'AutoDisposeAsyncNotifierProviderRef' is from 'package:riverpod/src/async_notifier.dart' ('../.pub-cache/hosted/pub.dev/riverpod-2.6.1/lib/src/async_notifier.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'mounted'.
        if (!ref.mounted) return;
                 ^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command '/home/ssm-user/flutter/bin/flutter'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

# ISSUE 43


---

### 🧾 Codex 작업 설명문 (그대로 써도 되는 버전)

**Title**
`Refactor PolicyPrefetchNotifier: deduplicate provider & remove legacy mounted usage`

**Goal**

* `PolicyPrefetchNotifier` / `policyPrefetchProvider`를 **한 곳(appliction 레이어)에서만** 정의하도록 정리
* 예전에 `mounted`를 사용하던 **legacy 구현/파일을 모두 정리**
* 현재 사용 중인 prefetch 로직은 그대로 유지

---

### 1. `lib/application/policy/policy_prefetch_provider.dart`를 단일 소스로 유지

다음 구현을 기준으로 이 파일을 정리해줘
(동일/유사 import가 이미 있다면 중복 없이 정리해도 됨)

```dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/notifiers/policy_paging_notifier.dart';
import '../../../application/providers.dart'
    show policyPagingProvider, policyRepositoryInterfaceProvider;
import '../../../domain/repositories/policy_repository.dart';
import 'policy_list_provider.dart';

final policyPrefetchProvider =
    AsyncNotifierProvider<PolicyPrefetchNotifier, void>(
  PolicyPrefetchNotifier.new,
);

class PolicyPrefetchNotifier extends AsyncNotifier<void> {
  PolicyRepository get _repository =>
      ref.read(policyRepositoryInterfaceProvider);

  PolicyFeedsNotifier get _pagingNotifier =>
      ref.read(policyPagingProvider.notifier);

  PolicyListNotifier get _listNotifier => ref.read(policyListProvider.notifier);

  @override
  FutureOr<void> build() {
    // 초기 로직이 필요 없으면 비워둔다
  }

  Future<void> prefetchPolicies() async {
    // 이미 prefetch 중이면 중복 실행 방지
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    _listNotifier.setLoading();

    // 1) 캐시 우선 로드
    try {
      final cached = await _repository.loadCachedPolicies(
        filter: _pagingNotifier.currentFilter,
      );

      if (cached.isNotEmpty) {
        _pagingNotifier.seedFromCache(cached);
        _listNotifier.setPolicies(cached);
      } else {
        _listNotifier.clear();
      }
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] cache preload failed: $e\n$st');
      _listNotifier.setError(e, st);
    }

    // 2) 원격 최신 데이터로 갱신
    try {
      final remote = await _repository.refreshPolicies(
        filter: _pagingNotifier.currentFilter,
      );
      _pagingNotifier.replaceWithFresh(remote);
      _listNotifier.setPolicies(remote);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] remote prefetch failed: $e\n$st');
      _listNotifier.setError(e, st);
      state = AsyncValue.error(e, st);
    }
  }
}
```

* 위 로직이 **정확히 현재 사용하는 prefetch 로직**이므로
  이 파일 안에서 다른 오래된 구현(특히 `mounted` 사용)은 모두 삭제해줘
* `mounted`를 사용한 코드는 남기지 않는다

---

### 2. `lib/features/policy/providers/policy_prefetch_provider.dart` 정리

이 파일에 있는 **별도의 `PolicyPrefetchNotifier`/`policyPrefetchProvider` 구현은 모두 삭제**하고,
application 레이어의 구현만 내보내는 **얇은 export 파일**로 바꿔줘

```dart
export 'package:youth_road_app/application/policy/policy_prefetch_provider.dart';
```

> 패키지 이름 `youth_road_app`은 현재 프로젝트 구조를 기준으로 한 추정입니다 (추측입니다)
> 실제 pubspec의 name이 다르면 거기에 맞게 수정해줘

이렇게 하면:

* 기존에 `features/policy/providers/policy_prefetch_provider.dart`를 import하던 코드들은 그대로 유지 가능
* 실제 구현은 항상 `lib/application/policy/policy_prefetch_provider.dart` 한 곳만 사용

---

### 3. 레거시 `mounted` 및 중복 구현 전체 정리

1. `lib/features/policy/providers/policy_prefetch_provider.dart` 뿐 아니라
   레포 전체에서 **`PolicyPrefetchNotifier` 관련 `mounted` 사용을 모두 제거**해줘

   * 검색 키워드 예시:

     * `PolicyPrefetchNotifier`
     * `policyPrefetchProvider`
     * `mounted`

2. 최종적으로 레포 안에

   * `PolicyPrefetchNotifier` 정의는 **딱 한 군데** (`lib/application/policy/policy_prefetch_provider.dart`)만 남도록 정리

3. `policyPrefetchProvider` 또한 동일하게 한 군데만 남도록 정리

---

### 4. 검증 조건 (Acceptance Criteria)

* `flutter analyze` 시

  * `PolicyPrefetchNotifier` / `policyPrefetchProvider` 중복 정의 에러 없음
  * `'mounted' isn't defined for the class 'PolicyPrefetchNotifier'` 에러 완전 제거

* `flutter test` 전부 통과 (있는 경우)

* `flutter build` 또는 CI 빌드에서

  * `PolicyPrefetchNotifier` 관련 컴파일 에러 없음

* 검색 결과

  * `PolicyPrefetchNotifier` 정의는 `lib/application/policy/policy_prefetch_provider.dart`에만 존재
  * `policyPrefetchProvider` 정의도 동일
  * `PolicyPrefetchNotifier`와 관련된 어떤 파일에서도 `mounted`를 사용하지 않음

---


🟦 #job20 — 기존 정책 폴더 정리 + PolicyNew 전체 적용 리팩토링 아키텍처 (FULL SPEC)


@chatgpt-codex
# job20 — 기존 정책 기능 폴더 정리 + PolicyNew 전체 전환 리팩토링 아키텍처 (Full System Overhaul)

---

# 0. 시스템 정의 (System Definition)
본 job20은 YouthRoad-Gyeongbuk 프로젝트의 기존 정책 기능 전체를
**PolicyNew 아키텍처(job01~job19 기반)**로 전면 교체하기 위한 핵심 리팩토링 작업이다.

목표 시스템은 다음을 포함한다:

1) **정책 UI/Interaction 전체 구조를 PolicyNew로 통합**  
2) 기존 lib/**policy 관련 파일 전체를 정리/이관/폐기/마이그레이션  
3) Folder-level 정리 기준 확립  
4) 정책 도메인, 필터, 검색, 추천, 비교 기능을 모두 PolicyNew로 통합  
5) 기존 화면에서 호출되는 흐름을 PolicyNew로 넘기기 위한 안전한 브릿지 layer 구성  
6) 전체 Policy 기능의 Stable-Core Layer 구축  

---

# 1. 문제 정의 (Problem Definition)

기존 정책 기능은 아래 문제들을 포함한다:

- 파일/폴더 구조가 분산되어 유지보수가 어렵다.  
- V1/V2 정책 화면이 분리되어 있으며, UI/도메인/컨트롤러가 섞여 있고 중복 코드가 있다.  
- 필터/검색/정렬/추천/지역/비교/즐겨찾기 등이 서로 다른 구조를 사용한다.  
- 로딩/페이징/오류 처리가 화면마다 달라 통일성이 없다.  
- Domain/Data/Presentation 계층이 불명확하다.  
- SWR, Query 기반 fetch 구조가 적용되지 않아 속도 문제를 유발한다.  
- 리팩토링 없이 확장하기에는 너무 많은 충돌이 발생한다.  

job20은 이 문제들을 해결하고,  
**프로젝트의 정책 기능 전체를 단일 아키텍처로 통합하기 위한 정리 작업**이다.

---

# 2. 요구사항 분석 (Requirements)

## 기능 요구사항
- 기존 정책 화면을 PolicyNew UI로 대체
- 기존 코드 중 필요한 Domain/Data는 마이그레이션 후 제거
- V1, V2 파일 정리 (중복 제거)
- 정책 상세 뷰, 정책 리스트, 추천, 정렬, 검색, 비교 기능을 PolicyNew 기반으로 재정렬
- 전체 기능이 실제 앱 빌드에서 충돌 없이 동작해야 함

## 기술 요구사항
- 파일 정리 후 git clean 상태 유지
- 기존 경로에서 새 PolicyNew 구조로 안전하게 이관
- Provider, Route, Navigator 등이 모두 PolicyNew 기준으로 동작해야 함
- 파일 의존성 충돌 및 import 에러가 없을 것
- 기존 흐름에 영향을 주지 않도록 "PolicyLegacy" 보관 폴더로 안전하게 이동

---

# 3. 아키텍처 설계 (Architecture)

job20 후 정책 기능 전체는 아래 구조를 따른다:

lib/
└── features/
└── policy_new/
├── domain/           # job01job02 정의한 Domain
├── data/             # Repository + Sources (job03)
├── application/      # Controllers + QueryEngine (job04job06)
└── presentation/     # UI (job05~job19)
└── legacy/
└── policy/               # 기존 모든 정책 파일 임시 보관 위치 (삭제 전 확보)

아키텍처 계층:

- **Domain** → Policy 엔티티, 필터, 정렬, 페이징 등 핵심 개념  
- **Data** → Repository, RemoteSource, SWR  
- **Application** → FeedController, Query Orchestrator, EventBus  
- **Presentation** → Feed UI, DetailSheet, FilterBar, SortSheet, KeywordSheet  

---

# 4. 데이터 파이프라인 / 흐름도 (Data Flow Diagram)

[UI (PolicyFeedHomeScreen)]
│
▼
[PolicyFilterBar / Sheets]
│ (상태 변경)
▼
[policyFilterUiStateProvider] ←─────── user actions
│
▼
[BasePolicyFeedController] ←─────── EventBus
│
▼
[PolicyQueryOrchestrator]
│
▼
[PolicyQueryEngine]
│
▼
[PolicyRepository]
│
▼
[RemoteSource / Cache]
│
▼
[PolicyPagingState]
│
▼
[UI → 리스트 렌더링]

---

# 5. Provider / Controller 상호작용 규칙

1) UI는 오직 `policyFilterUiStateProvider` 조작  
2) FeedController는 필터 상태 변경을 자동 감지하여 `refresh()`  
3) QueryEngine은 feedType 기반 Query를 Orchestrator에 위임  
4) EventBus는 favoritesChanged / compareChanged / profileUpdated / cacheCleared 감지  
5) Detail 화면은 policyDetailProvider를 통해 데이터 개별 fetch  
6) UI는 Repository 또는 Domain에 직접 의존하지 않음  

---

# 6. UI 상태도 (UI State Machine)

FilterUiState
├─ region
├─ category
├─ sort
├─ keyword
├─ tags
├─ showOnlyOnline
└─ showOnlyOngoing

변경 이벤트 발생 →
FeedController.refresh() →
PolicyQuery 재조립 →
Repository fetch →
PolicyPagingState
├─ loading
├─ data (items + hasMore)
└─ error

---

# 7. 이벤트 흐름 (Event Flow)

### 사용자 액션  

검색 → setKeyword()
정렬 변경 → setSort()
지역 변경 → setRegion()
카테고리 변경 → setCategory()
추천 태그 선택 → setTags()
“모집중만 보기” → toggleOngoingOnly()

### 시스템 이벤트 (EventBus)

favoritesChanged → FavoriteFeed, RecommendFeed refresh
compareChanged → CompareFeed refresh
profileUpdated → RecommendFeed + RegionFeed refresh
cacheCleared → 모든 FeedController reset

---

# 8. 파일 구조 정리 (Legacy Cleanup + New Placement)

## 기존 정책 폴더 제거/이동 규칙

아래 경로의 기존 파일은 모두 삭제 또는 legacy 폴더로 이동한다:

lib/ui/screens/policy/**        → legacy/policy/ui/**
lib/data/policy/**             → legacy/policy/data/**
lib/presentation/policy/**     → legacy/policy/presentation/**
lib/application/policy/**      → legacy/policy/application/**

절대 PolicyNew 폴더와 혼합 금지.

## PolicyNew 전면 적용 후 구조

lib/features/policy_new/
domain/
data/
application/
presentation/
screens/
widgets/
filters/
detail/

---

# 9. Acceptance Criteria (job20)

- [ ] 기존 정책 관련 파일을 모두 `legacy/policy/**` 로 이동  
- [ ] PolicyNew 구조가 lib/features/policy_new 아래 완전하게 구성됨  
- [ ] PolicyFeedHomeScreen 라우팅이 PolicyNew 기준으로 연결됨  
- [ ] 기존 코드 참조(import) 중 policy 관련 경로가 남아있지 않음  
- [ ] PolicyNew UI가 앱 실행 시 정상적으로 표시됨  
- [ ] FeedController, QueryEngine, Orchestrator 동작 정상  
- [ ] EventBus와 FilterUiState 반응 정상  
- [ ] 실제 기기에서 스크롤/페이징/검색/정렬/필터/상세 화면 동작  
- [ ] 빌드 에러, 의존성 충돌 없음  

---

# 10. Codex 실행 명령 세트 (job20 수행용)

아래 순서대로 Codex에게 실행시키면 됨:

### ✔ 1단계 — 기존 파일 이동

@chatgpt-codex
job20-step1:
“lib/ui/screens/policy/”,
“lib/data/policy/”,
“lib/presentation/policy/”,
“lib/application/policy/”
→ 모두 lib/legacy/policy/ 아래로 이동”

### ✔ 2단계 — 빈 PolicyNew 폴더 초기 세팅

@chatgpt-codex
job20-step2:
“lib/features/policy_new/{domain,data,application,presentation}” 폴더 생성

### ✔ 3단계 — Domain/Data/Application/Presentation 파일 재구축

@chatgpt-codex
job20-step3:
job01~job19 내용 기반으로 PolicyNew 아키텍처 파일 전체 생성
(파일 이름, 경로 명시 필수)

### ✔ 4단계 — Routing 전환

@chatgpt-codex
job20-step4:
기존 정책 라우팅 → PolicyFeedHomeScreen(policy_new)로 변경

---

# ISSUE 44
lib/features/policy_new/application/providers.dart:134:39: Error: Type 'PolicyFeedType' not found.
PolicyQuery _initialQueryFor(Ref ref, PolicyFeedType type) {
                                      ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:71:43: Error: 'PolicyEvent' isn't a type.
    StateNotifierProvider<PolicyEventBus, PolicyEvent?>(
                                          ^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:182:70: Error: 'PolicyFeedType' isn't a type.
    StateNotifierProvider.family<PolicyQueryController, PolicyQuery, PolicyFeedType>(
                                                                     ^^^^^^^^^^^^^^
lib/features/policy_new/presentation/screens/policy_feed_home_screen.dart:57:46: Error: The getter 'label' isn't defined for the class '(String, PolicyFeedType)'.
 - 'PolicyFeedType' is from 'package:youth_road_app/features/policy_new/domain/values/policy_feed_type.dart' ('lib/features/policy_new/domain/values/policy_feed_type.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'label'.
          tabs: _tabs.map((e) => Tab(text: e.label)).toList(),
                                             ^^^^^
lib/features/policy_new/presentation/screens/policy_feed_home_screen.dart:64:35: Error: The getter 'type' isn't defined for the class '(String, PolicyFeedType)'.
 - 'PolicyFeedType' is from 'package:youth_road_app/features/policy_new/domain/values/policy_feed_type.dart' ('lib/features/policy_new/domain/values/policy_feed_type.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
          final isSearchTab = tab.type == PolicyFeedType.search;
                                  ^^^^
lib/features/policy_new/presentation/screens/policy_feed_home_screen.dart:66:27: Error: The getter 'type' isn't defined for the class '(String, PolicyFeedType)'.
 - 'PolicyFeedType' is from 'package:youth_road_app/features/policy_new/domain/values/policy_feed_type.dart' ('lib/features/policy_new/domain/values/policy_feed_type.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
            feedType: tab.type,
                          ^^^^
lib/features/policy_new/presentation/screens/policy_feed_home_screen.dart:80:53: Error: The getter 'type' isn't defined for the class '(String, PolicyFeedType)'.
 - 'PolicyFeedType' is from 'package:youth_road_app/features/policy_new/domain/values/policy_feed_type.dart' ('lib/features/policy_new/domain/values/policy_feed_type.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
    final currentType = _tabs[_tabController.index].type;
                                                    ^^^^
lib/legacy/policy/ui/screens/policy/policy_detail_v2_screen.dart:44:20: Error: The getter 'PolicyDetailNotifier' isn't defined forthe class '_PolicyDetailV2ScreenState'.
 - '_PolicyDetailV2ScreenState' is from 'package:youth_road_app/legacy/policy/ui/screens/policy/policy_detail_v2_screen.dart' ('lib/legacy/policy/ui/screens/policy/policy_detail_v2_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'PolicyDetailNotifier'.
          message: PolicyDetailNotifier.errorMessage,
                   ^^^^^^^^^^^^^^^^^^^^
lib/legacy/policy/ui/screens/policy/policy_detail_v2_screen.dart:50:20: Error: The getter 'PolicyDetailNotifier' isn't defined forthe class '_PolicyDetailV2ScreenState'.
 - '_PolicyDetailV2ScreenState' is from 'package:youth_road_app/legacy/policy/ui/screens/policy/policy_detail_v2_screen.dart' ('lib/legacy/policy/ui/screens/policy/policy_detail_v2_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'PolicyDetailNotifier'.
          message: PolicyDetailNotifier.errorMessage,
                   ^^^^^^^^^^^^^^^^^^^^
lib/features/policy_new/application/controllers/base_feed_controller.dart:49:12: Error: The method 'fold' isn't defined for the class 'PolicyResult<List<Policy>>'.
 - 'PolicyResult' is from 'package:youth_road_app/features/policy_new/domain/values/policy_result.dart' ('lib/features/policy_new/domain/values/policy_result.dart').
 - 'List' is from 'dart:core'.
 - 'Policy' is from 'package:youth_road_app/features/policy_new/domain/entities/policy.dart' ('lib/features/policy_new/domain/entities/policy.dart').
Try correcting the name to the name of an existing method, or defining a method named 'fold'.
    result.fold(
           ^^^^
lib/features/policy_new/application/controllers/base_feed_controller.dart:71:12: Error: The method 'fold' isn't defined for the class 'PolicyResult<List<Policy>>'.
 - 'PolicyResult' is from 'package:youth_road_app/features/policy_new/domain/values/policy_result.dart' ('lib/features/policy_new/domain/values/policy_result.dart').
 - 'List' is from 'dart:core'.
 - 'Policy' is from 'package:youth_road_app/features/policy_new/domain/entities/policy.dart' ('lib/features/policy_new/domain/entities/policy.dart').
Try correcting the name to the name of an existing method, or defining a method named 'fold'.
    result.fold(
           ^^^^
lib/features/policy_new/application/controllers/base_feed_controller.dart:75:18: Error: The argument type 'List<dynamic>' can't beassigned to the parameter type 'List<Policy>'.
 - 'List' is from 'dart:core'.
 - 'Policy' is from 'package:youth_road_app/features/policy_new/domain/entities/policy.dart' ('lib/features/policy_new/domain/entities/policy.dart').
          items: merged,
                 ^
lib/features/policy_new/application/providers.dart:134:39: Error: 'PolicyFeedType' isn't a type.
PolicyQuery _initialQueryFor(Ref ref, PolicyFeedType type) {
                                      ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:137:10: Error: Undefined name 'PolicyFeedType'.
    case PolicyFeedType.recommend:
         ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:143:10: Error: Undefined name 'PolicyFeedType'.
    case PolicyFeedType.all:
         ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:149:10: Error: Undefined name 'PolicyFeedType'.
    case PolicyFeedType.region:
         ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:156:10: Error: Undefined name 'PolicyFeedType'.
    case PolicyFeedType.search:
         ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:158:19: Error: Undefined name 'PolicyFeedType'.
        feedType: PolicyFeedType.search,
                  ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:162:10: Error: Undefined name 'PolicyFeedType'.
    case PolicyFeedType.favorite:
         ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:170:10: Error: Undefined name 'PolicyFeedType'.
    case PolicyFeedType.compare:
         ^^^^^^^^^^^^^^
lib/features/policy_new/application/providers.dart:134:13: Error: A non-null value must be returned since the return type 'PolicyQuery' doesn't allow null.
 - 'PolicyQuery' is from 'package:youth_road_app/features/policy_new/domain/values/policy_query.dart' ('lib/features/policy_new/domain/values/policy_query.dart').
PolicyQuery _initialQueryFor(Ref ref, PolicyFeedType type) {
            ^
lib/features/policy_new/application/controllers/policy_detail_controller.dart:22:12: Error: The method 'fold' isn't defined for the class 'PolicyResult<Policy>'.
 - 'PolicyResult' is from 'package:youth_road_app/features/policy_new/domain/values/policy_result.dart' ('lib/features/policy_new/domain/values/policy_result.dart').
 - 'Policy' is from 'package:youth_road_app/features/policy_new/domain/entities/policy.dart' ('lib/features/policy_new/domain/entities/policy.dart').
Try correcting the name to the name of an existing method, or defining a method named 'fold'.
    result.fold(
           ^^^^
lib/features/policy_new/application/controllers/policy_feed_controllers.dart:15:17: Error: The getter 'type' isn't defined for theclass 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
      if (next?.type == PolicyEventType.refreshRequested) {
                ^^^^
lib/features/policy_new/application/controllers/policy_feed_controllers.dart:73:17: Error: The getter 'type' isn't defined for theclass 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
      if (next?.type == PolicyEventType.favoritesChanged) {
                ^^^^
lib/features/policy_new/application/controllers/policy_feed_controllers.dart:92:17: Error: The getter 'type' isn't defined for theclass 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
      if (next?.type == PolicyEventType.refreshRequested) {
                ^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command '/home/ssm-user/flutter/bin/flutter'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

