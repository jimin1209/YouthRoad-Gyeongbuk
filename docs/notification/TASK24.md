TASK 515 – ExploreSubMode 도입 및 탐색 탭 모드 상태 뼈대 만들기 (all / region / search)

[전제]
- TASK 514에서 ExploreScreen 이 생성되어 있고,
  현재 탐색(Explore) 탭은 ExploreScreen 으로 진입하며
  "경상북도 전체 정책" 리스트(기존 전체 탭 로직)를 보여주고 있다고 가정한다.
- 아직 "내 지역" / "검색" 기능은 구현되지 않은 상태이다.

[목표]
- ExploreScreen 내부에 탐색 모드 개념을 추가한다:
  - ExploreSubMode = { all, region, search }
- 상단에 [전체] [내 지역] [다른 지역 선택] 칩/버튼 UI와
  검색 바, 상태 텍스트를 모드 기반으로 표시한다.
- 이 단계에서는 **리스트 데이터는 여전히 "전체 정책" 기준으로만 로딩**하고,
  모드 전환은 UI/상태만 달라지는 수준으로 구현한다.
  (실제 region/search 필터링/검색은 이후 TASK에서 구현 예정)

────────────────────────────────────
[1. Scope (수정/추가 범위)]
────────────────────────────────────
1) Explore 모드/상태 정의
   - 위치(권장):
     - lib/features/policy_new/application/explore/explore_state.dart
       또는
     - lib/features/policy_new/application/explore/explore_providers.dart
   - 다음 내용을 포함:
     - ExploreSubMode enum 정의
     - ExploreState 또는 최소한 현재 모드를 표현하는 StateProvider/StateNotifier

2) ExploreScreen 수정
   - 파일:
     - lib/features/policy_new/presentation/explore/policy_explore_screen.dart
   - 상단 UI(모드 칩/검색 바/상태 텍스트)를 ExploreSubMode 기반으로 동작하도록 수정.
   - 리스트 영역은 여전히 기존 전체 리스트 Provider/위젯을 그대로 사용.

────────────────────────────────────
[2. ExploreSubMode 및 상태 모델 정의]
────────────────────────────────────
1) enum 정의
   - 새로운 enum 추가:

     enum ExploreSubMode {
       all,    // 경북 전체 정책
       region, // 내 지역 / 선택 지역 정책
       search, // 키워드/태그 검색
     }

2) 상태 모델 (간단 버전)
   - 이 단계에서는 아래 정도만 관리하면 된다:

     class ExploreViewState {
       final ExploreSubMode mode;
       final String? selectedRegionName; // 예: "울진군", null = 전체
       final String? keyword;            // 검색어 (search 모드용, 아직 실제 사용 X)

       const ExploreViewState({
         required this.mode,
         this.selectedRegionName,
         this.keyword,
       });

       ExploreViewState copyWith({
         ExploreSubMode? mode,
         String? selectedRegionName,
         String? keyword,
       }) { ... }
     }

   - Provider 예시:
     - final exploreViewStateProvider = StateNotifierProvider<ExploreViewStateNotifier, ExploreViewState>(...);

   - 초기값:
     - mode = ExploreSubMode.all
     - selectedRegionName = null
     - keyword = null

3) StateNotifier (또는 StateProvider) 메서드
   - 다음 정도의 메서드만 우선 정의:

     - void setMode(ExploreSubMode mode)
     - void setRegion(String? regionName)  // TASK 516에서 실제로 쓸 예정
     - void setKeyword(String? keyword)    // TASK 517에서 실제 검색에 사용 예정

   - 이 TASK에서는 setMode 까지만 실제로 사용해도 된다.

────────────────────────────────────
[3. ExploreScreen 상단 UI 수정]
────────────────────────────────────
ExploreScreen 의 build 메서드에서:

1) 상태 구독
   - final viewState = ref.watch(exploreViewStateProvider);
   - final notifier = ref.read(exploreViewStateProvider.notifier);

2) 검색 바 영역
   - 이미 TASK 514에서 만든 검색 바(또는 그 자리에 들어갈 Container/TextField)를
     ExploreSubMode 와 연동할 준비만 한다.
   - 이 단계에서는:
     - 탭하거나 입력해도 아직 실제 검색은 하지 않는다.
     - onTap 시:
       - notifier.setMode(ExploreSubMode.search);
       - TODO(TASK 517) 주석만 추가.

3) 모드 칩/버튼 영역
   - 검색 바 아래에 한 줄 또는 두 줄로 칩/버튼 UI 추가:

     Row(
       children: [
         ChoiceChip 또는 FilterChip "전체",
         ChoiceChip 또는 FilterChip "내 지역",
         ChoiceChip 또는 FilterChip "다른 지역 선택",
       ],
     )

   - 선택 상태:
     - "전체" 칩: viewState.mode == ExploreSubMode.all 이면 selected = true
     - "내 지역" 칩: viewState.mode == ExploreSubMode.region && selectedRegionName == 내 지역
       (이 단계에서는 region 이름을 몰라도 되므로, 단순히 mode == region 인지만 보고 선택 처리해도 된다.)
     - "다른 지역 선택" 칩:
       - 이 단계에서는 onSelected 내부에 TODO 만 남겨두고, 실제 지역 선택 시트는 다음 TASK에서 구현.

   - onSelected 동작:
     - "전체":
       - notifier.setMode(ExploreSubMode.all);
     - "내 지역":
       - notifier.setMode(ExploreSubMode.region);
       - TODO(TASK 516): 프로필에서 내 지역 불러와 상태에 반영
     - "다른 지역 선택":
       - // TODO(TASK 516): RegionSelectBottomSheet 를 띄워 선택한 지역을 setRegion 으로 반영

4) 상태 텍스트
   - 모드별로 한 줄 요약 텍스트를 다르게 표기:

     - mode == all:
       - "경상북도 전체 정책"
     - mode == region:
       - selectedRegionName 이 있으면:
         - "{selectedRegionName} 정책"
       - 없으면(아직 지역 선택 안 함, 단순 '내 지역' 모드):
         - "내 지역 정책"
     - mode == search:
       - keyword 가 있으면:
         - "\"{keyword}\" 검색 결과"
       - 없으면:
         - "검색 결과"

   - 이 텍스트는 리스트 위에 Padding 하나 주고 Text 로 표시.

────────────────────────────────────
[4. 리스트 영역 처리 (이번 단계)]
────────────────────────────────────
1) 리스트 데이터는 여전히 "전체 정책"만 사용
   - 이 단계에서는 ExploreSubMode 에 따라 실제 쿼리/Provider 를 바꾸지 않는다.
   - 즉, 현재 ExploreScreen 이 사용하는 Provider(기존 전체 탭에서 쓰던 것) 그대로 유지.

2) UI 관점에서의 차이
   - 모드가 바뀌어도:
     - 리스트 내용은 그대로지만
     - 상단 모드 칩 상태, 상태 텍스트만 바뀌는 상태가 되어야 한다.

3) TODO 주석
   - 리스트를 빌드하는 부분 근처에:

     - // TODO(TASK 516): ExploreSubMode.region 일 때 region 필터 적용
     - // TODO(TASK 517): ExploreSubMode.search 일 때 검색 쿼리 적용

   - 이 주석으로 나중에 작업 포인트를 명확히 남긴다.

────────────────────────────────────
[5. Acceptance Criteria]
────────────────────────────────────
1) 빌드/런타임
   - flutter analyze / flutter build 에러 없음.
   - 탐색(Explore) 탭 진입 및 모드 전환 중 런타임 에러 없음.

2) 모드 상태 전환
   - 탐색 탭 진입 시:
     - 기본 모드: ExploreSubMode.all
     - 상태 텍스트: "경상북도 전체 정책" (또는 이와 유사한 문구)
   - "전체" 칩을 탭하면:
     - ExploreSubMode.all 로 상태가 설정되고, 칩 선택/상태 텍스트가 all 모드 기준으로 표시된다.
   - "내 지역" 칩을 탭하면:
     - ExploreSubMode.region 으로 상태가 설정되고, 상태 텍스트가 region 모드 기준으로 바뀐다.
     - (실제 데이터 필터링은 아직 되지 않아도 된다.)
   - 검색 바를 탭하면:
     - ExploreSubMode.search 로 모드가 바뀌고,
     - 상태 텍스트가 search 모드 기준으로 바뀐다.
     - (실제 검색 수행은 이후 TASK에서 구현 예정.)

3) 리스트 동작
   - 모드 변경(전체/내 지역/검색)과 상관없이,
     - 정책 리스트는 기존 전체 탭과 동일하게 잘 로딩되고,
     - 스크롤/새로고침/상세 진입 기능이 정상 동작해야 한다.

4) 코드 구조
   - ExploreSubMode enum 과 ExploreViewState/Provider 가 분리된 파일로 정리되어 있어,
     이후 TASK (516, 517)에서 재사용/확장 가능해야 한다.
   - ExploreScreen 안의 상단 UI는 이 상태를 기반으로 동작하도록 구현되어 있어야 한다.

────────────────────────────────────
[6. 제약사항]
────────────────────────────────────
- 이 TASK에서는 다음을 하지 말 것:
  - regionScope 나 검색 쿼리를 실제 API/Repository 호출에 반영
  - 새로운 Provider/Repository 를 도입해 필터링을 실제로 수행
- 오직:
  - ExploreSubMode enum/상태 모델 도입,
  - ExploreScreen 상단 UI에 모드/요약 텍스트 반영,
  - 모드 전환이 잘 되는지 확인하는 수준까지 구현
  에만 집중한다.
