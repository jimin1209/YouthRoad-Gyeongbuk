TASK41 – 탐색 탭 필터/정렬 실제 동작 + 보관함 비교 진입 바 노출

[목표]
1) 탐색 탭 상단의 검색/필터/정렬/칩 UI를 실제 explore 쿼리 상태와 연결해서 동작하게 만든다.
2) 즐겨찾기(보관함) 탭에서 비교 중인 정책이 있을 때, CompareEntryBar가 하단에 항상 보이게 한다.

────────────────────────────────────
1. 탐색 탭 – 필터/정렬/검색 상태 연결
────────────────────────────────────
[주요 파일]
- lib/features/policy_new/presentation/explore/policy_explore_screen.dart
- (필요 시) lib/features/policy_new/application/controllers/*** (explore 관련 컨트롤러/프로바이더)

[1-1] 탐색 쿼리의 단일 진실(Single Source of Truth) 정리

1) 현재 “정책 탐색”에서 실제 데이터를 가져오는 쿼리/컨트롤러를 찾는다.
   - 예시) policyExploreControllerProvider, policyExploreQueryProvider,
           policyLocalFeedProvider(탐색용) 등.
2) 이 쿼리(또는 컨트롤러)가 갖는 필드/파라미터를 확인한다.
   - keyword
   - regionMode (전체 / 내 지역)
   - category (청년/창업/주거/취업/교육/생활 등 배열 또는 enum)
   - status (진행중만 / 마감포함 / 마감만)
   - sort (최신순 / 마감 임박순 등)

3) 탐색 탭 상단 UI는 이 “쿼리 상태”와만 동기화되도록 만든다.
   - 어떤 위젯도 개별적인 local state로 필터를 따로 들고 있지 않게 한다.

[1-2] SearchSortFilterRow → 컨트롤러에 직접 위임

policy_explore_screen.dart 안의 검색/정렬/필터 관련 위젯이 실제로
쿼리/컨트롤러 메서드를 호출하도록 수정한다.

예시 패턴 (실제 타입/이름은 리포지토리에 맞게 바꿀 것):

```dart
class PolicyExploreScreen extends ConsumerWidget {
  const PolicyExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyExploreControllerProvider);
    final controller = ref.read(policyExploreControllerProvider.notifier);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SearchSortFilterRow(
                  keyword: state.keyword,
                  onKeywordChanged: controller.updateKeyword,
                  onSubmit: (_) => controller.reload(),
                  sort: state.sort,
                  onSortChanged: controller.updateSort,
                  onOpenFilterSheet: () async {
                    final result = await showPolicyFilterBottomSheet(
                      context: context,
                      initial: state,
                    );
                    if (result != null) {
                      controller.applyFilter(result);
                    }
                  },
                ),
                const SizedBox(height: 12),
                _CategoryChipsRow(
                  categories: state.categories,
                  onToggleCategory: controller.toggleCategory,
                ),
                const SizedBox(height: 8),
                _StatusChipsRow(
                  status: state.status,
                  onStatusChanged: controller.updateStatus,
                ),
                const SizedBox(height: 16),
                Text(
                  '경북 전체 정책',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
        _PolicyListSliver(...), // 기존 리스트 부분
      ],
    );
  }
}
※ 핵심:

onChanged / onTap / onSelected 같은 모든 콜백이 controller 메서드를 호출해야 한다.

정렬 버튼이 현재 아무 일도 하지 않는다면, 위처럼 updateSort()를 호출하고 그 안에서 state.copyWith(sort: …) + reload()를 수행하도록 구현한다.

[1-3] 기존 아래쪽 검색/버튼 블럭 제거

현재 스크린 하단 근처에 “검색어를 입력하세요 / 최신순 / 필터” 버튼이 또 있는 경우,
이 블럭은 전부 삭제한다.

검색창은 상단에 1개만 존재.

정렬/필터 버튼도 상단 Row에만 존재.

중복된 위젯이 있으면 사용자가 어디를 눌러야 하는지 헷갈리므로 제거.

[1-4] 필터/정렬 실제 반영 여부 확인 로깅

테스트 편의를 위해 explore 컨트롤러에 디버그 로그를 추가한다.

예시:

dart
Copy code
void updateSort(PolicySort sort) {
  if (state.sort == sort) return;
  debugPrint('[Explore] sort changed: $sort');
  state = state.copyWith(sort: sort);
  reload();
}

void toggleCategory(PolicyCategory category) {
  final updated = _toggleInList(state.categories, category);
  debugPrint('[Explore] categories: $updated');
  state = state.copyWith(categories: updated);
  reload();
}
실행 후 로그캣에서
[Explore] sort changed / [Explore] categories: 로그가 찍히는지,
또 그 직후 실제로 API 쿼리나 로컬 필터가 다시 적용되는지 확인한다.

────────────────────────────────────
2. 보관함(즐겨찾기) 탭 – CompareEntryBar 확실히 노출
────────────────────────────────────
[주요 파일]

lib/features/policy_new/presentation/tabs/policy_feed_tab.dart

lib/features/policy_new/presentation/compare/widgets/compare_entry_bar.dart

[2-1] 즐겨찾기 탭에서 compare 상태 감시

PolicyFeedTab(또는 즐겨찾기 전용 탭 위젯)의 build에서
비교 상태 provider를 감시하고, 즐겨찾기 탭에만 CompareEntryBar를 붙인다.

dart
Copy code
class PolicyFeedTab extends ConsumerWidget {
  const PolicyFeedTab({
    super.key,
    required this.feedType,
  });

  final PolicyFeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareState = ref.watch(policyCompareProvider); // 실제 provider 이름 사용
    final compareCount = compareState.items.length;        // 실제 필드로 수정
    final isBookmarkTab = feedType == PolicyFeedType.favorite; // enum 확인

    final showCompareBar = isBookmarkTab && compareCount > 0;

    debugPrint(
      '[PolicyFeedTab] feedType=$feedType, compareCount=$compareCount, showCompareBar=$showCompareBar',
    );

    return Column(
      children: [
        Expanded(
          child: _PolicyFeedBody( // 기존 리스트/스크롤 전체
            feedType: feedType,
          ),
        ),
        if (showCompareBar)
          CompareEntryBar(
            itemCount: compareCount,
            onOpenCompare: () {
              // 기존 compare 라우트 사용
              // 예: context.pushNamed(AppRoute.policyCompare.name);
            },
          ),
      ],
    );
  }
}
즐겨찾기 탭(보관함)이 실제로 feedType: PolicyFeedType.favorite로
PolicyFeedTab을 사용하고 있는지 확인한다.

만약 다른 enum/탭 위젯을 쓰고 있다면, 보관함 탭만 이 PolicyFeedTab 구조를 사용하게 정리한다.

compareState의 items가 실제로 채워지고 있는지 로그로 확인한다.

PolicyCard에서 비교 토글을 눌렀을 때 compare provider에 잘 추가되는지,
[Compare] add item ... 식의 로그를 provider 또는 notifier에 추가해서 확인.

[2-2] CompareEntryBar 스타일은 유지, SafeArea 하단 적용

기존 CompareEntryBar 구현이 있다면 아래 조건만 확인/수정한다.

SafeArea(top: false, bottom: true)로 감싸서 bottom nav 위에 잘 붙도록 할 것.

너비는 MediaQuery 전체.

높이는 56~72 사이, 내부는 Row(왼쪽 텍스트 / 오른쪽 버튼) 구성.

[2-3] 동작 확인 시나리오

보관함 탭에서 최소 2개 이상의 정책을 “비교 중”으로 설정한다.

로그캣에서:

[Compare] ... (아이템 추가 로그)

[PolicyFeedTab] ... showCompareBar=true 로그가 찍히는지 확인.

이때 화면 하단에 CompareEntryBar가 보이고,
버튼을 눌렀을 때 PolicyCompareScreen으로 이동하면 완료.

────────────────────────────────────
[완료 조건 체크리스트]

탐색 탭에서:

카테고리/진행 상태/정렬 버튼을 누를 때마다 Explore 컨트롤러 로그가 찍힌다.

정책 카드 리스트 내용이 실제로 바뀐다(필터 적용, 정렬 변경 반영).

중복 검색/정렬/필터 버튼 블록은 제거되어 UI가 단순해졌다.

보관함 탭에서:

두 개 이상 정책을 비교 중으로 설정하면 하단에 CompareEntryBar가 보인다.

CompareEntryBar는 스크롤과 상관없이 항상 bottom navigation 바로 위에 고정되어 있다.

CompareEntryBar의 버튼으로 PolicyCompareScreen으로 정상 진입할 수 있다.