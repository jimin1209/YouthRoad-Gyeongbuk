#==============================================================================
# TASK 51 – Flutter UI 리뉴얼 1차 정비 (High Fidelity Version)
#==============================================================================

SYSTEM DEFINITION:
- YouthRoad App UI 전 영역에 대해 시각 구조·테마·컴포넌트·레이아웃을 표준화하고,
  이를 코드 수준에서 강제 가능한 공통 파일들과 UI 레이아웃 구조로 정비한다.

PROBLEM DEFINITION:
1) UI hierarchy 모호
2) 재사용 가능한 UI 컴포넌트 부재
3) CTA 영역 위치 일관성 부족
4) 전역 spacing, typography 규칙 불통일

SCOPE (THIS TASK ONLY):
1) 신규 공통 UI 리소스 생성 + 적용 가능한 초기 화면 적용
2) 기존 코드 삭제 금지 — 수정 또는 대체만 수행
3) Pages affected in this step:
   - ExploreTab
   - CompareEntryBar
   - PolicyDetailBottomSheet

OUTPUT REQUIREMENTS:
- 반드시 아래 신규 파일을 생성하고 정의해야 한다
  (내용 전체 제공 — placeholder 금지)

  1) lib/ui/theme/app_theme.dart
  2) lib/ui/theme/app_text.dart
  3) lib/ui/theme/app_spacing.dart
  4) lib/ui/theme/app_colors.dart
  5) lib/ui/components/app_card.dart
  6) lib/ui/components/app_button.dart
  7) lib/ui/components/app_divider.dart
  8) lib/ui/components/app_section_title.dart
  9) lib/ui/layout/app_screen_container.dart
  10) lib/ui/layout/app_floating_bar.dart

MANDATORY DESIGN RULES:
- Padding horizontal = 16px
- Section spacing vertical = 24px
- Card radius = 16px
- Button radius = 12px
- BottomSheet radius = 24px
- Divider opacity = primary.withOpacity(0.2)
- TextStyle 직접 선언 금지 (app_text만 사용)

ACTUAL IMPLEMENTATIONS REQUIRED:
[a] ExploreTab 리팩토링
    목적:
      - 정책 리스트의 시각 hierarchy 재구성
      - Header → Summary → Card List 구조로 수정

[b] CompareEntryBar 변경
    변경 방식:
      - Floating Style Bar
      - height = 56
      - radius = 20
      - elevation = 2
      - 새로운 layout 파일(app_floating_bar.dart) 기반 적용

[c] PolicyDetailBottomSheet 시각 구조 개선
    포함 요소:
      - Sticky CTA Zone
      - 정보 블럭화 (지원 대상 / 신청 기간 / 신청 방법 등)

CODING RULES:
- 변경되는 각 파일은 전체 파일 단위로 제공할 것
- 기존 파일에 partial patch 금지 (full code 제공)
- Provider 호출/구조 변경하지 말 것
- 레거시 코드 삭제 금지
- import 최소화: app_theme/app_text/app_spacing 기반 구조만 사용

ACCEPTANCE CRITERIA:
[PASS 조건]
- 화면 3개에 신규 UI 공통 컴포넌트 기반 적용 완료
- TextStyle 직접 생성 금지
- paddingHorizontal=16이 전체에서 유지됨
- CompareEntryBar가 floating 형태로 동작함

[FAIL 조건]
- 기존 UI 구조가 유지된 경우
- 신규 Theme 파일 미생성
- 공통 컴포넌트 없이 기존 Container 기반 UI 유지
- spacing 또는 typography 직접 선언 사용

PROCEED NOW AND RETURN:
1) 신규 파일 10개 전체 본문 제공
2) ExploreTab 전체 파일 제공
3) CompareEntryBar 전체 파일 제공
4) PolicyDetailBottomSheet 전체 파일 제공
5) 모든 파일의 full content만 반환 (설명 금지)

#==============================================================================
