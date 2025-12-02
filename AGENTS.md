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

## [fix/app-ux-debug-and-map] Youth Road UX / 디버그 패널 / 카카오맵 개선

Status: Open.

### 0. 작업 범위 요약

이번 작업의 목표는 다음 여섯 가지 개선 사항을 한 번에 해결하는 것입니다.

1. 지역 선택 탭에서 **경북 모든 시·군이 표시되지 않는 문제** 수정
2. 상시 노출되는 **디버그 패널 버튼 노출 방식 개선**
3. 카카오맵 로딩 시 **bootstrap timeout / sdkFail / 흰 화면 이슈** 해결
4. 디버그 패널의 **Provider 탭에 아무것도 표시되지 않는 문제** 수정
5. 디버그 패널에서 **아이템 클릭 시 상세 로그 패널에 내용이 표시되지 않는 문제** 수정
6. **카테고리별 탐색 컨텐츠 부족**에 대한 UX/데이터 구조 개선

---

### 1. 지역 선택 탭 – 경북 전체 시·군 미표시 문제

#### 1-1. 배경 / 증상

- "지역을 선택해주세요" 탭에서 **경상북도 전체 시·군 목록이 모두 나오지 않음**.
- 실제 기대값: **경상북도 23개 시·군**이 전부 노출되어야 함.
- 현재: 일부 지역만 노출되거나, 순서/개수가 일치하지 않는 현상 발생.

#### 1-2. 목표

- 앱 내 지역 선택 UI에서 **경북 모든 시·군이 누락 없이 노출**되도록 수정.
- 지역 데이터의 **source(원천), 변환, 필터링, 표시** 전체 체인을 점검 및 정리.

#### 1-3. 상세 요구사항

1. **데이터 소스 확인**
   - 사용 중인 Region/City 리스트 소스 확인:
     - gbyouth OpenAPI 혹은 별도 하드코딩/로컬 JSON 여부.
   - 실제 응답 또는 저장 데이터에서 **엔트리 개수, 키 이름, 코드값** 확인.
   - 기준:
     - 시·군 이름(예: 포항시, 경주시, 김천시…)  
     - 내부 코드(예: regionCode, areaId 등)

2. **모델 매핑 검증**
   - `RegionModel`, `CityModel` 등 영역에서:
     - JSON 키 → 필드 매핑이 올바르게 되어 있는지 확인.
     - null 허용 여부 / 기본값 처리 확인.

3. **필터/정렬 로직 점검**
   - 특정 조건(예: `isActive`, `hasPolicies`) 때문에 일부 지역이 필터링되어 사라지지 않는지 확인.
   - UI 정렬 기준(가나다 순, 코드 순)을 명시적으로 고정.
   - 경북 외 지역(타 시·도)은 이 탭에 노출하지 않도록 별도 조건 분리.

4. **Provider / State 관리**
   - 지역 리스트를 제공하는 Provider (예: `regionListProvider`, `locationFilterProvider`)에서:
     - 초기 로딩 실패 시 UI에 빈 리스트가 들어가지 않도록 에러 처리.
     - 로딩 상태 / 실패 상태를 구분해 로그 남기기.

#### 1-4. 구현 가이드 (예시 흐름)

- `lib/domain/location/entities/region.dart`
  - Region 엔티티에 `code`, `name`, `isAvailable` 필드 존재 여부 확인 및 필요 시 추가.
- `lib/data/location/region_remote_source.dart`
  - API 응답에서 `name`, `code` 필드 매핑 재검증.
  - 응답 길이가 23 미만이면 warning 로그 출력.
- `lib/application/location/region_controller.dart`
  - 초기화 시:
    - `fetchRegions()` 호출.
    - 실패 시 fallback(로컬 하드코딩 리스트) 고려 가능.
- `lib/presentation/location/widgets/region_selector.dart`
  - Provider에서 받은 리스트 길이와 항목을 디버그 로그에 남김.

#### 1-5. 체크리스트

- [ ] 경북 시·군 리스트가 **23개**인지 API/데이터 기준으로 재확인.
- [ ] Region/City 모델 JSON 매핑 점검 및 필요 시 수정.
- [ ] 지역 리스트 Provider 초기화/에러 처리 로직 정리.
- [ ] UI에서 지역 드롭다운/선택 모달에서 **23개 전부 노출** 확인.
- [ ] 잘못된 필터 조건(예: 정책 있는 지역만 노출)이 적용되어 있지 않은지 확인.

#### 1-6. 완료 기준

- 실제 기기/에뮬레이터에서 지역 선택 화면을 열었을 때,  
  경북의 시·군 23개가 **누락 없이 모든 기기에서 동일하게 노출**될 것.
- 디버그 로그에서 지역 리스트 길이 = 23으로 찍히고, 이름이 모두 올바른지 검증.

---

### 2. 디버그 패널 버튼 – 상시 노출 문제

#### 2-1. 배경 / 증상

- 화면 우측/좌측 상단 등에 있는 **디버그 패널 열기 버튼이 항상 떠 있어서 UX적으로 방해**가 됨.
- 현재: dev 빌드 또는 특정 플래그가 true일 때 항상 버튼 노출.

#### 2-2. 목표

- 디버그 패널 버튼을 **필요할 때만** 보이도록 제어.
- 개발/디버깅 편의성은 유지하되, 실제 사용 흐름에서 방해되지 않도록 개선.

#### 2-3. 상세 요구사항

1. **환경별 노출 조건**
   - 기본 룰:
     - `kDebugMode == true`일 때만 디버그 패널 기능 활성.
     - release 빌드에서는 디버그 패널 및 버튼 완전히 숨김.

2. **사용자 토글 도입**
   - SharedPreferences (또는 앱 내 설정 상태)에 `debug_panel_enabled: bool` 플래그 추가.
   - 기본값:
     - dev/debug 빌드는 `true` 또는 `false` 중 팀에서 합의한 값.
   - 앱 내 **개발자 설정 화면 또는 숨겨진 제스처**로 ON/OFF 변경 가능하게 함.
     - 예: 앱 상단 타이틀 5회 탭 시 토글.

3. **지연 노출 / 제스처 기반 노출**
   - 상시 떠있지 않게 하기 위해 아래 중 하나 적용:
     - 앱 시작 후 일정 시간(예: 3초) 후 fade-in.
     - 특정 영역 롱프레스(3초) 시에만 버튼 나타나도록 변경.

4. **시각적 스타일 최소화**
   - 버튼 크기를 작게, 반투명 처리, 화면 모서리에 배치.
   - 드래그로 위치 이동 가능하면 더 좋음.

#### 2-4. 구현 가이드 (예시)

- `lib/debug/debug_panel_launcher.dart`
  - `DebugPanelLauncher` 위젯에서:
    - `shouldShowDebugButton` 계산 로직에
      - `kDebugMode`
      - `debug_panel_enabled` 플래그 반영.
- `lib/application/debug/debug_settings_controller.dart`
  - `debugPanelEnabledProvider` 추가, SharedPreferences 연동.
- `lib/presentation/settings/dev_settings_screen.dart`
  - "디버그 패널 활성화" 토글 스위치 추가 (dev 전용 메뉴).

#### 2-5. 체크리스트

- [ ] release 빌드에서 디버그 버튼/패널 완전히 숨김.
- [ ] debug 빌드에서 설정 토글로 디버그 버튼 ON/OFF 가능.
- [ ] 디버그 버튼이 앱 주요 UI(탭바, FAB, 하단 내비게이션 등)를 가리지 않도록 위치/스타일 조정.
- [ ] 디버그 버튼의 상태가 앱 재시작 후에도 유지되는지 확인.

#### 2-6. 완료 기준

- dev 빌드에서:
  - 설정/제스처를 통해 디버그 버튼을 켰다가 껄 수 있고,
  - 버튼이 상시 방해 요소가 아닌 수준으로 축소/배치.
- release 빌드에서 디버그 버튼 및 패널이 전혀 보이지 않음.

---

### 3. 카카오맵 – bootstrap timeout / sdkFail / 흰 화면 이슈

#### 3-1. 배경 / 증상

- 카카오맵 로딩 시 콘솔에서:
  - bootstrap timeout 발생
  - sdkFail 발생
  - 실제 화면은 **흰 화면만 표시되고 지도는 나타나지 않음**.
- WebView에서 Kakao 지도 HTML/JS를 로딩하는 구조.

#### 3-2. 목표

- 카카오맵 로딩 시 bootstrap timeout / sdkFail이 발생하지 않도록 수정.
- WebView에서 **안정적으로 켜지는 지도 화면** 확보.
- 실패 시에도 원인을 추적할 수 있는 로깅 확보.

#### 3-3. 상세 요구사항

1. **로딩 타이밍 조정**
   - Kakao JS SDK(`kakao.maps.load`) 호출 시점:
     - WebView의 `onLoadStop` 또는 `onPageFinished` 이후에만 실행.
   - 현재 bootstrap 타이머가 **HTML 로딩 전에 나가는지** 확인 후 수정.

2. **타임아웃 시간 조정**
   - 기존 bootstrap timeout 값이 3000ms 정도라면 8000ms 정도로 증가.
   - 네트워크 상태가 조금 느려도 정상 로딩 가능하도록 여유 확보.

3. **appkey / 도메인 / referer 설정 검증**
   - 사용 중인 Kakao JavaScript 키가:
     - 올바른 키인지
     - 허용 도메인(도메인/패키지) 설정이 올바른지
   - 개발 도메인/로컬 환경에서 허용되지 않아 sdkFail 발생 가능성 체크.

4. **에러 로깅 강화**
   - HTML/JS에서:
     - `kakao.maps.load` 실패 시,
     - `onerror`, `catch` 등에서 window.postMessage 또는 console.log로 원인 코드를 앱으로 전달.
   - Flutter 쪽에서 WebView 콘솔 로그를 Debug 패널/Logger로 포워딩.

5. **흰 화면 fallback 처리**
   - 일정 시간 내에 지도 로딩이 되지 않을 경우:
     - “지도를 불러오지 못했습니다. 다시 시도해주세요.” 메시지 + 재시도 버튼 표시.
   - 재시도 시 HTML 재로딩 및 Kakao SDK 재호출.

#### 3-4. 구현 가이드 (예시 경로)

- `lib/presentation/map/widgets/kakao_map_webview.dart`
  - `onWebViewCreated`, `onLoadStop` 핸들러에서 Kakao 초기화 JS 호출 시점 변경.
- `assets/html/kakao_map.html` 또는 유사 경로
  - `kakao.maps.load` 호출부에 try/catch 추가.
  - window.postMessage로 에러 코드/메시지 전달.
- `lib/application/map/kakao_map_controller.dart`
  - bootstrap timeout 타이머를 관리하고, 타임아웃 시 fallback UI 트리거.

#### 3-5. 체크리스트

- [ ] WebView 로딩 순서: HTML → Kakao SDK → 지도 초기화 순서 확인.
- [ ] bootstrap timeout이 과도하게 짧지 않은지 재설정.
- [ ] Kakao JS 키 및 허용 도메인 설정 확인.
- [ ] sdkFail 발생 시 구체적 에러 원인(키 오류, 도메인 오류, 네트워크 오류 등)을 로그에서 확인 가능.
- [ ] 흰 화면만 보이는 상황에서 재시도 UI가 표시되는지 확인.

#### 3-6. 완료 기준

- 적어도 2~3대의 실제 디바이스/에뮬레이터에서:
  - 카카오맵 진입 시 정상적으로 지도 표시.
  - 네트워크가 느릴 때도 지연은 있을 수 있으나 흰 화면에서 멈추지 않고, 실패 시 메시지/재시도 유도.
- 디버그 로그에서 bootstrap timeout / sdkFail 재현이 어렵거나, 발생 시 원인을 식별할 수 있는 메시지가 남을 것.

---

### 4. 디버그 패널 – Provider 탭에 아무것도 표시되지 않음

#### 4-1. 배경 / 증상

- 디버그 패널의 **Provider 탭에 아무 Provider 정보도 표시되지 않는 현상**.
- 예상 구조: Riverpod의 Observer/ProviderContainer 이벤트를 받아 목록을 보여주는 방식.

#### 4-2. 목표

- Provider 탭에 **실제 사용 중인 Provider 목록과 상태 변화가 표시**되도록 복구.
- Riverpod Observer가 올바르게 등록·동작하는지 확인.

#### 4-3. 상세 요구사항

1. **Observer 등록 확인**
   - `ProviderScope` 생성 시 `observers: [DebugProviderObserver()]` 설정이 되어 있는지 확인.
   - 만약 앱 엔트리포인트가 복수개면, 모든 엔트리포인트에 동일하게 적용.

2. **Riverpod 버전/구조 정합성**
   - Riverpod 2.x 사용 시:
     - 기존 1.x 스타일 Observer 코드(예: `ProviderObserver`)가 여전히 유효한지 확인.
   - `DebugProviderObserver` 내부에서:
     - `didAddProvider`, `didUpdateProvider`, `didDisposeProvider` 구현 상태 점검.
     - 예외 발생 시 try/catch로 잡고 최소한 로그는 남기기.

3. **Provider 필터링 로직**
   - Provider 탭에서 표시할 Provider들을 필터링하는 로직 존재 여부 확인:
     - 특정 네임스페이스만 보이게 하다가 아무것도 안 나오는 상황일 수 있음.
   - 최소한 “모든 Provider” 혹은 “이름 있는 Provider만”이라도 표시되도록 조건 완화.

4. **상태 전달 경로**
   - Debug 패널 UI 쪽 상태 모델(예: `DebugProviderTrackerState`)과 Observer가 이벤트를 주고받는 경로 점검.
   - Stream/Notifier/StateNotifier 등 사용 중인 타입에 따라, Listener 연결 여부 확인.

#### 4-4. 구현 가이드 (예시)

- `lib/debug/debug_provider_observer.dart`
  - 각 콜백에서 Debug 패널 Store/Controller로 이벤트 전달:
    - 예: `debugProviderStore.addEvent(provider, newValue);`
- `lib/main.dart` 또는 앱 엔트리포인트
  - `ProviderScope(observers: [DebugProviderObserver()])` 형태 유지.
- `lib/debug/panel/tabs/provider_tab.dart`
  - Store/Controller에서 Provider 이벤트를 subscribe하고, 리스트/필터링 렌더링.

#### 4-5. 체크리스트

- [ ] 앱 실행 시 ProviderObserver 콜백이 실제로 호출되는지 로그로 확인.
- [ ] Provider 탭 리스트에 최소 몇 개의 Provider가 표시되는지 확인.
- [ ] Provider 필터링 조건이 과도하게 restrictive하지 않은지 검토.
- [ ] Provider 탭에서 스크롤과 검색(있다면) 동작 정상 여부 확인.

#### 4-6. 완료 기준

- 앱 구동 후, Provider 탭 진입 시:
  - 여러 Provider가 리스트로 표시되고,
  - 화면 전환/상태 변경 시 해당 Provider 상태 변화가 갱신되는 것을 확인.

---

### 5. 디버그 패널 – 아이템 클릭 시 세부 로그 미표시

#### 5-1. 배경 / 증상

- 디버그 패널에서 특정 항목(네트워크 로그, Provider 이벤트, Map 관련 이벤트 등)을 클릭해도,
  **우측 또는 하단의 상세 패널에 아무 내용도 표시되지 않음**.

#### 5-2. 목표

- 디버그 패널에서 리스트 항목 클릭 시, 해당 항목의 **상세 정보(JSON, timestamp, 메타데이터 등)**가 제대로 표시되도록 복구.

#### 5-3. 상세 요구사항

1. **선택 상태 관리**
   - Debug 패널 상태 모델(예: `DebugPanelState`)에 `selectedItem` 필드 존재 여부 확인.
   - 리스트 클릭 시:
     - `onTap` → `debugPanelController.selectItem(item)` 호출되도록 연결.
   - UI 상세 영역은 `selectedItem` 변화를 listen하고 재렌더링.

2. **타입/직렬화 문제**
   - 로그 아이템이 Map, Object, String 등 다양한 타입일 수 있음.
   - 상세 패널에서 JSON으로 변환 시, 변환 에러로 인해 아무것도 표시되지 않는 상황 방지:
     - 변환 실패 시에도 `toString()` 결과라도 표시.

3. **null 처리**
   - `selectedItem == null` 상태일 때는 “항목을 선택해주세요” 안내 문구 표시.
   - 클릭 후에도 selectedItem이 null이라면, 클릭 이벤트가 제대로 전달되지 않은 것.

4. **탭별 독립 동작**
   - Network 탭, Provider 탭 등 탭이 다를 경우:
     - 탭 전환 시 selectedItem 초기화/유지 정책 정의.
     - 탭마다 별도의 selectedItem을 가질지, 하나를 공유할지 결정.

#### 5-4. 구현 가이드 (예시)

- `lib/debug/panel/debug_panel_controller.dart`
  - `void selectItem(DebugItem item)` 구현:
    - 상태 내 `selectedItem = item;` 후 notify.
- `lib/debug/panel/widgets/debug_item_list.dart`
  - 각 항목 onTap에서 `controller.selectItem(item)` 호출.
- `lib/debug/panel/widgets/debug_item_detail.dart`
  - `selectedItem`을 watch해서, 있을 경우 JSON pretty-print / 없으면 안내 문구 표시.

#### 5-5. 체크리스트

- [ ] 리스트 항목 클릭 시 `selectItem` 로직 호출 여부 확인.
- [ ] 상세 패널이 `selectedItem` 변경을 반영하는지 확인.
- [ ] JSON 직렬화 실패 시에도 최소한 텍스트 형태로 내용이 보이는지 확인.
- [ ] 탭 전환 시 상세 패널 초기화/유지 동작이 자연스러운지 확인.

#### 5-6. 완료 기준

- 디버그 패널에서 임의의 로그 항목을 클릭했을 때:
  - 상세 패널에 해당 로그의 전체 내용 및 메타정보(timestamp, tag 등)가 보일 것.
- 직렬화에 실패하는 특이한 로그 타입이 있어도 앱이 깨지지 않고, 최소한 텍스트는 표시.

---

### 6. 카테고리별 탐색 – 컨텐츠 부족 UX 개선

#### 6-1. 배경 / 증상

- “카테고리별 탐색” 화면에서 **표시되는 정책/컨텐츠 수가 매우 적거나 없는 것으로 느껴짐**.
- 실제 정책 데이터보다 훨씬 적게 보이는 가능성 존재:
  - 카테고리 매핑이 너무 엄격하거나,
  - 필터 조건이 과도하게 좁아서 숨겨지는 정책이 많을 수 있음.

#### 6-2. 목표

- 카테고리별 탐색 화면에서 **실질적으로 활용 가능한 수준의 정책 수**가 보이도록 개선.
- 데이터 구조/필터링/UX 관점에서 모두 검토.

#### 6-3. 상세 요구사항

1. **카테고리 매핑 점검**
   - 내부 카테고리(예: 취업, 창업, 주거, 교육, 생활안정 등)와
     정책 API의 분류 코드가 어떻게 연결되는지 재검토.
   - 하나의 정책이 여러 카테고리에 소속될 수 있도록 매핑 허용 여부 검토.

2. **필터 완화**
   - 예: 모집중/마감 등 상태 필터가 너무 엄격해서 정책이 거의 안 나오지 않는지 확인.
   - 초기에 “모집중+마감임박” 위주, 이후에 “전체 보기” 토글 제공 등 단계적 필터 구조 도입.

3. **정책 개수 표시**
   - 각 카테고리 카드/탭에 “정책 12개” 등 개수를 노출.
   - 0개인 카테고리는 “해당 카테고리의 진행중인 정책이 없습니다” 메시지를 명확히 표시.

4. **대체 컨텐츠 / 추천**
   - 특정 카테고리에 실제 정책이 거의 없다면:
     - 인접 카테고리 정책을 추천,
     - “이 카테고리를 선택한 사람들은 이런 정책도 봤어요” 형태의 제안.

5. **지역 필터와의 결합**
   - 카테고리 + 지역 필터를 동시에 사용하는 경우:
     - 너무 좁아서 0개가 되는 상황이 잦다면,
       “필터를 완화해보세요” 안내 문구 및 원클릭 필터 해제 버튼 제공.

#### 6-4. 구현 가이드 (예시)

- `lib/domain/policy/entities/policy_category.dart`
  - Category 정의 재검토 및 태그 다중 매핑 허용.
- `lib/data/policy/policy_remote_source.dart`
  - 카테고리/지역/상태 필터 파라미터 구성을 명시적으로 분리.
- `lib/application/policy/policy_category_controller.dart`
  - 카테고리별 정책 리스트 계산 로직 정비.
- `lib/presentation/policy/screens/category_explore_screen.dart`
  - 카테고리 카드에 정책 개수 노출.
  - 0개일 때 안내 문구 및 필터 완화 버튼 제공.

#### 6-5. 체크리스트

- [ ] 카테고리-정책 매핑 규칙 문서화(어떤 정책이 어떤 카테고리에 포함되는지).
- [ ] 실제 정책 총 개수 대비 카테고리별 리스트에 표시되는 개수 비교.
- [ ] “0개일 때 UX”가 적절히 안내/대체를 제공하는지 확인.
- [ ] 지역/카테고리/상태 필터 조합에 따라 극단적으로 0만 나오는 조합이 있지 않은지 확인.

#### 6-6. 완료 기준

- 주요 카테고리(취업, 주거, 창업 등)를 눌렀을 때:
  - 실제 gbyouth 정책 수 대비 합리적인 수준의 리스트가 표시.
  - 데이터가 적은 경우에도 사용자에게 이유와 대체 행동(필터 완화, 다른 카테고리 추천 등)을 제공.

---


### 7. 청년 검색 V2 – 진입 시 청년정책 데이터가 로드되지 않는 문제

#### 7-1. 배경 / 증상

- 홈 또는 다른 화면에서 **“청년 검색 V2(Youth Search V2)” 버튼을 탭**하면  
  검색 화면으로 정상 이동하지만,
- 화면 초기화 시점에 **정책/검색 초기 데이터가 로드되지 않아 빈 화면**만 표시됨.
- 검색창, 추천 정책, 최근 검색 등의 초기 상태가 비어 있는 것으로 보임.

#### 7-2. 목표

- 검색 화면 진입 즉시 필요한 모든 초기 데이터(정책 목록, 추천 정책, 인기 검색 키워드 등)가 **자동으로 로드**되도록 복구.
- 초기 로딩 순서를 명확히 정의해, 어떤 상황에서도 빈 상태로 진입하지 않도록 보장.

#### 7-3. 상세 요구사항

1. **초기 로딩 트리거 보장**
   - `SearchControllerV2` 또는 관련 Notifier에서  
     `onInit()` 혹은 `build()` 시점에 다음 데이터를 자동 로드해야 함:
     - 기본 정책 목록 (전체 or 특정 정렬 기준)
     - 추천 정책 목록
     - 인기 검색어 목록
     - 지역 기반 추천 목록(있다면)

2. **네비게이션 구조 점검**
   - 기존 Search V1 → V2 구조 변경 과정에서  
     라우터 GoRouter의 `extra`, `refreshListenable`, `redirect` 로직이  
     초기 호출을 막고 있을 가능성 있음.
   - 검색 화면이 ProviderScope 하위가 아닌 다른 scope 내부에 진입하며  
     Provider가 재생성되지 않는 상황인지 확인.

3. **비동기 순서 관리**
   - 화면 진입 후 UI가 먼저 그려지고,  
     정책 데이터 fetch가 나중에 실행되거나 누락되는 상황을 방지:
     - 반드시 `Future.microtask(() => controller.initialize());` 형태로 초기화.
     - 또는 `AsyncNotifier.build` 내부에서 자동 호출.

4. **오류 발생 시 fallback**
   - 정책 로딩 실패 시:
     - “정책을 불러오지 못했습니다. 다시 시도해주세요.”  
     - 재시도 버튼 or Swipe-to-Refresh 지원.

5. **Skeleton UI 제공**
   - 초기 상태 로딩 시 skeleton placeholder 노출  
     → 빈 화면으로 보이지 않도록 UX 보완.

#### 7-4. 구현 가이드 (예시)

- `lib/application/search/controllers/search_controller_v2.dart`
  - `initialize()` 또는 `loadInitialData()` 함수 생성:
    - 추천 정책
    - 기본 정책 리스트
    - 인기 키워드
    - 최근 검색어  
    한 번에 sequential/parallel 호출.
- `lib/presentation/search_v2/search_screen_v2.dart`
  - `ref.listen` 또는 `ref.watch`를 통해 초기화 타이밍 보장.
- `lib/application/search/providers.dart`
  - 진입 시 자동 호출되는 Provider 구조 재검토.

#### 7-5. 체크리스트

- [ ] 검색 화면 진입 직후 정책 데이터 fetch가 실행되는지 로그로 확인.
- [ ] 초기 상태가 빈 화면이 아닌 skeleton/로딩 UI인지 확인.
- [ ] 추천 정책/기본 정책/인기 키워드가 모두 정상 로드되는지 확인.
- [ ] 네비게이션 전환 방식(GoRouter push/pop)이 초기화를 막지 않는지 검토.

#### 7-6. 완료 기준

- 검색 V2 진입 시:
  - 어떤 경로(Home → Search, Explore → Search, Region → Search 등)에서 진입하더라도
  - 정책 데이터/추천 리스트/검색 이력 등이 **즉시 로드되어 화면에 표시**됨.
- 빈 화면/초기화 누락 현상이 재현되지 않을 것.

---

### 8. 지역 변경 시 추천 정책이 잠시 나타났다 사라지는 문제

#### 8-1. 배경 / 증상

- 지역 필터를 변경하면  
  **추천 정책이 1~2초간 표시되었다가 사라지는 문제** 발생.
- UI는 “추천 정책(지역 기반)”이 표시되었다가  
  이후 상태 변화로 인해 리스트가 empty 상태로 재렌더링되는 것으로 보임.
- Riverpod 재빌드, 필터 로직, debounce, 천천히 도착하는 async 응답 등이 원인 가능성이 높음.

#### 8-2. 목표

- 지역 변경 시 추천 정책이 **안정적으로 유지되거나 갱신**되도록 개선.
- 추천 정책이 나타났다 사라지는 “깜빡임” 현상 제거.
- 비동기 응답 순서 문제를 방지.

#### 8-3. 상세 요구사항

1. **응답 순서 경쟁(race condition) 제거**
   - A 지역 요청 → B 지역 요청 순서가 뒤섞여  
     나중에 들어온 요청이 이전 요청을 덮어쓰는 문제 발생 가능.
   - 해결:
     - 요청마다 requestId 생성 → 응답 시 동일 requestId인지 검증.
     - 또는 `cancelToken`으로 이전 요청 취소.

2. **초기 상태 관리 명확화**
   - 지역 변경 직후 recommended state를  
     빈 리스트로 초기화하지 말고,  
     기존 리스트 유지 → 새 응답이 오면 교체.
   - 즉:
     - “Loading” → 기존 리스트 유지  
     - “Loaded” → 새 리스트로 교체  
     - “Error” → 기존 리스트 유지 + 토스트/메시지 표시

3. **디버그 로그 추가**
   - 지역 변경 시:
     - oldRegion → newRegion 로깅
     - fetchRecommendedPolicies(region) 시작 시점
     - 응답 성공/실패 시점
     - 응답 리스트 길이, requestId 유효성 표시

4. **필터/조건 누락 방지**
   - 지역 기반 추천 정책 필터링에 다음 문제가 없는지 확인:
     - 정책 데이터에 regionId가 누락된 경우
     - 특정 지역에서 추천 정책이 실제로 존재하지 않는 경우
     - 검색 V2와 공유된 필터 글로벌 상태가 reset되는 경우

5. **UI 스테이트 분리**
   - 추천 정책 displayedState vs 로딩 logic state 구분:
     - 로딩 중에도 화면은 이전 추천 정책을 유지해야 함.
     - 빈 모습이 잠깐이라도 나오지 않도록 함.

6. **지연(debounce) vs 즉시 반영 정책 재조정**
   - 지역이 빠르게 변경될 때:
     - debounce 300ms 적용  
     또는
     - 이전 요청 cancel하고 새 요청 생성

#### 8-4. 구현 가이드 (예시)

- `lib/application/policy/recommendation_controller.dart`
  - `currentRequestId` 저장
  - fetch 시 새로운 id 생성  
    응답 시 id 비교 후 업데이트 여부 결정
  - 기존 recommended 리스트 유지한 채 상태 전이

- `lib/presentation/search_v2/widgets/recommended_section.dart`
  - 지역 변경 시 UI가 empty로 초기화되지 않도록 상태 분기:
    - `loading`이면 skeleton  
    - `loaded`이면 리스트 표시  
    - `error`면 기존 리스트 유지 + 에러 메시지

- `lib/application/policy/providers.dart`
  - 지역 필터 provider 변경 시  
    recommendation provider가 즉시 invalidate되면서 빈 리스트로 초기화되는지 확인.
  - 필요 시 `keepAlive` 적용.

#### 8-5. 체크리스트

- [ ] 지역 변경 직후 Recommended UI가 empty로 초기화되지 않는지 확인.
- [ ] race condition 방지 로직(requestId or cancelToken) 동작 확인.
- [ ] 응답 순서가 꼬여도 UI가 깜빡이거나 사라지지 않을 것.
- [ ] 추천 정책이 있는/없는 지역 모두에서 정상 동작 확인.

#### 8-6. 완료 기준

- 지역 변경 시:
  - 추천 정책이 지나가듯 잠시 보였다 사라지는 현상이 **완전히 제거**됨.
  - UI는 항상 “일관적이고 안정된 추천 정책 상태”를 유지.
- 빠르게 지역을 연속 변경해도  
  추천 정책이 덧그려지거나 사라지는 문제 없이 부드럽게 갱신됨.

---


