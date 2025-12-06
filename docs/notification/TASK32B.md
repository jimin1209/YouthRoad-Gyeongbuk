TASK32B – 정책 비교 상태를 실제 비교 목록/비교 화면과 연결

[배경]
- TASK32에서 policy_card.dart에 한글 문자열(모집중/시작 예정/신청 기간 등)을 복구하고,
  비교 버튼에 "비교 중" 라벨을 추가해 카드 단에서 선택 상태는 보이게 했다.
- 하지만 비교/즐겨찾기 로직 자체는 그대로라,
  여전히 "비교 버튼이 안 눌러지는 느낌 + 비교 정책 UI가 안 보이는 문제"가 남아 있다.
- 목표는 카드의 "비교 중" 상태를 전역 비교 목록 상태와 연결하고,
  별도의 비교 화면에서 선택한 정책들을 한눈에 볼 수 있게 만드는 것이다.

[목표]
1) policy_card.dart의 비교 버튼 상태("비교 중")를
   실제 비교 목록 Provider/StateNotifier와 완전히 연결한다.
2) 선택한 정책이 있을 때 접근할 수 있는 "비교 화면(PolicyCompareScreen)"을 복구 또는 구현한다.
3) 비교 화면에서 선택된 정책들의 주요 속성을 테이블/리스트 형태로 보여준다.

[수정 범위(후보)]
- 비교 상태/컨트롤러
  - lib/features/policy_new/application/controllers/**compare**_controller.dart
  - lib/features/policy_new/application/providers.dart 의 compare 관련 Provider
- 비교 화면
  - lib/features/policy_new/presentation/compare/***/policy_compare_screen.dart
- 정책 카드
  - lib/features/policy_new/presentation/widgets/policy_card.dart (이미 추가된 "비교 중" UI를 전역 상태와 연결)

[구체 작업]
1) 비교 상태 관리 구조 파악
   - "비교 중인 정책 리스트"를 어떤 Provider/StateNotifier가 들고 있는지 확인한다
     (예: policyCompareControllerProvider, comparedPolicyIdsProvider 등).
   - policy_card.dart에서 비교 버튼 onTap 시 어떤 메서드가 호출되는지 추적하고,
     실제로 위 Provider 상태가 변경되는지 확인한다.
   - 상태 갱신이 없거나 로컬 변수만 바뀌는 구조라면,
     onTap에서 compareController.toggle(policyId) 같은 형태로
     전역 비교 상태를 갱신하도록 수정한다.

2) 카드의 isCompared 계산을 Provider 기반으로 통일
   - policy_card.dart에서 isCompared = "전역 비교 목록에 이 policy.id가 포함되어 있는지"로 계산한다.
   - "비교 중" 라벨 및 아이콘 스타일은 isCompared 값에 따라 토글되도록 수정한다.
   - 이렇게 해서 카드 UI와 전역 비교 상태가 항상 일치하도록 만든다.

3) 비교 화면(PolicyCompareScreen) 구현/복구
   - 비교 화면에서 전역 비교 목록 Provider를 watch 하여,
     선택된 정책들의 최소 정보(제목, 분야, 지역, 신청 기간 등)를
     가로/세로 테이블 또는 리스트 형태로 표시한다.
   - 선택된 정책 수가 0개일 때는
     "선택한 정책이 없습니다. 카드의 비교 아이콘을 눌러 비교할 정책을 선택해 주세요."
     라는 빈 상태 문구를 표시한다.

4) 비교 화면 진입 경로 추가
   - 비교 목록에 1개 이상 있을 때,
     화면 하단에 "비교 중 N개 · 비교 화면 열기" 같은 바 또는 버튼을 노출한다.
   - 해당 바/버튼을 탭하면 PolicyCompareScreen 으로 이동한다.
   - 필요하면 Compare 탭/아이콘이 이미 있다면, 그 탭 진입 시에도
     동일한 PolicyCompareScreen 을 보여주도록 정리한다.

[Acceptance Criteria]
- 카드에서 비교 아이콘을 탭할 때마다:
  - "비교 중" 상태가 토글되고,
  - 전역 비교 목록 Provider의 내용도 함께 변경된다.
- 비교 목록에 1개 이상 있을 때:
  - 화면 하단 또는 전용 영역에 "비교 중 N개 · 비교 화면 열기" UI가 나타난다.
  - 이 UI를 눌렀을 때 PolicyCompareScreen 으로 이동한다.
- PolicyCompareScreen 에서:
  - 선택된 정책들의 주요 속성이 표/리스트 형태로 노출된다.
  - 선택된 정책이 0개이면 적절한 안내 문구가 보인다.
