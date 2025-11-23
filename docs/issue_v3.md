# Issue Specification v3 (Full Version)

## 🔒 작업 절대 규칙 (MASTER RULES)
아래 규칙은 모든 작업에 **무조건** 적용되며 Codex는 절대 위반해서는 안 된다.

1. **이슈 번호는 반드시 순서대로 진행**한다.  
   Issue #1 → Issue #2 → Issue #3 → … 순차적으로.  
   어떤 경우에도 건너뛰기 금지.

2. **명시되지 않은 파일 수정 금지.**  
   각 Issue에서 “수정 가능”이라고 명시한 파일 외 절대 변경하지 않는다.

3. **리팩토링 / 최적화 금지.**  
   Issue 요구 외의 구조변경 금지(변수명 수정, 경로 이동, 함수 분리 등 전부 금지).

4. **백워드 호환 유지.**  
   기존 기능 정상 작동 필수.

5. **변경은 최소 단위로.**  
   Issue 목표 달성에 필요한 최소한의 변경만 적용.

6. **Issue 범위 밖 파일 생성 금지.**  
   명시된 파일만 생성/수정 가능.

7. **Issue 완료 후 검증 필수.**  
   - Acceptance Criteria 100% 일치  
   - 수정 파일이 Issue 범위 내에 있는지 확인  
   - 논리적 빌드 가능 상태 유지  
   - 불필요한 변경 없는지 확인

8. **테스트 실행 금지 (환경에 Flutter/Dart 없음).**  
   테스트 코드 작성은 가능하나 실행 요구 금지.

9. **Codex는 절대 추측 금지.**  
   Issue에 명시되지 않은 내용은 작업하지 않는다.


---

# 📌 Issue 목록 (v3)

---  
# **Issue #1 — Repository 중복 초기화 제거 및 DI 단일화**

## Problem
- LateInitializationError 발생  
- Repository 인스턴스가 여러 화면에서 중복 생성됨  
- late final 필드 + Provider 중복 초기화 충돌

## Goal
- Repository를 Provider 기반 단일 인스턴스로 통일  
- `late final _repo` 등 자체 초기화 제거

## Allowed Files
- `lib/core/repository/**`
- `lib/features/**/provider/*.dart`

## Acceptance Criteria
- Repository 중복 초기화 오류 제거  
- 모든 화면에서 동일 Repository Provider 사용  
- 빌드 가능 상태 유지  


---  
# **Issue #2 — ref.listen 오용 제거 & 안전한 구조화**

## Problem
- ref.listen이 build 외부(예: initState)에 사용됨  
- 붉은 에러 화면 표시

## Goal
- 모든 ref.listen을 ConsumerWidget의 build 내부로 이동  
- initState 및 비빌드 영역 listen 제거

## Allowed Files
- `lib/features/**/ui/*.dart`
- `lib/features/**/controller/*.dart`

## Acceptance Criteria
- ref.listen 관련 오류 완전히 해결  
- 탭 이동/네비게이션 시 붉은 오류 화면 없음  


---  
# **Issue #3 — 정책 목록 API Provider 초기화 실패 해결**

## Problem
- 정책 목록/기관 목록 불러오기 실패  
- API 키 전달 오류 및 Provider 초기화 순서 꼬임

## Goal
- 정책 목록 Provider 초기화 순서 정상화  
- API URL 구성/키 전달 정확히 되도록 수정

## Allowed Files
- `lib/features/policy/**`
- `lib/core/api/**`

## Acceptance Criteria
- 정책 목록 정상 로드  
- Retry 클릭 시 정상 재요청  
- API 실패 로직 예외 없이 동작  


---  
# **Issue #4 — ProviderScope 범위 충돌 해결**

## Problem
- 화면 이동 시 ProviderScope 재생성  
- Provider override 충돌로 인한 재초기화 문제

## Goal
- ProviderScope 구조 명확화  
- override 충돌 제거

## Allowed Files
- `lib/app.dart`
- `lib/main.dart`

## Acceptance Criteria
- push/pop 반복 시 Provider 재초기화 문제 없음  
- 앱 전체 안정적인 상태 유지  


---  
# **Issue #5 — 카테고리 화면 정적 Provider 분리**

## Problem
- 현 단계에서는 정상 동작하나 향후 충돌 위험 높음  
- 구조적으로 독립성이 필요

## Goal
- 카테고리 Provider를 독립 파일로 분리  
- 다른 Provider 영향 제거

## Allowed Files
- `lib/features/category/**`

## Acceptance Criteria
- 카테고리 화면 정상 유지  
- 정책 API/Provider 변경과 충돌 없음  



---

# 🔍 Debug System Issues (v3 확장)

아래 Debug 관련 이슈들은 기존 Issue v3 규칙에 그대로 종속되며  
**Issue 번호는 이어서 사용한다.**  
(예: 기존이 Issue #1~#5 → Debug는 Issue #6부터)

---

# **Issue #6 — Global Debug Framework Scaffolding**

## Problem
- 실기기에서 flutter run 로그 확인 불가  
- 앱 화면에 개발용 상태/에러 출력할 체계 없음

## Goal
- 모든 디버그 기능의 기반이 되는 Global Debug Wrapper 제공  
- 디버그 모드에서만 활성화  
- Debug Overlay 패널 기본 틀 생성

## Allowed Files
- `lib/debug/**` (신규 디렉토리 생성 허용)
- `lib/main.dart`
- `lib/app.dart` (최소 변경만)

## Implementation Guideline
- kReleaseMode에서는 완전 비활성화  
- 작은 floating debug 버튼 → overlay 열림  
- 이후 Issue #7~#10 확장을 지원하는 구조 구축

## Acceptance Criteria
- 디버그 모드에서만 Debug 버튼 표시  
- 버튼 클릭 시 비어 있는 Debug Overlay 열리고 닫힘  
- 릴리즈 모드에서는 UI 없음  


---

# **Issue #7 — Provider별 실시간 상태 Debug Console Panel**

## Problem
- Riverpod Provider 상태(loading/data/error) 직접 추적 어려움

## Goal
- Provider 상태 실시간 표시 패널 구현  
- Provider 상태 변경 시 자동 갱신

## Allowed Files
- `lib/debug/debug_provider_tracker.dart`
- `lib/debug/debug_overlay.dart`

## Implementation Guideline
- Provider 상태: name, status, lastUpdated, lastError  
- Error Provider는 강조 표시  
- Debug Overlay 내 “Provider Console” 섹션 추가

## Acceptance Criteria
- Debug 패널에 Provider 상태 목록 표시  
- 실시간 업데이트  
- 오류 Provider 명확히 구분  


---

# **Issue #8 — 예외 발생 시 Toast 기반 오류 알림 자동화**

## Problem
- API/Provider 오류가 화면에서 즉시 인지되지 않음

## Goal
- Provider에서 error 발생 시 자동 Toast 팝업  
- 중복 팝업 방지를 위한 throttle 처리

## Allowed Files
- `lib/debug/debug_toast.dart`
- `lib/debug/debug_provider_tracker.dart` (필요 시 최소 변경)

## Implementation Guideline
- Debug 모드에서만 Toast 표시  
- Provider 이름 + 오류 요약 정도의 텍스트 표시  
- UI 영향 없도록 Overlay 기반 구현

## Acceptance Criteria
- Provider error → 즉시 Toast 표시  
- 릴리즈 모드에서는 절대 표시되지 않음  


---

# **Issue #9 — Network Inspector + 정책/기관 API Debug Track 패널**

## Problem
- 실기기에서 API 호출 흐름 추적 어려움

## Goal
- 네트워크 요청/응답 기록  
- 정책/기관 API 별 Debug Track 제공

## Allowed Files
- `lib/debug/debug_network_logger.dart`
- `lib/core/api/**`
- `lib/debug/debug_overlay.dart`

## Implementation Guideline
- 기록: URL, StatusCode, latency, 시간  
- 정책 API/기관 API 필터링 지원  
- Body 전체 저장 금지(요약만)

## Acceptance Criteria
- Debug Overlay의 Network 탭에서 모든 API 로그 확인 가능  
- 정책/기관 API 필터 기능 정상  
- 릴리즈 모드에서는 표시/저장되지 않음  


---

# **Issue #10 — Unity 연동 하이브리드 Debug Panel**

## Problem
- Unity 상태를 Flutter와 같이 모니터링 불가

## Goal
- Unity → Flutter 로그 수신  
- Unity 초기화/포커스/지도 이벤트 등을 Debug 패널에서 확인

## Allowed Files
- `lib/debug/debug_unity_logger.dart`
- Unity ↔ Flutter 통신 관련 최소 변경 파일  
- `lib/debug/debug_overlay.dart`

## Implementation Guideline
- Unity method channel 통해 로그 수신  
- Debug Overlay에 Unity 탭 추가  
- Unity 없는 화면에서도 안전하게 작동해야 함

## Acceptance Criteria
- Unity 지도가 있는 화면에서 Unity 로그 표시  
- 디버그 모드에서만 표시  
- 릴리즈 빌드에서는 완전 비활성화  


---

# ✔ 끝
이 문서는 Codex가 모든 이슈를 정확히, 안전하게, 규칙대로 수행하기 위한 최종 기준 문서이다.
