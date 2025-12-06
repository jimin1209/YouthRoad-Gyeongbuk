TASK34 – 정책 비교 진입 위치 이동(탐색 → 보관함) + 비교 바 sticky 처리

[배경]
- 현재 "비교 n개 · 비교 화면 열기" 바가 정책 탐색 탭(추천/탐색) 영역에 노출되어 있다.
- 사용성 상 비교는 "내가 모아둔 정책(보관함)"에서 하는 것이 자연스럽고,
  탐색 탭에서는 스크롤을 조금만 내려도 이 바와 상단 버튼들이 모두 사라진다.

[목표]
1) "비교 n개 · 비교 화면 열기" 바의 주 진입 위치를
   - 탐색 탭이 아닌 **보관함 탭**으로 옮긴다.
2) 보관함 탭에서 해당 비교 바를
   - 리스트 스크롤과 무관하게 **화면 하단에 고정(sticky)** 시킨다.
3) 탐색/추천 탭에서는
   - 정책 카드에서 비교 대상 선택(아이콘/“비교 중” 라벨)은 유지하되,
   - 화면 중간에 뜨는 비교 바는 제거한다.

[수정 범위(후보)]
- 비교 상태/Provider
  - lib/features/policy_new/application/controllers/**compare**_controller.dart
  - lib/features/policy_new/application/providers.dart 내 compare 관련 Provider
- 비교 바 UI
  - lib/features/policy_new/presentation/compare/widgets/**compare_entry_bar.dart (신규)**
  - 또는 기존 "비교 n개 · 비교 화면 열기" 바가 정의된 파일
- 탭별 스크린
  - 추천/탐색 탭: policy_recommend_tab.dart, policy_explore_tab.dart
  - 보관함 탭: policy_saved_tab.dart (정확한 파일명/경로는 실제 리포지토리 기준으로 확인)

[구체 작업]

1) CompareEntryBar 공통 위젯 정의
   - 예시 시그니처:
     - class CompareEntryBar extends ConsumerWidget { ... }
   - 내부 동작:
     - compareState = ref.watch(policyCompareProvider 등)
     - count = 선택된 정책 수
     - count == 0 이면 SizedBox.shrink() 반환 (표시 안 함)
     - count >= 1 이면
       - "비교 {count}개" 텍스트
       - "비교 화면 열기" 버튼(onTap → compare 화면으로 push)
     - 스타일: 현재 구현된 바의 색상/타이포를 재사용

2) 보관함 탭에 sticky 바 배치
   - 보관함 탭 Scaffold/Body 구조를 다음과 같이 변경:
     - Column(
         children: [
           Expanded(child: SavedPolicyListView ...),
           SafeArea(
             top: false,
             child: CompareEntryBar(),
           ),
         ],
       )
   - 이렇게 하면 정책 리스트는 위에서 스크롤되고,
     CompareEntryBar 는 항상 화면 하단(바텀 네비 위)에 고정된다.

3) 탐색/추천 탭 UI 정리
   - 기존에 탐색 탭 상단/중간에서 노출되던
     "비교 n개 · 비교 화면 열기" 바를 제거한다.
     - CompareEntryBar 를 주입하지 않거나, 조건 분기로 막는다.
   - 정책 카드의 비교 아이콘/“비교 중” 라벨은 그대로 유지하여,
     어느 탭에서든 비교 대상 선택은 가능해야 한다.

4) 비교 화면 진입
   - CompareEntryBar 의 "비교 화면 열기" 버튼이
     기존 비교 화면(PolicyCompareScreen 등)으로 정상 네비게이션 되는지 확인한다.
   - 비교 대상 리스트는 탭에 관계없이 공통 Provider 상태를 사용하므로,
     추천/탐색 탭에서 선택한 정책도 보관함 탭 CompareEntryBar 에 그대로 반영되어야 한다.

[Acceptance Criteria]
- 추천/탐색 탭:
  - 정책 카드의 비교 아이콘을 눌러 "비교 중" 상태를 토글할 수 있다.
  - 화면 어디에도 "비교 n개 · 비교 화면 열기" 바는 노출되지 않는다.
- 보관함 탭:
  - 비교 대상이 0개일 때는 하단에 어떤 비교 바도 보이지 않는다.
  - 1개 이상일 때:
    - 화면 하단(바텀 네비 바로 위)에 "비교 n개 · 비교 화면 열기" 바가 항상 노출된다.
    - 정책 리스트를 위/아래로 스크롤해도 비교 바는 사라지지 않는다.
  - "비교 화면 열기"를 누르면 기존 비교 화면으로 진입하며,
    비교 화면에서 선택한 정책들이 정상적으로 렌더링된다.
