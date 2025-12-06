TASK32C – PolicyCompareScreen 네비게이션 및 하단 비교 상태 바 연결

[배경]
- TASK32/TASK32B에서 카드의 "비교 중" 상태와 비교 목록 Provider를 정리하고,
  PolicyCompareScreen 위젯도 추가된 상태다.
- Codex 메시지에 따르면 "라우트나 버튼에서 PolicyCompareScreen()으로 이동하도록 연결"만 남아 있다.
- 현재 실제 화면에서는
  - 어디서 PolicyCompareScreen 으로 들어가는지,
  - 선택한 정책 개수(비교 중 N개)를 보여주는 UI가 없는 상태다.

[목표]
1) 정책 목록 화면(추천/탐색/보관함 중 최소 1곳 이상)에서
   PolicyCompareScreen 으로 들어가는 진입점을 만든다.
2) 비교 목록에 정책이 1개 이상 있을 때,
   화면 하단에 "비교 중 N개 · 비교 화면 열기" 바를 표시하고,
   탭 시 PolicyCompareScreen 으로 이동하게 한다.
3) PolicyCompareScreen 은 navigator 라우트에 정식 등록한다.

[수정 범위(후보)]
- 네비게이션/라우터
  - lib/navigation/app_router.dart 또는 go_router 설정 파일
- 정책 탐색/추천/보관함 화면
  - lib/features/policy_new/presentation/explore/policy_explore_screen.dart
  - lib/features/policy_new/presentation/**/policy_list_screen.dart 등
- 비교 화면
  - lib/features/policy_new/presentation/compare/policy_compare_screen.dart

[구체 작업]
1) 라우트 등록
   - app_router.dart (또는 사용하는 라우터 파일)에
     PolicyCompareScreen 을 위한 라우트(예: '/policy/compare')를 추가한다.
   - 현재 사용하는 라우팅 방식에 맞춰 구현:
     - go_router 사용 시 GoRoute(path: '/policy/compare', builder: …)
     - 일반 Navigator 사용 시 onGenerateRoute 또는 routes 맵에 등록.

2) 하단 비교 상태 바 UI 추가
   - 정책 목록을 보여주는 주요 화면(예: explore/recommend/favorites 리스트)에서
     비교 목록 Provider를 watch 해 "비교 중 정책 개수"를 가져온다.
   - 개수가 0이면 하단 바는 표시하지 않는다.
   - 개수가 1 이상이면 다음 형태의 바를 화면 하단에 표시한다.
     - 예시 텍스트: "비교 중 3개 · 비교 화면 열기"
     - 우측에 화살표 아이콘(>) 또는 "열기" 버튼.
   - 바 전체를 탭하면 PolicyCompareScreen 으로 네비게이션한다.
   - SafeArea 를 고려해 바텀 네비게이션 바와 겹치지 않게 padding 처리.

3) 카드의 비교 버튼과 상태 바 동작 확인
   - 카드에서 비교 버튼을 눌러 비교 목록에 추가할 때,
     하단 비교 상태 바가 즉시 나타나고 개수가 증가하는지 확인한다.
   - 카드에서 비교를 해제하면 개수가 감소하고,
     0개가 되면 바가 자동으로 사라지도록 구현한다.

4) PolicyCompareScreen 진입/이탈 동작
   - 하단 바 또는 다른 진입 버튼에서 PolicyCompareScreen 으로 이동했을 때
     현재 비교 목록이 올바르게 표시되는지 확인한다.
   - 뒤로가기 시 이전 정책 리스트 화면으로 자연스럽게 돌아오도록 한다.

[Acceptance Criteria]
- 비교 목록에 정책이 없을 때는 하단 바가 보이지 않는다.
- 정책 카드의 비교 버튼을 1개 이상 켰을 때:
  - 화면 하단에 "비교 중 N개 · 비교 화면 열기" 바가 나타난다.
  - 이 바를 탭하면 PolicyCompareScreen 으로 이동한다.
- PolicyCompareScreen 에서 비교 목록이 올바르게 표시되고,
  뒤로가기를 눌렀을 때 다시 정책 리스트로 정상 복귀한다.
