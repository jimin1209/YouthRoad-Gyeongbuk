################################################################################
# BLOCK A. 1차 릴리즈 전에 반드시 처리할 핵심 기능 + 안정화 TASK
# (총 6개: Provider 충돌, 필터/정렬, 알림, 카카오맵, 비교 레이아웃, 비교 줌)
################################################################################

TASK_PROVIDER_INIT_CONFLICT_FIX:
  title: "RegionNotifier ↔ PolicyFilterUiStateNotifier 초기화 충돌(Riverpod assert) 제거"

  priority: "critical"

  intent:
    - Riverpod 경고("Providers are not allowed to modify other providers during their initialization")를
      유발하는 구조를 제거한다.
    - RegionNotifier, PolicyFilterUiStateNotifier, 탐색/카카오맵 화면이
      서로 안전하게 연동되도록 provider 의존 관계를 재정리한다.

  scope_of_change:
    - lib/features/policy_new/application/notifiers/region_notifier.dart
      (또는 동등 역할의 RegionNotifier 파일)
    - lib/features/policy_new/application/notifiers/policy_filter_ui_state_notifier.dart
    - lib/features/policy_new/presentation/feed/policy_feed_screen.dart
    - lib/features/map_v2/kakao_map_screen.dart
    - 기타 Region/Filter 관련 provider를 참조하는 파일

  problem_definition:
    - [증상]
      - 정책 탐색 탭 또는 카카오맵 화면 진입 시, 전체 화면이 빨간 에러 화면으로 덮인다.
      - 에러 메시지:
        - Providers are not allowed to modify other providers during their initialization.
        - AutoDisposeNotifierProviderImpl<RegionNotifier, String?> 가
          StateNotifierProvider<PolicyFilterUiStateNotifier, PolicyFilterUiState>를
          building 중에 수정했다고 나옴.
    - [발생 조건]
      - 앱 실행 후 홈/탐색/카카오맵 탭 전환 과정에서 Region/Filter 관련 provider들이 초기화될 때.
    - [기대 동작]
      - 어떤 화면에서든 provider 초기화 중에 다른 provider state를 수정하지 않으며,
        탐색 탭/카카오맵 진입 시 에러 없이 정상적으로 화면이 그려진다.

  requirements:
    - 단일 소스 정의:
      - Region 관련 상태의 단일 source of truth를 명확히 한다.
        - 예: regionProvider(String?) 또는 PolicyFilterUiState 안의 selectedRegion 중 하나를 기준으로.
    - 금지 패턴 제거:
      - RegionNotifier의 build/constructor/init 안에서
        policyFilterUiStateNotifier.notifier의 메서드(setFilter, updateRegion 등)를 호출하는 코드를 제거한다.
      - 반대로 PolicyFilterUiStateNotifier의 초기화 중에 regionProvider를 "수정"하는 코드도 허용하지 않는다.
    - 안전한 연동 방식으로 변경:
      - 방법 A) PolicyFilterUiStateNotifier 안에서 ref.listen(regionProvider, ...)을 사용해
               Region 변경을 감지하고 자기 자신의 state만 갱신한다.
      - 방법 B) UI 레벨(탐색 탭/카카오맵 상단 위젯)에서
               regionProvider를 watch하고, onChanged/onTap 이벤트 시에만
               ref.read(policyFilterUiStateNotifier.notifier)를 호출한다.
      - 어떤 방식을 쓰더라도 "provider build 중 cross-update"가 일어나지 않도록 한다.
    - 순환 의존성 방지:
      - RegionNotifier ↔ PolicyFilterUiStateNotifier가 서로를 동시에 watch/read하지 않도록 구조를 정리한다.
    - 검증:
      - 수정 후, debug 모드에서 동일 경로(탐색 탭 진입, 카카오맵 진입)를 반복 테스트해도
        해당 assert가 다시 발생하지 않아야 한다.

  non_goals:
    - Region 선택 UX(콤보박스/드롭다운) 개선 자체는
      TASK_REGION_SELECTOR_REDESIGN에서 다루며, 여기서는 provider 충돌 해결에만 집중한다.

  acceptance_criteria:
    - [ ] 탐색 탭, 카카오맵 탭 진입 시 더 이상
          "Providers are not allowed to modify other providers during their initialization" 에러가 발생하지 않는다.
    - [ ] Region을 변경해도 필터 UI/데이터가 정상 반영되며, 다른 provider에서 새로운 경고/에러가 발생하지 않는다.
    - [ ] riverpod element.dart 관련 assert가 로그에 찍히지 않는다.

-------------------------------------------------------------------------------

TASK_FILTER_SORT_FIX:
  title: "정책 탐색 탭 진행 상태/정렬/필터 실제 동작 복구"

  priority: "critical"

  intent:
    - 탐색 탭에서 사용자가 선택한 진행 상태(진행중만/마감 포함/마감만),
      정렬(최신순/인기순 등), 검색어, 카테고리 필터가
      실제 정책 목록 데이터와 완전히 일치하도록 복구한다.
    - 필터 시트가 작은 화면에서도 스크롤되어, 항상 '적용' 버튼을 눌러
      필터를 반영할 수 있게 만든다.

  scope_of_change:
    - lib/features/policy_new/application/controllers/*feed*_controller.dart
    - lib/features/policy_new/domain/values/policy_filter.dart
      (또는 정책 필터 역할을 하는 DTO/Value 객체)
    - lib/features/policy_new/data/repositories/*policy*_repository.dart
    - lib/features/policy_new/presentation/feed/policy_feed_screen.dart
    - lib/features/policy_new/presentation/feed/widgets/*filter*.dart
    - 그 외 파일은 위 기능을 연결하는 데 꼭 필요할 때만 최소한으로 수정한다.

  problem_definition:
    - [증상]
      - 탐색 탭 상단에서 '진행중만'이 선택되어 있고,
        요약 문구는 "경북 전체 · 모집중만 · 최신순" 등으로 표시되지만,
        신청 기간이 이미 지난 정책이 함께 노출된다.
      - 정렬 옵션(최신순/인기순 등)을 변경해도 카드 순서가 거의 또는 전혀 바뀌지 않아
        사용자가 정렬 효과를 체감하기 어렵다.
      - 일부 기기에서 필터 시트가 세로 스크롤이 되지 않아,
        하단의 '적용' 버튼이 화면 바깥에 가려져 필터를 적용할 수 없다.
    - [발생 조건]
      - 정책 탐색 탭 진입 → 진행 상태/정렬/카테고리/검색어를 조합해 변경 →
        필터 시트에서 '적용'을 탭하면, UI 요약 문구는 바뀌더라도
        실제 정책 데이터(목록)에는 조건이 반영되지 않거나 반영이 불완전하다.
    - [기대 동작]
      - 진행 상태:
        - '진행중만' 선택 시 오늘 날짜 기준으로
          applyStartDate <= today <= applyEndDate 인 정책만 표시된다.
        - '마감만' 선택 시 today > applyEndDate 인 정책만 표시된다.
        - '마감 포함' 선택 시 진행/마감 정책이 모두 표시되지만,
          UI에서 진행/마감 여부가 명확히 구분된다면 더 좋다.
      - 정렬:
        - '최신순' 기준 필드를 명확히 정의하고(예: 정책 등록일 또는 신청 시작일),
          해당 필드 기준 내림차순으로 정렬된다.
        - '인기순' 등이 있다면, 좋아요/조회수/추천 점수 등 내부 정의에 따라
          일관되게 정렬된다.
      - 필터 시트:
        - 작은 화면에서도 세로 스크롤이 가능하며,
          항상 '닫기' / '적용' 버튼을 볼 수 있고 탭할 수 있다.

  requirements:
    - 진행 상태 필터:
      - 서버 status 코드에만 의존하지 말고,
        정책의 신청 시작일/종료일을 기준으로 로컬에서 한 번 더 필터링한다.
      - 오늘 날짜 계산은 time zone(Asia/Seoul)에 맞게 처리하고,
        DateTime 비교 시 날짜만 비교하는지, 시각까지 포함할지 정책을 명확히 한다.
    - 정렬:
      - PolicyFilter 또는 쿼리 객체에 정렬 기준 필드를 추가/정리하고,
        repository 계층에서 이를 사용해 API 파라미터 또는 로컬 정렬에 반영한다.
      - 정렬 변경 시 항상 페이지 1부터 다시 로딩되도록 한다.
    - 필터 적용 플로우:
      - 필터 시트에서 '적용' 버튼을 누를 때,
        현재 선택된 모든 조건(진행 상태/카테고리/정렬/검색어 등)을 모은
        하나의 PolicyFilter 객체를 생성해 feed controller에 전달한다.
      - feed controller는 이전 결과를 초기화하고, 새 필터로 정책 목록을 다시 요청한다.
    - UI/레이아웃:
      - 필터 시트 root를 SingleChildScrollView 또는 BottomSheet 전용 스크롤 컨테이너로 감싸
        세로 스크롤을 허용한다.
      - 하단 버튼 영역은 항상 화면 안에 고정되도록 SafeArea + Align/BottomSheet 구조를 사용한다.
    - 로깅:
      - 필터 적용 시 실제 쿼리 파라미터를 로깅해, 디버깅이 쉽도록 한다
        (예: [Policy][INFO] fetchPoliciesByQuery(scope: ..., statusFilter: ING_ONLY, sort: LATEST)).

  non_goals:
    - 새로운 필터 항목(예: 복잡한 소득 기준, 학력 조건 등) 추가는 이번 작업에 포함하지 않는다.
    - 추천 탭/보관함 탭의 별도 정렬/필터 구조 변경은 필요할 경우 별도 TASK로 다룬다.

  acceptance_criteria:
    - [ ] '진행중만' 선택 후, 신청 기간이 이미 지난 정책이 탐색 탭 리스트에 나타나지 않는다.
    - [ ] '마감만' 선택 시 today 이후 마감되는 정책이 포함되지 않는다.
    - [ ] 정렬 옵션을 '최신순' ↔ '인기순'으로 여러 번 바꾸면
          카드 순서가 각 기준에 맞게 눈에 띄게 달라진다.
    - [ ] 필터 시트가 어떤 해상도에서도 세로 스크롤이 가능하며,
          항상 '적용' 버튼을 눌러 필터를 적용할 수 있다.
    - [ ] 필터를 변경할 때마다 fetch 로그에 변경된 필터/정렬 값이 반영된 파라미터가 찍힌다.

-------------------------------------------------------------------------------

TASK_NOTIFY_FIX:
  title: "정책 신청 알림 설정 end-to-end 복구 + UI 동기화"

  priority: "critical"

  intent:
    - 정책 상세 화면 및 알림 바텀시트에서 사용자가 선택한 알림 옵션이
      DB/OS 알림 스케줄에 정확히 반영되고, UI에도 즉시 반영되도록 흐름을 정리한다.
    - '알림 옵션 선택 후 화면이 갱신되지 않는 문제'를 해결하고,
      한국어 기준의 신청 기간/마감 텍스트를 일관되게 적용한다.

  scope_of_change:
    - lib/features/policy_new/presentation/detail/policy_detail_bottom_sheet.dart
    - lib/features/policy_new/presentation/reminder/policy_reminder_bottom_sheet.dart
      (또는 알림 옵션 바텀시트 UI)
    - lib/features/policy_new/application/controllers/policy_reminder_controller.dart
      (또는 동등 역할 notifier)
    - lib/data/local/isar/policy_reminder_isar_model.dart
    - lib/data/local/isar/isar_service.dart (알림 관련 쿼리 부분)
    - 알림 스케줄링 관련 Android 코드 (Notification/AlarmManager/WorkManager 등)
    - 공통 텍스트 리소스 (AppStrings 등)

  problem_definition:
    - [증상]
      - 알림 옵션(마감 하루 전/3일 전/7일 전/당일)을 선택하고 '선택 완료'를 눌렀을 때,
        하단 '예약된 알림' 목록과 정책 상세 상단의 요약 문구(예: "알림 설정됨 · 마감 하루 전")가
        즉시 갱신되지 않는다.
      - 알림이 설정되어 있음에도, 상세 화면에 "신청 알림이 꺼져 있어요" 라는 문구가 남아있거나
        반대로 알림을 끄고 나와도 계속 '설정됨'으로 표시되는 경우가 있다.
      - 일부 화면에서 신청 기간이 "Period: 2023-07-25 ~ 2028-12-31" 같이
        영문 라벨 + 영문 포맷으로 표시된다.
    - [발생 조건]
      - 정책 상세 → '신청 알림 설정' 버튼 탭 → 알림 바텀시트에서 옵션 선택/변경 →
        다시 상세 화면으로 돌아오면 UI와 내부 상태가 서로 어긋나 있다.
    - [기대 동작]
      - 알림 옵션 선택/변경/해제 시:
        - DB와 OS 알림 스케줄이 모두 최신 상태로 유지되고,
        - '예약된 알림' 리스트와 상세 화면 요약 문구가 즉시 그 상태를 반영한다.
      - 신청 기간/마감 텍스트는 모두 한국어 포맷으로 통일된다.

  requirements:
    - 상태 단일화:
      - 특정 정책의 알림 상태는 "단일 소스(예: PolicyReminderState + Isar)"에서만 진실을 유지하고,
        다른 화면들은 이 상태를 watch하여 그리기만 한다.
      - 알림 설정/해제/옵션 변경 시 항상 controller/notifier를 통해서만 상태를 변경한다.
    - OS 알림 스케줄:
      - 마감일(DateTime)과 선택한 오프셋(1/3/7일 전/당일)을 이용해
        실제 알림 시간이 올바르게 계산되도록 한다.
      - 기존 알림이 있을 경우 새 옵션 선택 시 먼저 취소(cancel) 후 새로 등록한다.
    - UI 동기화:
      - 알림 바텀시트에서 옵션 선택 후 저장/완료 시,
        notifier의 state를 갱신하고, pop 후 상세 화면이 자동으로 재빌드되도록 한다.
      - '예약된 알림' 섹션은 DB에서 읽은 현재 예약 목록을 그대로 표시한다.
      - 알림이 하나도 없을 경우 안내 문구
        ("아직 알림이 없습니다. 원하는 시점을 선택해 알림을 받아보세요.")가 표시된다.
    - 텍스트/포맷:
      - "Period:" 같은 영문 하드코딩 텍스트를 제거하고, "신청 기간" 한국어 라벨 사용.
      - 날짜 포맷을 yyyy.MM.dd (E) 형태로 통일하고 locale 'ko' 적용.

  non_goals:
    - iOS 백그라운드 푸시/원격 푸시 연동은 이번 작업에 포함하지 않는다
      (로컬 알림 기준으로 동작 확인).
    - 복수 알림(동일 정책에 2개 이상의 서로 다른 시점 알림) 지원은 우선순위에서 제외한다.

  acceptance_criteria:
    - [ ] 알림 옵션 선택 후, '예약된 알림' 리스트와 상세 상단 요약 문구가
          즉시 새 옵션을 반영해 갱신된다.
    - [ ] 알림을 해제한 뒤 상세 화면을 나갔다가 다시 들어와도
          "알림 꺼져 있음" 상태가 유지된다.
    - [ ] 신청 기간/마감 텍스트가 모든 화면에서 한국어 포맷으로 일관되게 표시된다.
    - [ ] 실제 안드로이드 기기에서 선택한 시점(예: 마감 하루 전 11:00)에
          알림이 정상적으로 도착한다.

-------------------------------------------------------------------------------

TASK_KAKAOMAP_CORE_FIX:
  title: "카카오맵 현재 위치/청년센터 마커/카드 연동 핵심 UX 복구"

  priority: "critical"

  intent:
    - 카카오맵 화면에서 내 현재 위치, 반경 원, 청년센터 마커, 하단 카드 리스트가
      서로 연동되도록 복구한다.
    - 현재 위치 버튼이 실제로 동작하고, 버튼 위치도 UX에 맞게 조정한다.

  scope_of_change:
    - lib/features/map_v2/kakao_map_screen.dart
    - lib/features/map_v2/kakao_map_webview.dart
    - lib/features/map_v2/kakao_map_html_builder.dart
    - lib/features/policy_new/presentation/map/youth_center_map_provider.dart
    - 카카오맵 JS Bridge 관련 자바스크립트 코드 (HTML 템플릿 내부)
    - 필요한 경우: 위치 권한/현재 위치 가져오기 유틸

  problem_definition:
    - [증상]
      - 카카오맵 화면에서 청년센터 마커가 보이지 않거나, 깨진 이미지 아이콘으로만 보인다.
      - 현재 위치 버튼을 눌러도 지도 카메라가 내 위치로 이동하지 않고, 아무 반응이 없는 것처럼 보인다.
      - 내 현재 위치는 파란 점으로 표시되는 것 같으나, 반경 원 중심 및 센터 마커와의 관계가 불분명하다.
      - 버튼 위치가 우측 하단에 있어 거리/전국/시군도 컨트롤과 UX적으로 동선이 맞지 않는다.
    - [발생 조건]
      - 하단 탭에서 '카카오맵' 진입 → 지도 로딩 완료 후 확대/축소/이동 →
        현재 위치 버튼, 센터 카드 탭 등을 시도해도 지도/마커가 기대만큼 반응하지 않는다.
    - [기대 동작]
      - 지도 진입 시 내 위치 인근 청년센터 마커와 반경 원이 함께 표시되고,
        현재 위치 버튼을 누르면 카메라가 내 위치로 깔끔하게 이동한다.
      - 하단 센터 카드를 탭하면 해당 마커 위치로 카메라가 이동한다.

  requirements:
    - 현재 위치:
      - 위치 권한이 허용된 상태에서 GPS/네트워크 기반 현재 위치를 가져온다.
      - 현재 위치 좌표를 카카오맵 JS로 전달해 파란 점 + 반경 원 중심을 표시한다.
    - 청년센터 마커:
      - youthCenterMapProvider 또는 동등한 데이터 소스에서
        센터 좌표/이름/ID를 가져와 마커를 생성한다.
      - 마커 아이콘에 사용할 이미지가 유효한 URL/asset인지 확인하고,
        실패 시 fallback 기본 마커를 사용한다.
    - 현재 위치 버튼:
      - 버튼 onTap 시:
        - 위치 권한 체크 및 필요 시 요청.
        - 현재 위치를 다시 가져와(또는 캐시 사용) 카카오맵 카메라를 해당 좌표로 애니메이션 이동.
      - 버튼 위치를 UX에 맞게 우측 하단 → 지도 상단/좌상단 근처 등
        다른 컨트롤과 어울리는 위치로 재배치한다.
    - 카드 ↔ 마커 연동:
      - 하단 센터 카드에 센터 ID/좌표를 포함하고,
        탭 시 JS Bridge를 통해 해당 좌표로 카메라 이동 명령을 보낸다.
      - 필요하다면 해당 마커를 약간 확대/하이라이트 처리한다.

  non_goals:
    - 전국 모든 센터를 한 번에 로딩하는 성능 최적화(클러스터링 등)는 이번 작업에 포함하지 않는다.
    - 경로 안내/네비게이션, 폴리라인 등 고급 기능은 포함하지 않는다.

  acceptance_criteria:
    - [ ] 실제 기기에서 카카오맵 탭 진입 시, 내 위치 + 반경 원 + 인근 청년센터 마커가 보인다.
    - [ ] 현재 위치 버튼을 누르면 지도 중심이 내 위치로 이동한다.
    - [ ] 하단 센터 카드를 탭하면 해당 센터 마커 위치로 카메라가 부드럽게 이동한다.
    - [ ] 버튼 위치가 변경된 레이아웃에서 다른 UI 요소와 겹치지 않고 자연스럽게 보인다.

-------------------------------------------------------------------------------

TASK_COMPARE_LAYOUT_FIX:
  title: "정책 비교 화면 상단 정책 카드 리스트 복구 + 레이아웃 안정화"

  priority: "high"

  intent:
    - 정책 비교 화면에서 상단에 가로 스크롤 정책 카드들이 항상 보이도록 레이아웃을 복구한다.
    - 비교 요약/하이라이트/세부 정보 섹션과 상단 카드 영역이 자연스럽게 함께 보이게 정리한다.

  scope_of_change:
    - lib/features/policy_new/presentation/compare/policy_compare_screen.dart
    - lib/features/policy_new/presentation/compare/widgets/* (특히 상단 카드 리스트 위젯)
    - 비교 상태 provider (compareRepositoryProvider 등)를 사용하는 부분

  problem_definition:
    - [증상]
      - "정책 비교" 화면에서, "비교 중인 정책 N개" 같은 타이틀은 보이지만
        실제 상단 정책 카드(가로로 스크롤되는 카드들)가 보이지 않고,
        아래 "비교 하이라이트" / "요약" / 세부 정보 섹션만 나타난다.
    - [발생 조건]
      - 추천/탐색 탭에서 여러 정책을 '비교'에 추가한 뒤, 비교 진입 바를 눌러 비교 화면으로 이동했을 때.
    - [기대 동작]
      - 상단에 항상 비교 대상 정책 카드들이 가로 스크롤 리스트로 노출되고,
        아래에 비교 요약/하이라이트/세부 정보가 이어서 표시된다.

  requirements:
    - 데이터 바인딩:
      - compareRepositoryProvider(또는 동등 역할 provider)의 ids/list가
        상단 카드 리스트 위젯에 정상적으로 전달되는지 확인한다.
      - compare 리스트가 비어 있지 않은데도 UI 상단이 렌더링되지 않는 경우,
        null/empty 체크 로직을 점검하고 수정한다.
    - 레이아웃:
      - 상단 카드 리스트가 Column/SingleChildScrollView 안에서
        0 높이로 줄어들거나 overflow로 잘리는 구조가 없는지 확인한다.
      - 필요한 경우 SizedBox/ConstrainedBox로 최소 높이를 보장한다.
    - 상태/스크롤:
      - 상단 카드 리스트는 가로 스크롤(ScrollDirection.horizontal),
        하단 섹션은 세로 스크롤 가능하도록 스크롤 구조를 분리한다.
    - 줌 작업과의 연계:
      - 향후 TASK_COMPARE_ZOOM_FIX에서 InteractiveViewer 등을 도입하더라도,
        상단 카드 리스트가 가려지지 않고 항상 보이도록 구조를 설계한다.

  non_goals:
    - 비교 대상 정책의 필드 구성/하이라이트 로직 변경은 포함하지 않는다
      (순수 레이아웃/표시 문제만 해결).

  acceptance_criteria:
    - [ ] 정책 2개 이상을 비교에 추가했을 때, 비교 화면 상단에 정책 카드들이 항상 보인다.
    - [ ] 비교 하이라이트/요약/세부 정보 섹션이 상단 카드 리스트 아래에 자연스럽게 이어져 보인다.
    - [ ] 어떤 해상도에서도 상단 카드가 잘리거나 완전히 사라지는 현상이 재발하지 않는다.

-------------------------------------------------------------------------------

TASK_COMPARE_ZOOM_FIX:
  title: "정책 비교 화면 줌인/줌아웃 제스처 지원"

  priority: "high"

  intent:
    - 정책 비교 화면에서 사용자가 두 손가락 핀치 제스처로
      비교 내용을 확대/축소할 수 있도록 해 작은 화면에서도 가독성을 확보한다.

  scope_of_change:
    - lib/features/policy_new/presentation/compare/policy_compare_screen.dart
    - lib/features/policy_new/presentation/compare/widgets/* (비교 테이블/컬럼 위젯)
    - 공통 확대/스크롤 관련 유틸이 있다면 해당 파일

  problem_definition:
    - [증상]
      - 정책 비교 화면에서 비교 테이블/내용이 고정된 스케일로만 표시되며,
        핀치 줌이 작동하지 않는다.
      - 작은 화면(폰)에서는 텍스트/셀 크기가 작게 느껴지고,
        비교 기능의 체감 품질이 떨어진다.
    - [발생 조건]
      - 정책 카드에서 '비교' 추가 → 하단 비교 진입 바 → 정책 비교 화면 진입 →
        두 손가락으로 확대/축소를 시도해도 내용 크기가 변하지 않는다.
    - [기대 동작]
      - 핀치 제스처로 비교 영역을 1.0~2.5배 사이로 확대/축소할 수 있고,
        확대 상태에서 드래그로 다른 부분을 볼 수 있다.

  requirements:
    - 비교 영역(테이블 또는 카테고리별 행/열)을 InteractiveViewer 또는 유사한 위젯으로 감싼다.
    - minScale, maxScale, boundaryMargin 등을 적절히 설정해 UX가 과도하게 깨지지 않도록 한다.
    - 확대 시 가로/세로 스크롤이 자연스럽게 동작하도록 제스처 우선순위를 조절한다.
    - 비교 대상 정책 수(2개 이상)와 관계 없이 레이아웃 에러(RenderFlex overflow 등)가 발생하지 않도록 한다.

  non_goals:
    - 데스크탑/Web에서의 키보드/마우스 기반 줌 UX(CTRL+휠 등)는 이번 작업에 포함하지 않는다.
    - 비교 항목/필드 구성 변경은 별도 TASK에서 다룬다.

  acceptance_criteria:
    - [ ] 실제 기기에서 정책 비교 화면을 열고 두 손가락으로 핀치 줌 시
          비교 내용이 자연스럽게 확대/축소된다.
    - [ ] 확대된 상태에서 가로/세로 드래그로 다른 열/행을 볼 수 있다.
    - [ ] 비교 대상이 2개 이상일 때도 레이아웃 에러 없이 정상 표시된다.

################################################################################
# END OF BLOCK A
################################################################################
