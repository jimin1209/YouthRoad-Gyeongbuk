TASK30 – Explore(탐색) 탭 레이아웃/스크롤 구조 정리 (RenderFlex overflow 제거)

[베이스라인]
- TASK28(알림 DB/리스트/컨트롤러 정리) + TASK29(알림 스케줄러 게이트웨이 로그 보강)까지 완료된 상태를 기준으로 한다.
- 이번 TASK30에서는 알림/보관함/스토리지/문서 등은 전혀 건드리지 않고,
  오직 Explore(탐색) 탭 레이아웃만 수정한다.

[수정 범위 (강제 제한)]
- 주 파일:
  - lib/features/policy_new/presentation/explore/policy_explore_screen.dart
- 필요 시, 이 화면에서만 사용하는 “탐색 탭 전용 레이아웃 위젯” 파일 일부는 수정 가능.
- 다음은 절대 수정하지 말 것:
  - Explore 관련 application/provider/service 레이어 (쿼리/필터/비즈니스 로직)
  - Storage/Youthcenter/Docs 경로의 파일들
  - TASK28의 3개 파일(isar_service, reminder_list_item, reminder_list_screen)

[증상]
- Explore(탐색) 탭 진입 시, 하단에 "A RenderFlex overflowed by XX pixels on the bottom" 경고와
  노랑/검정 줄무늬가 나타난다.
- 상단 검색/모드/필터/카테고리 영역만 보이고,
  실제 정책 카드 리스트가 보이지 않거나, 공간이 부족해 아래로 넘치며 에러가 발생한다.

[기대 동작]
- 탐색 탭 화면에서:
  - 상단에 검색창 + 모드 칩(전체/내 지역/검색) + 필터/카테고리 영역이 보여야 하고,
  - 그 아래에는 정책 카드 리스트가 스크롤 가능한 형태로 정상 표시되어야 한다.
- 어떤 화면 크기에서도 RenderFlex overflow 경고가 발생하지 않아야 한다.

[구체 작업 지시]

1) 현재 레이아웃 구조 파악
- lib/features/policy_new/presentation/explore/policy_explore_screen.dart 파일을 열고,
  body가 어떻게 구성되어 있는지 먼저 파악한다.
- 특히 다음을 확인:
  - Column 안에 상단 헤더 + 필터 + ListView/Expanded 가 어떻게 배치되어 있는지
  - SingleChildScrollView + ListView 조합으로 이중 스크롤이 생기는 구조는 아닌지
  - Flexible/Expanded 없이 고정 높이 위젯들이 쌓여서 overflow가 나는 구조인지

2) 기본 패턴 확정 (둘 중 하나로 정리)

[패턴 A – Column + Expanded(ListView)]
- Scaffold.body를 다음 구조로 정리한다 (예시):

  Scaffold(
    body: Column(
      children: [
        _ExploreHeader(검색/모드 텍스트/지역 설명),
        _ExploreFilterAndCategoryBar(...),
        Expanded(
          child: _ExplorePolicyListView(...), // ListView.builder or SliverList 포함
        ),
      ],
    ),
  );

- 규칙:
  - 검색/모드/필터/카테고리 위젯들은 Column 상단에 고정.
  - 실제 정책 리스트는 반드시 Expanded 안에 들어가도록 한다.
  - Column 안에서 ListView/CustomScrollView 를 직접 넣지 말고, Expanded로 감싸서 높이를 제한한다.

[패턴 B – CustomScrollView + Sliver 구조]
- 전체를 CustomScrollView로 만들고, 상단 UI는 SliverToBoxAdapter,
  정책 리스트는 SliverList로 구성:

  CustomScrollView(
    slivers: [
      SliverToBoxAdapter(child: _ExploreHeader(...)),
      SliverToBoxAdapter(child: _ExploreFilterAndCategoryBar(...)),
      SliverList(delegate: SliverChildBuilderDelegate(... 정책 카드 ...)),
    ],
  );

- 이 패턴을 사용할 경우, 상단 영역의 Column 안에서 또 스크롤 위젯을 넣지 말고,
  SliverToBoxAdapter 안의 내용은 고정/Wrap 정도로만 구성한다.

→ 두 패턴 중 현재 구조에 더 자연스럽게 맞는 쪽 하나를 선택해서 레이아웃을 재구성한다.

3) RenderFlex overflow 제거
- Column 내부에 있는 자식들을 점검하여,
  - Expanded/Flexible 없이 “자연 높이 + ListView”가 동시에 들어가 있지 않게 만든다.
- 디버그 모드로 빌드 후, Explore 탭 진입 시
  - "A RenderFlex overflowed..." 경고가 더 이상 표시되지 않아야 한다.
- overflow 제거 과정에서:
  - 상단 검색/필터/카테고리 UI가 잘려 보이거나, 리스트가 전혀 나오지 않는 문제가 없도록
    실제 기기 세로 길이를 고려해 테스트한다.

4) 정책 리스트 표시 확인
- ExploreSubMode.all / region / search 각각에 대해,
  - 정책이 존재하는 경우라면 카드 리스트가 실제 화면에 표시되는지 확인한다.
- 데이터/쿼리/필터 로직은 수정하지 않고,
  - 현재 Provider/Repository에서 내려주는 데이터를 그대로 받아서 보여주기만 한다.
- 로딩/에러/빈 상태 위젯이 있다면 기존 동작을 유지하고,
  - 오직 레이아웃(스크롤/높이/배치) 관련 코드만 수정한다.

[Acceptance Criteria]
- Explore 탭 진입 시:
  - 어떤 기기 해상도에서도 RenderFlex overflow 경고가 보이지 않는다.
  - 검색/모드/필터/카테고리 영역과 정책 리스트가 한 화면 안에서 자연스럽게 스크롤된다.
- 정책 카드가 실제 데이터가 있을 때 화면에 보인다.
- 다른 탭(추천/보관함), 알림 화면, Storage/Docs 관련 화면에는 영향을 주지 않는다.
- TASK28/TASK29에서 수정된 알림 관련 파일은 그대로 유지되며, 추가 변경이 없다.

[제약]
- 데이터/비즈니스 로직(Provider/Repository/Service)은 변경하지 않는다.
- Explore/Storage/docs 경로의 다른 파일은 이번 TASK30에서 수정하지 말고, 읽기 전용으로 둔다.
- git 커밋/분리는 사용자가 직접 할 예정이므로, 코드는 레이아웃 안정화에만 집중한다.
