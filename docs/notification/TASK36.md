TASK36 – Explore 탭 _ModeSelector Row RenderFlex overflow 해결

[배경]
- 로그 기준:
  - "A RenderFlex overflowed by 132 pixels on the right."
  - 에러 위젯: Row @ lib/features/policy_new/presentation/explore/policy_explore_screen.dart:206:12
  - Row 는 _ModeSelector 내부에서 모드 버튼들을 가로로 배치하는 역할.
- 현재 화면 폭(약 328px)보다 Row 자식들의 총 가로폭이 크기 때문에
  오른쪽으로 넘치면서 RenderFlex overflow 경고가 뜬다.

[목표]
1) 어떤 화면 폭에서도 _ModeSelector Row에서 RenderFlex overflow가 발생하지 않도록 한다.
2) "전체 / 내 지역 / 다른 지역 / 검색" 등 모드 버튼이
   - 잘리지 않고,
   - 필요 시 너비를 나눠 가지거나, 가로 스크롤이 가능하게 만든다.

[수정 범위]
- lib/features/policy_new/presentation/explore/policy_explore_screen.dart
  - _ModeSelector 위젯 정의부 (Row가 있는 위치)

[구체 작업]

1) _ModeSelector 구조 파악
   - 관련 코드 위치:
     - Row(
         children: [
           // 전체 / 내 지역 / 검색 / (다른 지역 선택?) 버튼들
         ],
       )
   - children 구성과 padding/margin 을 확인하고,
     텍스트가 긴 버튼(예: "경북 상주시 지역 정책") 때문에 가로폭 초과가 나는지 점검.

2) 가로폭 대응 방식 택1 또는 병행

   옵션 A – Expanded 로 균등 분배
   - Row 안의 각 버튼을 Expanded로 감싸서,
     전체 Row 너비를 균등하게 나누도록 한다.
   - 예시(실제 구현은 파일 전체 기준으로 적용):

     Row(
       children: [
         Expanded(child: _ModeChip(label: '전체', ...)),
         Expanded(child: _ModeChip(label: '내 지역', ...)),
         Expanded(child: _ModeChip(label: '다른 지역', ...)),
       ],
     )

   - label 이 너무 길 경우, Text 에 maxLines: 1, overflow: TextOverflow.ellipsis 지정.

   옵션 B – 가로 스크롤 허용
   - 버튼 수나 텍스트 길이가 동적으로 늘어날 수 있다면,
     SingleChildScrollView + Row 조합을 사용:

     SingleChildScrollView(
       scrollDirection: Axis.horizontal,
       child: Row(
         children: [
           _ModeChip(...),
           _ModeChip(...),
           _ModeChip(...),
           ...
         ],
       ),
     )

   - 이 경우, overflow 는 발생하지 않고 버튼들이 가로로 스크롤 가능해진다.

3) 기존 Sliver/Scroll 구조와의 결합 확인
   - _ModeSelector 는 SliverToBoxAdapter 안쪽 Column → Row 로 구성되어 있다.
   - 위 수정 후에도:
     - 스크롤/슬리버 동작에 영향이 없는지
     - 모드 버튼 탭 시 ExploreViewState.mode 전환이 제대로 동작하는지 확인.

[Acceptance Criteria]
- 디버그 모드에서 Explore 탭 사용 시,
  - 더 이상 "RenderFlex overflowed by XX pixels on the right" 경고가 나오지 않는다.
- 모든 해상도에서 모드 버튼이 잘리지 않고,
  - 필요 시 가로 스크롤 또는 ellipsis 로 자연스럽게 처리된다.
- 기존 모드 전환 로직(전체/내 지역/검색)에는 영향이 없다.
