TASK 22 – 보관함(Storage) 탭 고도화
        (즐겨찾기 + 비교 + 알림 통합, 비교 영역 핀치 줌 지원)

[전제]
- TASK 21: 상단 탭이 "추천 / 탐색 / 보관함" 3개 구조로 정리되어 있고,
  보관함(Storage) 탭이 메인 탭 중 하나로 존재한다고 가정한다.
- TASK 20: 탐색(Explore) 탭이 ExploreScreen 하나로 전체/지역/검색 기능을 통합한 상태라고 가정한다.
- 현재 보관함 탭은 임시로 "기존 즐겨찾기 탭 화면" 또는 유사 화면과 연결되어 있을 수 있다.
- 이 TASK의 목표:
  - 보관함 탭 안에 "즐겨찾기 / 비교 / (선택) 알림 요약" 기능을
    하나의 StorageScreen 안에서 섹션 구조로 통합한다.
  - 정책 비교 테이블이 길고 넓어 한눈에 보기 어려운 문제를 해결하기 위해,
    **두 손가락 핀치 제스처(확대/축소)로 비교 영역을 확대·축소하고 드래그 이동할 수 있게** 만든다.
  - 별도의 + / - / 100% 버튼 UI는 추가하지 않는다. (제스처만 사용)

────────────────────────────────────
[1. Scope (수정/추가 범위)]
────────────────────────────────────
아래 파일(또는 동일 역할 파일)만 수정/추가 대상으로 삼는다.

1) StorageScreen (보관함 메인 화면) 파일 – 신규 또는 교체
   - 권장 위치:
     - lib/features/policy_new/presentation/storage/policy_storage_screen.dart
   - 전체 파일 교체/생성 방식으로 구현해도 된다.

2) 보관함 탭 → 화면 매핑부
   - 예시:
     - lib/features/policy_new/presentation/policy_tab_screen.dart
     - lib/navigation/app_router.dart
   - 보관함 탭을 눌렀을 때 StorageScreen 이 사용되도록 연결한다.

3) 보관함 관련 Provider/State 정의부 (필요시)
   - 예시:
     - lib/features/policy_new/application/storage/storage_providers.dart
     - lib/features/policy_new/application/storage/storage_state.dart
   - 기존 즐겨찾기/비교 Provider 를 재사용하되,
     필요하면 StorageScreen 전용 ViewModel/State 를 추가로 정의한다.

※ 이 TASK에서는 Repository/UseCase/알림 예약 로직 등 도메인 레이어는 변경하지 않는다.
※ 기존 FavoriteScreen/CompareScreen 파일은 삭제하지 않고, 참조만 끊고 TODO 로 남긴다.

────────────────────────────────────
[2. 기존 구조 파악]
────────────────────────────────────
1) 즐겨찾기(Favorite) 화면/위젯
   - 키워드: "즐겨찾기", "Favorite", "Bookmark", "관심 정책"
   - 확인:
     - 즐겨찾기 목록 Provider (예: favoritePoliciesProvider)
     - 즐겨찾기 추가/제거 로직 (Controller/Action 등)

2) 비교(Compare) 화면/위젯
   - 키워드: "비교", "Compare", "PolicyCompareScreen"
   - 확인:
     - 비교 대상 선택/저장 Provider (예: compareSelectionProvider)
     - 하이라이트 분석/비교 테이블 UI 구조
     - 현재 진입 경로 (별도 탭 vs 라우팅)

3) (선택) 알림(Reminder) 관련 코드
   - 키워드: "알림", "Reminder", "PolicyReminder"
   - 이 TASK에서는 알림 섹션은 “요약/보기” 수준만 고려한다.

────────────────────────────────────
[3. StorageScreen 개념 설계]
────────────────────────────────────
StorageScreen 은 다음 3개 섹션으로 구성한다:

  섹션 A – 즐겨찾기(Favorites)
  섹션 B – 비교(Compare)   ★ 핀치 줌/드래그 가능한 비교 영역
  섹션 C – (선택) 알림(Reminders) 요약

[3-1] 상단 헤더/요약 영역
- 타이틀: "보관함"
- 서브텍스트:
  - "즐겨찾기한 정책, 비교 중인 정책, 예약된 알림을 한 곳에서 관리해보세요."
- 요약 바(작은 카드):
  - "즐겨찾기 N개 · 비교 M개 · 알림 K개"
  - N/M/K는 아래 Provider 기준:
    - N: 즐겨찾기 정책 수
    - M: compareSelectionProvider 에 담긴 정책 수
    - K: 예약된 알림 수 (알림 Provider 가 있다면)

[3-2] 섹션 A – 즐겨찾기(Favorites)
- 헤더:
  - 제목: "즐겨찾기"
  - 우측 액션:
    - 토글 "진행중만" (기본 ON)
    - 필요하면 "전체 보기" 버튼
- 내용:
  - 진행중 정책 그룹(항상 펼침)
  - 마감된 정책 그룹(기본 접힘, 펼침/접힘 가능)
- 카드:
  - 즐겨찾기 하트 토글 유지
  - 비교 아이콘(↔) 유지 → 누르면 compareSelectionProvider 에 추가
- Empty 상태:
  - 텍스트:
    - "즐겨찾기한 정책이 아직 없어요."
    - "관심 있는 정책에서 하트를 누르면 여기에서 모아볼 수 있어요."
  - 버튼: "정책 탐색하러 가기" → 탐색(Explore) 탭으로 네비게이션
- 데이터:
  - favoritePoliciesProvider 또는 동등 Provider 사용
  - 진행중/마감 그룹핑은 UI 레벨에서 처리해도 되고, Provider 에서 구분해서 내려줘도 된다.

[3-3] 섹션 B – 비교(Compare) + 핀치 줌
- 헤더:
  - 제목: "비교 중인 정책"
  - 우측 액션:
    - "모두 비우기" 버튼 (compareSelectionProvider 초기화)

- 내용: (M = 비교 대상 개수)

  ● M > 0 일 때

  1) 상단 하이라이트 분석 영역
     - 예시:
       - "추천 정책" (추천 점수 가장 높은 정책)
       - "지원 조건이 더 쉬운 정책"
       - "지원금이 더 큰 정책"
     - 기존 Compare 화면의 분석 결과/로직이 있다면 재사용.

  2) 비교 테이블 영역 (핵심: 핀치 줌 + 드래그)
     - 선택된 정책들을 컬럼으로, 주요 항목을 행으로 표시:
       - 신청 기간
       - 지원 대상
       - 지원 내용/혜택
       - 지역
       - 담당 기관
       - (선택) 난이도/경쟁률 등
     - 비교 테이블 전체를 **단일 컨테이너** 안에 넣고,
       그 컨테이너를 두 손가락 제스처로 확대/축소/이동 가능하게 만든다.

     - 구현 권장 방식:
       - Flutter 의 `InteractiveViewer` 위젯 사용:
         - minScale: 0.8 (또는 0.7)
         - maxScale: 1.5 (또는 2.0)
         - panEnabled: true
         - scaleEnabled: true
       - InteractiveViewer.child 에 실제 비교 테이블(가로 스크롤 가능한 Row/Column 조합)을 넣는다.
       - 이렇게 하면:
         - 두 손가락으로 핀치아웃 → 테이블 확대
         - 핀치인 → 테이블 축소 (더 많이 한 화면에 보임)
         - 한 손가락/두 손가락 드래그 → 테이블 내부를 이동(패닝)할 수 있음

     - 스크롤/제스처 충돌 방지:
       - StorageScreen 전체는 기본적으로 세로 스크롤.
       - 비교 영역 안에서는:
         - InteractiveViewer 가 가로/세로 드래그를 우선 처리하되,
         - 스케일이 1.0 이하(기본 크기)이고 더 이상 이동할 내용이 없을 때는
           상위 스크롤(ListView)와 자연스럽게 연동되도록 한다.
         - 필요시 `clipBehavior`, `constrained` 등의 옵션을 조절해 문제를 최소화한다.

  ● M = 0 일 때

  - Empty 상태:
    - "비교할 정책이 없어요."
    - "정책 카드에서 비교 아이콘(↔)을 눌러 최대 3개까지 비교해보세요."
  - 이때 비교 테이블/InteractiveViewer 는 렌더링하지 않아도 된다.

- 데이터 소스:
  - compareSelectionProvider: 선택된 정책 ID 목록
  - compareAnalysisProvider (있다면): 분석 결과
  - 없으면 Selection 리스트를 이용해 PolicyRepository 에서 디테일 가져와 비교 테이블 구성.

[3-4] 섹션 C – 알림(Reminders) (선택)
- 구현 가능할 경우:
  - 헤더:
    - 제목: "다가오는 알림"
    - 우측: "알림 관리" 버튼
  - 내용:
    - 예약된 알림 리스트:
      - "{정책명} – 마감 하루 전 알림 (2025.12.14 10:00)" 형태
      - 각 항목에 "해제" 또는 "관리" 버튼
  - 데이터:
    - policyRemindersProvider 같은 Provider 가 있다면 사용.
- 아직 알림 Provider/구조가 없으면:
  - UI 에서 이 섹션은 숨기거나 "준비 중" 텍스트만 노출.
  - 코드에 TODO:
    - // TODO(TASK 540): 예약된 정책 알림 목록 Provider 추가 후 알림 섹션 구현

────────────────────────────────────
[4. 구현 세부 지시]
────────────────────────────────────
1) StorageScreen 구성
   - ConsumerWidget 또는 ConsumerStatefulWidget 으로 구현.
   - 대략 구조:
     - Scaffold(
         body: SafeArea(
           child: ListView(
             children: [
               Header(타이틀/서브텍스트/요약 바),
               FavoriteSection(),  // 즐겨찾기
               CompareSection(),   // 비교(핀치 줌)
               (옵션) ReminderSection(), // 알림
             ],
           ),
         ),
       )

2) Provider 사용
   - 즐겨찾기: favoritePoliciesProvider
   - 비교: compareSelectionProvider (+ compareAnalysisProvider 있으면 사용)
   - 알림(선택): policyRemindersProvider

3) 상호작용
   - 즐겨찾기 토글:
     - 카드의 하트를 누를 때 기존 로직 그대로 호출.
   - 비교 추가:
     - 카드의 비교 아이콘(↔)을 누르면 compareSelectionProvider 에 추가되고,
       StorageScreen 의 비교 섹션에도 반영.
   - "모두 비우기":
     - compareSelectionProvider 상태 초기화.
   - "정책 탐색하러 가기":
     - BottomNav/TabController 등을 통해 Explore 탭으로 전환.
   - 핀치 줌/드래그:
     - 비교 테이블 영역 전체를 InteractiveViewer 등으로 래핑.
     - minScale ~ maxScale 사이에서 두 손가락 핀치로 확대/축소.
     - 사용자가 두 손가락 제스처로 테이블 전체를 확대하고,
       손가락 드래그로 좌우/상하 이동 가능해야 한다.

4) 기존 Favorite/Compare 화면 정리
   - 기존 FavoriteScreen/CompareScreen 이 있다면:
     - 메인 플로우에서는 더 이상 라우팅하지 않도록 참조 제거.
     - 파일 상단에 TODO:
       - // TODO(TASK 540): StorageScreen 안정화 후 legacy Favorite/Compare 화면 제거 검토

────────────────────────────────────
[5. Acceptance Criteria]
────────────────────────────────────
1) 빌드/런타임
   - flutter analyze / flutter build 에러 없음.
   - 보관함 탭 진입, 즐겨찾기/비교 상호작용 중 런타임 에러 없음.

2) 보관함 상단
   - 보관함 탭 진입 시:
     - 타이틀 "보관함" + 서브텍스트 표시.
     - "즐겨찾기 N개 · 비교 M개 · 알림 K개" 요약 바 표시.
     - N/M/K 는 실제 Provider 상태를 반영.

3) 즐겨찾기 섹션
   - 즐겨찾기가 있을 때:
     - 진행중/마감 그룹 표기.
     - 하트 토글 시 즐겨찾기 상태 즉시 반영.
   - 즐겨찾기가 없을 때:
     - Empty 메시지 + "정책 탐색하러 가기" 버튼 노출.
     - 버튼 클릭 시 Explore 탭으로 이동.

4) 비교 섹션 (핵심: 핀치 줌)
   - 비교 대상(M)이 1개 이상일 때:
     - "비교 중인 정책" 헤더 + "모두 비우기" 버튼 표시.
     - 하이라이트 분석 영역 + 비교 테이블 표시.
   - "모두 비우기" 클릭 시:
     - compareSelectionProvider 상태 초기화,
       비교 섹션이 Empty 상태로 바뀜.
   - 핀치 줌/드래그:
     - 두 손가락으로 비교 영역을 핀치 아웃하면:
       - 테이블이 확대되어 텍스트/셀 크기가 커지는 것이 눈으로 확인 가능.
     - 두 손가락으로 핀치 인하면:
       - 테이블이 축소되어 한 화면에 더 많은 내용이 들어오는 것이 확인 가능.
     - 한 손가락 또는 두 손가락 드래그로:
       - 확대된 테이블을 좌우/상하로 이동 가능해야 한다.
     - 스케일은 설정한 minScale ~ maxScale 범위를 벗어나지 않는다.

   - 비교 대상이 없을 때(M = 0):
     - "비교할 정책이 없어요." 안내 문구 노출.
     - 비교 테이블/InteractiveViewer 는 렌더링되지 않아야 한다.

5) 알림 섹션(구현한 경우)
   - 예약된 알림이 있을 때:
     - "다가오는 알림" 리스트가 정상 표시.
   - 알림 Provider 가 아직 없으면:
     - 섹션 숨김 또는 "준비 중" 안내 + TODO 주석 존재.

6) 레거시 화면
   - 보관함 탭에서 기존 FavoriteScreen/CompareScreen 으로 직접 이동하는 탭/네비게이션이 없어야 한다.
   - 해당 화면들은 코드베이스에 남아있더라도 메인 플로우에서는 사용되지 않는다.

────────────────────────────────────
[6. 제약사항]
────────────────────────────────────
- 이 TASK에서는 다음을 하지 말 것:
  - 추천 탭/탐색 탭 내부 로직/레이아웃 변경
  - 정책 상세/알림 예약/Repository/UseCase 수정
  - API 스펙 변경
- 오직:
  - StorageScreen 신규 구현,
  - 즐겨찾기/비교/(알림) 섹션 통합,
  - 비교 섹션에 핀치 줌/드래그 가능한 비교 뷰 추가,
  - 보관함 탭이 StorageScreen 하나만 사용하도록 네비게이션 수정
  에만 집중한다.
