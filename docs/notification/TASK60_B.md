################################################################################
# BLOCK B. 1차 릴리즈 이후 UX/디자인 개선 TASK
################################################################################

TASK_POLICY_DETAIL_UI_POLISH:
  title: "세부 정책 화면 버튼/레이아웃 일관성 정리"

  priority: "normal"

  intent:
    - 정책 상세 화면 상단의 주요 버튼들(찜/비교/알림/신청 페이지 열기)을
      크기와 정렬이 일관된 컴포넌트로 정리해, 화면 전체의 완성도를 높인다.
    - 세부 정보 섹션(지원 대상/신청 기간/신청 방법 등)의 타이포/간격도 정돈한다.

  scope_of_change:
    - lib/features/policy_new/presentation/detail/policy_detail_bottom_sheet.dart
    - lib/features/policy_new/presentation/detail/widgets/* (버튼/헤더/섹션 위젯)
    - 공통 버튼 스타일 정의 파일 (theme/components 등)

  problem_definition:
    - [증상]
      - 정책 상세 상단 버튼들의 가로/세로 크기, 패딩, 아이콘/텍스트 정렬이 들쭉날쭉하다.
      - 일부 정책에서 버튼 텍스트 길이에 따라 높이가 달라져 화면이 어수선해 보인다.
    - [발생 조건]
      - 다양한 정책 상세 화면을 열어보면, 알림/찜/비교/신청 버튼이 카드마다
        약간씩 다른 느낌으로 보인다.
    - [기대 동작]
      - 모든 정책 상세 화면에서 버튼 크기/정렬/폰트가 통일되어 일관된 UI를 제공한다.

  requirements:
    - 상단 버튼들을 공통 위젯(예: PolicyActionButton)으로 추출하고,
      동일한 높이/패딩/BorderRadius/폰트 스타일을 적용한다.
    - 텍스트 길이가 달라도 아이콘/레이블 정렬이 맞도록 Flex/Align 설정을 조정한다.
    - 섹션 간 간격, 제목/내용 타이포(폰트 크기/두께)를 디자인 가이드에 맞게 통일한다.

  non_goals:
    - 새로운 기능 버튼 추가(예: 공유/메모 등)는 이번 작업에 포함하지 않는다.

  acceptance_criteria:
    - [ ] 서로 다른 3개 이상의 정책 상세 화면을 비교했을 때,
          상단 버튼들의 높이/패딩/정렬이 동일하게 보인다.
    - [ ] 디자인 시안(또는 기준 화면)과 육안 비교 시 큰 차이가 없다.

-------------------------------------------------------------------------------

TASK_REGION_SELECTOR_REDESIGN:
  title: "탐색 탭 내 지역 버튼 제거 + 지역 콤보박스/드롭다운 도입"

  priority: "low"

  intent:
    - 현재 UX상 실효성이 떨어지는 '내 지역' 버튼을 제거하고,
      사용자가 원하는 시·군을 명시적으로 선택할 수 있는 콤보박스/드롭다운 UI로 개선한다.

  scope_of_change:
    - lib/features/policy_new/presentation/feed/policy_feed_screen.dart
    - lib/features/policy_new/presentation/feed/widgets/*region*.dart
    - lib/features/policy_new/domain/values/policy_filter.dart (지역 필터 정의)
    - 지역 리스트 상수/데이터 파일 (예: region_constants.dart)

  problem_definition:
    - [증상]
      - 탐색 탭 상단의 '내 지역 (경북 전체)' 버튼이 실제로는 지역을 바꾸는 기능 없이,
        UX적으로도 실용성이 거의 없다.
    - [발생 조건]
      - 탐색 탭 진입 → '내 지역' 버튼을 눌러봐도 사용자가 원하는 시·군을
        명확히 선택할 수 없다.
    - [기대 동작]
      - 사용자가 도/시·군(예: 경북 전체, 포항, 경주, 구미 등)을
        명시적으로 선택할 수 있는 콤보박스/드롭다운을 제공한다.

  requirements:
    - '내 지역' 버튼을 제거하고, 지역 선택 콤보박스/드롭다운 컴포넌트를 추가한다.
    - 기본 값은 "경북 전체"로 두되, 선택 목록에 주요 시·군을 포함한다.
    - 선택된 지역은 PolicyFilter의 region 필드에 반영되고,
      필터 요약 문구에도 포함된다 (예: "구미 · 진행중만 · 최신순").
    - 지역 변경 시 필터/정렬 변경과 동일하게 페이지를 리셋하고 목록을 새로 로딩한다.
