TASK27 – Explore 탭 필터/정렬 통합 (진행중만, 분야, 지원형태 등 + 모드 연동)

[전제]
- TASK 511~515, TASK25, TASK26 까지 적용된 상태라고 가정한다.
  - 상단 메인 탭: "추천 / 탐색 / 보관함"
  - 탐색(Explore) 탭: ExploreScreen
  - ExploreScreen:
    - ExploreSubMode { all, region, search } 사용
    - ExploreViewState 에 mode / selectedRegionName / selectedRegionCode / useMyRegionAsDefault / keyword 등이 있다.
    - [전체] [내 지역] [다른 지역 선택] 칩으로 모드/지역 전환 가능.
    - search 모드에서는 keyword 기반 검색이 실제로 동작(검색 Provider/Repository 연결 완료).
  - 현재 필터(진행중만, 분야, 지원형태, 기관, 정렬 등)는
    - 레거시 구조로 일부 흩어져 있거나,
    - ExploreScreen 에서 아직 일관되게 쓰이지 않고 있을 수 있다.

[목표]
- ExploreScreen 에서 사용하는 **필터/정렬 상태를 단일 모델로 통합**하고,
  ExploreSubMode(all/region/search)와 함께 일관되게 Query 에 반영한다.
  - 공통 필터 예:
    - 진행 상태: 진행중만 / 마감포함 / 마감만
    - 분야(카테고리): 취업, 창업, 주거, 생활안정, 교육 등
    - 지원 형태: 자금지원, 교육, 공간지원, 컨설팅 등
    - 정렬: 추천순 / 최신 등록순 / 마감 임박순 / 지원금 순 등
- UI 상단의 필터 칩/정렬 드롭다운 등이
  - 어떤 모드(all/region/search)에서도 동일한 구조로 동작하고,
  - Query → Provider → 리스트까지 한 흐름으로 연결되도록 정리한다.

────────────────────────────────────
[1. Scope (수정/추가 범위)]
────────────────────────────────────
1) Explore 상태/Provider 관련
   - 예:
     - lib/features/policy_new/application/explore/explore_state.dart
     - lib/features/policy_new/application/explore/explore_providers.dart
   - ExploreViewState 에 필터/정렬 정보를 추가하고,
     Query 모델(PolicyFeedQuery 등)에 이 정보를 포함시키는 작업.

2) ExploreScreen
   - 파일:
     - lib/features/policy_new/presentation/explore/policy_explore_screen.dart
   - 상단 필터 칩/정렬 UI를 ExploreViewState 기반으로 재정리.
   - onTap/onSelected 에서 ExploreViewState 를 변경하고,
     그에 따라 Provider/리스트가 다시 로딩되도록 한다.

3) (선택) 기존 필터/정렬 관련 상수/모델 정리
   - 예:
     - lib/features/policy_new/domain/values/policy_category.dart
     - lib/features/policy_new/domain/values/policy_sort_kind.dart
     - 기존에 흩어져 있는 필터 enum/상수를 재사용 또는 합치는 작업.

────────────────────────────────────
[2. 필터/정렬 상태 모델 정의]
────────────────────────────────────
1) 필터/정렬용 enum/모델 설계

   - 진행 상태:

     enum PolicyStatusFilter {
       inProgressOnly, // 진행중만
       includeClosed,  // 마감 포함
       closedOnly,     // 마감만
     }

   - 정렬:

     enum PolicySortKind {
       recommended, // 추천순 (기본값)
       newest,      // 최신 등록순
       deadline,    // 마감 임박순
       amount,      // 지원금/혜택 큰 순 (지원하는 경우)
     }

   - 분야/카테고리:
     - 이미 유사한 enum/상수가 있다면 재사용:
       - 예: PolicyCategory.youth, PolicyCategory.job, PolicyCategory.housing ...
     - 없다면 최소한 String 태그 리스트로 구성:
       - List<String> selectedCategories;

   - 지원 형태/기관 등은 필요 수준에 맞게:
     - 지원 형태: List<String> selectedSupportTypes;
     - 기관: String? selectedInstitution;

2) ExploreViewState 확장

   - 예시:

     class ExploreViewState {
       final ExploreSubMode mode;
       final String? selectedRegionName;
       final String? selectedRegionCode;
       final bool useMyRegionAsDefault;

       final String keyword;

       final PolicyStatusFilter statusFilter;
       final PolicySortKind sortKind;
       final List<String> selectedCategories;
       final List<String> selectedSupportTypes;
       // 필요하면 selectedInstitution 등 추가

       const ExploreViewState({
         required this.mode,
         this.selectedRegionName,
         this.selectedRegionCode,
         this.useMyRegionAsDefault = false,
         this.keyword = '',
         this.statusFilter = PolicyStatusFilter.inProgressOnly,
         this.sortKind = PolicySortKind.recommended,
         this.selectedCategories = const [],
         this.selectedSupportTypes = const [],
       });

       ExploreViewState copyWith({
         ExploreSubMode? mode,
         String? selectedRegionName,
         String? selectedRegionCode,
         bool? useMyRegionAsDefault,
         String? keyword,
         PolicyStatusFilter? statusFilter,
         PolicySortKind? sortKind,
         List<String>? selectedCategories,
         List<String>? selectedSupportTypes,
       }) {
         return ExploreViewState(
           mode: mode ?? this.mode,
           selectedRegionName: selectedRegionName ?? this.selectedRegionName,
           selectedRegionCode: selectedRegionCode ?? this.selectedRegionCode,
           useMyRegionAsDefault: useMyRegionAsDefault ?? this.useMyRegionAsDefault,
           keyword: keyword ?? this.keyword,
           statusFilter: statusFilter ?? this.statusFilter,
           sortKind: sortKind ?? this.sortKind,
           selectedCategories: selectedCategories ?? this.selectedCategories,
           selectedSupportTypes: selectedSupportTypes ?? this.selectedSupportTypes,
         );
       }
     }

3) StateNotifier 메서드

   - ExploreViewStateNotifier 에 다음 메서드 추가:

     void setStatusFilter(PolicyStatusFilter filter) { ... }
     void setSortKind(PolicySortKind sortKind) { ... }
     void toggleCategory(String category) { ... }
     void clearCategories() { ... }
     void toggleSupportType(String type) { ... }
     void clearSupportTypes() { ... }

   - 각 메서드는 copyWith 으로 상태를 갱신하고,
     Provider 가 다시 빌드되도록 한다.

────────────────────────────────────
[3. Query 모델에 필터/정렬 반영]
────────────────────────────────────
1) PolicyFeedQuery (또는 동등한 쿼리 모델)에 필터 필드 추가:

   class PolicyFeedQuery {
     final String? regionCode;
     final String? keyword;
     final PolicyStatusFilter statusFilter;
     final PolicySortKind sortKind;
     final List<String> categories;
     final List<String> supportTypes;
     // ... page, size 등 기존 필드

     const PolicyFeedQuery({
       this.regionCode,
       this.keyword,
       this.statusFilter = PolicyStatusFilter.inProgressOnly,
       this.sortKind = PolicySortKind.recommended,
       this.categories = const [],
       this.supportTypes = const [],
       // ...
     });
   }

2) ExploreScreen 에서 Provider 호출부 수정

   - ALL/REGION/SEARCH 각 모드에 대해,
     ExploreViewState 를 기반으로 PolicyFeedQuery 를 생성:

     PolicyFeedQuery _buildQuery(ExploreViewState state) {
       return PolicyFeedQuery(
         regionCode: state.mode == ExploreSubMode.all
             ? null
             : state.selectedRegionCode,
         keyword: state.mode == ExploreSubMode.search
             ? (state.keyword.isEmpty ? null : state.keyword)
             : null,
         statusFilter: state.statusFilter,
         sortKind: state.sortKind,
         categories: state.selectedCategories,
         supportTypes: state.selectedSupportTypes,
       );
     }

   - 모드 분기 로직에서:

     final state = ref.watch(exploreViewStateProvider);
     final query = _buildQuery(state);

     switch (state.mode) {
       case ExploreSubMode.all:
       case ExploreSubMode.region:
         final asyncPolicies = ref.watch(exploreListFeedProvider(query));
         ...
       case ExploreSubMode.search:
         final asyncPolicies = ref.watch(exploreSearchFeedProvider(query));
         ...
     }

   - 여기서 exploreListFeedProvider / exploreSearchFeedProvider 구현은
     프로젝트 상황에 맞게 연결.

3) Repository 레벨에서 필터/정렬 적용

   - 정책 Repository 메서드에 필터 파라미터 반영:

     Future<List<Policy>> getPolicies(PolicyFeedQuery query) {
       return api.fetchPolicies(
         regionCode: query.regionCode,
         keyword: query.keyword,
         status: mapStatusFilter(query.statusFilter),
         sort: mapSortKind(query.sortKind),
         categories: query.categories,
         supportTypes: query.supportTypes,
         // ...
       );
     }

   - mapStatusFilter / mapSortKind 등은 API 스펙에 맞게 변환.

────────────────────────────────────
[4. ExploreScreen – 필터/정렬 UI 구현]
────────────────────────────────────
1) 진행 상태 필터 칩

   - 예: [진행중만] [마감 포함] [마감만]

     Wrap(
       spacing: 8,
       children: [
         ChoiceChip(
           label: const Text('진행중만'),
           selected: state.statusFilter == PolicyStatusFilter.inProgressOnly,
           onSelected: (_) => notifier.setStatusFilter(PolicyStatusFilter.inProgressOnly),
         ),
         ChoiceChip(
           label: const Text('마감 포함'),
           selected: state.statusFilter == PolicyStatusFilter.includeClosed,
           onSelected: (_) => notifier.setStatusFilter(PolicyStatusFilter.includeClosed),
         ),
         ChoiceChip(
           label: const Text('마감만'),
           selected: state.statusFilter == PolicyStatusFilter.closedOnly,
           onSelected: (_) => notifier.setStatusFilter(PolicyStatusFilter.closedOnly),
         ),
       ],
     )

2) 정렬 드롭다운/팝업

   - 예: 우측 상단에 작은 정렬 버튼:

     PopupMenuButton<PolicySortKind>(
       icon: const Icon(Icons.sort),
       onSelected: notifier.setSortKind,
       itemBuilder: (context) => [
         const PopupMenuItem(
           value: PolicySortKind.recommended,
           child: Text('추천순'),
         ),
         const PopupMenuItem(
           value: PolicySortKind.newest,
           child: Text('최신 등록순'),
         ),
         const PopupMenuItem(
           value: PolicySortKind.deadline,
           child: Text('마감 임박순'),
         ),
         const PopupMenuItem(
           value: PolicySortKind.amount,
           child: Text('지원금 많은순'),
         ),
       ],
     )

3) 분야/지원 형태 필터 칩

   - 예시:

     Wrap(
       spacing: 8,
       children: categories.map((c) {
         final selected = state.selectedCategories.contains(c.id);
         return FilterChip(
           label: Text(c.label),
           selected: selected,
           onSelected: (_) => notifier.toggleCategory(c.id),
         );
       }).toList(),
     )

   - categories 리스트는:
     - 상수에서 가져오거나
     - 서버에서 내려받는 태그를 기반으로 해도 된다.

4) 모드와의 연동

   - ALL/REGION/SEARCH 모든 모드에서 같은 필터/정렬 UI 를 사용한다.
   - 사용자가 필터를 누르면:
     - ExploreViewState 의 필터 값이 바뀌고,
     - 쿼리가 재생성되어 Provider 가 다시 로딩된다.
   - 모드가 바뀌어도 필터 상태는 유지되게 한다:
     - 예: "진행중만 + 창업" 필터를 켜고 있다가
       - 전체 → 내 지역 → 검색으로 바꾸더라도
       - 필터는 그대로 적용된 검색/리스트로 보여준다.

────────────────────────────────────
[5. 상태 텍스트/요약 바에 필터 반영 (선택)]
────────────────────────────────────
1) 상단 상태 텍스트에 필터 요약을 약간 포함:

   - 예:
     - "경상북도 전체 정책 · 진행중만 · 창업, 주거"
     - "\"창업\" 검색 결과 · 구미시 · 진행중만"

2) 필터가 많아질 경우:
   - 상단에 "필터 X개 적용됨" 같은 간단한 요약만 보여주고,
   - 상세 필터는 바텀 시트에서 관리하는 방식도 고려할 수 있다.
   - 이 부분은 최소한의 텍스트만 넣고, 디자인은 추후 TASK 로 남겨도 된다.

────────────────────────────────────
[6. Acceptance Criteria]
────────────────────────────────────
1) 빌드/런타임
   - flutter analyze / flutter build 기준 컴파일 에러 없음.
   - Explore 탭에서 모드/필터/검색/지역 전환을 반복해도 런타임 에러 없음.

2) 필터 동작
   - "진행중만 / 마감 포함 / 마감만" 칩 전환 시:
     - 리스트가 즉시 다시 로딩되고,
     - API/쿼리에도 해당 statusFilter 가 반영된다.
   - 분야/지원 형태 칩 on/off 시:
     - 해당 카테고리/유형에 맞는 정책만 리스트에 노출되는 것이 확인 가능해야 한다
       (백엔드/데이터 스펙이 허용하는 범위 내에서).

3) 정렬 동작
   - 정렬 메뉴에서 "최신 등록순"을 선택하면:
     - 리스트 아이템들의 정렬 순서가 달라지는 것이 확인 가능해야 한다.
   - "마감 임박순" 등도 API/정렬 스펙에 맞게 동작.

4) 모드 간 일관성
   - ALL / REGION / SEARCH 모드 모두에서:
     - 같은 필터/정렬 UI 가 표시되고,
     - 같은 ExploreViewState 필터 상태를 공유한다.
   - 모드 전환 시 필터 상태는 유지되며,
     - 단지 regionCode/keyword 에 따라 다른 쿼리를 호출하는 수준으로만 달라진다.

5) UX
   - 필터/정렬을 여러 개 켰을 때도 UI 가 깨지지 않고
     - 넘치는 경우 스크롤 가능하거나,
     - Wrap 으로 다음 줄로 자연스럽게 내려간다.
   - "필터 초기화" 수준의 버튼이 있다면,
     - 클릭 시 ExploreViewState 의 필터 관련 필드가 초기값으로 되돌아가고
       리스트도 초기 상태로 돌아간다.

────────────────────────────────────
[7. 제약사항]
────────────────────────────────────
- 이 TASK에서는:
  - 정책 상세 화면, 보관함 탭, 카카오맵 화면의 로직은 변경하지 않는다.
  - 백엔드 API 스펙 변경이 필요한 경우:
    - 실제 요청 로직 변경은 최소화하고,
    - 필요한 경우 TODO(TASK28) 형태로 후속 작업을 명시한다.
- 오직:
  - Explore 탭에서 사용하는 필터/정렬 상태를 단일 모델로 정리하고,
  - ALL/REGION/SEARCH 모드에서 공통적으로 이 모델을 사용하도록 만드는 것
  에만 집중한다.
