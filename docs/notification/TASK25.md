TASK25 – Explore 탭 지역 모드 실제 필터 적용 (내 지역 / 다른 지역 선택)

[전제]
- TASK 511~515까지 적용된 상태라고 가정한다.
  - 상단 메인 탭은 "추천 / 탐색 / 보관함" 3개 구조.
  - 탐색(Explore) 탭은 ExploreScreen 으로 진입.
  - ExploreScreen 내부에 ExploreSubMode(enum: all, region, search)와
    ExploreViewState(현재 모드, selectedRegionName, keyword 등)가 존재.
  - 상단에 [전체] [내 지역] [다른 지역 선택] 칩과 검색 바, 상태 텍스트가
    ExploreSubMode 기반으로 표시되고 있다.
  - 현재는 모드가 바뀌어도 실제 리스트 데이터는 "전체 정책" 그대로이고,
    지역/검색 필터가 적용되지 않은 상태이다.

[목표]
- ExploreSubMode.region 일 때 실제로 "지역 필터"가 적용되도록 한다.
  - "내 지역" 칩 선택 시 → 프로필/설정에 저장된 기본 지역으로 필터링.
  - "다른 지역 선택" 칩 선택 시 → RegionSelect 시트/화면에서 선택한 지역으로 필터링.
- 상태 텍스트와 리스트 데이터를 모두 지역 기준으로 일관되게 동작시키고,
  모드 전환 시에도 크래시 없이 안정적으로 작동하도록 한다.

────────────────────────────────────
[1. Scope (수정/추가 범위)]
────────────────────────────────────
1) Explore 상태/Provider 관련 파일
   - 예시:
     - lib/features/policy_new/application/explore/explore_state.dart
     - lib/features/policy_new/application/explore/explore_providers.dart
   - ExploreViewState 및 관련 StateNotifier/Provider 에
     "지역 정보" 및 "지역 기반 쿼리"를 반영하는 수정.

2) ExploreScreen
   - 파일:
     - lib/features/policy_new/presentation/explore/policy_explore_screen.dart
   - "내 지역", "다른 지역 선택" 칩의 onSelected 동작 구현.
   - RegionSelect UI(바텀 시트 등) 연동 및 선택 결과 → ExploreViewState 반영.
   - ExploreSubMode.region 인 경우, 실제로 region 필터가 적용된 Provider/쿼리로 리스트 표시.

3) (필요시) Region 선택/프로필 정보 관련 파일
   - 예시:
     - userProfileProvider 또는 regionProvider 와 같은 기존 지역 상태 제공자
     - RegionSelectBottomSheet / RegionSelectScreen 등 지역 선택 UI
   - 이미 존재한다면 재사용하고, 없다면 TODO 정도로 남긴다.

────────────────────────────────────
[2. 지역 정보 소스 결정]
────────────────────────────────────
먼저, "내 지역"을 무엇으로 간주할지 결정해야 한다.

1) 기존 코드에서 사용자 지역 정보를 제공하는 Provider/모델을 찾는다.
   - 검색 키워드:
     - "regionProvider", "userRegion", "currentRegion", "selectedRegion"
     - "프로필", "내 지역", "경상북도", "시군구" 등
   - 예시 후보:
     - userProfileProvider.state.region
     - regionFilterProvider.state.selectedRegion
   - 실제 프로젝트에서 사용하는 타입/모델에 맞춰 연결한다.

2) 지역 식별 방식 정리
   - 최소 다음 항목 중 1개 이상:
     - regionCode (예: "GB-울진", "울진군 코드")
     - regionName (예: "울진군")
   - 정책 쿼리(Repository/Provider)가 요구하는 필드에 맞게 매핑한다.
     - 예: PolicyQuery(regionCode: "47190") or scope: "gyeongbuk|울진군"

3) ExploreViewState 에 지역 정보 필드 확장 (필요시)
   - 기본 구조 예:

     class ExploreViewState {
       final ExploreSubMode mode;
       final String? selectedRegionName;
       final String? selectedRegionCode;
       final bool useMyRegionAsDefault;
       // ... keyword 등 기존 필드

       const ExploreViewState({
         required this.mode,
         this.selectedRegionName,
         this.selectedRegionCode,
         this.useMyRegionAsDefault = false,
         // ...
       });

       ExploreViewState copyWith({
         ExploreSubMode? mode,
         String? selectedRegionName,
         String? selectedRegionCode,
         bool? useMyRegionAsDefault,
         String? keyword,
         // ...
       }) { ... }
     }

   - "내 지역"과 "다른 지역"을 구분하기 위해:
     - useMyRegionAsDefault = true → 내 지역
     - useMyRegionAsDefault = false → 사용자가 선택한 특정 지역

────────────────────────────────────
[3. Explore 상태 변경 메서드 구현]
────────────────────────────────────
ExploreViewStateNotifier (또는 동등한 StateNotifier) 에 아래 메서드를 구현한다.

1) void setMode(ExploreSubMode mode)
   - 기존에 있는 경우, region 모드 진입 시 지역 정보가 없다면
     - 자동으로 내 지역 정보를 불러와 설정하도록 확장해도 된다.
   - 예:
     - mode == ExploreSubMode.region &&
       state.selectedRegionCode == null → loadMyRegion()

2) Future<void> setMyRegion()
   - userProfileProvider 등에서 "내 지역" 정보를 가져와
     - selectedRegionName, selectedRegionCode 를 업데이트.
     - useMyRegionAsDefault = true 설정.
   - 프로필에 지역 정보가 없으면:
     - 상태 텍스트에서 "내 지역 정보가 설정되지 않았습니다" 등 안내를 할 수 있게
       내부 플래그만 두고, 실제 토스트/경고는 UI에서 처리.

3) void setCustomRegion(String regionName, String regionCode)
   - RegionSelect UI에서 선택한 지역 정보를 넘겨받아:
     - selectedRegionName = regionName
     - selectedRegionCode = regionCode
     - useMyRegionAsDefault = false
     - mode = ExploreSubMode.region

────────────────────────────────────
[4. ExploreScreen – 칩 및 RegionSelect 동작 구현]
────────────────────────────────────
ExploreScreen 의 상단 칩/버튼을 다음과 같이 동작하게 수정한다.

1) "전체" 칩
   - onSelected:
     - notifier.setMode(ExploreSubMode.all);
   - 선택 상태:
     - viewState.mode == ExploreSubMode.all

2) "내 지역" 칩
   - onSelected:
     - notifier.setMode(ExploreSubMode.region);
     - await notifier.setMyRegion();  // async 호출 가능하다면
   - 선택 상태:
     - viewState.mode == ExploreSubMode.region &&
       viewState.useMyRegionAsDefault == true

3) "다른 지역 선택" 칩
   - onSelected:
     - RegionSelectBottomSheet (또는 RegionSelectScreen) 띄우기
       - 기존에 지역 선택 화면/시트가 있다면 그대로 재사용.
       - 없다면:
         - // TODO(TASK 26): RegionSelectBottomSheet 구현
           형태로 TODO 만 남기고 지금은 임시 Mock 데이터 사용해도 된다.
     - 사용자가 지역을 선택하면:
       - notifier.setCustomRegion(selectedName, selectedCode)
   - 선택 상태:
     - viewState.mode == ExploreSubMode.region &&
       viewState.useMyRegionAsDefault == false

4) 상태 텍스트 (mode + 지역 기반)
   - ExploreSubMode 별로 텍스트 출력:

     - mode == all:
       - "경상북도 전체 정책"

     - mode == region && selectedRegionName != null:
       - "${selectedRegionName} 정책"

     - mode == region && selectedRegionName == null:
       - "내 지역 정책"

     - mode == search:
       - keyword 유무에 따라 기존 규칙 유지.

────────────────────────────────────
[5. 리스트 쿼리 – region 적용]
────────────────────────────────────
이제 실제로 ExploreSubMode.mode 와 selectedRegionCode 를 정책 리스트 Provider/쿼리에 반영한다.

1) Explore 에서 사용할 쿼리 모델 정리
   - 이미 PolicyFeedQuery 같은 모델이 있다면:
     - regionScope / regionCode 필드 추가 또는 활용.
   - 없으면 간단한 파라미터 구조라도 통일:

     class PolicyFeedQuery {
       final String? regionCode; // null = 전체
       final bool onlyInProgress;
       // ... 기존 필드 (page, sort 등)
     }

2) ExploreScreen 에서 Provider 호출부 수정
   - 현재는 "전체" 쿼리만 사용하는 Provider 를 쓰고 있을 것이다.
   - 이를 다음 로직으로 변경:

     - if (viewState.mode == ExploreSubMode.region &&
           viewState.selectedRegionCode != null) {
         // 지역 필터 쿼리
         final query = PolicyFeedQuery(regionCode: viewState.selectedRegionCode, ...);
         final asyncPolicies = ref.watch(exploreRegionFeedProvider(query));
       } else {
         // 전체 쿼리
         final query = PolicyFeedQuery(regionCode: null, ...);
         final asyncPolicies = ref.watch(exploreAllFeedProvider(query));
       }

   - Provider 이름/구조는 실제 프로젝트에 맞게 정한다.
   - 중요한 것은:
     - ExploreSubMode.region && selectedRegionCode != null 일 때,
       **반드시 지역 필터가 포함된 쿼리**가 사용되어야 한다는 점.

3) Repository/데이터 레이어 연동
   - 정책 Repository 쪽에서 regionCode/regionScope 를 이미 처리한다면:
     - 해당 파라미터를 그대로 전달.
   - 없다면:
     - // TODO(TASK 27): Repository 레벨에서 region 필터 파라미터 지원 추가
       주석만 남기고, 현재는 임시로 regionCode 를 무시한 전체 검색을 유지할 수도 있다.
       (단, Acceptance Criteria 만족을 위해 가능하면 실제 region 필터까지 구현하는 것을 권장)

────────────────────────────────────
[6. Acceptance Criteria]
────────────────────────────────────
1) 빌드/런타임
   - flutter analyze / flutter build 기준 컴파일 에러 없음.
   - 탐색 탭에서 모드/지역 전환, 리스트 로딩 중 런타임 에러 없음.

2) "전체" 모드
   - "전체" 칩이 선택된 상태에서:
     - 상태 텍스트: "경상북도 전체 정책" (또는 이와 유사한 문구).
     - 리스트: 현재와 동일한 전체 정책 목록.

3) "내 지역" 모드
   - "내 지역" 칩을 탭하면:
     - ExploreSubMode.region 으로 변경.
     - viewState.useMyRegionAsDefault = true.
     - 상태 텍스트:
       - 프로필 지역이 울진군이라고 가정하면: "울진군 정책".
     - 리스트:
       - API/데이터에 실제 필터 기능이 있다면, 해당 지역 정책만 표시.
       - (임시로 전체와 같은 데이터를 쓰더라도, 코드 구조상 regionCode 가 쿼리에 반영되어 있어야 함.)

4) "다른 지역 선택" 모드
   - "다른 지역 선택" 칩을 탭하면:
     - RegionSelect UI(또는 임시 다이얼로그)가 열려야 한다.
     - 임의로 "구미시"를 선택하면:
       - ExploreSubMode.region, useMyRegionAsDefault = false,
         selectedRegionName = "구미시", selectedRegionCode = <구미 코드>.
       - 상태 텍스트: "구미시 정책".
       - 리스트: 구미시 정책만(가능하면) 표시.

5) 모드 전환 안정성
   - 전체 ↔ 내 지역 ↔ 다른 지역 ↔ 검색 모드를 오가도:
     - 화면 크래시 없음.
     - Provider/Riverpod assertion 없음.
     - 스크롤/당겨 새로고침/상세 진입 등의 기본 동작 정상.

────────────────────────────────────
[7. 제약사항]
────────────────────────────────────
- 이 TASK에서는:
  - 검색 모드(ExploreSubMode.search)의 실제 검색 로직, 키워드 입력 처리, 필터 칩 동작은 구현하지 않는다.
  - 추천 탭/보관함 탭/카카오맵 화면의 기존 로직은 변경하지 않는다.
- 오직:
  - Explore 탭의 region 모드를 실제 동작하게 만드는 것
    (내 지역/다른 지역 선택 → 상태/쿼리/리스트 반영)
  에만 집중한다.
