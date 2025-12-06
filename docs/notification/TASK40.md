TASK43 – 보관함 탭 비교 진입 바 강제 노출 + 탐색 필터 수평/간결화

[목표]
1) 즐겨찾기(보관함) 탭에서 비교 중인 정책이 있을 때, 화면 하단에 CompareEntryBar가 실제로 보이도록 만든다.
2) 탐색 탭 상단 필터 UI를 “가로 2줄 + 검색 줄” 정도로 간결하게 줄이고 정책 리스트 영역을 넓힌다.

────────────────────────────────────
1. 보관함 탭 – CompareEntryBar 실제 노출
────────────────────────────────────
[수정 파일]
- lib/features/policy_new/presentation/tabs/policy_feed_tab.dart
- lib/features/policy_new/presentation/compare/widgets/compare_entry_bar.dart

[요구 사항]

1) 내부 Scaffold 제거 & Column 구조로 단순화

현재 PolicyFeedTab 내부에 또 하나의 Scaffold가 있으면,
상위의 “정책 탐색” 탭 Scaffold와 겹치면서 bottomNavigationBar 사이에 CompareEntryBar가 끼어 보이지 않을 수 있다.

PolicyFeedTab의 build를 다음과 같은 패턴으로 바꾼다 (필요한 부분만 기존 코드로 교체):

```dart
class PolicyFeedTab extends ConsumerWidget {
  const PolicyFeedTab({
    super.key,
    required this.feedType,
  });

  final PolicyFeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) 비교 상태 가져오기 (실제 provider/필드명 사용)
    final compareState = ref.watch(policyCompareProvider);
    final hasCompareItems = compareState.items.isNotEmpty; // 필드명 맞게 수정

    // 2) 이 탭이 즐겨찾기(보관함) 탭인지 확인
    final isFavoriteTab = feedType == PolicyFeedType.favorite; // enum 실제 값 확인

    // 3) 표시 여부
    final showCompareBar = isFavoriteTab && hasCompareItems;
    debugPrint(
      '[PolicyFeedTab] feedType=$feedType, hasCompareItems=$hasCompareItems, showCompareBar=$showCompareBar',
    );

    return Column(
      children: [
        // 기존 리스트/스크롤 뷰 전체를 이 Expanded 안으로 옮긴다.
        Expanded(
          child: _PolicyFeedBody(   // 실제 위젯 이름/내용으로 대체
            feedType: feedType,
          ),
        ),

        if (showCompareBar)
          CompareEntryBar(
            itemCount: compareState.items.length, // 실제 필드명 사용
            onOpenCompare: () {
              // 기존 compare 화면 라우팅 로직 그대로 사용
              // 예) context.pushNamed(AppRoute.policyCompare.name);
            },
          ),
      ],
    );
  }
}
※ 핵심: PolicyFeedTab 안에서는 Scaffold를 사용하지 않고, 상위(정책 탐색 탭)의 Scaffold 안에서 body로만 동작하게 만든다.

CompareEntryBar 스타일 & SafeArea

lib/features/policy_new/presentation/compare/widgets/compare_entry_bar.dart 를 다음 규칙으로 정리한다.

전체 폭을 차지하는 하나의 Container + SafeArea(bottom) 사용.

높이는 56~72 정도.

왼쪽에는 비교 n개 선택됨 텍스트, 오른쪽에는 “비교 화면 열기” 버튼.

예시:

dart
Copy code
class CompareEntryBar extends StatelessWidget {
  const CompareEntryBar({
    super.key,
    required this.itemCount,
    required this.onOpenCompare,
  });

  final int itemCount;
  final VoidCallback onOpenCompare;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1FF), // 연한 파랑 톤 (필요시 테마 색상 사용)
          border: const Border(
            top: BorderSide(color: Color(0xFFDBE2EE)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '비교 중인 정책 $itemCount개',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: onOpenCompare,
              icon: const Icon(Icons.table_chart_outlined, size: 18),
              label: const Text('비교 화면 열기'),
            ),
          ],
        ),
      ),
    );
  }
}
동작 확인 시나리오

보관함 탭에서 비교 선택 0개 → CompareEntryBar 미표시.

같은 탭에서 2개 이상 “비교 중” 토글 → 하단에 CompareEntryBar 표시.

스크롤을 위아래로 움직여도 CompareEntryBar는 항상 하단에 고정.

추천/탐색 탭에서는 어떤 경우에도 CompareEntryBar가 나타나지 않음.

────────────────────────────────────
2. 탐색 탭 – 필터 수평/간결화
────────────────────────────────────
[수정 파일]

lib/features/policy_new/presentation/explore/policy_explore_screen.dart

[요구 사항]

상단 레이아웃을 다음 3줄로 제한

(1) 검색/정렬/필터 줄 (Row)

구성: [검색창(Expanded)] [최신순 버튼] [필터 아이콘 버튼]

이 줄이 탐색 필터의 “메인 컨트롤”.

예:

dart
Copy code
Row(
  children: [
    Expanded(
      child: _SearchField( // 기존 검색 위젯 재사용
      ),
    ),
    const SizedBox(width: 8),
    _SortButton(),   // 최신순 / 마감임박 등
    const SizedBox(width: 8),
    _FilterIconButton(), // 아이콘만 있는 필터 버튼
  ],
)
(2) 카테고리 칩 줄 (가로 스크롤)

카테고리(청년/창업/주거/취업/교육/생활 등)를
SingleChildScrollView(scrollDirection: Axis.horizontal) + Row로 구성.

dart
Copy code
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      const SizedBox(width: 16),
      ...categories.map(
        (c) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(c.label),
            selected: c.isSelected,
            onSelected: (_) => onToggleCategory(c),
          ),
        ),
      ),
      const SizedBox(width: 16),
    ],
  ),
)
(3) 진행 상태 칩 줄 (가로 스크롤 또는 Row)

“진행중만 / 마감 포함 / 마감만” 3개만 가로로 배치.

이 줄도 한 줄만 보이게, 너무 큰 패딩 없이.

dart
Copy code
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      const SizedBox(width: 16),
      ...statusChips,
      const SizedBox(width: 16),
    ],
  ),
)
중복된 검색/칩 제거

현재 아래쪽에 추가로 있는 “검색어를 입력하세요” 입력창이나
또 다른 카테고리/상태 칩 블록은 전부 삭제한다.

필터/정렬 관련 컨트롤은 위 3줄에만 존재하도록 정리.

전체 배치 예시

dart
Copy code
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchSortFilterRow(...),   // (1)
        const SizedBox(height: 12),
        _CategoryChipsRow(...),      // (2)
        const SizedBox(height: 8),
        _StatusChipsRow(...),        // (3)
        const SizedBox(height: 16),
        Text(
          '경북 전체 정책',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ),
  ),
),
_SliverPolicyList(...),
UX 기준

탐색 탭 진입 시, 위쪽 필터 블록 높이가 화면의 절반을 넘지 않도록 구성.

필터 칩이 많아져도 가로 스크롤로 처리되며, 세로로 여러 줄 쌓이지 않는다.

정책 카드 1.5개 이상이 항상 기본 화면에 보이도록 배치(필터 높이를 조정).

────────────────────────────────────
[완료 조건 체크]

보관함 탭에서 비교 기능이 실제로 진입 가능하고,
CompareEntryBar가 글로벌 bottom nav 바로 위에 고정으로 보일 것.

탐색 탭에서 필터 UI가 “검색줄 + 카테고리 한 줄 + 진행 상태 한 줄” 정도로 간결해지고,
정책 리스트가 넓게 보이며 overflow 에러가 재발하지 않을 것.