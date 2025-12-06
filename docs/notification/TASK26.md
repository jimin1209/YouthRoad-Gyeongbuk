TASK26 – Explore 탭 검색 모드 실제 동작 구현 (검색어 기반 정책 검색)

[전제]
- TASK 511~515, TASK25 까지 적용된 상태라고 가정한다.
  - 상단 메인 탭: "추천 / 탐색 / 보관함"
  - 탐색(Explore) 탭: ExploreScreen
  - ExploreScreen:
    - ExploreSubMode { all, region, search } 사용
    - ExploreViewState 에 mode / selectedRegionName / selectedRegionCode / keyword 등이 존재
    - 상단에 [전체] [내 지역] [다른 지역 선택] 칩 + 검색 바 + 상태 텍스트가 모드 기반으로 표시
  - TASK25 에서 ExploreSubMode.region 일 때 "내 지역 / 다른 지역 선택"에 따른 지역 필터가
    (최소한 쿼리/Provider 단계까지) 반영되어 있다.
- 현재 ExploreSubMode.search 모드에서는
  - 검색 바/키보드 입력은 UI만 있고,
  - 실제 검색 쿼리/Provider 연결 및 검색 결과 리스트 동작은 구현되지 않은 상태이다.

[목표]
- ExploreSubMode.search 모드에서 **검색어 기반 정책 검색**이 실제로 동작하도록 구현한다.
  - 검색 바에 문자열을 입력하면, 검색 전용 Provider/쿼리가 호출되어 검색 결과 정책 리스트를 보여준다.
  - 검색어가 없으면 검색 모드라도 결과가 비거나, "검색어를 입력해 주세요" 메시지가 뜨도록 처리.
- 검색 모드 전환, 검색어 초기화, 다른 모드(전체/지역)로 전환 시
  예외 없이 안정적으로 동작하도록 만든다.

────────────────────────────────────
[1. Scope (수정/추가 범위)]
────────────────────────────────────
1) Explore 상태/Provider 관련 파일
   - 예:
     - lib/features/policy_new/application/explore/explore_state.dart
     - lib/features/policy_new/application/explore/explore_providers.dart
   - ExploreViewState 에 검색어(keyword) 필드/메서드를 명확히 정의하고,
     검색 쿼리 모델(PolicyFeedQuery 등)에 keyword 를 반영하도록 수정.

2) ExploreScreen
   - 파일:
     - lib/features/policy_new/presentation/explore/policy_explore_screen.dart
   - 검색 바 위젯(onChanged/onSubmitted 등) 구현 및 ExploreSubMode.search 모드에 따른 UI/리스트 분기 로직 구현.

3) (선택) 검색 전용 Provider/Repository 메서드
   - 예:
     - exploreSearchFeedProvider / policySearchProvider
     - repository.searchPolicies(keyword, regionCode, filters...)
   - 이미 비슷한 Provider 가 있다면 재사용하고,
     없으면 최소한 검색 keyword 기반으로 동작하는 Provider/Repository 메서드를 추가.

────────────────────────────────────
[2. 상태 모델 – keyword 처리]
────────────────────────────────────
1) ExploreViewState 에 keyword 필드 확정
   - 구조 예:

     class ExploreViewState {
       final ExploreSubMode mode;
       final String? selectedRegionName;
       final String? selectedRegionCode;
       final bool useMyRegionAsDefault;
       final String keyword; // 기본은 빈 문자열

       const ExploreViewState({
         required this.mode,
         this.selectedRegionName,
         this.selectedRegionCode,
         this.useMyRegionAsDefault = false,
         this.keyword = '',
       });

       ExploreViewState copyWith({
         ExploreSubMode? mode,
         String? selectedRegionName,
         String? selectedRegionCode,
         bool? useMyRegionAsDefault,
         String? keyword,
       }) { ... }
     }

2) StateNotifier 메서드
   - ExploreViewStateNotifier 에 다음 메서드를 추가/정리:

     void setKeyword(String keyword) {
       state = state.copyWith(keyword: keyword);
     }

     void clearKeyword() {
       state = state.copyWith(keyword: '');
     }

     void enterSearchModeWithKeyword(String keyword) {
       state = state.copyWith(
         mode: ExploreSubMode.search,
         keyword: keyword,
       );
     }

   - 키워드를 변경하면 검색 Provider 가 재빌드되도록 연결한다.

────────────────────────────────────
[3. 검색용 Provider/쿼리 설계]
────────────────────────────────────
1) 쿼리 모델 (PolicyFeedQuery 또는 동등한 것) 확장
   - 이미 있는 경우:

     class PolicyFeedQuery {
       final String? regionCode;
       final bool onlyInProgress;
       final String? keyword;
       // ... 기타 sort, page 등
     }

   - 없으면 keyword 필드를 포함한 간단한 모델을 만들어도 된다.

2) 검색 전용 Provider
   - 예시:

     final exploreSearchFeedProvider =
         FutureProvider.family<List<Policy>, PolicyFeedQuery>((ref, query) async {
       final repo = ref.watch(policyRepositoryProvider);
       return repo.searchPolicies(
         keyword: query.keyword ?? '',
         regionCode: query.regionCode,
         // ... other filters
       );
     });

   - 실제 이름/구현은 프로젝트 구조에 맞게 조정.
   - 검색 로직이 이미 있다면(ex: policySearchProvider), 그걸 감싸거나 재사용해도 된다.

3) Repository 연동
   - 정책 Repository 에서 검색용 메서드를 확인/추가:

     Future<List<Policy>> searchPolicies({
       required String keyword,
       String? regionCode,
       // ... extra filters
     });

   - 백엔드 API 가 keyword + regionCode 를 지원한다면 그대로 연결하고,
     아직 keyword 만 지원한다면 regionCode 는 무시해도 된다(코드 구조만 열어두기).

────────────────────────────────────
[4. ExploreScreen – 검색 바 UI 구현]
────────────────────────────────────
ExploreScreen 의 검색 바 영역을 실제로 상태에 연결한다.

1) TextEditingController
   - ExploreScreen 이 ConsumerStatefulWidget 인 경우:
     - TextEditingController _searchController; 을 추가하고
       initState/dispose 에서 관리.
   - StatelessWidget 이라면:
     - ref.watch(exploreViewStateProvider).keyword 를 TextField 의 initialValue 로 사용하는 방향도 가능하나,
       실제 구현 편의를 위해 Stateful 로 전환해도 된다.

2) 검색 바 위젯
   - 모양 예시:

     TextField(
       controller: _searchController,
       decoration: InputDecoration(
         hintText: '검색어를 입력하거나 태그를 선택해보세요.',
         prefixIcon: const Icon(Icons.search),
         suffixIcon: state.keyword.isNotEmpty
             ? IconButton(
                 icon: const Icon(Icons.clear),
                 onPressed: () {
                   _searchController.clear();
                   notifier.clearKeyword();
                 },
               )
             : null,
       ),
       onChanged: (value) {
         // 디바운스 여부는 선택
         notifier.setKeyword(value);
         notifier.setMode(ExploreSubMode.search);
       },
       onSubmitted: (value) {
         notifier.enterSearchModeWithKeyword(value);
       },
     );

   - 핵심:
     - 입력이 시작되면 ExploreSubMode.search 로 진입.
     - keyword 를 ExploreViewState 에 반영.

3) 디바운스(선택)
   - API 호출이 무거운 경우:
     - onChanged 내에서 바로 Provider 호출하지 않고,
     - 300~500ms 디바운스 로직을 넣을 수도 있다.
   - 구현 난이도를 고려해, 처음에는 디바운스 없이 onChanged 에서 바로 상태 변경해도 무방.

────────────────────────────────────
[5. ExploreScreen – 모드별 리스트 분기]
────────────────────────────────────
ExploreScreen 의 리스트 영역에서 ExploreSubMode 에 따라 다른 Provider 를 사용하도록 분기한다.

1) 모드 분기 로직 예시:

   final viewState = ref.watch(exploreViewStateProvider);

   Widget buildBody() {
     switch (viewState.mode) {
       case ExploreSubMode.all:
         return _AllPolicyList(); // 기존 전체 리스트 (지역/검색X)
       case ExploreSubMode.region:
         return _RegionPolicyList(viewState.selectedRegionCode);
       case ExploreSubMode.search:
         return _SearchPolicyList(
           keyword: viewState.keyword,
           regionCode: viewState.selectedRegionCode, // 선택 사항
         );
     }
   }

2) 검색 리스트 위젯(_SearchPolicyList) 예시

   class _SearchPolicyList extends ConsumerWidget {
     const _SearchPolicyList({
       required this.keyword,
       this.regionCode,
     });

     final String keyword;
     final String? regionCode;

     @override
     Widget build(BuildContext context, WidgetRef ref) {
       if (keyword.trim().isEmpty) {
         return const _SearchEmptyKeywordView();
       }

       final query = PolicyFeedQuery(
         keyword: keyword.trim(),
         regionCode: regionCode,
       );

       final asyncPolicies = ref.watch(exploreSearchFeedProvider(query));

       return asyncPolicies.when(
         data: (policies) {
           if (policies.isEmpty) {
             return _SearchNoResultView(keyword: keyword);
           }
           return _PolicyListView(policies: policies);
         },
         loading: () => const PolicyListLoading(),
         error: (e, st) => GlobalErrorView(error: e, stackTrace: st),
       );
     }
   }

3) 검색 모드에서의 특정 상태 UI

   - keyword 가 비어 있을 때:
     - "_SearchEmptyKeywordView" 예:
       - "검색어를 입력해 주세요."
       - "예: 청년, 창업, 주거"
   - keyword 가 있는데 결과가 empty:
       - "\"{keyword}\"에 대한 정책을 찾지 못했어요."
       - "필터를 넓히거나 다른 키워드를 시도해보세요."

────────────────────────────────────
[6. 상태 텍스트 – 검색 모드 반영]
────────────────────────────────────
ExploreScreen 상단의 상태 텍스트를 검색 모드에 맞게 수정한다.

1) 모드별 텍스트 예시:

   - all:
     - "경상북도 전체 정책"
   - region:
     - selectedRegionName 이 있으면: "${selectedRegionName} 정책"
     - 없으면: "내 지역 정책"
   - search:
     - keyword.trim().isEmpty:
       - "검색 결과"
     - keyword 가 있을 때:
       - "\"{keyword}\" 검색 결과"

2) 검색 모드에서 지역과 함께 쓸 수도 있음
   - 선택적으로:
     - 검색 + 지역이 동시에 적용된 경우:
       - "\"{keyword}\" · ${selectedRegionName ?? '경상북도 전체'}"
   - 이 부분은 향후 TASK27 에서 더 세밀하게 다듬을 여지로 남겨둬도 된다.

────────────────────────────────────
[7. Acceptance Criteria]
────────────────────────────────────
1) 빌드/런타임
   - flutter analyze / flutter build 기준 컴파일 에러 없음.
   - 탐색 탭에서 검색을 수행하는 동안 런타임 에러/Riverpod assertion 없음.

2) 검색 모드 진입/이탈
   - 검색 바를 탭하거나 입력하면:
     - ExploreSubMode.search 로 상태가 전환된다.
   - 상단 칩 중 "전체" / "내 지역" / "다른 지역 선택"을 탭하면:
     - 해당 모드로 전환되고, 리스트도 모드에 맞는 Provider/쿼리를 사용한다.
   - 검색 모드에서 keyword 를 비우면:
     - 검색 결과 리스트는 "_SearchEmptyKeywordView" 또는 빈 상태를 보여야 한다.

3) 검색 결과 동작
   - 특정 키워드를 입력 후 엔터(onSubmitted) 또는 타이핑(onChanged) 했을 때:
     - 검색 쿼리가 호출되고,
     - 검색 결과 정책 리스트가 화면에 표시된다.
     - 결과가 없으면 "검색 결과 없음" 메시지가 표시된다.
   - 검색 도중에도 스크롤, 정책 상세 진입 등이 정상 동작한다.

4) 모드 전환간 상태 일관성
   - all → search → region → search → all 등 모드를 여러 번 바꿔도:
     - 크래시 없이 동작.
     - 검색 바 텍스트 / ExploreViewState.keyword / 리스트 내용이
       서로 엇갈리지 않고 일관성 있게 동작해야 한다.

────────────────────────────────────
[8. 제약사항]
────────────────────────────────────
- 이 TASK에서는:
  - 추천 탭/보관함 탭/카카오맵 화면의 로직은 건드리지 않는다.
  - Explore 탭 내의 필터 칩(진행중만, 분야, 기관 등)이 있다면,
    현재 검색 구현과 충돌하지 않는 선에서 그대로 두되,
    세밀한 필터 조합 로직은 후속 TASK 로 남겨둔다.
- 오직:
  - ExploreSubMode.search 의 실제 검색 동작 구현,
  - 검색 바 ↔ 상태 ↔ 검색 Provider ↔ 리스트 연결
  에만 집중한다.
