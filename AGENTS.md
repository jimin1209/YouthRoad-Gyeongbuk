# GENERAL RULES — YouthRoad-Gyeongbuk AI Agent Guide

본 문서는 YouthRoad-Gyeongbuk 프로젝트에서 AI Agent(Codex)가
코드를 생성하거나 문제를 해결할 때 반드시 따라야 하는 공통 규칙을 정의한다.

## 1. Response Format Rules
- 모든 코드는 반드시 **전체 파일 단위(full-file)** 로 출력한다.
- 코드 일부 조각(snippet)만 출력하지 않는다.
- 파일 비교/수정도 항상 “전체 파일로 교체 가능한 형태”로 출력한다.
- 여러 파일을 수정할 경우, 각 파일을 명확한 경로와 전체 코드 블록으로 구분한다.
- 설명은 최소화하고, **코드가 우선**이다.

## 2. Repository Structural Rules
- 프로젝트 구조를 변경하지 않는다. (폴더 이동/파일명 변경 금지)
- 신규 파일 생성 시 반드시 정확한 상대 경로를 표시해야 한다.
- 기존 구조: lib/, docs/, android/, ios/, unity/ 를 절대 임의로 재구성하지 않는다.
- Riverpod/GoRouter/Freezed 구조는 기존 컨벤션을 따른다.

## 3. Branch Workflow Rules
- 현재 체크아웃된 브랜치에서만 작업한다.
- 다른 브랜치 기반으로 수정하거나 merge/rebase를 시도하지 않는다.
- 이슈 기반 개발을 따른다: feature/* 브랜치는 반드시 해당 Issue 번호 기준으로 작업한다.
- 브랜치를 변경하거나 생성하지 않는다(요청 시에만 한다).

## 4. Issue-driven Development Rules
- 모든 작업은 반드시 **현재 Issue의 요구사항만** 기반으로 처리한다.
- Issue에 없는 기능을 임의로 구현하지 않는다.
- Acceptance Criteria가 존재할 경우, 그 조건을 절대적으로 따른다.
- 모호한 요구사항이 있을 경우, 작업 전에 반드시 질의한다.
- Issue 기반 코드 생성 시, 기존 코드 호환성을 항상 유지한다.

## 5. No Assumptions Policy
- “추정”, “아마”, “가능할 것” 같은 불확실한 표현을 사용하지 않는다.
- 알 수 없는 정보는 반드시 “모름”이라고 명확히 말한다.
- 확인되지 않은 API, class, provider, method를 임의로 생성하지 않는다.
- 실제 프로젝트 파일 기준으로 존재하는 것만 사용한다.

## 6. Flutter Development Rules
- Riverpod 2.x, GoRouter 14.x, Freezed 기반 구조를 준수한다.
- 모든 Provider는 StateNotifier/AsyncNotifier 패턴 중 기존 문서 기준을 따른다.
- 네이밍 규칙: snake_case 파일명 / UpperCamelCase 클래스명 / lowerCamelCase 변수명.
- 모든 UI는 SafeArea, Scaffold, Theme를 준수한다.
- WebView(KakaoMap) 및 Unity 연동 파일은 기존 구조를 유지한다.

## 7. Unity Integration Rules
- flutter_unity_widget 라이프사이클 충돌 해결을 위해
  ProxyLifecycleProvider 패치 패턴을 항상 동일하게 적용한다.
- android/unityLibrary 내부 구조는 기존 방식 외 수정하지 않는다.
- Unity와 Flutter 간 메시지 통신 구조는 기존 Controller/Channel 방식을 따른다.
- IL2CPP / Android 빌드 오류 수정 시 기존 해결 패턴을 재사용한다.

## 8. Environment & Build Rules
- pubspec.yaml에 의존성 추가 시 반드시 기존 버전 범위와 충돌이 없는지 확인한다.
- Android/iOS/Unity 빌드 스크립트는 임의로 수정하지 않는다(이슈 요구 시 예외).
- Debug/Release 빌드 구성은 기존 codemagic.yaml 또는 gradle 기반을 따른다.

## 9. Logging & Error-handling Rules
- 모든 네트워크 기능은 DebugNetworkLogger와 호환돼야 한다.
- try/catch는 기존 레이어 패턴(domain → data → presentation)을 유지한다.
- 오류 메시지는 사용자 UI에 직접 노출되지 않게 한다.

## 10. Communication Rules with Human (지민님)
- 지민님이 요청한 규칙·패턴·컨벤션을 항상 최우선으로 따른다.
- 이해가 불명확한 경우 반드시 질문한다.
- 작업 경로와 파일명을 절대 임의로 변경하지 않는다.
- 지민님이 요청한 색 하트: 💙🩵 만 사용한다.
- 존댓말만 사용한다.


지금부터 ISSUE LIST 입니다.


## ISSUE [feature/core-stability] Core Stability Layer Spec #122
이 명세는 feature/core-stability 브랜치를 대상으로 한다.

목표:
앱 전체를 안정화시키기 위한 Core Stability Layer를 7개 파일 구조로 구축한다.
모든 코드는 전체 파일 형태로 생성하고, core 레이어만 수정한다.

파일 목록:
- lib/core/error/app_exception.dart
- lib/core/error/error_reporter.dart
- lib/core/logging/app_logger.dart
- lib/core/network/network_result.dart
- lib/core/network/retry_policy.dart
- lib/core/network/app_dio.dart
- main.dart (global error handler 추가)

세부 요구사항:
현재 브랜치는 feature/core-stability 이며,
YouthRoad 앱의 안정성과 오류 복구 능력을 대폭 강화하기 위한
“Core Stability Layer”를 구축하고 싶다.

아래 요구사항을 기반으로 새로운 파일들을 생성하거나 필요한 곳에서 리팩토링을 수행해줘.
모든 코드는 전체 파일 단위로 제공해야 하며, 기존 UI나 feature 레벨 코드는 수정하지 말고,
core 레이어에 집중해 안정 기반을 만들어라.

────────────────────────────────────────
[목표]
앱이 어떤 상황에서도 크게 죽지 않고,
네트워크 불안정 / WebView 오류 / 비동기 예외를 모두 흡수하며,
추후 KakaoMap/검색/아키텍처 리팩토링 시에도 흔들리지 않는
탄탄한 기반(Core Stability Layer)을 만드는 것이다.

이 기반은 앱 전체의 "백본 엔진" 역할을 한다.

────────────────────────────────────────
[생성 또는 리팩토링해야 할 파일 목록]

1) lib/core/error/app_exception.dart
   - 앱 전역에서 사용될 예외 타입(AppException) 정의
   - 다음과 같은 세부 타입을 포함:
       - NetworkException
       - ServerException
       - TimeoutException
       - UnexpectedException
   - "사용자용 메시지(get userMessage)"와 "로깅용 메시지(get debugMessage)"를 분리
   - StackTrace를 안전하게 보관할 수 있는 구조 설계

2) lib/core/network/network_result.dart
   - 모든 API 결과를 감싸는 Result 모델
   - 형태:
       sealed class NetworkResult<T>
         - NetworkSuccess<T>(data)
         - NetworkFailure<T>(error: AppException)
   - UI/Provider 계층에서 안정적으로 분기 처리 가능해야 함

3) lib/core/network/retry_policy.dart
   - 네트워크 재시도 정책 정의
   - 요구사항:
       - 기본 3회 재시도
       - 500~599 에러, timeout, network offline 시 재시도
       - 1초 → 2초 → 4초 exponential backoff
       - 재시도 횟수 및 딜레이 설정 가능 옵션 포함

4) lib/core/network/app_dio.dart
   - 앱 전체에서 사용할 단일 Dio 인스턴스를 제공
   - 요구사항:
       - base options(timeouts, headers) 설정
       - retry_policy 적용
       - logging interceptor 적용
       - 모든 Dio 오류를 NetworkFailure로 변환하는 wrapper 함수 제공
   - provider 또는 singleton 패턴으로 제공

5) lib/core/logging/app_logger.dart
   - YouthRoad 전체에서 사용하는 통일된 로깅 유틸
   - 다음 메서드 포함:
       - logInfo(message)
       - logWarn(message)
       - logError(message, [error, stackTrace])
   - print()를 직접 사용하지 않고 여기로 모두 흡수
   - 나중에 JS console, network log, provider log를 이 Logger로 연결 가능하도록 설계

6) lib/core/error/error_reporter.dart
   - global error handler에서 받아온 에러를
     app_logger로 기록하고, 필요 시 분석도 가능하도록 구조만 잡아둠
   - 나중에 Crashlytics/Sentry 연결 가능하게 Hook 포인트 제공

7) main.dart (또는 앱의 entrypoint)
   - runZonedGuarded 적용
   - FlutterError.onError 적용
   - 모든 uncaught exception을 error_reporter를 통해 로깅
   - AppDio 초기화
   - 초기 로그 출력(예: YouthRoad starting with Core Stability Layer)

────────────────────────────────────────
[커스텀 설계 규칙]

- core/ 아래 파일들은 앱 기능과 독립적으로 동작해야 한다.
- 외부 의존은 모두 DI 가능하게 구성한다 (ex: Provider 또는 getter).
- Dio 요청은 반드시 NetworkResult<T>로 감싸서 리턴한다.
- 어떤 계층에서도 throw DioError를 그대로 던지지 않는다.
- Core Stability Layer는 UI 수정 없이 완성되어야 한다.
- 모든 생성 파일은 “전체 파일 형태”로 제공한다 (부분 코드 금지).
- import 경로는 상대경로 혹은 프로젝트 경로 기준으로 정확히 작성한다.

────────────────────────────────────────
[결과]

이 명령을 수행한 후 나는 다음과 같은 상태를 기대한다:

- lib/core/error/app_exception.dart
- lib/core/error/error_reporter.dart
- lib/core/logging/app_logger.dart
- lib/core/network/network_result.dart
- lib/core/network/retry_policy.dart
- lib/core/network/app_dio.dart
- main.dart (global error handler 추가된 전체 파일)

이 7개 파일이 완전히 구성된 상태이며,
앱 전체가 네트워크 안정화 + 예외 안전 + 로깅 기반을 갖춘
프로덕션 품질의 Core Stability Layer를 얻게 된다.

────────────────────────────────────────

이 요구사항에 맞춰 모든 파일을 전체 코드 형태로 작성해줘.


## [feature/devtools] In-App Devtools Layer Spec #123
이 명세는 feature/devtools 브랜치에서 실행한다.

────────────────────────────────────────
[목표]

앱 전체에서 발생하는 상태 변화, 로그, 네트워크 요청, WebView console 출력을
실시간으로 확인할 수 있는 “In-App DevTools Layer”를 구축한다.

이 레이어는 KakaoMap 디버깅, 네트워크 추적, 상태 확인,
빌드 안정성 확보에 중요하며, 이후 모든 리팩토링의 기반이 된다.

DevTools는 개발 빌드에서만 동작하도록 설계하고,
전체 파일 단위로 완성된 코드로 제공해야 한다.

────────────────────────────────────────
[생성해야 할 주요 기능]

1) DebugOverlay (앱 최상단 Floating Debug Panel)
   - Toggle 가능한 floating button 또는 long-press gesture
   - 패널 열기/닫기 기능
   - 크기/위치 persistent 저장(optional)

2) Log Console Panel
   - app_logger의 모든 출력(logInfo/logWarn/logError)을 실시간 표시
   - 날짜, 태그, 레벨 필터링
   - 스크롤, 자동 스크롤 유지 옵션

3) Provider State Tracker Panel
   - 모든 Riverpod provider의 변경 이벤트를 기록
   - provider name, old→new value, timestamp 출력
   - provider observer(AppProviderObserver) 구현 포함

4) WebView Console Mirror Panel
   - WebView의 console.log, console.warn, console.error를 모두 Dart로 미러링
   - JS → Dart 브리지 구축
   - KakaoMap 디버깅 가능하도록 연결

5) Network Inspector Panel
   - Dio 요청/응답을 모두 기록
   - URL, statusCode, method, duration(ms), payload 일부 표시
   - 오류 발생 시 빨간색 등 강조
   - Retry 버튼(optional)

6) DevTools Provider
   - 모든 패널 상태를 관리하는 Riverpod Provider
   - Panel open/close, active tab, log buffer, provider events buffer, network buffer 등 관리

────────────────────────────────────────
[생성해야 할 파일 목록]

lib/devtools/
 ├─ debug_overlay.dart
 ├─ devtools_provider.dart
 ├─ panels/
 │    ├─ log_console_panel.dart
 │    ├─ provider_tracker_panel.dart
 │    ├─ network_inspector_panel.dart
 │    ├─ webview_console_panel.dart
 ├─ widgets/
 │    ├─ devtools_tab_bar.dart
 │    ├─ devtools_container.dart

core/logging/app_logger.dart 수정 필요:
 - app_logger의 모든 로그를 DevTools로도 전송할 수 있는 hook 추가

core/network/app_dio.dart 수정 필요:
 - 모든 요청/응답/오류를 DevTools Network Panel에 전달하는 interceptor 추가

Flutter WebView 수정 필요:
 - JavascriptChannel 이용하여 console.* 메시지를 DevTools Panel로 전달하는 브리지 추가

────────────────────────────────────────
[설계 규칙]

- DevTools는 release 모드에서는 완전히 비활성화되어야 한다.
  (kReleaseMode 플래그 또는 assert 활용)

- UI는 기존 화면을 방해하지 않는 형태로 오버레이되어야 한다.
  (Stack + Positioned)

- 모든 Panel은 탭 형태로 전환 가능해야 한다.
  (Log / Provider / Network / WebView)

- AppLogger / Dio / WebView / Riverpod Observer 모두 DevTools로 연결된다.

- 필요한 모든 파일은 “전체 파일” 형태로 Codex가 생성해야 한다.
  (부분 코드 또는 diff 금지)

────────────────────────────────────────
[Codex 기대 결과]

Codex는 다음을 전체 파일로 생성해야 한다:

- lib/devtools/debug_overlay.dart
- lib/devtools/devtools_provider.dart
- lib/devtools/panels/log_console_panel.dart
- lib/devtools/panels/provider_tracker_panel.dart
- lib/devtools/panels/network_inspector_panel.dart
- lib/devtools/panels/webview_console_panel.dart
- lib/devtools/widgets/devtools_tab_bar.dart
- lib/devtools/widgets/devtools_container.dart
- core/logging/app_logger.dart 수정본
- core/network/app_dio.dart 수정본
- WebView 관련 브리지 코드들

결과적으로,
앱 안에서 실시간 로그/상태/네트워크/JS 콘솔을 볼 수 있는
전체 DevTools Layer가 완성된다.

────────────────────────────────────────
위 모든 요구사항을 기반으로 Codex가 전체 파일을 생성하도록 한다.

## [feature/map-upgrade] KakaoMap WebView Integration Full Rebuild #124
이 명세는 KakaoMap WebView 모듈을 전면 재설계하기 위한 이슈이며,  
**작업 대상 브랜치는 `feature/map-upgrade`** 이다.

또한 **`feature/map-upgrade` 브랜치는 반드시 `fix/kakaomap-webview`의 최신 변경 내용을 병합(`git merge`)한 상태**에서 작업을 진행해야 한다.

- 참고 브랜치였던 **`codex/redesign-kakaomap-integration-in-flutter`** 의 변경 사항은 이미 `fix/kakaomap-webview`에 포함되어 있다.
- 따라서 Codex는 `feature/map-upgrade`의 코드베이스가 `fix/kakaomap-webview` 최신 기준임을 전제로 한다.

본 Issue에서 Codex는 KakaoMap 엔진 전체를 "완전히 새로" 작성한다.

---

# ✔ 목표

Flutter + WebView 기반 KakaoMap 엔진을 다음 기준으로 완전 재설계한다:

- 안정적인 Kakao SDK 로딩
- JSON 기반 양방향 통신 (Flutter ↔ JS)
- Marker / Polyline / Bounds / MapType / Cluster 등 지도 기능 확장
- 로딩 / 에러 / 재시도 UI 구축
- JS console log → Flutter 전달
- Controller 명령 큐(ready 전까지 버퍼링)
- WebView reload 대응 및 상태 보존
- Provider + Screen 상태 연동

기존 KakaoMap 구조는 전부 폐기하고, HTML/JS/Controller/WebView/Provider/Screen 레벨을 모두 재작성한다.

Codex는 반드시 **모든 파일을 "완전한 전체 Dart 파일" 형태로 제공해야 한다.**
부분 코드, 중간 생략, diff 출력 금지.

---

# ✔ 재설계 대상 파일 목록

아래 모든 파일을 신규 설계로 재작성한다:

1. `lib/ui/screens/map/kakao_map_html_builder.dart`
2. `lib/ui/widgets/map/kakao_map_webview.dart`
3. `lib/ui/controllers/map/kakao_map_controller.dart`
4. `lib/ui/providers/map/kakao_map_providers.dart`
5. `lib/ui/screens/map/kakao_map_screen.dart`

필요하다면 Codex는 다음 파일도 자유롭게 신규로 추가할 수 있다 (전체 Dart 파일로 제공해야 함):

- `lib/ui/models/map/kakao_map_models.dart`
- `lib/ui/models/map/kakao_map_options.dart`
- `lib/ui/controllers/map/kakao_map_commands.dart`

---

# ✔ HTML/JS 설계 요구사항

### 1) Kakao SDK 로딩
- autoload=false 사용
- Flutter로 다음 JSON 이벤트 전달:
  - `sdk_loading`
  - `sdk_loaded`
  - `sdk_failed`
  - `ready`

### 2) 통일된 JSON 메시지 포맷
모든 JS → Flutter 메시지는 아래 형식을 따라야 한다:

```json
{
  "type": "eventType",
  "payload": {},
  "timestamp": 123456789,
  "level": "info" | "warn" | "error",
  "source": "kakaomap-js"
}
지원해야 하는 메시지 예:

ready

marker_click

region_click

cluster_click

log

error

3) 지도 기능
marker 렌더링 / 업데이트

marker 클릭 이벤트

polyline 렌더링(add/remove/clear)

지도 bounds fitting

setCenter / setLevel / animate 옵션

mapType 변경

필요 시 marker clustering 고려

4) console.log 수집
log/warn/error → Flutter로 JSON 이벤트 전송

✔ Flutter Controller 설계 요구사항
Controller 기본 책무
JS에 명령 전달 (postMessage)

ready 이전 명령은 queue에 저장 → ready 이후 flush

모든 JS 이벤트를 Dart 모델로 변환

Public API 예
moveTo(lat, lng)

animateTo(lat, lng)

setLevel(level)

setMapType(type)

setMarkers(list)

setPolylines(list)

fitToMarkers(list)

reload()

상태(State)
loading

sdk_loading

sdk_loaded

ready

error

reloading

✔ WebView Wrapper (kakao_map_webview.dart)
필수 구현:

WebView + JavaScriptChannel

Controller와 WebViewController 바인딩

HTML 문자열 주입

로딩/에러/재시도 UI

옵션(center, level, mapType…) 전달

JS 이벤트 스트림 수집

✔ Provider Layer
kakao_map_providers.dart에서 담당해야 할 것:

KakaoMapController provider

지도 상태 provider

이벤트 스트림 provider

선택된 marker provider

지도 옵션 provider

✔ Screen (kakao_map_screen.dart)
필요 사항:

KakaoMapWebView 렌더링

지도 상태 반영 UI

테스트용 버튼 (이동/레벨/타입 변경 등)

이벤트 로그 패널 (선택된 marker, 오류 등)

✔ 설계 규칙
JS ↔ Dart 통신은 JSON만 사용 (문자 prefix 금지)

모든 JS 오류는 Flutter로 전달

모든 파일은 전체 Dart 파일로 출력

기존 코드 덮어쓰기 허용

WebView reload 시 상태 복원 필요

HTML escaping 필수

✔ Codex의 최종 출력
Codex는 이 이슈의 명세를 기반으로 아래 모든 파일을 전체 Dart 파일로 생성해야 한다:

kakao_map_html_builder.dart

kakao_map_webview.dart

kakao_map_controller.dart

kakao_map_providers.dart

kakao_map_screen.dart

그리고 필요 시 다음 파일도 생성한다:

kakao_map_models.dart

kakao_map_options.dart

kakao_map_commands.dart

결과적으로,
feature/map-upgrade 브랜치에서 KakaoMap WebView 엔진이 완전히 재구축된 상태가 되어야 한다.

## [feature/architecture-upgrade] App Architecture Upgrade Spec #125
이 이슈는 YouthRoad 앱의 전체 아키텍처를 정리/업그레이드하기 위한 스펙이다.  
**작업 대상 브랜치는 `feature/architecture-upgrade`** 이며,  
이 브랜치는 이미 `fix/kakaomap-webview` 기반으로부터 분기되어 있다고 가정한다.

가능하면 작업 전 아래를 한 번 수행한 상태에서 진행한다:

```bash
git checkout feature/architecture-upgrade
git merge fix/kakaomap-webview
🎯 목표
현재 YouthRoad 프로젝트의 구조를 다음 방향으로 재정비한다:

폴더/레이어 구조를 명확히 분리 (core / domain / data / application / presentation)

Riverpod 2.x 기반 상태/DI 구조를 정리

Navigation(GoRouter) 진입 경로와 AppRoot를 명확히 분리

Repository / UseCase / Model 계층을 정돈

Config/Env, Logging, Error, Network 등 core 레이어와 자연스럽게 연결

향후 DevTools, KakaoMap 업그레이드, Search 업그레이드가 모두 이 구조 위에서 잘 동작하게 만들기

Codex는 “유스로드 앱의 표준 아키텍처”를 설계하는 마음으로 작업해야 한다.

모든 수정된 파일은 전체 Dart 파일 형태로 출력해야 하며,
부분 코드 / diff / 생략은 허용되지 않는다.

🧱 폴더/레이어 구조 목표
아래와 비슷한 구조를 만든다 (이미 있는 구조가 있다면, 그 위에 정리/보강):

lib/core/

공통 상수, 에러, 로깅, 네트워크, env, theme 등 (Core Stability Layer와 자연스럽게 연결)

lib/domain/

entities/ (순수 도메인 모델)

repositories/ (추상 인터페이스)

usecases/ (앱의 비즈니스 규칙 / 유스케이스)

lib/data/

models/ (API/DB 모델)

sources/ (remote/local data source)

repositories/ (domain repository 구현)

lib/application/

앱 전역 상태/로직 (예: Auth, Session, Config, AppState 등)

Riverpod 기반 Notifier/Provider (non-UI)

lib/presentation/

screens/

widgets/

viewmodels/ or controllers/ (UI 바인딩용 Provider 등)

lib/app/

app.dart (MaterialApp / root widget)

router/ (GoRouter 설정)

providers/ (전역 provider 묶음)

bootstrap/ (runApp 전 초기화 로직)

Codex는 현재 레포 상태를 존중하되, 이 구조에 최대한 가깝게 정리/이동/추가 작업을 수행해야 한다.

📌 핵심 작업 항목
1) App Entry & Bootstrap
필수 생성/정리:

lib/app/app.dart

YouthRoadApp (MaterialApp or MaterialApp.router)

theme, locale, router 연동

lib/app/router/app_router.dart

GoRouter 설정

메인 화면, 지도 화면, 검색 화면 등 주요 route 정의

Route 이름/패턴 상수 관리

lib/app/bootstrap/bootstrap.dart

runApp 전에 필요한 초기화 로직 (Env, Log, Core init 등)

나중에 main.dart에서 bootstrap() → runApp(YouthRoadApp()) 형태로 사용할 수 있도록 구성

lib/app/providers/app_providers.dart

전역적으로 필요한 Provider 들을 한 곳에서 정의/정리

Core/Domain/Application 계층과 연결되는 Provider도 여기서 엮을 수 있음

Codex는 main.dart가 간결해지도록,
실제 앱 초기화와 구동 로직을 위 파일들로 분리하도록 설계해야 한다.

2) Domain Layer 정리
필수 작업:

lib/domain/entities/ 내부에 주요 엔티티 정의

예: Policy, Region, Institution, UserPreference 등

순수 Dart 클래스이며, JSON 직렬화/역직렬화나 Dio/Isar 의존을 두지 않는다.

lib/domain/repositories/

정책, 지역, 검색, 즐겨찾기 등 핵심 Repository 인터페이스 정의

예:

PolicyRepository

SearchRepository

RegionRepository

lib/domain/usecases/

주요 UseCase 정의

예:

FetchPolicyList

SearchPolicies

GetRecommendedPolicies

GetRegionSummary

각 UseCase는 call() 또는 execute() 메서드 하나로 의도를 표현하는 구조.

Codex는 Domain이 Data/Infra에 직접 의존하지 않도록
인터페이스+엔티티만 정의하는 계층으로 유지해야 한다.

3) Data Layer 정리
필수 작업:

lib/data/models/

API/DB를 위한 Model 정의

fromJson / toJson / toDomain 변환 메서드 등 포함 가능

lib/data/sources/remote/ / local/

원격 API 호출 (Dio 기반)

로컬 캐시/Isar/SharedPreferences 등 (이미 있다면 재사용)

lib/data/repositories/

domain repositories 인터페이스 구현체

예: PolicyRepositoryImpl, SearchRepositoryImpl

Core Network와 Core Stability Layer(AppDio, NetworkResult, AppException 등)와 자연스럽게 통합

Codex는 Data 계층이 domain/usecase와 잘 어울리도록 mappings를 구성해야 한다.

4) Application Layer (상태/비즈니스 Orchestration)
필수 작업:

lib/application/에 전역적인 상태/로직 모듈 배치

예: 앱 전역 설정, 세션, 필터 preset, 추천 정책 상태 등

Riverpod 기반 Notifier/AsyncNotifier를 이용해:

도메인 UseCase를 호출하고

presentation 계층에서 관찰할 수 있는 형태로 상태를 제공

예:

AppConfigController

PolicySearchController

RecommendationController 등

5) Presentation Layer 구조 정리
필수 작업:

lib/presentation/screens/

기존 페이지들을 기능별로 정리 (예: home, map, search, policy_detail 등 하위 폴더)

lib/presentation/widgets/

여러 화면에서 재사용되는 공통 UI 컴포넌트들 정리

화면별 ViewModel/Controller/Notifier는

lib/presentation/... 또는 lib/application/...에 위치하도록 컨벤션 정리

Codex가 일관된 네이밍 컨벤션을 정해주면 좋다.

6) Provider / DI 정리
필수 작업:

lib/app/providers/app_providers.dart 또는 유사 파일 안에:

주요 Repository/UseCase/Controller Provider 정의

Provider, StateNotifierProvider, AsyncNotifierProvider 등 적절히 사용

DevTools, Core Stability Layer, KakaoMap, Search 등 모듈들이

이 Provider 레이어를 통해 연결될 수 있도록 준비

🧪 테스트 & 빌드 관점
Codex는 코드 생성 시, 최소한 Dart 분석기에서 오류가 나지 않도록 구성해야 한다.

통합 테스트/위젯 테스트 파일이 일부 필요하다면, 샘플 1~2개 정도 추가할 수 있다.

다만 이 이슈의 주 목적은 “구조 정리”이므로,
테스트 작성은 필수는 아니고 선택적이다.

📏 설계 규칙 (중요)
모든 수정/생성 파일은 완전한 Dart 파일로 출력해야 한다. (partial/diff 금지)

현재 프로젝트에 이미 있는 유용한 구조/이름은 가능하면 재사용한다.

import 순환(circular dependency)이 생기지 않도록 주의한다.

domain은 data에 의존하지 않고, data가 domain에 의존하는 방향을 지킨다.

app/bootstrap/main의 책임을 명확히 분리하여, main은 최소한의 코드만 남긴다.

✅ Codex 최종 출력 기대
Codex는 이 이슈 내용을 기반으로:

lib/app/app.dart

lib/app/router/app_router.dart

lib/app/bootstrap/bootstrap.dart

lib/app/providers/app_providers.dart

lib/domain/**

lib/data/**

lib/application/**

lib/presentation/** (필요한 핵심 화면/구조 정리)

필요 시 core와의 연결부 일부 수정

위에 해당하는 파일들을 전체 Dart 파일 형태로 생성/수정해야 한다.

최종적으로,
feature/architecture-upgrade 브랜치에
YouthRoad 프로젝트의 “표준 아키텍처” 골격이 완성된 상태가 되어야 한다.

## [feature/search-upgrade] Full Search Engine Rebuild (Query Engine + Ranking + UI/UX) #126
이 이슈는 YouthRoad 앱의 “검색(Search)” 기능을 전면 재구축하기 위한 스펙이다.  
**작업 대상 브랜치는 `feature/search-upgrade`** 이며,  
가능하면 브랜치 생성 이후 아래 명령으로 최신 상태를 동기화한 뒤 진행한다:

```bash
git checkout feature/search-upgrade
git merge fix/kakaomap-webview
git merge feature/architecture-upgrade
검색 모듈은 앱 전체 컨텍스트(Core Stability, Architecture Upgrade, KakaoMap Engine)와 자연스럽게 연결될 수 있도록 재설계해야 한다.

Codex는 반드시 모든 수정·추가 파일을 “완전한 Dart 전체 파일” 형태로 제공해야 한다.
부분 코드 / diff / 생략 출력 금지.

🎯 목표
YouthRoad의 검색 엔진을 다음 방식으로 완전 재설계한다:

고성능 로컬 + 원격 하이브리드 검색 시스템

검색어 자동완성 / 추천 검색어 / 최근 검색 기록

카테고리 필터 + 동적 정렬 옵션

정책/기관/지역 기반 연관 검색 (AI 없는 순수 로직 기반)

검색 결과 ↔ 지도(KakaoMap) 연동

Pagination + Infinite Scroll

Provider 기반의 SearchController 통합

오류·빈결 없는 검색 응답 처리(loading/empty/error)

데이터 계층(data/models, repos, sources) 정리 및 domain/usecase 연결

🧱 구성 요소 (필수)
1) Domain Layer 구조
Directory
pgsql
Copy code
lib/domain/search/
    entities/
    repositories/
    usecases/
필수 엔티티
SearchQuery

SearchResult

SearchCategory

SearchSuggestion

SearchHistoryEntry

필수 인터페이스
SearchRepository

SearchSuggestionRepository

SearchHistoryRepository

필수 유스케이스
ExecuteSearch

GetSearchSuggestions

GetSearchHistory

SaveSearchHistoryEntry

ClearSearchHistory

2) Data Layer 구조
Directory
bash
Copy code
lib/data/search/
    models/
    sources/
    repositories/
Remote Source (필수)
정책 목록

기관 목록

지역 목록 기반의 통합 검색 API

Query → Filter → Pagination 구조 지원

Local Source (필수)
Isar 또는 SharedPreferences 기반 최근 검색어 저장소

로컬 인덱싱 및 캐싱 전략 정의

Model 요구사항
Domain ↔ Data 간 변환 함수(toDomain, fromJson 등) 필수

Null-safe & strict types 적용

3) Application Layer (검색 상태/로직 관리)
Directory:

bash
Copy code
lib/application/search/
    controllers/
    providers.dart
필수 Controller
SearchController

query 입력

debounce 처리 (300~500ms)

remote/local 병합 검색

pagination

상태: idle / loading / success / empty / error

SearchSuggestionController

검색어 입력 시 자동완성 제공

provider-stream 구조

SearchHistoryController

최근 검색어 표시/저장/삭제

제스처 기반 삭제 가능하도록 구조 제공

필수 Providers
searchControllerProvider

searchSuggestionProvider

searchHistoryProvider

Codex는 Provider Layer에서 Riverpod 2.x 스타일로 AsyncNotifier/Notifier 기반 상태를 구축해야 한다.

4) Presentation Layer (UI/UX)
Directory:

bash
Copy code
lib/presentation/search/
    screens/
    widgets/
    viewmodels/
필수 화면 구성
1. SearchScreen (정식 검색 화면)
검색 입력창

자동완성 리스트

최근 검색어: 가로 스크롤 + 삭제 지원

카테고리 필터 (정책/기관/지역 등)

검색 결과 페이지네이션

검색 결과 → KakaoMap 연동 (marker highlight + moveTo)

2. SearchResultList
정책 카드 / 기관 카드 / 지역 카드 통합 UI

common list item widget 필요

3. SearchBar widget (재사용 가능)
홈 화면 / 리스트 화면 어디서든 사용 가능

debounced input 반영

📡 KakaoMap 연동 요구사항
검색 결과 → 지도 이동 or 마커 띄우기 가능한 구조 필요.

예시 이벤트:
검색 결과 항목 클릭 → 맵에서 해당 정책 위치로 zoom + highlight

카테고리 필터 → 지도 필터 자동 변경

지도 이동 시 주변 정책 재검색(optional)

Codex는 반드시 feature/map-upgrade에서 만든 KakaoMapController와 완전히 호환되도록 구현해야 한다.

🧪 테스트 / 안정성 고려
Dart analyzer 에러 없도록 모든 파일 정합성 유지

비동기 흐름(debounce + pagination + auto-complete) 일관성 유지

잘못된 query 처리(empty → empty-state)

네트워크 장애 → error-state (retry 가능)

📏 설계 규칙 (중요)
전 파일은 “완전한 Dart 파일” 형태로 출력할 것

domain → data → application → presentation 레이어 경계 유지

Riverpod 2.x 사용

import 순환 금지

search controller는 debounce 필수

repository는 반드시 interface + implementation 구조

🎉 Codex 최종 출력 기대
Codex는 아래 디렉터리에 해당하는 모든 파일을 완전한 전체 파일로 출력해야 한다:

lib/domain/search/**

lib/data/search/**

lib/application/search/**

lib/presentation/search/**

필요한 provider/integration 파일

출력은 파일 단위로 나누어 제공되어야 하며,
Dart analyzer에서 에러 없는 상태여야 한다.

최종적으로
feature/search-upgrade 브랜치에서 YouthRoad 검색 엔진이 전체 리빌드된 상태가 되어야 한다.

