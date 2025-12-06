TASK37 – 보관함 CompareEntryBar 표시 조건 보정 + Explore 상단 영역 UX 점검

[배경]
- TASK34에서:
  - CompareEntryBar(“비교 n개 · 비교 화면 열기”)는
    "즐겨찾기(보관함) 탭 하단에만 sticky"로 노출하기로 했으나,
    현재 보관함 탭에서 이 바가 보이지 않는 문제가 있다.
- 또한 Explore 탭에서는 상단 모드/필터/버튼들이
  정책 리스트 스크롤 시 화면 위로 사라져 접근성이 떨어진다.

[목표]
1) 보관함(즐겨찾기) 탭에서 비교 대상이 1개 이상일 때
   CompareEntryBar가 항상 하단에 보이도록 표시 조건/위치를 보정한다.
2) Explore 탭 상단 모드/필터 영역이
   스크롤 시 완전히 사라지지 않도록 UX를 개선한다
   (최소한 모드 선택 영역을 SliverPersistentHeader 등으로 고정하거나,
    다시 접근하기 쉽게 만든다).

[수정 범위]
- lib/features/policy_new/presentation/compare/widgets/compare_entry_bar.dart
- lib/features/policy_new/presentation/tabs/policy_feed_tab.dart
- lib/features/policy_new/presentation/explore/policy_explore_screen.dart
  (상단 영역 스크롤/Sliver 구조 관련)

[구체 작업]

1) CompareEntryBar 표시 조건 재검증
   - CompareEntryBar 내부에서 사용하는 Provider/상태:
     - 선택된 비교 정책 리스트를 어떤 Provider가 제공하는지 확인
       (예: policyCompareControllerProvider, selectedComparePoliciesProvider 등).
   - count 계산 로직:
     - 선택된 정책 수가 1개 이상일 때만 바를 보여주도록 구현되어 있는지 확인.
   - null/empty 처리나, feedType 조건과 동시에 AND 조건이 걸려서 항상 false가 되는지 점검.

2) policy_feed_tab.dart 에서 비교 바 주입 조건 점검
   - 즐겨찾기 탭(feedType == PolicyFeedType.favorite)에서만 CompareEntryBar를 렌더링하는 로직을 확인.
   - 다음 조건 모두를 만족할 때만 CompareEntryBar가 보이도록 정리:
     - 현재 탭: 즐겨찾기(보관함)
     - 비교 대상 개수: 1개 이상
   - Column(
       children: [
         Expanded(child: ...리스트...),
         SafeArea(top: false, child: CompareEntryBar()),
       ],
     )
     패턴으로 sticky 구현이 되어 있는지 확인.

3) Explore 상단 영역 스크롤 UX 개선(최소 설계/부분 구현)
   - ExploreScreen 의 Sliver 구조 점검:
     - SliverAppBar, SliverToBoxAdapter, SliverList 구성 확인.
   - 모드/지역 선택과 핵심 필터(진행중만/마감 포함/마감만)를
     SliverPersistentHeader로 분리하여 pinned = true로 설정하는 방안을 고려:
     - 사용자가 리스트를 내려도 모드/필터는 상단에 남아있도록.
   - 이번 TASK37에서는:
     - 최소한 "_ModeSelector + 상태 필터" 를 하나의 SliverPersistentHeader 로 분리하는 쪽까지 진행.
     - UI가 너무 복잡해지면, TODO(TASK38)로 세부 고도화는 남겨도 된다.

[Acceptance Criteria]
- 보관함(즐겨찾기) 탭:
  - 비교 대상 0개 → 하단 CompareEntryBar 표시 안 됨.
  - 비교 대상 1개 이상 → 하단 CompareEntryBar가 항상 보임.
- CompareEntryBar 의 "비교 화면 열기" 버튼은 PolicyCompareScreen 으로 정상 이동.
- Explore 탭:
  - 정책 리스트를 아래로 스크롤해도,
    최소한 모드 선택(전체/내 지역/검색)과 상태 필터(진행중만/마감 포함/마감만)는
    사용자가 다시 쓰기 어렵지 않은 위치에 유지된다
    (SliverPersistentHeader pinned 또는 동등한 구조).
- 추가 RenderFlex overflow, 레이아웃 깨짐이 발생하지 않는다.
