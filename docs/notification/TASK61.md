TASK_ID: SEARCH_STABILIZATION_V2

WORK_SCOPE:
  - 정책 탐색 탭 전 구간 안정화 및 상태 일치화 작업
  - 상태 연산, UI 라벨링, 캐싱, Empty 상태 처리 일원화

TARGET_FILES:
  - lib/features/policy_new/presentation/search/policy_search_screen.dart
  - lib/features/policy_new/application/search/search_controller.dart
  - lib/features/policy_new/domain/policy_state_utils.dart (신규 생성)
  - lib/ui/common/empty_result_view.dart (신규 생성 또는 확장)

OBJECTIVE:
  1) 필터 선택 상태, 검색 쿼리, 화면 노출 상태 간의 완전 일치
  2) 동일 조건 재조회 시 캐시 활용, 조건 변경 시 강제 갱신
  3) 빈 상태 UI 일관 표현 및 overflow 제거

REQUIRED IMPLEMENTATIONS:

  [1] State Resolution Unification
  - 아래 기준으로 상태 계산 함수를 domain layer에 정의할 것
    resolvePolicyState(DateTime now, DateTime endDate) → PolicyActiveState
  - 기준:
      endDate < today       → closed
      0 ≤ D-Day ≤ 3         → closingSoon
      endDate > today       → active

  - UI에서 closingSoon은 active 그룹에 포함하되,
    라벨링 시 강조 노출 구조 유지

  [2] Filtering Rule Standardization
  - 필터칩 선택값과 내부 필터링 조건을 다음 규칙으로 강제 매핑
      진행중만  → active만 반환
      마감 포함 → active, closingSoon, closed 전체 반환
      마감만    → closed만 반환

  - 검색 조건 프로바이더에서 동일 기준으로 필터링 사용

  [3] Unified Search Key Formation
  - 다음 key 형태로 캐싱 key를 구성할 것
      search:{regionCode}:{filterCode}:{orderCode}

  - 조건 변경 시 캐시 무효화
  - 동일 조건 재조회 시 timestamp ≤ 120초면 캐시 사용

  [4] Unified Label Rendering
  - 현재 조건 표시, 빈 상태 안내 등 모든 텍스트는 아래 함수로 처리
      SearchLabelBuildContext.makeLabel(
        regionName, filterLabel, sortLabel
      )

  - 노출 예시:
      “경북 구미시 · 진행중 상태 · 최신순”
      “경북 포항시 · 마감된 정책 · 마감 임박 우선순”

  - filterLabel 변환 규칙:
      active        → “진행중”
      closingSoon   → “마감 임박”
      closed        → “마감된 정책”

  [5] Empty State Standardization
  - Empty 상태 화면은 다음 문구만 노출
      ① “조건에 맞는 정책이 없습니다.”
      ② “검색 조건(지역/상태/정렬)을 변경해보세요.”

  - 아래 문구는 절대 노출 금지
      “결과가 최신입니다.”
      “동일 조건입니다.”
      “최근 결과를 가져오는 중입니다.”

  [6] Overflow Protection
  - 빈 상태/조건 텍스트/요약 표시가 포함된 상태에서도
    overflow 발생하지 않도록 scroll container 적용
  - SafeArea(bottom: true) 적용
  - 예상 환경:
      Android 해상도 640×360급, 폰트 스케일 115%에서
      경고 표시 없어야 함

TEST_ACCEPTANCE_CRITERIA:
  ✔ 동일 지역 & 동일 상태 & 동일 정렬 기준일 때
    상세 화면 정책과 탐색 결과 수가 반드시 일치할 것

  ✔ 조건 변경 시 API 재조회 수행
     (ex: 구미 → 포항 변경 시 구미 캐시 반영 금지)

  ✔ Empty 상태에서도 overflow 로그 및 yellow stripes 미출현

  ✔ 필터칩 선택 상황과 하단 조건 표시가 항상 동일 값일 것

  ✔ closingSoon 정책은 active 조건 조회 시 반드시 포함될 것

DELIVERABLES:
  - 신규 domain util 1개
  - 공용 EmptyView 1개
  - 검색쿼리 캐시 Key 생성 모듈 적용
  - acceptance 검증 가능한 화면 캡쳐 4세트
