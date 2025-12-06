[증상 요약]
- 보관함 탭에서 카드에 "비교 중" 뱃지는 뜨지만, 화면 하단에 CompareEntryBar가 보이지 않아 비교 화면으로 진입할 수 없음.
- 탐색 탭에서 검색/정렬/필터 UI는 보이나, 버튼과 칩을 눌러도 실제 리스트 내용이 바뀌지 않거나, 스크롤/레이아웃이 어색했던 이력이 있음.

────────────────────
A. 보관함 탭 – CompareEntryBar 확실히 노출
────────────────────

1) 보관함 탭 feedType 확인
- "보관함" 탭에서 사용 중인 feedType이 반드시 `PolicyFeedType.favorite`인지 확인하고,
  아니라면 favorite(즐겨찾기/저장 정책용) 타입으로 맞춘다.
- 이 feedType이 CompareEntryBar 노출 조건(`feedType == PolicyFeedType.favorite`)과 동일해야 한다.

2) compareCount 계산 방식 고정
- `policy_feed_tab.dart`에서 compareCount를 다음과 같이 읽도록 명시적으로 수정한다
  (provider 실제 이름은 프로젝트에 맞게 치환):

  - 예시:
    - `final compareState = ref.watch(policyCompareProvider);`
    - `final compareCount = compareState.items.length;`

- 즉, "비교 중" 뱃지에 사용되는 데이터와 **동일한 소스**에서 길이를 계산해야 한다.
  (다른 provider나 필드에서 가져오지 말 것)

3) 레이아웃 구조 강제
- 보관함 탭의 최상위 위젯은 다음과 같은 형태가 되도록 수정한다:

  - `Scaffold`(필요하다면 한 번만)
    - `body: Column(
         children: [
           Expanded(
             child: 기존 보관함 정책 리스트 (CustomScrollView / ListView 등),
           ),
           if (feedType == PolicyFeedType.favorite && compareCount > 0)
             SafeArea(
               top: false,
               child: CompareEntryBar(
                 itemCount: compareCount,
                 onOpenCompare: () {
                   // app_router.dart에 이미 정의된 compare 라우트 사용
                   // 예: context.pushNamed(AppRoute.policyCompare.name);
                 },
               ),
             ),
         ],
       )`

- Column 밖에서 바로 리스트를 리턴하는 다른 분기(예: `return list;`)가 있다면 모두 제거하고,
  항상 위 Column 구조를 통해 렌더링되도록 정리한다.

4) 동작 확인용 로그 추가
- CompareEntryBar가 조건에 맞게 평가되는지 확인을 위해 임시 로그를 추가한다:

  - 예시:
    - `debugPrint('[CompareEntryBar] feedType=$feedType, compareCount=$compareCount');`

- flutter run 실행 시, 보관함에서 여러 정책을 "비교 중"으로 만들었을 때
  `compareCount`가 1 이상으로 찍히는지 확인한다.

────────────────────
B. 탐색 탭 – 필터/정렬/검색 실제 동작 보장
────────────────────

1) Explore 상태/컨트롤러 연결 확인
- `policy_explore_screen.dart`에서 사용하는 상태/컨트롤러가 실제 Explore용 provider와 연결되어 있는지 확인한다.
  - 예: `final state = ref.watch(policyExploreControllerProvider);`
  - 검색/필터/정렬 변경 시 반드시 컨트롤러 메서드를 호출해야 한다:
    - 검색어 입력 완료 → `controller.setKeyword(...)`
    - 정렬 버튼 클릭 → `controller.setSortKind(...)`
    - 카테고리 칩 토글 → `controller.toggleCategory(...)`
    - 상태 칩 선택 → `controller.setStatusFilter(...)`
    - 초기화 버튼 → `controller.clearFilters()`

2) 리스트 리로드 트리거
- 위 컨트롤러 메서드들이 내부에서 실제로 정책 리스트를 다시 불러오도록 되어 있는지 확인하고,
  만약 단순히 state만 바꾸고 fetch를 안 한다면, 필터/정렬/검색 변경 후에
  - 원래 Explore 모듈에서 사용하던 `load()` / `fetchPolicies()` 등 리스트 로딩 메서드를 호출하도록 수정한다.
- 최종 목표: 검색/필터/정렬 중 하나라도 바꾸면 아래 정책 리스트가 즉시 해당 조건에 맞게 갱신되는 것.

3) 검색/정렬/필터 UI 한 세트만 유지
- `policy_explore_screen.dart` 안에서 검색창/정렬/필터 버튼이 두 번 이상 등장하지 않도록 정리한다.
  - 상단 헤더 영역의 검색/정렬/필터 Row 1세트만 남기고,
  - 리스트 위/아래에 중복된 검색창/버튼이 있다면 제거한다.

4) 가로 칩 overflow 방지
- 카테고리/상태 칩 Row는 반드시 `SingleChildScrollView(scrollDirection: Axis.horizontal)`로 감싸고,
  Row 안 item들이 화면을 넘치지 않도록 구성한다.
- flutter run 시 `RenderFlex overflowed` 경고가 더 이상 policy_explore_screen.dart 기준으로 발생하지 않아야 한다.

────────────────────
[완료 조건 재확인]

- 보관함 탭:
  - 최소 2개의 정책을 "비교 중"으로 만들면, 하단에 CompareEntryBar가 항상 보인다.
  - 스크롤을 위/아래로 해도 CompareEntryBar는 bottom navigation 바로 위에 고정된다.
  - "비교 화면 열기"를 누르면 PolicyCompareScreen으로 정상 진입한다.

- 탐색 탭:
  - 검색/정렬/필터/카테고리/상태를 조합해서 바꾸면, 아래 정책 리스트 결과가 실제로 바뀐다.
  - 탐색 탭 관련 RenderFlex overflow 에러가 flutter run 로그에 나타나지 않는다.
  - 화면에는 검색/정렬/필터 진입 컴포넌트 세트가 딱 1개만 보인다.