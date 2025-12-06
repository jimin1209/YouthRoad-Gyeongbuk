TASK39 – 탐색 필터 레이아웃 단순화 + 비교 바 실제 노출

[목표]
1) 탐색(Explore) 탭 상단 필터 영역 구조를 단순화하고, RenderFlex bottom overflow를 제거한다.
2) 보관함(즐겨찾기) 탭에서 CompareEntryBar가 실제로 화면에 보이도록, 리스트와 글로벌 BottomNavigationBar 사이에 고정 배치한다.

────────────────────────────────────
1. 탐색 탭 필터 UI 구조 단순화
────────────────────────────────────
[수정 대상]
- lib/features/policy_new/presentation/explore/policy_explore_screen.dart

[요구 사항]

1) 상단 구조를 다음 4단계로 정리한다 (중복된 검색/칩 제거):

   (1) 모드 선택 줄
       - "전체", "내 지역 (경북 전체)", "검색" 3개만 남긴다.
       - Row 대신 다음 중 하나로 구현:
         - Row + Expanded 3개 버튼
         - 또는 SingleChildScrollView(scrollDirection: Axis.horizontal) + Row
       - 이 줄은 1줄만 나오게 하고, overflow 대비 텍스트에 `maxLines: 1`, `overflow: TextOverflow.ellipsis` 적용.

   (2) 검색 + 정렬 + 필터 줄
       - SearchBar(혹은 TextField) 하나 + 정렬 버튼(최신순) + 필터 버튼 3개를 Row로 배치.
       - 공간이 부족하면 SearchBar는 Expanded, 나머지 버튼은 고정 width 또는 IconButton으로.
       - 기존에 탐색 영역 하단 쪽에 있던 "검색어를 입력하세요" 입력창은 삭제하고, **이 SearchBar 한 군데만 사용**한다.

   (3) 상단 카테고리 칩 줄
       - "청년/창업/주거/취업/교육/생활" 등 카테고리 칩들은 `Wrap`으로 감싸서 여러 줄로 자연스럽게 내려가게 한다.
         - 예: 
           ```dart
           Wrap(
             spacing: 8,
             runSpacing: 8,
             children: categoryChips,
           )
           ```
       - Row 안에 Wrap을 넣지 말고, Column 안에서 Wrap 단독으로 사용한다.

   (4) 상태 필터 줄
       - "진행중만 / 마감 포함 / 마감만" 3개를 하나의 Row 또는 Wrap으로 배치.
       - 이 줄은 (3)번과 마찬가지로 **Column 안에 별도 섹션**으로 두고, 아래 정책 리스트와 함께 스크롤되도록 한다.
       - 기존처럼 상태 칩 바로 아래 쪽에 또 다른 SearchBar나 카테고리 칩이 나오지 않도록 중복 제거.

2) 레이아웃 컨테이너 정리
   - Sliver 구조 예:
     ```dart
     CustomScrollView(
       slivers: [
         SliverToBoxAdapter(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               _ModeSelector(...),          // (1)
               SizedBox(height: 12),
               _SearchAndFilterRow(...),    // (2)
               SizedBox(height: 12),
               _CategoryChipsWrap(...),     // (3)
               SizedBox(height: 12),
               _StatusFilterRow(...),       // (4)
               SizedBox(height: 16),
               _SectionTitle("경북 전체 정책"),
             ],
           ),
         ),
         _PolicyListSliver(...),
       ],
     );
     ```
   - `SliverToBoxAdapter` 내 Column에는 `Expanded`/`Flexible`을 쓰지 않는다.
   - 각 섹션은 자신의 높이를 자연스럽게 늘리고, 전체는 CustomScrollView로 스크롤만 담당.

3) overflow 제거 조건
   - 위 구조로 변경 후, 다양한 해상도에서 탐색 탭을 확인했을 때
     `BOTTOM OVERFLOWED BY XXX PIXELS` 로그가 더 이상 나오지 않아야 한다.

────────────────────────────────────
2. 보관함 탭에서 CompareEntryBar 실제 노출
────────────────────────────────────
[수정 대상]
- lib/features/policy_new/presentation/tabs/policy_feed_tab.dart
- lib/features/policy_new/presentation/compare/widgets/compare_entry_bar.dart

[요구 사항]

1) CompareEntryBar 표시 조건 재점검
   - 보관함 탭이 사용하는 feedType을 확인한다.
     예: `PolicyFeedType.favorite` 또는 실제 enum 값.
   - 아래 조건을 만족할 때만 CompareEntryBar를 보여준다.
     ```dart
     final compareState = ref.watch(policyCompareProvider); // 실제 provider 이름 사용
     final hasItems = compareState.items.isNotEmpty;        // 실제 필드명 사용

     final shouldShowCompareBar =
         feedType == PolicyFeedType.favorite && hasItems;
     ```

2) CompareEntryBar 위치를 리스트와 글로벌 BottomNavigationBar 사이로 조정
   - 현재 구조가 `Scaffold` 안에 또 다른 `Scaffold`를 중첩하고 있거나,
     내부 Scaffold의 `bottomNavigationBar`에 CompareEntryBar를 넣어서
     상위(앱 전체) bottom nav에 가려지고 있을 가능성이 높다.

   - `policy_feed_tab.dart` 의 반환 구조를 다음과 같이 변경한다 (내부 Scaffold 제거):

     ```dart
     class PolicyFeedTab extends ConsumerWidget {
       @override
       Widget build(BuildContext context, WidgetRef ref) {
         final shouldShowCompareBar = ... // 위에서 계산

         return Column(
           children: [
             Expanded(
               child: _PolicyFeedBody(  // 기존 리스트/스크롤뷰 그대로 이동
                 feedType: feedType,
               ),
             ),
             if (shouldShowCompareBar)
               CompareEntryBar(
                 onOpenCompare: () {
                   // compare 화면으로 라우팅
                 },
               ),
           ],
         );
       }
     }
     ```

   - 이렇게 하면, 상위의 `Scaffold(body: PolicyFeedTab(), bottomNavigationBar: ...)` 구조 안에서
     CompareEntryBar가 글로벌 bottom nav 바로 위에 자연스럽게 붙는다.

3) CompareEntryBar 내부 SafeArea 처리
   - CompareEntryBar 자체는 높이 56~64 정도의 Container로,
     내부에 `SafeArea(top: false, child: ...)` 를 사용해 하단 시스템 바와 겹치지 않게 한다.
   - 예:
     ```dart
     class CompareEntryBar extends StatelessWidget {
       @override
       Widget build(BuildContext context) {
         return SafeArea(
           top: false,
           child: Container(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: Row(
               children: [
                 Expanded(child: Text('비교 4개 선택됨', maxLines: 1, overflow: TextOverflow.ellipsis)),
                 const SizedBox(width: 8),
                 FilledButton(
                   onPressed: onOpenCompare,
                   child: const Text('비교 화면 열기'),
                 ),
               ],
             ),
           ),
         );
       }
     }
     ```

4) 확인 시나리오
   - 보관함 탭에서 0개 선택 → CompareEntryBar 미표시.
   - 보관함 탭에서 2개 이상 "비교 중" 상태 → 화면 하단에 CompareEntryBar 표시,
     스크롤을 아무리 올리고 내려도 바는 항상 고정.
   - 추천/탐색 탭에서는 어떤 경우에도 CompareEntryBar가 나타나지 않는다.
