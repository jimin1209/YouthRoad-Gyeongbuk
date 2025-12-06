TASK 514 – ExploreScreen 기본 뼈대 생성 + 기존 "전체 정책" 화면 이관

[목표]
- 탐색(Explore) 탭에서 사용할 새로운 ExploreScreen 을 만들고,
  기존 "전체 정책" 탭 화면(ALL 탭)을 이 ExploreScreen 안으로 옮긴다.
- 이 단계에서는 아직 "내 지역 / 검색" 모드는 구현하지 않고,
  ExploreScreen 이 "전체 모드 (경북 전체 정책 리스트)"만 보여주도록 한다.
- 이후 TASK 515~ 에서 내 지역/검색 모드, 필터 칩 등을 확장할 수 있도록 기반만 만들어 둔다.

────────────────────────────────────
[1. Scope (수정/추가 범위)]
────────────────────────────────────
1) 새로운 ExploreScreen 파일 생성
   - 권장 위치:
     - lib/features/policy_new/presentation/explore/policy_explore_screen.dart
   - 전체 파일 신규 생성.

2) 탐색 탭 → 화면 매핑 수정
   - 예시:
     - lib/features/policy_new/presentation/policy_tab_screen.dart
     - lib/navigation/app_router.dart
   - 탐색(Explore) 탭을 눌렀을 때 기존 ALL 화면이 아닌,
     새로 만든 ExploreScreen 으로 이동하도록 수정.

3) 기존 "전체 정책" 탭 화면
   - 예시 이름:
     - PolicyAllScreen, AllPolicyScreen, PolicyListAllTab 등
   - 이 화면이 하고 있던 "전체 정책 리스트" UI/로직을
     ExploreScreen 안으로 옮기거나 재사용 위젯으로 분리한다.
   - 이 단계에서는 레거시 화면 파일을 삭제하지 말고, 참조만 끊는다.
     - // TODO(TASK 520): Explore 탭 고도화 완료 후 legacy ALL 화면 제거 검토

────────────────────────────────────
[2. ExploreScreen 설계 (이번 단계 버전)]
────────────────────────────────────
1) 기본 구조
   - StatelessWidget 또는 ConsumerWidget 으로 구현.
   - scaffold 구조 예:
     - Scaffold(
         appBar: AppBar(title: const Text('탐색')),
         body: Column(
           children: [
             // 상단 검색 바 (이번 단계에서는 동작 안 해도 됨)
             // 상단 간단 상태 텍스트
             // Expanded(child: 기존 전체 정책 리스트),
           ],
         ),
       )

2) 상단 검색 바 (이번 단계 – 껍데기만)
   - TextField 또는 InkWell 박스로 대체:
     - hint: "검색어를 입력하거나 태그를 선택해보세요."
   - onTap / onChanged 는 TODO 정도만 남겨두고,
     아직 실제 검색 기능은 구현하지 않는다.
   - 이 바가 있는 상태에서도 기존 전체 리스트가 잘 보이는지만 확인.

3) 상태 텍스트
   - 검색어/필터가 아직 없어도,
     상단에 한 줄 텍스트를 노출:
     - 예: "경상북도 전체 정책"
   - 이후 TASK 520에서 "내 지역/검색 모드"가 들어가면 여기에 건수/상태를 붙일 예정.

4) 정책 리스트 영역
   - 기존 "전체 탭" 화면에서 쓰던 리스트/위젯을 최대한 그대로 가져온다.
   - 가능하면 "정책 리스트" 부분을 별도 Widget/함수로 추출해서,
     ExploreScreen 안에서 재사용하는 식으로 구성한다.
   - 이 단계에서 리스트 동작은 기존 ALL 탭과 동일해야 한다:
     - 페이징/스크롤/탭 → 상세 진입까지 그대로.

────────────────────────────────────
[3. 구현 세부 지시]
────────────────────────────────────
1) 기존 ALL 화면 코드 재사용
   - 현재 "전체 정책" 탭에서 사용하고 있는 화면/위젯을 찾아서:
     - 빌더 로직(AsyncValue<List<Policy>> 처리, 로딩/에러/Empty UI 등)을
       ExploreScreen 으로 옮기거나 별도 위젯으로 추출.
   - 이 과정에서 Provider/Repository 호출 방식은 변경하지 않는다.

2) 탐색 탭 연결 변경
   - TASK 511 이후, 탐색(Explore) 탭이 임시로 기존 ALL 화면에 연결되어 있다면:
     - 그 연결을 ExploreScreen() 으로 교체한다.
   - 이 시점에는:
     - ExploreScreen 의 리스트가 "그 전 ALL 탭과 똑같이 보이는지"만 확인하면 된다.

3) TODO 남기기
   - ExploreScreen 안에 아래와 같은 TODO 주석을 추가:
     - // TODO(TASK 515): ExploreSubMode 도입 (all/region/search)
     - // TODO(TASK 516): 내 지역/다른 지역 선택 칩 및 상태 텍스트
     - // TODO(TASK 517): 검색어 입력/검색 모드 전환
   - 기존 ALL 화면 파일 상단에는:
     - // TODO(TASK 520): ExploreScreen 안정화 후 legacy ALL 화면 제거 검토

────────────────────────────────────
[4. Acceptance Criteria]
────────────────────────────────────
1) 빌드/런타임
   - flutter analyze / flutter build 기준 에러가 없어야 한다.
   - 탐색 탭 진입 시 런타임 에러가 없어야 한다.

2) UI
   - 정책 메인에서 "탐색" 탭을 누르면:
     - 새 ExploreScreen 이 열린다.
     - 상단에 검색 바(동작 X) + "경상북도 전체 정책" 정도의 텍스트가 보인다.
   - 그 아래에 기존 "전체 탭"과 동일한 전체 정책 리스트가 보인다.

3) 동작
   - 리스트 스크롤, 당겨서 새로고침(있다면), 정책 카드 탭 → 상세 진입 등
     기존 ALL 탭에서 되던 동작이 ExploreScreen 에서도 똑같이 동작해야 한다.
   - 추천/보관함 탭 기능이나 다른 탭의 동작에는 영향을 주지 않아야 한다.

────────────────────────────────────
[5. 제약사항]
────────────────────────────────────
- 이 TASK에서는 다음을 하지 말 것:
  - 내 지역/다른 지역 모드 구현
  - 검색 로직/검색 Provider 구현
  - 정렬/필터 기능 변경
- 오직:
  - ExploreScreen 기본 뼈대 생성,
  - 기존 전체 정책 리스트를 ExploreScreen 으로 이관,
  - 탐색 탭이 ExploreScreen 을 사용하도록 네비게이션만 수정
  에만 집중한다.
