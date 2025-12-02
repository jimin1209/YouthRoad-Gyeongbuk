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

## [feature/policy-loading-overhaul] 정책 로딩 전체 오버홀 (페이징 + Lazy Loading + 무한 로딩 제거)

Status: Open.

### ISSUE 1

현재 정책 로딩 로직이 Search V2, 추천 정책, 카테고리별 탐색, 지역 필터 등에서
- 페이지네이션이 제대로 동작하지 않고,
- 무한 로딩(“최신 정보를 준비하고 있습니다…”) 상태에 빠지며,
- 초기 로딩이 지나치게 느리고,
- 추천 정책/검색 결과/좋아요/비교 UI와의 연동도 깨져 있는 상태다.

이 Super Command는 **기존 아키텍처(도메인/데이터/애플리케이션/프레젠테이션 구조)를 유지한 채로**  
정책 로딩 관련 전체 흐름을 전면 재정비해서:

1. Search V2 진입 시 정책/추천/검색 데이터가 **항상 정상 로딩**되고  
2. 정책 리스트/추천 정책이 **스크롤 기반 Lazy Loading(Paging)** 으로 부드럽게 로딩되며  
3. 어떤 화면에서도 **무한 로딩 상태에 머무르지 않도록** 하고  
4. 정책 비교 / 좋아요 / 추천 / 카테고리별 탐색과의 상태 연동이 **일관되게 동작**하도록 만드는 것이 목표다.

### Super Command

"feature/policy-loading-overhaul 브랜치에서,
정책 로딩 전반을 다음 기준에 맞춰 **전면 개선(refactor + bugfix)** 하라.

1. **단일 진실 소스(Single Source of Truth) 정리**
   - Search V2, 추천 정책, 카테고리별 탐색, 지역 추천, 좋아요/비교 등
     모든 정책 데이터 흐름의 '최상위 진실 소스'를 명확히 하나로 정의하라.
   - PolicyRepository / RemoteSource / Controller / Provider 간 책임을 명확히 분리하고,
     정책 목록을 각각 따로 들고 있는 중복 상태(state)들을 통합하거나 제거한다.
   - 같은 정책 리스트를 여러 Provider에서 중복 보관하는 구조를 정리하고,
     공통 Paging 상태 모델을 통해 재사용하도록 만든다.

2. **Search V2 초기화 흐름 전면 복구**
   - Search V2 화면 진입 시 반드시 다음 동작이 이루어지도록 `SearchV2Controller.initialize()`를 구현하고 배치하라.
     - 추천 정책 첫 페이지 로딩
     - 기본 정책 리스트(전체 또는 기본 정렬 기준) 첫 페이지 로딩
     - 인기 검색어 로딩
     - 최근 검색어 로딩
     - 현재 지역 기반 추천 정책 로딩
   - AsyncNotifier 또는 Controller의 `build` / `initialize`에서 예외 발생 시
     예외를 삼키지 말고 AsyncValue.error 또는 명시적인 에러 상태로 노출해서
     UI가 무한 로딩이 아니라 에러 + 재시도 버튼을 표시할 수 있게 한다.
   - Search V2 UI에서 로딩 상태 판별 로직을 다음과 같이 수정한다.
     - `state.isLoading && items.isEmpty` 일 때만 전체 스켈레톤을 보여주고
     - 데이터가 일부라도 있으면 리스트를 우선 렌더링하며, 추가 로딩은 하단 인디케이터로만 표현한다.
   - Issue #7, Issue #11, Issue #12에 정의된 요구사항을 모두 만족하도록 Search V2 초기화 흐름을 설계하고 구현하라.

3. **정책 리스트/추천 정책 페이징 + Lazy Loading 정식 도입**
   - Issue #10에서 정의한 요구사항을 기반으로,
     정책 리스트와 추천 정책 로딩을 **페이지 단위(Paging)** 로 로딩하는 공통 메커니즘을 구현한다.
     - `page`, `pageSize`, `items`, `hasMore`, `isLoadingFirstPage`, `isLoadingNextPage`, `error` 등을 가진 공통 PagingState를 정의한다.
     - gbyouth API가 페이징을 지원한다면 서버 페이징을 사용하고,
       지원하지 않는 경우 전체 fetch 후 클라이언트에서 chunk를 나누되,
       UI/Controller 인터페이스는 페이징 기반으로 동일하게 유지한다.
   - 스크롤 이벤트(또는 '더 불러오기' 버튼)를 감지해서
     리스트 끝에 도달했을 때만 `loadNextPage()`가 호출되도록 구현한다.
   - 페이징 요청 도중 중복 호출을 막기 위해
     `isLoadingNextPage == true` 일 때는 추가 호출을 무시하는 방어 로직을 넣는다.
   - 페이지가 더 이상 없을 때는 `hasMore = false` 로 상태를 정리하고,
     하단 로딩 인디케이터를 숨긴다.
   - Lazy Loading 도입 이후에도 Issue #8, Issue #10에서 요구한 UX (추천 정책 깜빡임 제거, 기존 리스트 유지 등)를 모두 만족하도록 한다.

4. **무한 로딩 상태 완전 제거**
   - '정책 로딩 중… 최신 정보를 준비하고 있습니다.' 메시지가
     데이터/에러 상태와 분리된 '영원한 중간 상태'로 머무르지 않도록
     모든 로딩 플래그 및 조건식을 점검하고 수정한다.
   - 로딩 → 성공 → 에러 세 상태를 명확히 구분하고,
     최소한 다음 세 가지 UI 상태를 제공하도록 한다.
     - 초기 로딩(완전 빈 상태): 전체 스켈레톤 + 로딩 메시지
     - 일부 데이터 존재 & 추가 로딩: 리스트 + 하단 로딩 인디케이터
     - 에러 발생: 에러 메시지 + 재시도 버튼 (기존 데이터가 있다면 유지)
   - Search V2 / 카테고리 탐색 / 추천 정책 / 좋아요 모아보기 화면에서
     어떤 경우에도 무한 로딩만 보이는 상태에 머무르지 않도록 전 화면을 점검한다.
   - Issue #12에 정의된 원인(A~E) 범주를 모두 커버하는 방향으로
     초기화 실패, 예외 삼키기, 잘못된 조건식 등을 제거한다.

5. **지역 변경·검색어 변경과 페이징·추천의 연동 정리**
   - 지역이 변경되거나 검색어가 바뀔 때:
     - PagingState를 초기화하고(page=1, items 비우기),
     - 첫 페이지를 재요청하는 흐름으로 통일한다.
   - 이 때 기존 리스트를 완전히 비우고 스켈레톤을 보일지,
     기존 리스트를 잠시 유지하면서 상단에 '업데이트 중'을 표시할지
     UX 정책을 한 가지로 정해 일관되게 구현한다.
   - 지역 변경 후 추천 정책이 잠시 표시되었다 사라지는 Issue #8의 문제를
     requestId 또는 cancelToken 기반 race condition 방지 로직으로 해결한다.

6. **좋아요/비교/카테고리별 탐색과의 상태 연동 복원**
   - Issue #11에 정의된 요구사항에 따라
     정책 비교 UI, 좋아요(하트) 기능, 좋아요 모아보기 페이지, 카테고리별 탐색과
     새로 정리된 정책 로딩 로직이 올바르게 연동되도록 상태 구조를 정리한다.
   - 정책 리스트가 페이징/검색/필터에 따라 변할 때도
     각 PolicyCard가 '좋아요 여부', '비교 리스트 포함 여부'를 정확히 표시하도록 한다.
   - 비교/좋아요 리스트는 정책 로딩 상태와 무관하게 유지되며,
     정책 데이터와의 매핑이 끊기지 않도록 id 기반으로 관리한다.

7. **에러 로깅 및 디버그 패널 통합**
   - Debug Provider/Logger 탭에서 정책 로딩 관련 이벤트를 실시간으로 추적할 수 있도록
     다음 상태 변화를 모두 로그로 남기고 디버그 패널에 연결한다.
     - initialize 시작/완료
     - fetch 첫 페이지/다음 페이지 시작/성공/실패
     - 지역 변경, 검색어 변경 이벤트
     - hasMore true/false 전환
     - 무한 로딩이 발생할 수 있는 조건의 변화
   - 디버그 패널에서 정책 관련 Provider 상태를 열어보면
     현재 페이지, 아이템 개수, 로딩 여부, 에러 정보 등을 한눈에 확인할 수 있도록
     상태 description을 개선한다.

8. **테스트 및 회귀 방지**
   - Search V2, 홈 추천, 카테고리별 탐색, 지역 추천, 좋아요 모아보기, 정책 비교 화면에 대해
     최소한 수동 테스트 시나리오를 정의하고, 위에서 언급한 이슈(#7, #8, #10, #11, #12)가
     다시 발생하지 않도록 회귀 테스트를 수행할 수 있는 구조를 마련한다.
   - 가능하다면 핵심 Controller/Repository에 대한 간단한 단위 테스트를 추가해
     페이징/에러 처리/초기화 로직이 깨지지 않도록 한다.

이 모든 변경은 **비즈니스 로직 및 도메인 모델 구조를 유지한 상태**에서 이루어져야 하며,
기존 기능(정책 비교, 좋아요, 카테고리별 탐색, 추천, Search V2 UI)을 제거하거나
사용자 체감 기능을 단순화하는 방향 대신,
'동일한 기능이 더 안정적이고 빠르게 작동하도록' 만드는 방향으로 리팩토링하라."




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





