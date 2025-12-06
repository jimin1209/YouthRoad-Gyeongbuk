TASK38 – 탐색 필터 오버플로우 및 비교 진입 바 위치/조건 정리

[목표]
1) 탐색(Explore) 화면 상단 필터 영역의 RenderFlex overflow를 제거한다.
2) CompareEntryBar(비교 진입 바)가 **보관함 탭에서만** 하단 고정으로 노출되도록 정리한다.
3) 탐색 탭에서는 CompareEntryBar가 전혀 보이지 않게 하고, 필터/버튼들이 겹치지 않도록 정리한다.

────────────────────────────────────
1. 탐색 화면 필터 영역 오버플로우 수정
────────────────────────────────────
[수정 대상]
- lib/features/policy_new/presentation/explore/policy_explore_screen.dart

[요구 사항]
1) 에러 로그에 나온 Row 위치 확인:
   - "Row:file:///.../policy_explore_screen.dart:206:12" 의 Row 및 해당 위젯(_ModeSelector 등)을 찾는다.

2) 모드 선택 영역(전체 / 내 지역 / 검색 등)이 Row 안에서 가로로 넘치지 않도록 수정:
   - Row 안의 각 모드 버튼을 `Expanded` 또는 `Flexible`로 감싸어 **가로 폭을 균등 분배**한다.
   - 버튼 텍스트에는 `overflow: TextOverflow.ellipsis`, `maxLines: 1` 을 적용해서 긴 텍스트가 줄 바꿈으로 높이를 늘리지 않게 한다.
   - 필요하면 Row 대신 `Wrap` 또는 `SingleChildScrollView(scrollDirection: Axis.horizontal)`로 바꿔서,
     작은 화면에서도 오버플로우가 발생하지 않게 한다. (Row로 유지하되 Expanded 3개로 맞추는 것을 우선시)

3) 전체 필터 영역 레이아웃 점검:
   - 필터/검색/키워드/상태 칩을 감싸는 Column이 상위에서 **스크롤 가능한 컨테이너** 안에 있도록 보장한다.
     - 예: `CustomScrollView` + `SliverToBoxAdapter(child: Column(...))` 구조에서,
       `SliverToBoxAdapter` 안의 Column에는 `Expanded` 또는 `Flexible`을 사용하지 않는다.
   - Column의 `mainAxisSize` 는 기본값(MainAxisSize.max)이더라도,
     스크롤 가능한 부모 안에서 overflow가 나지 않도록 불필요한 고정 height/constraints가 없는지 확인한다.

4) 수정 후 조건:
   - 탐색 탭에서 위로/아래로 스크롤할 때, 필터 영역과 정책 리스트가 자연스럽게 함께 스크롤된다.
   - 다시 실행 시 `RenderFlex overflowed by XXX pixels` 로그가 더 이상 나오지 않아야 한다.

────────────────────────────────────
2. CompareEntryBar 위치/표시 조건 정리
────────────────────────────────────
[수정 대상]
- lib/features/policy_new/presentation/tabs/policy_feed_tab.dart
- lib/features/policy_new/presentation/compare/widgets/compare_entry_bar.dart
- (필요 시) lib/features/policy_new/presentation/explore/policy_explore_screen.dart

[요구 사항]
1) CompareEntryBar 사용 위치를 “보관함 탭 전용”으로 제한:
   - 정책 탭에서 사용 중인 feedType(enum 등)를 확인한다.
     예: PolicyFeedType.recommend, PolicyFeedType.explore, PolicyFeedType.favorite(=보관함) 등.
   - `policy_feed_tab.dart` 에서 CompareEntryBar를 빌드할 때 조건을 다음과 같이 수정:
     - `feedType == PolicyFeedType.favorite` (또는 실제 보관함 탭이 사용하는 타입) **AND** 비교 목록 개수 > 0 일 때만 노출.
   - 탐색/추천 탭에서는 CompareEntryBar를 절대 빌드하지 않는다.

2) CompareEntryBar를 스크롤 바디가 아닌 Scaffold 하단에 고정:
   - `PolicyFeedTab`의 `Scaffold` 구조를 다음과 같이 정리:
     - `body`: 기존의 리스트/컨텐츠만 포함 (CustomScrollView, ListView 등)
     - `bottomNavigationBar` 또는 `bottomSheet`: 조건부로 CompareEntryBar를 넣는다.
       예) 
       ```dart
       return Scaffold(
         body: ... // 정책 리스트
         bottomNavigationBar: shouldShowCompareBar
             ? CompareEntryBar(...)
             : null,
       );
       ```
   - 이렇게 해서 리스트 스크롤과 무관하게, CompareEntryBar는 항상 하단에 고정되도록 한다.
   - CompareEntryBar 내부에서는 `SafeArea` 를 사용해 시스템 하단 영역/네비게이션 바와 겹치지 않도록 한다.

3) 탐색 화면에서 CompareEntryBar 제거
   - `policy_explore_screen.dart` 내에 CompareEntryBar를 직접 import/사용하는 코드가 있다면 모두 제거한다.
   - CompareEntryBar 노출은 `PolicyFeedTab`(보관함 탭)에서만 담당하도록 책임을 분리한다.

4) CompareEntryBar 스타일/높이 정리
   - CompareEntryBar의 높이를 56~64 정도의 고정 높이로 두고, 위/아래에 적절한 padding을 준다.
   - 내부 레이아웃 예:
     - 좌측: "비교 {n}개 선택됨" Text
     - 우측: FilledButton("비교 화면 열기")
     - Row(children: [Expanded(Text(...)), SizedBox(width:8), ElevatedButton(...)]) 형태로 구현.
   - 텍스트/버튼이 줄 바꿈되거나 2줄 이상으로 늘어나지 않도록 `maxLines:1` + `TextOverflow.ellipsis` 를 적용한다.

────────────────────────────────────
3. 확인용 체크리스트
────────────────────────────────────
1) 탐색 탭
   - 다양한 기기 폭(에뮬레이터/실기기)에서 필터/버튼이 화면을 넘치지 않고,
     RenderFlex overflow 로그가 발생하지 않는다.
   - 화면을 아래로 충분히 내렸을 때도 필터/버튼/카드들이 자연스럽게 위로 스크롤된다.

2) 보관함 탭
   - 정책 카드에서 2개 이상 “비교” 선택 → 하단 CompareEntryBar 등장.
   - CompareEntryBar는 스크롤과 상관 없이 화면 맨 아래 고정되어 있으며, 버튼이 카드와 겹치지 않는다.
   - CompareEntryBar의 “비교 화면 열기” 버튼을 눌렀을 때 정책 비교 화면으로 정상 진입한다.

3) 추천/탐색 탭
   - 어떤 경우에도 CompareEntryBar가 나타나지 않는다.
