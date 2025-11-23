📄 docs/debug_issue_v3.md (최종 완성본 — YouthRoad Style 포함)
🔷 YouthRoad Debug System — Issue Spec (v3, Complete Edition)
본 문서는 debug-system 브랜치 전용 Debug Framework 개발 사양서이며
Codex는 이 문서를 절대 기준으로 작업한다.

1. 🔥 Branch Policy (브랜치 절대 규칙)
브랜치명: debug-system

1) debug-system 브랜치에서만 작업한다.
2) main / master / work 브랜치는 절대 수정 금지.
3) Issue 순서:
   Issue #6 → #7 → #8 → #9 → #10
4) “다음 이슈 진행” 명령 없으면 절대 다음 Issue로 넘어가지 않는다.
5) Allowed Files 외 파일 수정 시 RULE VIOLATION.
6) Debug 기능은 Debug Mode에서만 작동.
7) Release Mode(kReleaseMode)에서는 UI/기능 100% 비활성.
8) 기존 YouthRoad 앱 로직/페이지/기능/테마를 절대 변경해선 안 됨.
2. 📁 Allowed Files (Debug System 전체 공통)
lib/debug/**                     → 생성/수정 가능
lib/main.dart                    → 최소 수정 가능
lib/app.dart                     → 최소 수정 가능
lib/core/api/**                  → Issue #9용 최소 수정 가능
Unity 통신 관련 파일            → Issue #10 최소 수정 가능
docs/debug_issue_v3.md           → 참조 전용
⚠ Allowed Files 외 파일은 한 줄도 수정 금지.

3. 📁 Debug Template Structure (Issue #6 초기에 자동 생성됨)
lib/debug/
    debug_button.dart
    debug_overlay.dart
    debug_provider_tracker.dart
    debug_toast.dart
    debug_network_logger.dart
    debug_unity_logger.dart
    debug_wrapper.dart
4. 🔷 Issue #6 — Global Debug Framework Scaffolding
🎯 Problem
실기기에서는 flutter run 로그 확인 불가

앱 내부에서 상태/오류/네트워크/Unity 로그를 볼 수 없음

🎯 Goal
디버그 모드에서만 작동하는 Global Debug Framework 구축

YouthRoad 스타일 기반의 Floating Debug Button + Overlay 기본 생성

📌 Allowed Files (Issue #6 전용)
lib/debug/**
lib/main.dart
lib/app.dart
📌 Implementation Guideline
🔹 DebugWrapper
App 전체를 감싸며 Debug Button + Debug Overlay 관리

state: overlayVisible(bool)

🔹 DebugButton
오른쪽 하단 floating mini button

Debug 모드에서만 보임

YouthRoad 스타일 적용 (Color Guide는 아래 UI/UX 가이드 참고)

🔹 DebugOverlay
처음에는 빈 화면(“EMPTY OVERLAY”)

AppBar 포함

#7~#10 패널이 이 영역에 삽입될 수 있는 구조로 설계

🔹 main.dart
기존 App 구조 절대 손대지 말고 아래처럼 최소 변경만 허용:

return DebugWrapper(
    child: const App(),
);
✔ Acceptance Criteria
Debug 모드에서만 플로팅 버튼 표시

버튼 클릭 시 Overlay open/close 동작

Overlay 내부는 “EMPTY OVERLAY”만 표시

Release 모드에서는 UI 0%, 기능 0% 노출

5. 🔷 Issue #7 — Provider Status Live Tracker
🎯 Goal
Riverpod Provider들의 상태(loading/data/error)를 실시간으로 Overlay에 표시

Allowed Files
lib/debug/debug_provider_tracker.dart
lib/debug/debug_overlay.dart
Acceptance Criteria
Provider 목록 자동 갱신

Error Provider는 강조 표시

Release Mode에서는 절대 작동하지 않음

6. 🔷 Issue #8 — Provider Error → Toast Alert
Goal
Provider에서 error 발생 시 Debug Toast로 즉시 표시

Allowed Files
lib/debug/debug_toast.dart
lib/debug/debug_provider_tracker.dart
Acceptance Criteria
error 발생 → 1회 Toast 출력

Release Mode 금지

throttle 적용 (중복 방지)

7. 🔷 Issue #9 — Network Inspector + 정책/기관 API Debug Tracker
Goal
모든 API 요청 기록

정책 API/기관 API 필터 제공

Allowed Files
lib/debug/debug_network_logger.dart
lib/core/api/** (최소 변경)
lib/debug/debug_overlay.dart
Acceptance Criteria
Debug Overlay에 Network 탭 생성

정책/기관 API 필터 정상 동작

Release 모드에서는 기록 금지

8. 🔷 Issue #10 — Unity Hybrid Debug Panel
Goal
Unity → Flutter 로그 수신 및 실시간 표시

Allowed Files
lib/debug/debug_unity_logger.dart
Unity MethodChannel 관련 파일(최소)
lib/debug/debug_overlay.dart
Acceptance Criteria
Unity 활성 화면에서 이벤트 정상 출력

Flutter/Unity Log 구분

Release 모드 완전 차단

9. 🔷 YouthRoad Debug Panel UI/UX Style Guide
(Codex가 반드시 따라야 하는 디자인 가이드)

Debug Panel은 YouthRoad 앱과 완전히 동일한 톤앤매너를 유지해야 한다.

🎨 Color Palette (YouthRoad 스타일)
용도	색상
Primary	#4D8AF0 (블루)
Primary Light	#A8C5FF
Background	#F3F6FB
Panel Surface	#FFFFFF
Danger/Error	#FF4D6D
Divider	#E2E8F0
🧩 Component Style
🔹 Floating Debug Button
배경색: Primary (#4D8AF0)

아이콘: white

그림자 최소

크기: mini (radius: 22~24)

위치: bottom 24, right 24

🔹 Debug Overlay Panel
배경: rgba(0,0,0,0.55) 반투명

상단 AppBar:

배경: Panel Surface White

글씨: Primary

아이콘: Primary

높이: 52

Divider: color #E2E8F0

🔹 탭 영역 (Network / Provider / Unity 등)
TabBar 스타일:

선택됨: Primary underline (3px)

미선택: Grey #A0AEC0

텍스트 Weight: SemiBold

🔹 Provider Console 스타일
정상 Provider: Grey text

Error Provider:

텍스트: Error Color (#FF4D6D)

좌측 Error Indicator Dot 추가

Row Height: 40~44

🔹 Network Inspector
요청/응답 카드 Style

배경: White

border: #E2E8F0

radius: 10

내부 padding: 12

정책/기관 구분

정책 API: 블루 작은 Badge (#4D8AF0)

기관 API: 보라 Badge (#7A63F1)

🔹 Unity Log 탭
Unity 이벤트 로그 each row 시안

prefix: [UNITY]

색상: Primary Light (#A8C5FF)

텍스트: white

로그 텍스트: monospace font 적용

🧭 Interaction / Motion Guide
Overlay open/close

Fade + Slide Down 120ms

Button ripple 효과 최소화

Panel 전환 애니메이션:

TabBar 기준 Fade 80ms

10. 🟥 RULE VIOLATION 기준
다음이 발생하면 Codex는 즉시 아래 문구를 출력하고 중단해야 한다:

RULE VIOLATION — Attempted to modify forbidden file/path
발생 조건:

Allowed Files 외 파일 수정

Issue 번호 건너뛰기

YouthRoad 스타일 적용 누락

Release 모드 노출

기존 앱 기능 변경

리팩토링/최적화 수행

11. ✔ Summary Table
Issue	목적	Allowed Files
#6	Debug Framework Scaffold	debug/**, main.dart, app.dart
#7	Provider Live Tracker	debug_provider_tracker.dart
#8	Provider Error Toast	debug_toast.dart
#9	Network Inspector	debug_network_logger.dart, core/api/**
#10	Unity Debug Panel	debug_unity_logger.dart
🔷 End of Document
Debug Panel YouthRoad Style Spec (v3 Final)