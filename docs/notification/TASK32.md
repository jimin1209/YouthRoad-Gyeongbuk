TASK32 – 정책 비교 버튼 동작/크기 개선 및 비교 UI 연결 복구

[배경]
- 정책 카드 우측 상단 비교 아이콘(↔)을 눌러도 아무 변화가 없고,
  비교 대상 선택 상태(하이라이트)도, 비교 화면(비교 UI)도 전혀 노출되지 않는다.
- 코드 상에는 비교 도메인/컨트롤러가 존재하지만,
  실제 onTap/Provider/라우트 연결이 끊겨 있는 상태로 보인다.

[목표]
1) 정책 카드의 비교 버튼을 눌렀을 때,
   - 비교 목록에 정책을 추가/제거하고,
   - 아이콘/카드에서 선택 상태가 명확히 보이도록 만든다.
2) 비교 화면(비교 UI)에서 선택한 정책들이 실제로 노출되고,
   주요 속성을 한 눈에 비교할 수 있도록 한다.
3) 비교 버튼의 터치 영역을 넉넉히 확보해 실제 기기에서 누르기 편하게 만든다.

[수정 범위(후보)]
- 정책 카드 위젯
  - lib/features/policy_new/presentation/**/widgets/policy_card.dart
  - 또는 카드 공통 위젯 (하트/비교 아이콘 함께 있는 파일)
- 비교 상태/컨트롤러
  - lib/features/policy_new/application/controllers/**compare**_controller.dart
  - lib/features/policy_new/application/providers.dart 내부 compare 관련 Provider
- 비교 화면
  - lib/features/policy_new/presentation/compare/***/policy_compare_screen.dart 등

[구체 작업]
1) 비교 상태 관리 구조 파악
   - "비교 대상 정책 리스트"를 어떤 Provider/StateNotifier가 들고 있는지 확인한다.
     예: policyCompareControllerProvider, selectedPoliciesForCompareProvider 등.
   - 현재 카드의 비교 아이콘 onTap 이 어떤 메서드(toggle/add/remove)를 호출하는지 추적하고,
     실제로는 호출이 안 되거나, no-op인 지점을 찾는다.

2) 카드 비교 버튼 로직 정리
   - 카드 위젯에 아래 패턴을 구현한다.
     - isCompared: 이 정책이 현재 비교 목록에 포함되어 있는지 Provider 기반으로 판단.
     - onTapCompare:
       - 포함되지 않았다면 → 비교 목록에 추가
       - 이미 포함되어 있다면 → 비교 목록에서 제거
   - UI 피드백:
     - isCompared == true 인 경우
       - 비교 아이콘 색상/배경을 하이라이트 (예: primary 색상)
       - 필요하면 카드 상단 또는 아이콘 주변에 "선택됨" 스타일(테두리/배경) 추가.

3) 비교 화면(Compare 탭/스크린) 연결
   - Compare 화면에서 선택된 정책 목록을 Provider에서 구독하고,
     - 최소한 "제목, 지역, 분야, 신청 기간" 정도는 표/리스트 형태로 표시한다.
   - 선택된 정책 수가 0개일 때:
     - "선택한 정책이 없습니다. 카드의 비교 아이콘을 눌러 비교할 정책을 선택해 주세요."
       라는 안내 문구를 보여준다.
   - 필요하다면 상단 탭 또는 Floating Button 등을 통해 Compare 화면으로 이동하는 진입점을 하나 이상 제공한다.

4) 비교 아이콘 크기/터치 영역 보정
   - IconButton 또는 GestureDetector + SizedBox 를 사용해서
     최소 40x40 이상의 탭 영역을 확보한다.
   - 하트 아이콘과 시각적으로 균형이 맞도록 크기를 통일한다.

[Acceptance Criteria]
- 정책 카드에서 비교 아이콘을 탭하면:
  - 아이콘/카드의 상태가 "선택됨/해제됨" 으로 즉시 바뀐다.
  - Compare 화면에 선택된 정책들이 반영된다.
- Compare 화면에서:
  - 1개 이상 선택 시 비교 표/리스트가 나타난다.
  - 0개 선택 시 적절한 빈 상태 안내가 나타난다.
- 실제 기기에서 비교 아이콘이 잘 눌리고, 잘못된 탭/미인식 문제가 줄어든다.
