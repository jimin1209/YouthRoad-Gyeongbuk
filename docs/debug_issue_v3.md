📄 docs/debug_issue_v3.md
🔷 YouthRoad Debug System — Issue Spec (v3)
본 문서는 debug-system 브랜치 전용 Debug Framework 개발 사양서이다.
Codex 및 모든 개발 자동화 시스템은 이 문서를 절대 기준으로 따른다.

1. 🔥 Branch Policy (브랜치 절대 규칙)
브랜치명: debug-system

1) debug-system 브랜치에서만 작업한다.
2) main / master / work 브랜치는 절대 수정 금지.
3) Issue 진행 순서:
   Issue #6 → Issue #7 → Issue #8 → Issue #9 → Issue #10
4) 사용자가 “다음 이슈 진행”이라고 하기 전까지 다음 Issue로 이동 금지.
5) Allowed Files 외 파일 수정 시 RULE VIOLATION.
6) Debug 기능은 Debug Mode에서만 동작해야 하며,
   Release Mode(kReleaseMode)에서는 반드시 100% 비활성화.
7) 기존 앱 로직, 기능, UI는 절대 변경하면 안 된다.
2. 📁 Allowed Files (Debug System 전체 공통)
Debug System 개발 동안 수정 가능 파일은 아래로 제한된다.

lib/debug/**                       → 새 파일/디렉토리 생성 OK
lib/main.dart                      → 최소 변경 허용
lib/app.dart                       → 최소 변경 허용
lib/core/api/**                    → Issue #9에서만 API Hook 용도 최소 변경 OK
Unity 통신 관련 파일              → Issue #10에서 최소 변경 OK
docs/debug_issue_v3.md             → 이 문서 (참조 전용)
⚠ 그 외 파일은 단 한 줄이라도 수정하면 RULE VIOLATION 처리해야 한다.

3. 📁 Debug Template Structure (초기 자동 생성해야 하는 구조)
Issue #6 시작 시 Codex는 아래 디렉토리와 파일을 반드시 먼저 생성해야 한다.

lib/debug/
    debug_button.dart
    debug_overlay.dart
    debug_provider_tracker.dart
    debug_toast.dart
    debug_network_logger.dart
    debug_unity_logger.dart
    debug_wrapper.dart
모든 파일은 스켈레톤(기본 틀) 상태로 시작해야 하며
Issue 번호가 올라갈 때마다 점진적으로 확장해 나가는 구조를 갖는다.

4. 🔷 Issue #6 — Global Debug Framework Scaffolding
🎯 Problem
실기기 테스트 시 flutter run 로그 확인이 불가능

앱 UI에서 오류/상태/로그를 볼 수 있는 Debug Layer 없음

🎯 Goal
Debug 모드에서만 노출되는 Global Debug Wrapper 구축

작은 플로팅 Debug 버튼 생성

버튼 클릭 시 “비어있는 Debug Overlay” 표시

Release Mode에서는 완전 비활성화

📌 Allowed Files (Issue #6 전용)
lib/debug/**
lib/main.dart
lib/app.dart
📌 Implementation Guideline
DebugWrapper 위젯 생성

앱 전체를 감싸며 Debug Button + Overlay를 관리

Overlay의 visible 상태 boolean을 관리

DebugButton

오른쪽 하단 Floating Action Button

Debug 모드에서만 보이며, 눌러서 Overlay 열기/닫기

DebugOverlay

현재는 단순한 완전 빈 Overlay + “EMPTY OVERLAY” 텍스트

향후 #7~#10 기능이 여기에 추가됨

main.dart 연동
main.dart에서 최소 수정 형태로 DebugWrapper(child: App()) 감싸기

kReleaseMode 반드시 체크
Release 모드에서는 DebugWrapper, Button, Overlay 모두 숨김

✔ Issue #6 Acceptance Criteria
디버그 모드일 때만 플로팅 디버그 버튼이 보인다

버튼 클릭 시 Overlay가 열린다

Overlay 내부는 지금은 "EMPTY OVERLAY" 문구만 포함

Overlay 닫기 버튼(AppBar leading) 동작 정상

Release 빌드에서는 Button/Overlay 완전 숨김

Allowed Files 외 파일은 단 한 줄도 변경하지 않는다

5. 🔷 Issue #7 — Provider Status Live Tracker Panel
🎯 Problem
Riverpod Provider들의 loading/data/error 상태를 실시간 모니터링 불가

🎯 Goal
Provider 상태를 실시간으로 Debug Overlay 하위 패널에서 표시

📌 Allowed Files
lib/debug/debug_provider_tracker.dart
lib/debug/debug_overlay.dart
📌 Implementation Guideline
Provider 이름, 상태(loading/data/error), lastUpdated, errorMessage를 기록

ProviderObserver를 활용해 상태 자동 기록

Overlay에서 “Provider Console” 탭 생성

Error 상태 Provider는 강조 표시(red)

✔ Acceptance Criteria
Provider 상태 목록이 실시간으로 갱신됨

Error Provider는 시각적 강조 필요

Release 모드에서 완전 비활성

6. 🔷 Issue #8 — Provider Error → Toast Alert
🎯 Problem
Provider 오류 발생 시 UI에서 즉시 확인하기 어려움

🎯 Goal
Debug 모드에서 Provider error 발생 시 자동 Toast 표시

📌 Allowed Files
lib/debug/debug_toast.dart
lib/debug/debug_provider_tracker.dart  (필요 최소 변경)
📌 Implementation Guideline
ProviderObserver에서 error 감지

error throttle 처리(중복 방지)

Flutter overlay 기반 토스트 생성

Release 모드에서는 비활성

✔ Acceptance Criteria
Provider error 발생 → 즉시 Toast 출력

Release 모드에서는 절대 표시되지 않음

7. 🔷 Issue #9 — Network Inspector + 정책/기관 API Debug Track
🎯 Problem
실기기에서 API 요청/응답 흐름 확인 어려움

🎯 Goal
Debug 모드에서 API 호출 로그를 Overlay에 기록/표시

정책 API / 기관 API 별 로그 필터링

📌 Allowed Files
lib/debug/debug_network_logger.dart
lib/core/api/**    (Hook을 위한 최소 변경만 허용)
lib/debug/debug_overlay.dart
📌 Implementation Guideline
기록 항목: URL, 응답코드, latency(ms), timestamp

body는 요약만 기록 (보안상 full body 금지)

정책 API/기관 API 필터 버튼 제공

로그는 메모리에만 저장 (파일 저장 금지)

✔ Acceptance Criteria
모든 API 요청이 Debug Overlay Network 탭에서 확인 가능

정책/기관 API 필터링 정상

Release 모드에서는 기록 및 표시 금지

8. 🔷 Issue #10 — Unity Hybrid Debug Panel
🎯 Problem
Unity 지도 상태를 Flutter에서 실시간 확인 불가

🎯 Goal
Unity → Flutter 로그 수신

Unity 초기화/포커스/지도 이벤트 추적

📌 Allowed Files
lib/debug/debug_unity_logger.dart
Unity MethodChannel 관련 파일들 (최소 변경)
lib/debug/debug_overlay.dart
📌 Implementation Guideline
Unity → Flutter MethodChannel 로그 수신

Debug Overlay에 Unity 탭 생성

Unity가 없는 화면에서도 NPE 없이 안전하게 작동

✔ Acceptance Criteria
Unity 지도가 있는 화면에서 Unity 로그 정상 표시

Debug 모드에서만 동작

Release 모드에서는 완전 비활성

9. 🔷 Summary
Issue	내용	Allowed Files
#6	Debug Framework Scaffold	debug/**, main.dart, app.dart
#7	Provider Tracker	debug_provider_tracker.dart
#8	Toast Error Alert	debug_toast.dart
#9	Network Inspector	debug_network_logger.dart, core/api/**
#10	Unity Debug Panel	debug_unity_logger.dart
10. 🟥 RULE VIOLATION 기준
Codex는 아래 상황 발생 시 즉시 아래처럼 출력해야 한다:

RULE VIOLATION — Attempted to modify forbidden file/path
발생 조건:

Allowed Files 외 파일 수정 시도

Issue 번호 건너뛰기

Release UI 변경

기존 앱 동작 변경

Refactoring / 최적화 등 Issue 미포함 작업 수행 시

🔷 끝.
