TASK31 – 정책 비교 버튼 동작/크기 개선 및 비교 탭 UI 복구

[베이스라인]
- TASK28(알림 플로우 정리) + TASK29(알림 스케줄러 로그 보강) + TASK30(탐색 탭 레이아웃/스크롤 정비) 상태를 기준으로 한다.
- 이번 TASK31에서는 정책 데이터 로딩/추천 로직은 변경하지 말고,
  비교 상태 관리(Provider/Controller)와 카드/비교 화면 UI에 한정해서 수정한다.


[배경]
- 정책 카드 우측 상단 비교 아이콘(↔) 탭 시
  - 선택 상태 피드백이 거의 없고,
  - 상단 "비교" 탭에 들어가도 선택한 정책이 보이지 않거나,
    비교 UI 자체가 나타나지 않는 문제가 있다.
- 보관함 탭 캡처 기준, 비교 아이콘 터치 영역이 너무 작아 보인다.

[목표]
1) 카드의 비교 아이콘을 눌렀을 때
   - 비교 후보로 추가/제거가 명확하게 동작하고,
   - 아이콘/카드에 시각적 피드백(선택 상태)이 생기도록 한다.
2) 상단 "비교" 탭 진입 시
   - 선택된 정책 목록과 비교 UI(테이블/리스트)가 항상 일관되게 반영되도록 한다.
3) 비교 아이콘의 터치 영역을 넉넉히 확보해 실제 기기에서 누르기 편하게 만든다.

[수정 범위(우선 후보)]
- 정책 카드 위젯:
  - lib/features/policy_new/presentation/common/policy_card.dart
  - 또는 "bookmark/favorite"와 같이 리스트에 쓰이는 카드 위젯 파일들
- 비교 상태/Provider:
  - lib/features/policy_new/application/controllers/policy_compare_controller.dart
  - lib/features/policy_new/application/providers.dart 안의 compare 관련 Provider
- 비교 화면:
  - lib/features/policy_new/presentation/compare/policy_compare_screen.dart
  - 또는 "compare" 키워드로 검색되는 화면/위젯들

[구체 지시]
1) 비교 상태 관리 구조 점검
   - 현재 비교 대상 목록을 어떤 Provider/StateNotifier가 들고 있는지 확인:
     - 예: policyCompareControllerProvider, selectedPoliciesForCompareProvider 등
   - 비교 아이콘 탭 → 어떤 메서드(toggleCompare, addToCompare, removeFromCompare 등)를 호출하는지 추적.

2) 카드 비교 아이콘 동작 정리
   - 카드 위젯에 다음 패턴을 구현:
     - isCompared: 현재 정책이 비교 목록에 포함되어 있는지 여부를 Provider 기반으로 판단.
     - onTapCompare:
       - 포함 안 되어 있으면 → 비교 목록에 추가
       - 이미 포함되어 있으면 → 비교 목록에서 제거
   - UI 피드백:
     - isCompared == true 인 경우:
       - 아이콘 색이나 배경을 하이라이트
       - 필요 시, 카드 상단에 "선택됨"과 같은 라벨/테두리 추가

3) 비교 탭 UI 연동
   - Compare 탭(스크린)에서:
     - 선택된 비교 목록을 상단에 나열하고,
     - 아래에 비교 테이블/리스트(요약/상태/기간/지원 내용 등)를 출력.
   - 비교 목록이 0개일 때:
     - "선택한 정책이 없습니다. 정책 카드에서 비교 아이콘을 눌러 비교할 정책을 선택해 주세요."
       와 같은 안내 문구 보여주기.

4) 버튼 크기/터치 영역 개선
   - 비교 아이콘을 최소 40x40 영역 안에 배치:
     - IconButton / GestureDetector + SizedBox 등으로 감싸서
       탭 오작동을 줄인다.
   - 시각적으로도 하트 아이콘과 균형 잡힌 크기로 보이도록 조정.

[Acceptance Criteria]
- 보관함/탐색/추천 등에서 카드 우측 상단 비교 아이콘을 탭하면:
  - 아이콘/카드에 선택 상태가 명확히 표현된다.
- 상단 "비교" 탭 진입 시:
  - 선택한 정책들이 비교 목록에 잘 나타나고,
  - 비교 UI(최소한 제목/분야/지역/신청 기간 정도)가 표시된다.
- 비교 아이콘을 여러 번 토글해도 상태가 꼬이지 않고,
  - 리스트/비교 탭 간 상태가 일관된다.
- 실제 기기에서 비교 아이콘이 잘 눌리고, 의도하지 않은 탭 미인식 문제가 줄어든다.
