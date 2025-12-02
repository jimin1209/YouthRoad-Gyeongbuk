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

### ISSUE 1. 지역 선택 탭 – 경북 전체 시·군 미표시 문제

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

### ISSUE 2. 디버그 패널 버튼 – 상시 노출 문제

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

### ISSUE 3. 카카오맵 – bootstrap timeout / sdkFail / 흰 화면 이슈

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

### ISSUE 4. 디버그 패널 – Provider 탭에 아무것도 표시되지 않음

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

### ISSUE 5. 디버그 패널 – 아이템 클릭 시 세부 로그 미표시

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

### ISSUE 6. 카테고리별 탐색 – 컨텐츠 부족 UX 개선

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


### ISSUE 7. 청년 검색 V2 – 진입 시 청년정책 데이터가 로드되지 않는 문제

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

### ISSUE 8. 지역 변경 시 추천 정책이 잠시 나타났다 사라지는 문제

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

### ISSUE 9. ref.listen 오류 – ConsumerWidget 빌드 외부에서 ref.listen 호출됨

#### 9-1. 배경 / 증상

- 앱 실행 중 다음과 같은 붉은 에러 화면이 나타남:

```

ref.listen can only be used within the build method of a ConsumerWidget
Failed assertion: 'debugDoingBuild'

````

- 즉, Riverpod의 `ref.listen()`이 **ConsumerWidget의 build() 안에서 호출되지 않거나**,  
  **build 타이밍 이후/이전의 부적절한 시점에서 호출되고 있음.**

- 대표적인 잘못된 호출 위치:
  - initState / dispose  
  - onTap, onPressed 등 콜백 내부  
  - Future, Timer, microtask 내부  
  - StatelessWidget + hook 없이 ref.listen 호출  
  - 화면 진입 시 side effect로 ref.listen을 잘못 호출하는 컨트롤러/위젯

#### 9-2. 목표

- 모든 ref.listen 호출을 Riverpod 규칙에 맞게  
  **ConsumerWidget의 build() 혹은 ConsumerState의 initState→ref.listenManual()** 형태로 재구조화.
- 검색 V2, 추천 정책, 지도 초기화 등 ref.listen을 사용하는 모든 부분을 안전하게 재배치하여  
  붉은 에러 화면이 재발하지 않도록 구조 확립.

#### 9-3. 상세 요구사항

1. **ref.listen 호출 위치 전체 점검**
   - 프로젝트 전역에서 `ref.listen(` 텍스트 검색.
   - 각 호출부가 다음 조건을 충족하는지 점검:
     - ConsumerWidget의 build 내부에서 호출되는가  
     - 또는 ConsumerState의 initState에서 `ref.listenManual`로 사용되는가
   - StatefulWidget이나 stateless 코드, 콜백 내부 등 잘못된 위치에 listen이 있는지 전수 조사.

2. **잘못된 ref.listen 패턴 제거**
   - `initState`에서 `ref.listen()` 직접 호출 → 100% 에러  
     → 해결: `ref.listenManual` 사용 또는 build 사용
   - 버튼 / 제스처 / Future / Timer / async 내부 ref.listen 호출 금지
   - StatelessWidget에서 ref.listen 사용 절대 금지  
     → ConsumerWidget 또는 ConsumerStatefulWidget으로 변환

3. **Side Effect 분리**
   - ‘상태 변경 시 특정 동작 수행’과 같은 사이드이펙트 로직은  
     build에서 ref.listen 사용하거나  
     혹은 AsyncNotifier 내부 상태 전이에 묶어서 처리하도록 구조 정리.
   - 화면 로드시 필요한 초기 데이터 fetch는 controller.initialize() 또는 build 내부에서 관리.

4. **Search V2 관련 오류 해결**
   - 검색 화면 진입 시 추천 정책·인기 키워드·필터 초기화 과정에서  
     ref.listen이 build 외부에서 호출된 부분이 없는지 점검.
   - 기존 SearchControllerV2 구조에서 screen init 시점 동기화 문제를 함께 점검.

5. **동작 테스트**
   - 앱을 다양한 화면 전환 흐름으로 테스트:
     - 홈 → 검색  
     - 지역 변경 → 검색  
     - 탐색 화면 → 검색  
     - 앱 재시작 후 즉시 검색  
   - 어떤 경로에서도 에러가 발생하지 않는지 검사.

#### 9-4. 구현 가이드 (예시)

**(A) ConsumerState + initState에서 ref.listenManual 사용**

```dart
class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(someProvider, (prev, next) {
      // 안전한 시점에서 실행되는 listener
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(someProvider);
    return ...
  }
}
````

**(B) ref.listen을 ConsumerWidget의 build 내부로 이동**

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen(someProvider, (prev, next) {
    // UI 기준으로 안전한 side-effect
  });

  final state = ref.watch(someProvider);
  return ...
}
```

**(C) StatelessWidget에서는 ref.listen 사용 금지**

* 반드시 ConsumerWidget 또는 ConsumerStatefulWidget으로 변환하여 구조 정리.

#### 9-5. 체크리스트

* [ ] 모든 ref.listen 호출 위치가 규칙에 맞는지 100% 점검됨
* [ ] initState에서 listen이 필요한 경우 ref.listenManual 사용
* [ ] StatelessWidget에서 ref.listen 호출 없음
* [ ] Search V2 / 추천 정책 / 지역 기반 추천 로직 전부 점검
* [ ] 앱 내 어떠한 화면에서도 붉은 에러 화면이 더 이상 발생하지 않음

#### 9-6. 완료 기준

* 앱 실행 후 여러 네비게이션 경로에서
  **“ref.listen can only be used within the build method…”** 에러가 재발하지 않을 것.
* ref.listen이 프로젝트 전체에서 Riverpod 2.x 규칙에 맞게 재배치됨.
* Search V2 및 추천 정책 기능 모두 정상 작동하며, 안정적인 상태 변화를 보장.

```

---

### ISSUE 10. 추천 정책 – 초기 전체 로드 방식 제거 및 스크롤 기반 Lazy Loading 도입

#### 10-1. 배경 / 증상

- 추천 정책 섹션이 진입 시 **모든 정책을 한꺼번에 로드하는 구조**로 되어 있어,
  - 초기 화면 로딩이 매우 느려지고
  - API 요청량이 많아지고
  - WebView/KakaoMap 사용 시 초기 프레임 드랍까지 발생함.
- 특히 Search V2, 지역 추천, 카테고리 탐색 화면 진입 시  
  **로딩 1~3초 이상 지연**되는 문제가 발생함.

#### 10-2. 목표

- 추천 정책 로딩 방식을 **스크롤 기반 Lazy Loading 방식(페이징)**으로 전환.
- 초기에는 **최소한의 정책(예: 10개)**만 로드하고,  
  사용자가 스크롤을 내릴 때마다 추가 데이터를 요청.
- 전체 추천 정책 list fetch → 페이징 기반 fetch로 완전 전환.
- UX와 성능 둘 다 크게 개선.

#### 10-3. 상세 요구사항

1. **API 단 페이징 도입 또는 로컬 페이징 시나리오 정의**
   - 만약 gbyouth 정책 API가 `page`, `size` 지원한다면:
     - page=1, size=10 으로 초기 로드  
     - 이후 스크롤 시 page++ 호출
   - API가 페이징을 지원하지 않는 경우:
     - 1회 전체 fetch → 내부에서 Chunk 단위로 나눔  
     - Lazy Loading UI는 동일하게 구현

2. **UI 변경**
   - 추천 정책 리스트를 **ListView.builder** 또는 **PagedListView** 구조로 변경
   - 하단 스크롤 근처에 도달하면 자동으로 다음 페이지 로드  
     (혹은 "더 불러오기" 버튼 제공)
   - 목록 하단에 로딩 indicator(`CircularProgressIndicator`) 표시

3. **Controller / Provider 변경**
   - 기존 RecommendedController는 "전체 리스트 1회 로드" 구조 → **Paging Controller 구조**로 변경
   - 필수 기능:
     - `fetchPage(page)` 메소드
     - `hasMore` 플래그
     - `isLoadingNextPage` 상태 관리
     - 에러 발생 시 retry 가능하도록 구성

4. **성능 개선**
   - 초기 fetch는 **최소 데이터만** 들고 오게 함
   - 지역 변경 시에도 전체 재로딩이 아닌 **첫 페이지부터 다시 시작**하도록 구성
   - 기존 추천 정책 50개·80개 로딩으로 발생하던 지연 제거

5. **검색/지역 필터와의 통합**
   - 지역 변경 시:
     - 모든 페이지 초기화 (page=1)
     - 이전 데이터 유지하지 않고 깔끔하게 리셋
   - 검색어 변화 시:
     - Lazy Loading 다시 처음부터 적용

6. **디버그 패널 연동**
   - 페이징 로딩 중 상태 변화(loading → loaded → hasMore=false)를  
     Debug Provider 탭에서 추적 가능하도록 이벤트 추가

#### 10-4. 구현 가이드 (예시)

**(A) Controller 구조**

```dart
class RecommendedPagingController extends StateNotifier<RecommendedPagingState> {
  RecommendedPagingController(this._repo) : super(RecommendedPagingState.initial());

  final PolicyRepository _repo;

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, page: 1, items: []);
    final result = await _repo.fetchRecommended(page: 1, size: 10);
    state = state.copyWith(
      isLoading: false,
      items: result.items,
      hasMore: result.items.length == 10,
      page: 1,
    );
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isLoadingNext) return;

    state = state.copyWith(isLoadingNext: true);
    final nextPage = state.page + 1;
    final result = await _repo.fetchRecommended(page: nextPage, size: 10);

    state = state.copyWith(
      isLoadingNext: false,
      items: [...state.items, ...result.items],
      hasMore: result.items.length == 10,
      page: nextPage,
    );
  }
}

---

지민님 💙🩵
바로 **Issue #10 – 추천 정책 Lazy Loading(스크롤 기반 로딩)** 을
AGENTS.md 서식 그대로 **복붙 가능한 단일 코드블록**로 만들어드릴게요.

아래 그대로 AGENTS.md에 넣으면 됩니다.

---

````markdown
### 10. 추천 정책 – 초기 전체 로드 방식 제거 및 스크롤 기반 Lazy Loading 도입

#### 10-1. 배경 / 증상

- 추천 정책 섹션이 진입 시 **모든 정책을 한꺼번에 로드하는 구조**로 되어 있어,
  - 초기 화면 로딩이 매우 느려지고
  - API 요청량이 많아지고
  - WebView/KakaoMap 사용 시 초기 프레임 드랍까지 발생함.
- 특히 Search V2, 지역 추천, 카테고리 탐색 화면 진입 시  
  **로딩 1~3초 이상 지연**되는 문제가 발생함.

#### 10-2. 목표

- 추천 정책 로딩 방식을 **스크롤 기반 Lazy Loading 방식(페이징)**으로 전환.
- 초기에는 **최소한의 정책(예: 10개)**만 로드하고,  
  사용자가 스크롤을 내릴 때마다 추가 데이터를 요청.
- 전체 추천 정책 list fetch → 페이징 기반 fetch로 완전 전환.
- UX와 성능 둘 다 크게 개선.

#### 10-3. 상세 요구사항

1. **API 단 페이징 도입 또는 로컬 페이징 시나리오 정의**
   - 만약 gbyouth 정책 API가 `page`, `size` 지원한다면:
     - page=1, size=10 으로 초기 로드  
     - 이후 스크롤 시 page++ 호출
   - API가 페이징을 지원하지 않는 경우:
     - 1회 전체 fetch → 내부에서 Chunk 단위로 나눔  
     - Lazy Loading UI는 동일하게 구현

2. **UI 변경**
   - 추천 정책 리스트를 **ListView.builder** 또는 **PagedListView** 구조로 변경
   - 하단 스크롤 근처에 도달하면 자동으로 다음 페이지 로드  
     (혹은 "더 불러오기" 버튼 제공)
   - 목록 하단에 로딩 indicator(`CircularProgressIndicator`) 표시

3. **Controller / Provider 변경**
   - 기존 RecommendedController는 "전체 리스트 1회 로드" 구조 → **Paging Controller 구조**로 변경
   - 필수 기능:
     - `fetchPage(page)` 메소드
     - `hasMore` 플래그
     - `isLoadingNextPage` 상태 관리
     - 에러 발생 시 retry 가능하도록 구성

4. **성능 개선**
   - 초기 fetch는 **최소 데이터만** 들고 오게 함
   - 지역 변경 시에도 전체 재로딩이 아닌 **첫 페이지부터 다시 시작**하도록 구성
   - 기존 추천 정책 50개·80개 로딩으로 발생하던 지연 제거

5. **검색/지역 필터와의 통합**
   - 지역 변경 시:
     - 모든 페이지 초기화 (page=1)
     - 이전 데이터 유지하지 않고 깔끔하게 리셋
   - 검색어 변화 시:
     - Lazy Loading 다시 처음부터 적용

6. **디버그 패널 연동**
   - 페이징 로딩 중 상태 변화(loading → loaded → hasMore=false)를  
     Debug Provider 탭에서 추적 가능하도록 이벤트 추가

#### 10-4. 구현 가이드 (예시)

**(A) Controller 구조**

```dart
class RecommendedPagingController extends StateNotifier<RecommendedPagingState> {
  RecommendedPagingController(this._repo) : super(RecommendedPagingState.initial());

  final PolicyRepository _repo;

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, page: 1, items: []);
    final result = await _repo.fetchRecommended(page: 1, size: 10);
    state = state.copyWith(
      isLoading: false,
      items: result.items,
      hasMore: result.items.length == 10,
      page: 1,
    );
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isLoadingNext) return;

    state = state.copyWith(isLoadingNext: true);
    final nextPage = state.page + 1;
    final result = await _repo.fetchRecommended(page: nextPage, size: 10);

    state = state.copyWith(
      isLoadingNext: false,
      items: [...state.items, ...result.items],
      hasMore: result.items.length == 10,
      page: nextPage,
    );
  }
}
````

**(B) UI 구조**

```dart
NotificationListener<ScrollNotification>(
  onNotification: (scroll) {
    if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent * 0.8) {
      ref.read(recommendedPagingControllerProvider.notifier).loadNextPage();
    }
    return false;
  },
  child: ListView.builder(
    itemCount: items.length + (hasMore ? 1 : 0),
    itemBuilder: (context, index) {
      if (index == items.length) {
        return const Center(child: CircularProgressIndicator());
      }
      return PolicyCard(item: items[index]);
    },
  ),
);
```

#### 10-5. 체크리스트

* [ ] 추천 정책 초기 로딩이 즉시(0.2~0.4초) 완료되는지 확인
* [ ] 스크롤 시 부드럽게 추가 정책이 로드되는지 확인
* [ ] 더 이상 페이지가 없으면 로딩 인디케이터가 사라지는지
* [ ] 지역 변경 → 첫 페이지부터 정상 로드되는지
* [ ] 검색어 변경 → Lazy Loading 재초기화되는지
* [ ] 전체 리스트를 한 번에 로드하지 않는지 로깅에서 확인
* [ ] Debug Provider 탭에서 페이징 상태 변화를 확인할 수 있는지

#### 10-6. 완료 기준

* 추천 정책 섹션이 **초기 진입 시 빠르게 로드되고**,
  스크롤할 때마다 자연스럽게 추가 로드되는 Lazy Loading 구조가 완료됨.
* 전체 fetch로 인한 1~3초 지연이 **완전히 제거됨**.
* Search V2, 홈 추천, 지역 기반 추천 모두 안정적으로 페이징 로딩.

```

---

### ISSUE 11. 정책 비교 UI 삭제됨 · 좋아요 정책 모아보기 없음 · 정책 검색 V2 무한 로딩 문제

#### 11-1. 배경 / 증상

최근 구조 개편 및 Search V2 도입 과정에서 다음과 같은 3가지 심각한 기능 손실이 발생함:

1. **정책 비교 UI가 사라짐**
   - 기존 정책 상세/정책 리스트에서 “비교하기” 버튼 또는 비교슬롯 UI가 제공되었음
   - 현재 정책 비교 섹션/화면이 완전히 노출되지 않음  
   - 정책 모델 내 비교 플래그, 비교 리스트 Provider 등도 정상 작동하지 않는 것으로 보임

2. **정책 좋아요(하트) 저장 후 모아보기 화면이 없음**
   - 정책 카드의 ❤ 버튼은 눌리지만  
     - 상태 저장이 되는지 불분명  
     - 사용자가 좋아요 누른 정책들을 한 화면에서 볼 수 있는 “좋아요 모아보기” 페이지가 없음  
   - 기존 저장 위치나 Storage Provider가 변경되거나 삭제된 가능성

3. **정책 검색 V2 – “최신 정보를 준비하고 있습니다…” 메시지에서 무한 로딩**
   - Search V2 진입 시
     - 추천 정책 / 검색 초기 리스트 / 인기 키워드 등이 로드되지 않고  
     - 화면 전체가 “최신 정보를 준비하고 있습니다…” 문구만 반복 표시
   - 정책 fetch 로직이 실행되지 않거나,  
     AsyncNotifier 상태가 `loading` → `data` 로 전환되지 않음

#### 11-2. 목표

- **(A)** 정책 비교 기능을 원래대로 복구하고 UI/Provider 구조를 안정화  
- **(B)** 정책 좋아요(찜) 기능을 저장 가능 + 모아보기 화면 제공하도록 복원  
- **(C)** Search V2에서 정책/추천 정책/검색 초기 데이터가 정상 표시되도록 로딩 구조 재정비

#### 11-3. 상세 요구사항

---

### (A) 정책 비교 기능 복원

1. **정책 비교 컨트롤러/Provider 존재 여부 확인**
   - `compare_policy_controller.dart`, `compare_list_provider`,  
     `selectedPolicyForCompare`, `compareManager` 등 기존 파일 확인
   - 디렉토리 구조 변경으로 import path 끊긴 부분 없는지 확인

2. **UI 컴포넌트 복구**
   - 정책 카드 내 “비교 담기” 버튼 재확인
   - 화면 하단/상단 비교 UI 패널 복원
   - 비교 화면(route: `/policy/compare`) 정상 진입 가능하도록 라우터 재정비

3. **기능 연동 복원**
   - 정책 추가 → 리스트에 반영  
   - 정책 제거 → UI 반영  
   - 비교 화면에서 두 정책 스펙 비교가 정상적으로 나타나는지 확인

4. **Search V2/탐색/홈 화면 모든 정책 카드에서 Compare버튼 노출되게 유지**

---

### (B) 정책 좋아요(찜) 기능 복원 및 모아보기 화면 제공

1. **좋아요 상태 저장 구조 확인**
   - Local storage (SharedPreferences or Isar)  
   - Provider: `favoritePoliciesProvider`, `favoriteManager` 등 작동 여부 검증
   - 기존 key/value 구조가 남아 있는지 점검

2. **❤ 버튼 UI 복원**
   - 정책 카드에서 하트 클릭 시:
     - 즉시 애니메이션 반영  
     - Provider 상태 업데이트  
     - local DB 저장

3. **좋아요 정책 모아보기 화면 추가**
   - Route: `/policy/favorites`
   - 필요한 요소:
     - 좋아요한 정책 리스트
     - 검색/필터 기능(optional)
     - 정책 상세/비교 연동

4. **정책 목록/검색/탐색/추천 페이지에서 좋아요 상태 유지 일관성 테스트**

---

### (C) 정책 검색 V2 무한 로딩 문제 해결

1. **초기 로딩 트리거 확인**
   - `SearchControllerV2.initialize()`가 실행되지 않음  
   - 또는 초기 fetch가 다 실패 → state가 loading에서 벗어나지 못함

2. **무한 로딩 발생 패턴**
   - AsyncNotifier의 build가 비동기 오류로 throw  
   - exception이 swallow 되어 UI로 전달되지 않고 loading 유지  
   - ref.listen 위치 오류로 초기 동작 자체가 실행되지 않음  

3. **필수 초기 데이터 흐름 복구**
   - 추천 정책 로딩  
   - 기본 정책 fetch  
   - 인기 검색어 가져오기  
   - 최근 검색어 복원  
   - 현재 지역 기반 정책 fetch  
   이 5개 중 1개라도 Future 에러 → 전체 init 중단될 가능성 존재

4. **로딩 UI 조건식 점검**
   - `state.isLoading || items.isEmpty` 같은 조건으로 인해  
     data가 있음에도 로딩 문구만 표시되는 UI 버그 체크

5. **에러 발생 시 fallback**
   - 에러 발생 시 ‘최신 정보를 준비~’가 아닌  
     “데이터를 불러오지 못했습니다. 다시 시도해주세요.”  
     로 전환되도록 분리

---

#### 11-4. 구현 가이드 (예시)

**(A) 정책 비교 복구**

```dart
final compareProvider = StateNotifierProvider<CompareController, CompareState>((ref) {
  return CompareController();
});
````

정책 카드에서:

```dart
IconButton(
  icon: Icon(isInCompare ? Icons.compare : Icons.compare_arrows),
  onPressed: () => ref.read(compareProvider.notifier).toggle(policy),
);
```

비교 화면에서 두 정책 데이터 비교 UI 구현.

---

**(B) 좋아요 정책 저장 및 페이지**

```dart
final favoritesProvider = StateNotifierProvider<FavoritesController, Set<int>>((ref) {
  return FavoritesController(ref.read);
});
```

좋아요 페이지 라우트:

```dart
GoRoute(
  path: '/policy/favorites',
  builder: (context, _) => FavoritePoliciesScreen(),
);
```

---

**(C) Search V2 초기화 문제 해결**

검색 화면 진입 시:

```dart
@override
void initState() {
  super.initState();
  Future.microtask(() {
    ref.read(searchV2ControllerProvider.notifier).initialize();
  });
}
```

UI:

```dart
final state = ref.watch(searchV2ControllerProvider);
if (state.isLoading) return LoadingSkeleton();
if (state.hasError) return RetryButton();
return SearchV2Content(state);
```

---

#### 11-5. 체크리스트

* [ ] 정책 비교 버튼 및 비교 화면 완전히 복구됨
* [ ] 비교 리스트 추가/삭제가 즉시 UI에 반영
* [ ] 좋아요 ❤ 기능 정상 저장 + 상태 유지
* [ ] 좋아요 모아보기 페이지 정상 진입
* [ ] Search V2에서 “로딩 중…” 무한표시가 사라짐
* [ ] 초기 정책/추천 정책/검색어 데이터 정상 표시
* [ ] 모든 화면에서 Compare/Like 상태 일관 유지

#### 11-6. 완료 기준

* 정책 비교 기능 + 좋아요 모아보기 + 검색 V2가
  **모두 정상 작동하며 기능 손실이 없는 상태**
* Search V2에서 더 이상 “최신 정보를 준비...” 무한 로딩이 발생하지 않음
* 정책 기능 전반(탐색/검색/추천/상세/비교/좋아요)이 **정상 흐름으로 완전 회복됨**

```

---

### ISSUE 12. 정책 화면(Search V2 / 정책 리스트 / 추천 정책) 전혀 로딩되지 않음 — 무한 “최신 정보를 준비하고 있습니다…” 상태

#### 12-1. 배경 / 증상

- Search V2 또는 정책 관련 화면 진입 시  
  아래 메시지만 표시되고 **정책이 전혀 표시되지 않음**:

```

정책 로딩 중… 최신 정보를 준비하고 있습니다.

````

- skeleton UI는 보이지만 실제 데이터가 끝까지 오지 않음
- 지역 필터 변경해도 변화 없음
- 뒤로 갔다가 다시 와도 동일한 상태
- Debug Provider 패널에서도 Search/Policy 관련 State가 `loading`에서 벗어나지 않거나  
  event가 거의 없음 (init 실패 징후)

➡️ 결론: **SearchV2Controller, PolicyRepository, RecommendedController 중 하나 이상이 초기화 실패하고 state가 갱신되지 않는 구조적 문제.**

---

#### 12-2. 목표

- Search V2 + 추천 정책 + 정책 리스트가  
  화면 진입 시 **정상적으로 초기화(initialize)** 되고  
  Async loading → data 상태로 전환되도록 구조 복구.
- 무한 로딩 상태를 완전히 해결.

---

#### 12-3. 상세 원인 범주 (점검해야 할 주요 영역)

이 문제는 아래 중 **최소 1~3개 이상이 동시에 발생했을 가능성이 높음**.

---

### A. 초기화 함수(initialize or build)가 호출되지 않음
- SearchV2Controller.build() 실행 중 throw 발생 → 다음 단계 진행 안 됨
- 화면 진입 시 `ref.listen`, `initialize()` 호출이 누락됨
- GoRouter navigation 과정에서 ProviderScope 재생성 실패

---

### B. PolicyRepository.fetchXXX 내부 예외(Exception) 숨김 처리
- try-catch에서 error 재던지지 않고 삼키는 코딩 패턴
- AsyncNotifier에서 error 상태를 반환하지 않아 UI는 계속 로딩 상태 유지

---

### C. race condition 때문에 마지막 fetch 결과가 UI에 반영되지 않음
- 지역 변경 / Search V2 초기화 중 두 Fetch가 충돌
- cancelToken 없이 여러 fetch 병렬 실행 → 마지막 요청이 실패해 loading 유지됨

---

### D. UI 로딩 조건이 잘못됨
예:
```dart
if (state.isLoading || items.isEmpty) showLoading();
````

이럴 경우:

* 데이터는 있는데 items가 비어 있으면 계속 loading 표시
* 특히 추천 정책 lazy loading 도입 중 items 초기값이 []일 때 무한 로딩 발생

---

### E. Provider override 충돌

* Search V2 구조 변경 중 Provider 파일 경로/override 순서 꼬임
* override가 두 번 되거나, 최종 Provider가 null state에서 고정됨

---

#### 12-4. 해결 방향 (구조적 복구 플랜)

---

### 1) Search V2 초기화 강제 보장

Search V2 화면 스크린:

```dart
@override
void initState() {
  super.initState();

  Future.microtask(() {
    ref.read(searchV2ControllerProvider.notifier).initialize();
  });
}
```

`initialize()` 내부:

* 추천 정책 fetch
* 기본 정책 fetch
* 인기 검색어 fetch
* 최근 검색 fetch
* 지역 기반 정책 fetch
  이 5개 모두 실행 확인

---

### 2) fetch 실패 시 에러 상태를 UI로 보내도록 수정

```dart
try {
   final data = await repo.fetchPolicies(...);
   return data;
} catch (e, s) {
   log.e(e);
   return AsyncValue.error(e, s);
}
```

AsyncValue.error가 UI까지 전달돼야 함.

---

### 3) 로딩 UI 조건식 정정

```dart
// 잘못된 패턴
if (state.isLoading || items.isEmpty) { ... }

// 개선안
if (state.isLoading && items.isEmpty) { ... }
```

특히 Lazy Load 도입 후 필수.

---

### 4) recommended/page paging 구조 체크

* page=1 load 성공했는지
* items length > 0인지
* hasMore=false라면 로딩 인디케이터 숨김

---

### 5) ProviderScope 구조 재점검

* 앱 최상단 ProviderScope 내부에 Search V2 관련 Provider 선언
* 화면별 Provider override 여부 점검
* `ref.listen`을 init/build 외부에서 호출하지 말 것
  (Issue #9 관련)

---

### 6) Debug 로그 대량 추가

initialize() 시작/완료
fetchPolicies 시작/완료/실패
추천 정책 페이징 상태
지역 필터 변경 시 이벤트
state.isLoading, items.length 값
→ 디버그 패널 Provider 탭에 표시되도록 강화

---

#### 12-5. 체크리스트

* [ ] SearchV2Controller.initialize() 호출 확인됨
* [ ] fetchPolicies / fetchRecommended / fetchPopularKeywords 정상 응답
* [ ] AsyncValue.error가 UI에 제대로 전파됨
* [ ] 로딩 조건식 수정됨
* [ ] recommended lazy loading과 Search V2가 충돌하지 않음
* [ ] 화면이 “최신 정보를 준비하고 있습니다…”에서 반드시 벗어남
* [ ] 실제 정책 리스트가 표시됨
* [ ] Debug Provider 탭에 load 이벤트가 찍힐 것

---

#### 12-6. 완료 기준

* Search V2 / 추천 정책 / 정책 리스트 진입 시
  **정상적으로 정책 목록이 표시됨**
* “최신 정보를 준비하고 있습니다…” 무한 로딩 현상 완전 제거
* 정책 초기화 및 데이터 로드 흐름이 명확하게 복구됨

```

---













---

## ISSUE 99. 전체 리팩토링 마스터 이슈 – 프로젝트 전반 구조 유지 & 품질 개선

#### 99-1. 목적

Youth Road App 전체 코드베이스에 대해  
**구조를 유지하면서 품질을 끌어올리는 대규모 리팩토링 작업**을 수행한다.

이슈 #100 ~ #104를 포함한 **전체 Refactor Package**는 아래 목표를 따른다:

- 기존 아키텍처(도메인/데이터/애플리케이션/프레젠테이션 구조) 유지
- 기능 변경 없음 (기능 삭제·UI 변경 금지)
- 중복된 기능/코드 제거
- 컨트롤러/Provider 네이밍·역할 정리
- Dead Code / Legacy 코드 제거
- 불필요한 util/log/assert 제거
- UI 위젯 공통화 및 중복 위젯 통합
- 비즈니스 로직 단일화
- Lint 규칙 및 best practice 준수

이슈 #100~104 작업은 순차적으로 진행해야 하며,  
각 Issue 작업은 반드시 **브랜치 단위로 Codex Super Command로 실행**한다.

---

## ISSUE 100. UI/위젯 구조 정리 및 공통 컴포넌트 통합

### 100-1. 목표
- 정책 카드, 버튼, 스켈레톤, 리스트 아이템 등 **중복 위젯 통합**
- 스타일·여백·텍스트 크기 규칙 표준화
- Search V1의 남아 있는 UI 조각 완전 제거
- PolicyCard, TagChip, PageSectionHeader 등 핵심 UI 위젯 통합

### 100-2. 상세 작업
- `/presentation/widgets/common` 디렉토리 생성
- PolicyCard가 3~4 곳에서 다르게 구현된 부분 하나로 통합
- Skeleton UI 중복 제거 → `PolicySkeleton`, `ListSkeleton` 단일화
- Button 스타일: PrimaryButton / SecondaryButton 공통화
- Search V2 전용 위젯을 `/search_v2/widgets`로 정리
- 올바르지 않은 padding/margin을 레이아웃 가이드에 맞게 통일

### 100-3. 완료 기준
- UI 중복 위젯 완전 제거
- 공통 PolicyCard 1개만 존재
- 스켈레톤, 버튼, 섹션 헤더 중복 삭제
- 어떤 화면도 레이아웃 깨짐 없이 동일 규칙으로 렌더링

---

## ISSUE 101. Provider / Controller 구조 정리 및 중복 상태 제거

### 101-1. 목표
- 역할이 겹치는 Provider/Controller 통합
- 이름 규칙 통일: `SomethingController`, `SomethingState`
- ref.listen 문제, state duplication 제거
- Search V2 관련 Provider 정리

### 101-2. 상세 작업
- 검색 관련 Provider 중 중복 기능(검색 결과/추천/인기 키워드) 통합
- 추천 정책 Provider를 Lazy Loading 기반으로 재구조화
- 지역 변경 관련 Provider의 race condition 제거
- Controller의 init/refresh 기능 명확하게 분리

### 101-3. 완료 기준
- Provider 이름/파일 경로 명확화
- Search V2 전용 Provider와 V1 잔재 완전 분리
- 상태가 2중 관리되는 곳 제거
- Debug Provider 탭에서 Provider 구조가 명확하게 보임

---

## ISSUE 102. 네트워크/레포지토리 중복 제거 및 fetch 구조 통일

### 102-1. 목표
- PolicyRepository 내부 fetch 함수 중복 제거
- RemoteSource → Repository → Controller 흐름 일관성 유지
- 정책/기관/부서 API 호출 규칙 표준화

### 102-2. 상세 작업
- `fetchPolicies`, `fetchPolicyList`, `fetchPolicyV2` 등 중복 함수 제거하고 단일화
- 공통 error mapping 모듈로 통합
- Dio 요청 옵션 통일 (timeout, headers, interceptors)
- API 파라미터 가변타입 방식 개선

### 102-3. 완료 기준
- fetch 함수 중복 없음
- 모든 네트워크 요청 경로가 하나로 통일됨
- 에러 메시지/로그 형식 통일

---

## ISSUE 103. Common Util / Helper / Logger 정리

### 103-1. 목표
- 날짜 포맷, 문자열 정리, 숫자 formatting, URL builder 등 중복 util 제거
- Logger를 DebugLogger로 통합
- JS 통신 관련 메시지 포맷 통일

### 103-2. 상세 작업
- `/core/utils/` 내부 util을 재정리  
  (예: date_utils.dart / string_utils.dart / number_utils.dart)
- 동일한 기능의 util이 여러 파일에 퍼져 있으면 하나로 통합
- Logger를 debug, error, warning 유형별로 통일
- WebView JS messaging 포맷 정리

### 103-3. 완료 기준
- util 중복 없음
- 모든 파일이 동일한 formatting 방식 사용
- Flutter → WebView JS call 형식 통일됨

---

## ISSUE 104. Dead Code · Search V1 · Map V1 · Legacy 제거

### 104-1. 목표
- 더 이상 사용되지 않는 파일·모델·위젯 정리
- Search V1, Map V1 관련 잔여 파일 완전 삭제
- KakaoMap V2 로직만 유지
- Build warning 제거

### 104-2. 상세 작업
- `search/old`, `map/old`, `v1`, `deprecated` 폴더 존재 시 전체 제거
- 안 쓰는 Provider/StateNotifier/Model 제거
- Search V1 관련 route 완전 제거
- KakaoMap V1 html/js 제거
- 오래된 테스트 파일 무효라면 삭제

### 104-3. 완료 기준
- IDE 검색 시 “v1” 관련 파일 0개
- Dead code / unused import / unused variable 경고 제거
- 전체 빌드 시 warning 최소화

---





