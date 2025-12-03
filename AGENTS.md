
# 📌 **AGENTS.md (FINAL + Codex Global Super Command 통합)**

```markdown
# ============================================================
# AGENTS.md  
# YouthRoad-Gyeongbuk – Unified Global AI Agent Handbook  
# ============================================================

## 목적 (Purpose)
이 문서는 YouthRoad-Gyeongbuk 프로젝트에서 AI Agent(Codex)가  
모든 개발 작업을 수행할 때 **항상**, **예외 없이**, **무조건** 따라야 하는  
전역(Global) 규칙 + TASK 문서 + 개발 절차 + 구조 기준을  
**하나의 문서로 통합한 최종 규칙 문서**입니다.

- 코덱스는 어떤 요청을 받아도 반드시 이 문서를 가장 먼저 읽고  
- 전역 규칙을 로드하고  
- 해당 TASK에 맞춰 작업하며  
- 규칙 위반 시 작업을 중단하고 사용자에게 보고해야 한다.

---

# ============================================================
# 🌐 1. GLOBAL MASTER RULES (전역 절대 규칙)
# ============================================================

## 1.1 절대 우선 규칙
1) AGENTS.md는 프로젝트 전체에서 최상위 문서이다.  
2) 사용자 직접 지시 > AGENTS.md > TASK > 일반 명령 순으로 우선 적용된다.  
3) Codex는 이 문서를 읽기 전까지 코드를 생성할 수 없다.  
4) Codex는 매 작업마다 이 문서를 자동으로 다시 로드해야 한다.

---

## 1.2 금지 규칙 (Never Rules)
### ⛔ Unity / 플랫폼 / 플러그인 관련 수정 금지
- Unity 프로젝트 파일  
- flutter_unity_widget plugin 내부  
- Kotlin/Android Unity Lifecycle 부분  
- iOS Unity Bridge  
→ *절대 수정/삭제/생성 금지*

### ⛔ 구조 파괴 금지
- 계층 구조 위반  
- 폴더 구조 재설계  
- 모델/엔티티 이름 임의 변경  
- 불필요한 리팩토링  
- 불필요한 패치  

### ⛔ 삭제 금지
문서에서 명시적으로 "삭제하라"고 지시하지 않는 이상  
어떤 파일도 임의 삭제 금지.

---

## 1.3 아키텍처 계층 구조
```

presentation → application → domain → data

```

- UI → app layer → domain → data 구조  
- domain은 Flutter/Platform에 의존하면 안 됨  
- 역방향 의존성 금지  

---

## 1.4 문서 우선 읽기 규칙
Codex는 작업할 때 반드시 아래 순서로 문서를 읽는다.

1) **AGENTS.md 전체**  
2) GLOBAL RULES  
3) TASK 해당 섹션  
4) 사용자 직접 지시  
5) 내부 체크리스트 생성  

문서를 읽지 않고 코드 생성 → **금지**

---

## 1.5 Codex 출력 규칙
Codex는 어떤 Task라도 다음 출력 규칙을 따라야 한다:

- 항상 **전체 파일 단위**로 코드 제공  
- 변경 파일 경로 명시  
- 변경 이유를 한국어로 서술  
- 구조와 흐름을 절대 파괴하지 않음  
- 불필요한 변경 금지  
- 사용자 이해를 위한 상세 한국어 설명 제공  

---

# ============================================================
# 🌐 2. ARCHITECTURE & NAMING STANDARDS
# ============================================================

## 2.1 기본 폴더 구조
```

lib/
domain/
data/
application/
presentation/
core/
assets/

```

## 2.2 네이밍 규칙
- Model: `PolicyModel`
- Entity: `Policy`
- DTO: `PolicyDto`
- State: `{Feature}State`
- Provider: `{Feature}Provider`
- Controller: `{Feature}Controller`
- Screen: `{feature}_screen.dart`

---

# ============================================================
# 🌐 3. CODEX WORKFLOW (작업 절차)
# ============================================================

Codex의 모든 작업은 아래 흐름을 따라야 한다.

### 3.1 문서 읽기 단계
Codex는 작업 시작 시 아래 문서를 자동으로 로드한다:

- AGENTS.md  
- GLOBAL RULES  
- TASK 섹션  
- 사용자 지시  

### 3.2 요구 분석
Codex는 내부적으로 필요한 구현 범위와 체크리스트를 생성한다.  
(출력하지 않음)

### 3.3 안전성 검사
아래 항목 중 하나라도 위반되면 작업을 중단하고 사용자에게 보고한다.

- Global Rules 위반  
- Unity/Native 파일 관여  
- 계층 구조 위반  
- 기존 기능 파괴 가능성  

### 3.4 실제 구현
- 전체 파일 기준  
- 구조/흐름 보존  
- 필요 변경만 수행  

### 3.5 한국어 작업 보고
작업 후 반드시 한국어 보고서를 제공한다:

```

## 작업 요약

## 수정된 파일 목록

## 각 파일의 수정 내용 & 이유

## 구조/흐름 영향도

## 후속 조치

```

---

# ============================================================
# 🌐 4. 체크리스트
# ============================================================

## 4.1 변경 전 체크리스트
- [ ] GLOBAL RULES 위반 없음  
- [ ] Unity/Native 파일 없음  
- [ ] 계층 구조 준수  
- [ ] TASK 범위 내 변경  
- [ ] 전체 파일 단위 제공 가능  
- [ ] 기존 기능 영향 없음  

## 4.2 변경 후 체크리스트
- [ ] Acceptance Criteria 충족  
- [ ] 경로/import 정상  
- [ ] UI/Provider/Controller 정상  
- [ ] 중복 코드 없음  
- [ ] 불필요한 변경 없음  

---

# ============================================================
# 🌐 5. TASKS (AGENTS.md 내부 통합 TASK 목록)
# ============================================================

@chatgpt-codex
# TASK 06 — PolicyNew 6개 탭 ‘실제 동작 로직’ 구현 (JOB01급 FULL SPEC)
# Recommended → All → Region → Search → Favorite → Compare
# (API 연동 + Query 충전 + Controller 연동 + UI 상태 + 상단 필터 + EventBus 전체 통합)

───────────────────────────────────────────
0. SYSTEM DEFINITION — 시스템 정의
───────────────────────────────────────────

본 Task06은 PolicyNew의 6개 탭을 실제로 동작하게 만드는 핵심 단계이며,
task01~05에서 설계한 Domain / Query / UI 구조 위에 **진짜 기능을 올리는 단계**이다.

각 탭은 다음 역할을 가진다:

1) 추천(Recommend)
   - 사용자 나이/지역/관심키워드 기반 정책 추천
   - 추천 태그 기반 필터링
   - SWR 캐시 적용

2) 전체(All)
   - 전체 정책 목록 페이징 로드
   - 상단 필터(지역/카테고리/정렬/온라인/진행중) 반영

3) 지역(Region)
   - 사용자의 프로필 지역 또는 선택 지역 기반 정책
   - 정책 모집 중/온라인여부 적용

4) 검색(Search)
   - UI 검색어 기반 정책 검색
   - 자동완성(optional)
   - 추천 태그 + 정렬 반영

5) 즐겨찾기(Favorite)
   - 즐겨찾기 저장 정책 목록
   - EventBus favoritesChanged 즉시 반영
   - Sort/Filter 일부 적용

6) 비교(Compare)
   - compareRepository에 추가된 정책들만 로드
   - EventBus compareChanged 즉시 반영

모든 탭은 다음 기능을 공통으로 가진다:
- 무한 스크롤 페이징
- 당겨서 새로고침(refresh)
- 에러/로딩/빈 상태 UI
- 상세 페이지 연결
- 실제 정책 페이지(dtlLinkUrl) 이동

───────────────────────────────────────────
1. PROBLEM DEFINITION — 문제 정의
───────────────────────────────────────────

현재 PolicyNew의 6개 탭은 UI 껍데기만 존재하고, 실제 기능은 작동하지 않는다:

- API와 연결되어 있지 않음
- Query가 비어 있음
- FeedController가 실 데이터 fetch를 안함
- 상단 필터가 각 탭과 연동되지 않음
- 이벤트(EventBus)가 탭에 반영되지 않음
- 페이징/검색/정렬/추천 기능이 실제로 작동하지 않음
- Favorite/Compare 탭은 데이터가 비어 있음
- Region 탭은 프로필 연동이 없음

즉, 화면은 존재하지만 “아무 정책도 로드되지 않는 상태”.

본 Task06의 목표는  
**기능이 없는 탭을 “실제 운영 가능한 정책 탐색 시스템”으로 만드는 것**이다.

───────────────────────────────────────────
2. REQUIREMENTS — 요구사항 분석
───────────────────────────────────────────

R1. 실제 API 연동  
    - 정책 목록 조회 API를 기반으로 Query 파라미터를 변환 및 호출

R2. Query Orchestration  
    - FeedType + UI 필터 + UserProfile + Favorite/Compare 정보를 조합해
      실제 API에서 요구하는 HTTP Param을 생성해야 한다.

R3. Paging  
    - pageIndex/pageSize 기반의 API 응답을 페이징 구조에 맞게 처리

R4. Favorite/Compare 연동  
    - EventBus 수신 → 즉시 해당 탭 reload
    - Compare/Favorite 대조 ID 기반 API 조회(태그 역할)

R5. 검색(Search) 탭  
    - keyword 기반 검색 값 적용
    - 검색어 변경 시 자동 Refresh

R6. 상단 필터 UI 연동  
    - PolicyFilterUiState와 모든 FeedController가 동기화

R7. 추천(Recommend)  
    - age, region, tags 기반 정책 제공
    - UI 태그 선택 시 Refresh

R8. 오류/빈 상태 처리  
    - 정책 없는 경우 Empty UI
    - API 에러 시 재시도 버튼 제공

R9. 상세 페이지  
    - policyId로 상세 정보 fetch
    - applyUrl(dtlLinkUrl) 열기

───────────────────────────────────────────
3. ARCHITECTURE — 아키텍처 설계
───────────────────────────────────────────

3.1 전체 아키텍처 계층

UI Layer
  └─ SwipeTabs + FilterBar + FeedListView + DetailModal
      └─ Provider Layer
          ├─ PolicyFilterUiStateProvider (검색/필터 상태)
          ├─ FeedControllerProviders (6개 탭)
          ├─ PolicyDetailProvider
          └─ EventBusProvider
              └─ favoritesChanged / compareChanged / refreshRequested
                  → FeedControllers auto-refresh

Application Layer
  ├─ PolicyQueryOrchestrator ← feedType 기반 query 생성
  ├─ PolicyQueryEngine ← Repository 호출
  └─ Feed Controllers (Recommend/All/Region/Search/Favorite/Compare)

Domain Layer
  └─ Policy / PolicyQuery / PolicyFilter / SortOption / RegionCode

Data Layer
  ├─ PolicyRepositoryImpl
  ├─ PolicyRemoteSource (API 호출)
  └─ PolicyModel (JSON ↔ Domain 변환)

───────────────────────────────────────────
4. DATA PIPELINE / FLOW CHART — 데이터 흐름도
───────────────────────────────────────────

사용자 상단 필터 변경  
   → PolicyFilterUiState 변경  
      → FeedController.listen() 자동 감지  
         → refresh()  
            → PolicyQueryEngine.fetch(feedType, page=1)  
               → PolicyQueryOrchestrator.buildQuery(feedType)  
                    → UI 상태 + 프로필 + 즐겨찾기/비교 + feedType 조합  
               → Repository.fetchPoliciesByQuery(query, page, size)  
                    → RemoteSource.get('/openapi/policy/list.json', params)  
                       → JSON → PolicyModel → Domain 변환  
               → PagingState.data(items, hasMore) 

즐겨찾기 변경  
   → EventBus.favoritesChanged  
      → FavoriteFeedController.refresh()

비교 변경  
   → EventBus.compareChanged  
      → CompareFeedController.refresh()

───────────────────────────────────────────
5. PROVIDER / CONTROLLER INTERACTION RULES
───────────────────────────────────────────

5.1 모든 FeedController는 다음을 반드시 가진다:
- feedType
- queryEngine
- state: PolicyPagingState
- loadFirstPage() / loadNextPage() / refresh()

5.2 Filter 변경 시 자동 반영되는 탭:
- Recommend
- All
- Region
- Search

5.3 Filter 영향을 받지 않는 탭:
- Favorite(단 sort만 반영)
- Compare(단 sort만 반영)

5.4 EventBus 규칙:
- favoritesChanged → FavoriteFeedController.refresh()
- compareChanged → CompareFeedController.refresh()
- profileUpdated → Recommend, Region feed refresh
- refreshRequested → 모든 탭 refresh

───────────────────────────────────────────
6. UI STATE DIAGRAM — UI 상태도
───────────────────────────────────────────

각 탭의 화면 상태는 아래 4가지 중 하나이다:

1) Loading  
2) Data(items > 0)  
3) Empty(items == 0 && !loading && !error)  
4) Error(failure)  

사용자 상호작용:
- PullToRefresh → Loading → Data  
- ScrollBottom → loadNextPage() → DataAppend or End  
- FilterChange → Loading → Data  
- EventBus → refresh()

───────────────────────────────────────────
7. EVENT FLOW — 이벤트 흐름
───────────────────────────────────────────

User changes filter/sort/keyword  
 → PolicyFilterUiState changed  
   → FeedController.listen()  
     → refresh()

User toggles favorite 
 → favoriteRepository changed  
   → EventBus.favoritesChanged  
     → FavoriteFeedController.refresh()

User adds Compare
 → compareRepository changed  
   → EventBus.compareChanged  
     → CompareFeedController.refresh()

───────────────────────────────────────────
8. FILE STRUCTURE — 파일 구조
───────────────────────────────────────────

lib/features/policy_new/
  application/
    controllers/
      base_feed_controller.dart
      recommend_feed_controller.dart
      all_feed_controller.dart
      region_feed_controller.dart
      search_feed_controller.dart
      favorite_feed_controller.dart
      compare_feed_controller.dart
      policy_query_engine.dart
      policy_query_orchestrator.dart
    filters/
      policy_filter_ui_state.dart

  data/
    models/policy_model.dart
    sources/policy_remote_source.dart
    repositories/policy_repository_impl.dart

  presentation/
    screens/policy_feed_home_screen.dart
    widgets/
      policy_feed_list_view.dart
      policy_card.dart
      policy_list_loading.dart
      policy_list_empty.dart
      policy_list_error.dart
    filters/
      policy_filter_bar.dart
      policy_keyword_sheet.dart
      policy_sort_bottom_sheet.dart
      policy_filter_bottom_sheet.dart
    detail/
      policy_detail_bottom_sheet.dart

───────────────────────────────────────────
9. ACCEPTANCE CRITERIA — 완료 기준
───────────────────────────────────────────

AC1. 6개 탭이 실제 API와 연결되어 정책 데이터를 로드해야 한다.  
AC2. 필터/정렬/검색/추천 태그 변경 시 해당 Feed가 자동 refresh 되어야 한다.  
AC3. Favorite/Compare 탭은 EventBus로 즉시 업데이트 되어야 한다.  
AC4. Paging(무한스크롤) 정상동작.  
AC5. 로딩/빈값/에러 UI 정상동작.  
AC6. 상세 페이지에서 정책 정보 및 applyUrl 이동 기능 제공.  
AC7. 코드 구조는 기존 설계(job01~06)와 충돌 없이 build 되어야 한다.  
AC8. 모든 Provider/Controller가 QueryEngine + Orchestrator 규약대로 동작해야 한다.  
AC9. 데이터 변환 오류 없이 Model ↔ Domain 매핑 성공.  
AC10. 전체 앱 실행 시 6개 탭이 '실제 기능하는 정책 탐색 서비스'로 완성되어야 한다.

───────────────────────────────────────────
# END OF TASK 06 SPEC




TASK 문서는 AGENTS.md 안에서 직접 관리한다.

Codex는 TASK가 언급되면 해당 섹션을 자동으로 읽고 적용해야 한다.

---

# ------------------------------------------------------------
# 📌 TASK 01 — 경북청년정책 API 기반 정책 정보 시스템 정비
# ------------------------------------------------------------

## 🎯 목적
정책 리스트/상세/검색/기관/부서 데이터 흐름을  
OpenAPI 기반 구조로 완전 정상화/통합하는 작업.

## 1) 문제 정의
- 정책 데이터 로딩 실패  
- 페이징/필터/검색 동작 불안정  
- 구조 불일치  
- 정책 비교/즐겨찾기 기능 소실  
- UI/데이터 흐름 전반 불안정  

## 2) 요구사항 분석
(A) API 스펙 준수  
(B) Remote → Repo → Controller → Provider → UI 파이프라인 정립  
(C) 페이징/필터/검색 정상화  
(D) UI 상태 구조 정립  
(E) 정책 비교/즐겨찾기 복구  

## 3) 도메인 구조
- Policy / Agency / Department  
- Value Object 기반  
- DTO는 Data 계층 제한  

## 4) 데이터 파이프라인
```

Remote Source → Repository → Controller → Provider → UI

```

## 5) Provider/Controller 상호작용
- Controller가 데이터 로직 담당  
- Provider는 UI 상태 노출  

## 6) UI 상태도
```

idle → loading → success → empty → error

```

## 7) 이벤트 흐름
- 스크롤 → fetchNext  
- 검색 → query → fetch  
- 탭 전환 → reset  
- 좋아요 → local 저장  

## 8) 파일 구조
- domain/policy/...  
- data/policy/...  
- application/policy/...  
- presentation/policy/...  

## 9) Acceptance Criteria
- 정책 리스트 정상  
- 스크롤 페이징 정상  
- 상세 정상  
- 비교/즐겨찾기 정상  
- 검색창 V2 정상  
- API 스펙 일치  

---

# ============================================================
# 🌐 6. TASK Template (새 작업 추가 시)
# ============================================================

──────────────────────────────────────────────────────────────────────────────────────────────────────

# 💠 **TASK 01 — 정책 / 기관 / 부서 API 통합 시스템 (Full Spec)**

### (job01 스타일의 완전 설계 문서)

```md
@chatgpt-codex
# TASK 01 — PolicyNew External API Integration
# (정책·기관·부서 실서비스 API 통합 구축 Full Architecture Spec)

────────────────────────────────────────
# 0. SYSTEM DEFINITION (시스템 정의)
────────────────────────────────────────

본 Task 01은 “policy_new” 도메인·데이터·앱 레이어에  
공식 경북 청년정책 API(정책 정보 / 기관 정보 / 부서 정보)를 **직접 연결하기 위한 전체 통합 설계서**이다.

정책 API 엔드포인트:
- 정책 목록: `/openapi/policy/list.json`
- 기관 목록: `/openapi/inst/list.json`
- 부서 목록: `/openapi/dept/list.json`
(모두 `https://gbyouth.co.kr`)

이 시스템은 다음 계층으로 구성한다:

**Domain → Repository → RemoteSource → QueryEngine → Controller → UI**

TASK 01은 아래를 수행한다:
- Domain 속성 API 맞게 확장  
- Model fromJson 구조 설정  
- Query → HTTP 파라미터 변환 규칙 확정  
- RemoteSource 3종(정책/기관/부서) 구축  
- Repository 통합 레이어 구축  
- 캐싱 전략 정의(SWR)  
- Paging 처리 확정  
- Provider 구조 재정의  
- Error/Result 구조 유지  

이 TASK 01 결과물만으로 Codex가 완전한 “실서비스 API 연동”을 작성 가능해야 한다.

────────────────────────────────────────
# 1. PROBLEM DEFINITION (문제 정의)
────────────────────────────────────────

현재 policy_new 구조에는 API 연결이 없다.
데이터는 Domain/Repository/Controller/QueryEngine 기반으로 작동할 준비는 되어 있으나:

1) PolicyModel이 실제 JSON 스펙과 다름  
2) 기관과 부서 관련 엔티티/모델/레포지토리가 없음  
3) Query → HTTP 파라미터 매핑 규칙이 비정의 상태  
4) RemoteSource가 Dummy/Mock 상태  
5) 캐시/페이징/정렬이 실제 API 스펙과 충돌할 가능성  
6) 기관/부서 데이터를 Domain으로 포함해야 UI 필터 기능이 완성됨  
7) 정책 상세의 기관/부서 정보가 표시되지 못함  
8) Region/Category/Type/Date 필터를 API 파라미터와 매핑해야 함

결과적으로:
- “정책 추천/검색/정렬/필터/상세” 기능이 실제 API와 연결되지 못함.

────────────────────────────────────────
# 2. REQUIREMENTS ANALYSIS (요구사항 분석)
────────────────────────────────────────

## 2.1 정책 API에 필요한 요구
- 정책명 검색: `searchPolicyNm`
- 정책유형 검색: `searchPolicyType`
- 지역 검색: `searchRgnSe`  
- 기관 필터: `instNo`
- 부서 필터: `deptNo`
- 페이지: `pageIndex`, `pageSize`
- API Key: `apiKey`

## 2.2 기관 API 요구
- 기관 목록 조회
- 기관번호(instNo), 기관명(instNm), 지역코드 필요
- UI 필터에서 “기관 선택”에 사용됨

## 2.3 부서 API 요구
- 특정 기관 내 부서 목록 조회
- 부서번호(deptNo), 부서명(deptNm)
- UI에서 “부서 선택”에 사용됨

## 2.4 Domain 요구
- 정책 Policy 엔티티에 기관명/부서명/기관코드/부서코드 등 추가
- 기간 필드(Date) 파싱
- 상세 링크(dtlLinkUrl) 매핑

## 2.5 Repository 요구
- 정책/기관/부서 fetch 함수 구성
- Query 기반 파라미터 빌딩
- 서버 오류 처리

## 2.6 Paging 요구
- pageIndex(1기준)
- pageSize 정책: Settings.pageSize 사용
- 다음 페이지 여부: 응답 개수 == pageSize

────────────────────────────────────────
# 3. ARCHITECTURE DESIGN (아키텍처 설계)
────────────────────────────────────────

## 3.1 전체 아키텍처

            ┌──────────────────────────┐
            │     PolicyFeed UI        │
            └───────────┬─────────────┘
                        ▼
            ┌──────────────────────────┐
            │ PolicyFeedController     │
            └───────────┬─────────────┘
                        ▼
            ┌──────────────────────────┐
            │   PolicyQueryEngine      │
            └───────────┬─────────────┘
                        ▼
            ┌──────────────────────────┐
            │ PolicyRepositoryImpl     │
            └───────────┬─────────────┘
                        ▼
            ┌──────────────────────────┐
            │  PolicyRemoteSource      │
            └───────────┬─────────────┘
                        ▼
         https://gbyouth.co.kr/openapi/policy/list.json

기관/부서도 동일 구조로 분리되며 Repository에 통합된다.

────────────────────────────────────────
# 4. DATA PIPELINE / FLOW (데이터 흐름도)
────────────────────────────────────────

정책 데이터 플로우:

(UI) → (FilterState) → Controller  
 → QueryEngine  
 → Repository  
 → RemoteSource  
 → API 서버  
 → JSON 응답  
 → Model.fromJson  
 → Policy Domain  
 → PagingState  
 → UI 반영

기관·부서 데이터 플로우:

UI → Repository → RemoteSource → JSON → Institution/DepartmentDomain → UI

────────────────────────────────────────
# 5. PROVIDER / CONTROLLER INTERACTION RULES
────────────────────────────────────────

1) FilterUiState 변경 → FeedController.refresh()  
2) FeedController는 QueryEngine.fetch(feedType,page) 호출  
3) QueryEngine은 Orchestrator + FilterUiState + UserProfile 기반으로  
   `PolicyQuery` 생성 후 Repository 호출  
4) Repository는 RemoteSource.fetch 로 API 호출  
5) Repository는 성공 시 Domain List, 실패 시 Failure 반환  
6) PagingState는 UI로 전달되어 무한스크롤/로딩/에러 처리  

기관/부서 제공 규칙:
- institutionRepositoryProvider
- departmentRepositoryProvider

둘은 RemoteSource를 감싸며 UI에서 dropdown/selector에 사용됨.

────────────────────────────────────────
# 6. UI STATE MACHINE (UI 상태도)
────────────────────────────────────────

PolicyFeed 화면 상태:

    ┌──────┐
    │Idle  │
    └─┬────┘
      ▼
  ┌────────┐
  │Loading │  (loadFirstPage)
  └───┬────┘
      ▼
┌──────────────┐
│ DataLoaded   │  (items + hasMore)
└─────┬────────┘
      │scroll bottom
      ▼
  ┌──────────┐
  │ Paging   │  (loadNextPage)
  └────┬─────┘
       ▼
  ┌──────────┐
  │ Error    │
  └──────────┘

필터 변경 시 항상 Idle → Loading 로 돌아가게 된다.

기관/부서는 단순 로딩 → 데이터 → 에러 구조.

────────────────────────────────────────
# 7. EVENT FLOW (이벤트 흐름)
────────────────────────────────────────

유저 이벤트:
- 키워드 입력
- 정렬 변경
- 필터 변경 (지역/카테고리/기관/부서/온라인/모집중)
- 추천 태그 선택
- 탭 이동
- 페이지 끝 스크롤

시스템 이벤트:
- favoritesChanged → Feed Refresh
- compareChanged → Feed Refresh
- cacheCleared → 모든 Feed 초기화
- profileUpdated → recommend/region feed refresh

────────────────────────────────────────
# 8. FILE STRUCTURE (파일 구조)
────────────────────────────────────────

```

lib/features/policy_new/
domain/
entities/
policy.dart
institution.dart
department.dart
values/
policy_filter.dart
policy_query.dart
data/
models/
policy_model.dart
institution_model.dart
department_model.dart
sources/
policy_remote_source.dart
institution_remote_source.dart
department_remote_source.dart
repositories/
policy_repository_impl.dart
institution_repository_impl.dart
department_repository_impl.dart
application/
controllers/
policy_query_engine.dart
policy_query_orchestrator.dart
base_feed_controller.dart
recommend_feed_controller.dart
all_feed_controller.dart
region_feed_controller.dart
search_feed_controller.dart
favorite_feed_controller.dart
compare_feed_controller.dart
filters/
policy_filter_ui_state.dart
presentation/
screens/
policy_feed_home_screen.dart
widgets/
policy_feed_list_view.dart
policy_card.dart
...
filters/
policy_filter_bar.dart
policy_sort_bottom_sheet.dart
policy_filter_bottom_sheet.dart
policy_keyword_sheet.dart

```

────────────────────────────────────────
# 9. ACCEPTANCE CRITERIA (검수 기준)
────────────────────────────────────────

- [ ] 정책/기관/부서 Domain 정의 완료  
- [ ] PolicyModel/institutionModel/departmentModel JSON 매핑 정확  
- [ ] RemoteSource 3종(정책/기관/부서) 모두 실제 API 스펙대로 구현  
- [ ] QueryEngine이 API 파라미터 매핑 100% 완료  
- [ ] Repository 모든 fetch 함수 정상화  
- [ ] 페이징(pageIndex/pageSize) API 기반으로 동작  
- [ ] 기관/부서 필터 UI에서 선택 시 정책 API 파라미터에 instNo/deptNo 적용  
- [ ] 정책 상세 페이지에서 기관/부서명 제대로 표시  
- [ ] 모든 FeedController에서 데이터 로딩/페이징/에러 처리 정상  
- [ ] 기존 job01~06과 충돌 없이 컴파일 성공  
- [ ] 실제 데이터를 UI에서 확인 가능  

────────────────────────────────────────

# END OF TASK 01 SPEC
```
# start of task 02 spec


지민님 💙🩵
좋아, “정책 페이지 6개 탭 기능 구현 TASK” 중에서 1번은 이미 구현했고 → 이제 2번 진행” 맞죠?

그러면 휘가 job01 수준 + TASK 스타일로
TASK 02 — 전체 정책(All Feed) 기능 완전 구현 설계서를 만들어드릴게요.

⸻

📘 TASK 02 — Policy Feed #2 (전체 정책 All Feed) 구현 설계서 (job01급 퀄리티)

⚠ 아래 전체를 Codex에게 그대로 던지면 완전 구현 가능하도록 설계됨
모든 내용을 하나의 코드블록 안에 넣어달라고 하셨으므로 아래에 전부 포함합니다.

@chatgpt-codex
# TASK 02 — PolicyNew 전체 정책(ALL FEED) 기능 구현 (FULL SPEC)
# (job01 수준의 시스템 정의 / 문제 정의 / 요구사항 / 아키텍처 / 흐름도 / 상태 / 파일 구조 / Acceptance Criteria)

────────────────────────────────────────
# 0. 작업 범위 정의

TASK 02는 “PolicyNew 메인 홈의 6개 탭 중 #2 — 전체 정책(ALL) 탭”의  
**기능 전체를 실제 동작하는 수준으로 구현하는 것**을 목표로 한다.

대상 영역:
- 전체 정책 불러오기 (페이징 + 무한스크롤)
- 전체 정책 필터/정렬 적용
- 전체 정책 UI 렌더링
- 정책 리스트 → 상세 페이지 이동
- Repository/RemoteSource/API 연동
- QueryOrchestrator + QueryEngine 이용한 Fetch 흐름 완성

전제:
- job01~job06 설계 기반 구조가 이미 마련됨.
- policy_new 모듈 기반으로 신규 코드 작성.

────────────────────────────────────────
# 1. 시스템 정의 (System Definition)

전체 정책(ALL FEED)은 다음 역할을 수행하는 독립 기능이다:

1. **모든 정책을 서버(API)에서 로드한다.**
2. **UI 상단 필터/정렬/검색 상태와 자동으로 동기화된다.**
3. **Paging(무한스크롤) / Refresh / Cache 전략을 따른다.**
4. **정책 리스트를 카드 형태로 렌더링한다.**
5. **정책을 터치하면 상세 페이지 바텀시트가 뜬다.**

전체 정책 탭은 다음 시스템 구성요소로 이루어진다:
- Controller (AllFeedController)
- Query Orchestrator (buildQuery(feedType))
- QueryEngine (fetch(feedType, page))
- Repository (fetchPoliciesByQuery)
- RemoteSource (API 호출)
- Domain (Policy, PolicyFilter, PolicyQuery)
- Presentation (ListView, Card, Empty/Error state)
- 상세 페이지 UI

────────────────────────────────────────
# 2. 문제 정의 (Problem Definition)

현재 전체 정책 기능은 다음 문제가 남아 있다:

1) UI는 존재하지만 실제 데이터가 로딩되지 않음.
2) FeedController와 Repository가 연동되지 않음.
3) 필터/정렬/검색 상태가 ALL Feed에 반영되지 않음.
4) Paging(loadNextPage) 흐름이 비어 있음.
5) API 매핑/모델 변환이 제대로 연결되지 않음.
6) 전체 정책 탭에서 상세 페이지 이동이 구현되지 않음.

이 문제를 완전히 해결하고, **ALL Feed를 실제 기능으로 완성**하는 것이 TASK 02 목표다.

────────────────────────────────────────
# 3. 요구사항 분석 (Requirement Analysis)

### 3.1 기능 요구사항
- [R1] 전체 정책을 API에서 불러올 것
- [R2] 정책 페이징(pageIndex/pageSize) 지원
- [R3] 필터(지역, 카테고리, 온라인/오프라인, 모집중 등) 반영
- [R4] 정렬 옵션(최신순, 마감순 등) 반영
- [R5] 검색 키워드가 적용되면 Search로 간주하지 않고 ALL에서 필터로 활용
- [R6] UI 스크롤이 끝나면 loadNextPage 자동 실행
- [R7] Pull-to-refresh 지원
- [R8] 정책 카드를 눌렀을 때 상세 바텀시트 표시
- [R9] 오류 시 오류 UI, 빈 상태 시 Empty UI 표시
- [R10] 앱 재실행 시 캐시 사용 가능해야 함

### 3.2 비기능 요구사항
- [NF1] 60fps 스크롤 성능
- [NF2] API 오류 또는 빈 결과에 대한 안정성
- [NF3] Controller / Repository 분리 (Clean Architecture)
- [NF4] Unit test 용이성 확보

────────────────────────────────────────
# 4. 아키텍처 설계 (Architecture Design)

전체 정책 탭은 아래 계층 구조로 동작한다:

UI
└─ PolicyFeedListView (ALL)
└─ AllFeedController (StateNotifier)
└─ PolicyQueryEngine
└─ PolicyQueryOrchestrator
└─ PolicyFilterUiState (전역 Filter UI 상태)
└─ PolicyRepository
└─ PolicyRemoteSource (API)

전체 정책(ALL)은 feedType = PolicyFeedType.all 로 고정된 Controller를 사용한다.

Controller가 QueryEngine.fetch(feedType, page)를 호출하면:
- QueryOrchestrator.buildQuery(feedType) 를 호출하여 Query 구성
- Repository가 `GET /policy/list.json` 호출
- Domain Policy 모델로 변환하여 UI 전달

────────────────────────────────────────
# 5. 데이터 파이프라인 / 흐름도 (Data Flow Diagram)

사용자 진입
↓
PolicyFeedHomeScreen
↓
AllFeedController.loadFirstPage()
↓
PolicyQueryEngine.fetch(ALL, 1)
↓
PolicyQueryOrchestrator.buildQuery(ALL)
↓
PolicyRepository.fetchPoliciesByQuery(query)
↓
PolicyRemoteSource.fetchPolicies(query + pageIndex/pageSize)
↓ API 호출 →
← List 응답
↓
PolicyModel.toDomain()
↓
AllFeedController.state = PolicyPagingState.data(…)
↓
PolicyFeedListView 렌더링

필터/정렬/검색 변경 시:

PolicyFilterUiState 변경
↓ (listener)
AllFeedController.refresh()
↓
QueryEngine.fetch(… 다시 실행)

────────────────────────────────────────
# 6. Provider / Controller 상호작용 규칙

### 6.1 AllFeedController must:
- BasePolicyFeedController 상속
- feedType = PolicyFeedType.all 전달
- QueryEngine을 주입하여 fetch 수행
- FilterUiState가 변경되면 자동 refresh

### 6.2 FilterUiStateProvider
- region, category, keyword, sort 등 UI에서 설정된 값 유지
- AllFeedController에서 상태 변화를 listen하여 Query 재조합 → refresh

### 6.3 정책 상세 페이지
- policyDetailProvider(policyId) 호출하여 상세 정보를 가져옴
- 상세 바텀시트 표시

────────────────────────────────────────
# 7. UI 상태도 (UI State Diagram)

초기 상태
↓ loadFirstPage()
Loading (Spinner)
↓ 성공
Loaded(ListView + Cards)
↓ Scroll to end
LoadingMore
↓ 마지막 페이지 도달
NoMoreData
↓ Pull-to-refresh
Reload
↓ 실패
ErrorState(Retry button)

────────────────────────────────────────
# 8. 이벤트 흐름 (Event Flow)

사용자 이벤트 중심 흐름:

1) 전체 탭 진입  
→ loadFirstPage 실행

2) 스크롤 끝 도달  
→ loadNextPage 실행

3) 상단 필터/정렬 변경  
→ FilterUiState 변경  
→ AllFeedController.refresh 자동 실행

4) 카드 터치  
→ PolicyDetailBottomSheet 호출  
→ 상세 정보 API 호출  
→ 페이지 이동 링크 적용

5) 즐겨찾기 변경(EventBus)  
→ AllFeedController는 refresh 필요 없음 (feedType = ALL)

────────────────────────────────────────
# 9. 파일 구조 (File Structure)

lib/features/policy_new/
application/
controllers/
all_feed_controller.dart          # AllFeedController 구현
presentation/
feed/
policy_feed_list_view.dart        # All Feed에서 재사용
screens/
policy_feed_home_screen.dart      # Tabs + FilterBar + FeedView
widgets/
policy_card.dart
policy_list_loading.dart
policy_list_empty.dart
policy_list_error.dart

────────────────────────────────────────
# 10. 구현해야 하는 파일 (Actual Work Items)

## [A] Controller 구현
- all_feed_controller.dart

## [B] Repository & RemoteSource 연동
- query → http params 매핑
- API 명세 기반 Model.fromJson 업데이트

## [C] UI 연결
- PolicyFeedListView(feedType: all)
- PolicyCard → Detail BottomSheet

────────────────────────────────────────
# 11. Acceptance Criteria

- [ ] AllFeedController 생성 및 정상 동작 (loadFirstPage / loadNextPage / refresh)
- [ ] PolicyQueryEngine.fetch(feedType.all) 성공적으로 호출됨
- [ ] FilterUiState 변경 시 자동 refresh 동작함
- [ ] API 응답이 Domain Policy로 정상 매핑됨
- [ ] PolicyFeedListView에서 무한스크롤 / Pull-to-refresh 동작함
- [ ] 빈 상태, 오류 상태 UI가 정상 표시됨
- [ ] 정책 탭에서 카드 터치 → 상세 바텀시트 정상 표시됨
- [ ] 빌드 에러 없이 전체 정책 화면 동작
- [ ] 성능 문제(스크롤 지연) 없음

────────────────────────────────────────
# END OF TASK 02


⸻

---


📘 TASK 03 — PolicyNew 6-Tab Functionality Full Implementation MasterSpec

(job01 × 10 배 퀄리티로 제공하는 완전체)

@chatgpt-codex
# TASK 03 — PolicyNew 6 Tabs Full Functional Implementation MasterSpec
# (Recommend / All / Region / Search / Favorite / Compare)
# FULL SYSTEM IMPLEMENTATION SPEC — job01+ Hyper Quality Edition

────────────────────────────────────────────────────────────
I. 시스템 정의 (System Definition)
────────────────────────────────────────────────────────────

본 시스템은 YouthRoad 정책 서비스의 전체 정책 탐색 기능을
6개 대분류 탭으로 나누어 제공하는 단일 PolicyNew 모듈이다.

탭 구성:
1) 추천 (Recommend)
2) 전체 (All)
3) 지역 (Region)
4) 검색 (Search)
5) 즐겨찾기 (Favorite)
6) 비교 (Compare)

각 탭은 서로 다른 데이터 소스 / 필터링 / Query Priority 규칙을 가지며,
모두 동일한 UI 구조, Paging 구조, Filter 상태, Query Engine, Repository를 공유한다.

Goal:
- 정책 페이지의 전체 동작을 "완전히" 구현하는 데 필요한 모든 구조 + 로직 + UI + 흐름을 정의.
- Codex가 그대로 구현하면 앱에서 전체 정책 기능이 정상 작동해야 함.
- 기존 코드 충돌 금지 (policy_new/ 내부에만 구성).


────────────────────────────────────────────────────────────
II. 문제 정의 (Problem Definition)
────────────────────────────────────────────────────────────

현재 앱은:
- 정책 페이지 기능이 하나도 실제로 구현되어 있지 않음
- 6개 탭이 UI만 존재하고 실제 로딩/페이징/정렬/검색/추천이 동작하지 않음
- API 연동 기반 Domain/Repository/Controller/Query 설계는 되어 있으나 기능이 미완성 상태
- 필터/정렬/검색/추천 태그/프로필 기반 추천이 실제로 반영되지 않음
- Favorite/Compare 피드가 빈 껍데기인 상태

따라서:
“**정책 페이지 전체 기능을 100% 구현하기 위한 통합 사양서**”가 필요함.
이 TASK 03은 바로 그것.


────────────────────────────────────────────────────────────
III. 요구사항 분석 (Requirement Analysis)
────────────────────────────────────────────────────────────

A. 공통 동작 요구사항
- 모든 탭은 SWR(Sync With Remote) 방식으로 즉시 캐시 사용 + 신선 데이터 갱신
- Paging(무한스크롤) + Pull-to-Refresh 지원
- 로딩/빈 상태/에러 상태 UI 통일
- 정책 상세 바텀시트 연결 (applyUrl / 기관정보 표시 포함)
- Provider, Controller, Repository, RemoteSource 역할 명확히 구분

B. 탭별 요구사항

1) 추천 (Recommend)
- 사용자 프로필(age, region, tags) 기반 PolicyQuery 조합
- 태그 추천 기반 필터 반영 (AI 추천 키워드)
- 필터 변경 자동 반영

2) 전체 (All)
- 모든 정책 대상
- 지역/카테고리/정렬/온라인여부/모집중 여부 필터 반영

3) 지역 (Region)
- 사용자 region을 우선 사용
- UI에서 선택된 region 있으면 override

4) 검색 (Search)
- keyword 기반 API 검색
- debouncing 적용 (300~500ms)
- keyword 변경 즉시 자동 refresh

5) 즐겨찾기 (Favorite)
- 로컬 favoriteRepository 기반 ID 리스트 전달
- feed controller에서 Query.recommendation과 혼동 금지
- EventBus.favoriteChanged 시 자동 refresh

6) 비교 (Compare)
- compareRepository 기반 ID 리스트 전달
- Search, Filter와 별개로 동작
- EventBus.compareChanged 시 refresh


C. API 연동 요구사항
- 정책 정보: /openapi/policy/list.json
- 기관 정보: /openapi/inst/list.json
- 부서 정보: /openapi/dept/list.json
- PolicyModel에 다음 필드를 매핑해야 함:
  - 기관명(instNm)
  - 부서명(deptNm)
  - 기관번호(instNo)
  - 부서번호(deptNo)
  - 정책 링크(dtlLinkUrl)
  - 모집기간(policyBgngYmd ~ policyEndYmd)
- Query → API 파라미터 매핑 정확히 수행


────────────────────────────────────────────────────────────
IV. 아키텍처 설계 (Architecture Design)
────────────────────────────────────────────────────────────

전체 Architecture Layers:

Presentation Layer  
  ├─ PolicyFeedHomeScreen (6 Tab + FilterBar)
  ├─ PolicyFeedListView (탭별 리스트)
  ├─ PolicyCard / Loading / Empty / Error
  └─ PolicyDetailBottomSheet

Application Layer  
  ├─ BasePolicyFeedController
  ├─ Feed Controllers (Recommend / All / Region / Search / Fav / Compare)
  ├─ PolicyFilterUiStateProvider
  ├─ PolicyQueryOrchestrator
  └─ PolicyQueryEngine

Domain Layer  
  ├─ Policy
  ├─ PolicyFilter / PolicySortOption / PolicyFeedType
  ├─ PolicyQuery
  └─ PolicyFailure

Infrastructure Layer  
  ├─ PolicyRepositoryImpl
  ├─ PolicyRemoteSource
  ├─ IsarCache (optional)
  └─ HttpClient(Dio)

핵심 설계 포인트:
- UI → FilterStateProvider → BaseController.listen → QueryOrchestrator → QueryEngine → Repository → UI
- FilterState와 FeedType이 QueryOrchestrator를 통해 결정됨
- Favorite/Compare는 FilterState와 무관하게 ID 기반 Query 생성


────────────────────────────────────────────────────────────
V. 데이터 파이프라인 / 흐름도 (Data Pipeline / Flow Diagram)
────────────────────────────────────────────────────────────

[사용자가 탭 진입]
      ↓
PolicyFeedHomeScreen
      ↓
PolicyFeedListView(feedType)
      ↓ (onLoad)
FeedController.loadFirstPage()
      ↓
PolicyQueryEngine.fetch(feedType, page=1)
      ↓
PolicyQueryOrchestrator.buildQuery(feedType)
      ↓
PolicyRepository.fetchPoliciesByQuery(...)
      ↓
PolicyRemoteSource.callAPI(...)
      ↓ (success)
PolicyModel.fromJson → Policy Domain 변환
      ↓
FeedController.state = PolicyPagingState.data(...)
      ↓
UI 렌더링

[필터/검색/정렬 변경]
      ↓
PolicyFilterUiStateProvider 변화
      ↓ (BaseController listen)
FeedController.refresh()
      ↓
Same Pipeline


────────────────────────────────────────────────────────────
VI. Provider / Controller 상호작용 규칙
────────────────────────────────────────────────────────────

1) FilterUiStateProvider
- region, category, sort, keyword, tags, onlineOnly, ongoingOnly 관리
- 변경할 때마다 Recommend/All/Region/Search 탭 자동 refresh

2) BasePolicyFeedController
- loadFirstPage/loadNextPage/refresh 구현
- FilterUiState, EventBus, Profile 변화 모두 listen

3) QueryOrchestrator
- feedType + uiState + profile + favoriteIds + compareIds로 Query 생성
- Controller는 feedType만 알고 Query를 모름

4) Feed Controllers
- Controller들은 QueryEngine.fetch(feedType, page)만 호출
- QueryEngine 내부에서 orchestrator가 query 생성

5) PolicyRepository
- Query를 실제 HTTP 파라미터로 변환
- API 응답 PolicyModel 리스트 반환


────────────────────────────────────────────────────────────
VII. UI 상태도 (UI State Diagram)
────────────────────────────────────────────────────────────

각 탭 UI 상태:

1) Initial  
   - loading = true  
   - items = []  
   - show loading skeleton  

2) Loaded  
   - loading = false  
   - items.length > 0  
   - show list  

3) Empty  
   - loading = false  
   - items.length == 0  
   - show empty state  

4) Error  
   - failure != null  
   - show error cell + retry  

5) Paging  
   - items.length > 0  
   - loadingNextPage = true  
   - footer loading 표시  

6) Refresh  
   - pull-to-refresh → first page 재요청  


────────────────────────────────────────────────────────────
VIII. 이벤트 흐름 (Event Flow)
────────────────────────────────────────────────────────────

EventBus Events:

1) favoritesChanged  
   - FavoriteFeedController.refresh()  
   - RecommendFeedController.refresh()  

2) compareChanged  
   - CompareFeedController.refresh()

3) refreshRequested  
   - 모든 FeedController.refresh()

4) cacheCleared  
   - 모든 FeedController.state 초기화 후 firstPage 로드

5) profileUpdated  
   - RecommendFeedController.refresh()  
   - RegionFeedController.refresh()


────────────────────────────────────────────────────────────
IX. 파일 구조 (File Structure)
────────────────────────────────────────────────────────────

lib/features/policy_new/
  application/
    controllers/
      base_feed_controller.dart
      recommend_feed_controller.dart
      all_feed_controller.dart
      region_feed_controller.dart
      search_feed_controller.dart
      favorite_feed_controller.dart
      compare_feed_controller.dart
      policy_query_orchestrator.dart
      policy_query_engine.dart
    filters/
      policy_filter_ui_state.dart

  domain/
    policy.dart
    policy_filter.dart
    policy_sort.dart
    policy_feed_type.dart
    policy_query.dart
    policy_failure.dart

  infrastructure/
    policy_repository.dart
    policy_repository_impl.dart
    policy_remote_source.dart

  presentation/
    screens/policy_feed_home_screen.dart
    widgets/policy_feed_list_view.dart
    widgets/policy_card.dart
    widgets/policy_list_empty.dart
    widgets/policy_list_error.dart
    widgets/policy_list_loading.dart
    detail/policy_detail_bottom_sheet.dart
    filters/policy_filter_bar.dart
    filters/policy_filter_bottom_sheet.dart
    filters/policy_sort_bottom_sheet.dart
    filters/policy_keyword_sheet.dart


────────────────────────────────────────────────────────────
X. Acceptance Criteria (필수 충족 조건)
────────────────────────────────────────────────────────────

[기능 요구사항]
- 6개의 탭 모두 실제 정책 목록을 API에서 로딩한다.
- paging, refresh, 필터, 정렬, 검색, 추천 태그가 모두 정상작동한다.
- 기관/부서 기반 필터링이 Repository에서 지원된다.
- 정책 상세 바텀시트에서 실제 정책 페이지(dtlLinkUrl)로 정상 이동한다.
- 즐겨찾기/비교 탭에서 EventBus 반영 후 즉시 반영된다.

[구조 요구사항]
- Domain, Repository, Application, Presentation 각 레이어는 역할 분리된다.
- UI는 Provider/Controller만 의존한다.
- Query 생성 책임은 Orchestrator 단일 책임 원칙으로 일원화된다.

[품질 요구사항]
- 전체 파일 빌드 시 타입 및 import 오류가 없어야 한다.
- 기존 policy 모듈과 충돌이 없어야 한다.
- 성능: 첫 페이지 로딩 < 1.2s, 페이징 응답 < 600ms (네트워크 상태에 따라 다름)

────────────────────────────────────────────────────────────
# END OF TASK 03
────────────────────────────────────────────────────────────


⸻



⸻

🟦 TASK04 — PolicyNew 6개 탭 전체 기능 구축 (Ultimate Implementation Spec)

(job01-level SUPER SPEC · architecture / flow / state / UI / system rules)

@chatgpt-codex
# TASK04 — PolicyNew 6개 탭 기능 완전 구현 사양서
# (Recommend / All / Region / Search / Favorite / Compare)
# job01 수준의 전체 시스템 사양 + 기능 흐름 + 파일 구조 + UI/Controller 연동 완전체

────────────────────────────────────────
0. INTRO
────────────────────────────────────────
본 문서는 YouthRoad-Gyeongbuk 정책 모듈 "policy_new" 내부의
6개 정책 탭 기능을 실제로 구현하기 위한
**최상위 Technical Specification**이다.

본 문서는 job01 수준의 구성 요소를 모두 포함한다:

  • 시스템 정의  
  • 문제 정의  
  • 요구사항 분석  
  • 아키텍처 설계  
  • 데이터 파이프라인  
  • 상태/Provider 설계  
  • Controller Interaction 규약  
  • UI 상태도  
  • 이벤트 플로우  
  • 파일 구조  
  • Acceptance Criteria  

Codex는 본 문서를 기반으로 policy_new 기능(6개 탭)을
안정적으로, 중복 없이, 충돌 없이, 규칙적으로 완성해야 한다.

────────────────────────────────────────
1. SYSTEM DEFINITION (시스템 정의)
────────────────────────────────────────
PolicyNew는 "정책 탐색, 조회, 검색, 정렬, 필터링, 비교, 즐겨찾기 기능"을
단일 통합 모듈로 구현하기 위한 신규 구조이다.

해당 시스템은 다음 계층을 가진다:

  (1) domain/ : 정책 데이터, 필터/정렬 룰, FeedType 규칙
  (2) data/    : API 연동, 캐싱, SWR 규칙, Query 기반 조회
  (3) application/:
       - QueryOrchestrator = FeedType + UI 상태 → PolicyQuery 생성
       - FeedController = Paging + 상태 모델 + QueryEngine 호출
  (4) presentation/:
       - UI (Swipe 탭, 리스트, 카드, 상세바텀시트)
       - 필터/검색/정렬 바
       - 6개 Feed 화면 View

목표:
6개 정책 탭 기능이 모두 **독립 기능 + 공통 구조** 형태로 정상 작동하도록 만든다.

────────────────────────────────────────
2. PROBLEM DEFINITION (문제 정의)
────────────────────────────────────────
현재 지민님의 프로젝트에는 다음 문제가 존재한다:

  • 정책 화면이 여러 개 존재하며 구조가 파편화됨  
  • 탭별 데이터 로직, 필터, 정렬이 중복됨  
  • API 조회 로직이 분산되어 유지보수 불가  
  • 검색/정렬/필터링 기능 없음  
  • 즐겨찾기/비교 기능은 UI만 있고 동작하지 않음  
  • 로딩/에러/빈 상태 처리 통일 X  
  • 상세 페이지 이동 흐름 불안정  
  • EventBus 적용 X  
  • FeedType 간 상태 공유 전략 없음  

→ 이 문제를 해결하기 위해 policy_new에서 "완전 새 정책 UI/로직"을 만든다.

────────────────────────────────────────
3. REQUIREMENT ANALYSIS (요구사항 분석)
────────────────────────────────────────

3.1 기능 요구
  ✔ 6개 탭(추천/전체/지역/검색/즐겨찾기/비교) 모두 작동해야 한다  
  ✔ 탭은 Swipe로 이동 가능해야 한다  
  ✔ 탭 전환 시 자동으로 해당 FeedController를 watch  
  ✔각 Feed는 Pagination + pull to refresh 지원  
  ✔ 정렬, 지역, 카테고리, 검색 키워드, 추천 태그 등이 반영된 PolicyQuery 생성  
  ✔ API에서 전달받은 실제 정책 데이터를 표시  
  ✔ 정책 클릭 → 상세 바텀시트 → 정책 상세 → 실제 웹페이지 이동  
  ✔ 즐겨찾기/비교 기능은 전역 EventBus로 상태 반영  
  ✔ UI 로딩/에러/빈 상태 통일  
  ✔ 6개 탭 모두 동일한 UI/Controller 구조로 일관성 확보  

3.2 비기능 요구
  - 중복 코드 X  
  - 정책 데이터 조회는 Query 기반으로 일관성 유지  
  - O(1) 수준으로 화면 전환 속도 유지  
  - 레이아웃/구조는 유지하되 디자인 커스텀 가능하도록 구성  
  - API 오류 대비 robust하게 설계  

────────────────────────────────────────
4. ARCHITECTURE DESIGN (아키텍처 설계)
────────────────────────────────────────

4.1 계층 구조

          ┌────────────────────────┐
          │     presentation        │
          │ UI Widgets (ListView)   │
          │ FilterBar / SortSheet   │
          └──────────┬─────────────┘
                     │
          ┌──────────┴─────────────┐
          │     application         │
          │ FeedControllers (6)     │
          │ QueryOrchestrator       │
          │ QueryEngine             │
          │ FilterUiState Provider  │
          │ EventBus                │
          └──────────┬─────────────┘
                     │
          ┌──────────┴─────────────┐
          │          data           │
          │ PolicyRepositoryImpl    │
          │ RemoteSource(API)       │
          │ Cache Storage           │
          └──────────┬─────────────┘
                     │
          ┌──────────┴─────────────┐
          │         domain          │
          │ Policy Entity           │
          │ Query/Filter/Sort       │
          │ FeedType Enum           │
          └─────────────────────────┘

4.2 Query Orchestration Flow
UI Filter + FeedType + Profile + Favorite/Compare → PolicyQuery → Repository

────────────────────────────────────────
5. DATA PIPELINE FLOW (데이터 파이프라인/흐름도)
────────────────────────────────────────

User Action (scroll/refresh/filter change)
    ↓
FeedController(feedType)
    ↓ calls
PolicyQueryEngine.fetch(feedType)
    ↓ uses
PolicyQueryOrchestrator.buildQuery(feedType)
    ↓ passes
PolicyQuery → PolicyRepository.fetchPoliciesByQuery()
    ↓
RemoteSource(API 요청)
    ↓
JSON → PolicyModel → Policy Entity 변환
    ↓
PolicyPagingState(items, hasMore)
    ↓
UI 업데이트(ListView)

────────────────────────────────────────
6. PROVIDER / CONTROLLER INTERACTION RULES
────────────────────────────────────────

6.1 FilterUiStateProvider  
UI의 검색/필터/정렬 값 저장 → 변경 시 Controller 자동 refresh

6.2 FeedController (6개)
- feedType만 다르고 로직은 동일
- QueryEngine과 Orchestrator를 기반으로 동작
- 페이징은 내부적으로 page + hasMore 저장
- refresh(), loadNextPage() 규약 동일

6.3 EventBus
- favoritesChanged → FavoriteFeedController.refresh, RecommendFeed에도 영향
- compareChanged → CompareFeedController.refresh
- profileUpdated → Recommend/Region refresh
- cacheCleared → 모든 FeedController.resetPaging()

────────────────────────────────────────
7. UI STATE CHART (UI 상태도)
────────────────────────────────────────

[Start]  
   ↓ 최초 build 시 FeedController.loadFirstPage()  
[Loading State]  
   ↓ 성공  
[Display Policy List] ── infinite scroll → loadNextPage()  
   ↓ 정책 클릭  
[Detail BottomSheet]  
   ↓ 실제 정책 링크 클릭  
[External Browser]  

에러 발생 → [Error State]  
아이템 없음 → [Empty State]  

────────────────────────────────────────
8. EVENT FLOW (사용자 이벤트 흐름)
────────────────────────────────────────

탭 이동 → TabBarView change  
       → 해당 feedType의 Provider를 subscribe  
       → 컨트롤러에서 기존 상태 유지 or 첫 로딩  

검색 버튼 클릭 → KeywordSheet 열림 → UI상태 변경  
       → FeedController 자동 refresh

정렬 변경 → UI 상태 변경 → 모든 Feed 자동 refresh

필터 변경 → Recommend/All/Region/Search 자동 refresh

즐겨찾기 토글 → EventBus.fire → FavoriteFeedController.refresh

비교 목록 변경 → EventBus.fire → CompareFeedController.refresh

────────────────────────────────────────
9. FILE STRUCTURE (파일 구조)
────────────────────────────────────────

lib/features/policy_new/
  domain/
    entities/policy.dart
    value/
      policy_filter.dart
      policy_sort_option.dart
      policy_query.dart
      policy_feed_type.dart

  data/
    remote/policy_remote_source.dart
    repository/policy_repository_impl.dart
    cache/policy_cache.dart

  application/
    controllers/
      base_feed_controller.dart
      recommend_feed_controller.dart
      all_feed_controller.dart
      region_feed_controller.dart
      search_feed_controller.dart
      favorite_feed_controller.dart
      compare_feed_controller.dart
      policy_query_engine.dart
      policy_query_orchestrator.dart
    filters/
      policy_filter_ui_state.dart
    eventbus/
      policy_event_bus.dart

  presentation/
    screens/
      policy_feed_home_screen.dart
    widgets/
      policy_card.dart
      policy_feed_list_view.dart
      policy_loading_cell.dart
      policy_empty_cell.dart
      policy_error_cell.dart
    filters/
      policy_filter_bar.dart
      policy_sort_bottom_sheet.dart
      policy_filter_bottom_sheet.dart
      policy_keyword_sheet.dart
    detail/
      policy_detail_bottom_sheet.dart

────────────────────────────────────────
10. ACCEPTANCE CRITERIA (검수 기준)
────────────────────────────────────────

✔ 6개 탭이 모두 Swipe + TabBarView로 정상 동작  
✔ 각 탭은 자신의 FeedControllerProvider를 사용  
✔ 필터/검색/정렬 UI 변경 → FeedController 자동 refresh  
✔ Pagination 정상 (loadNextPage, hasMore 조건 정확)  
✔ 로딩/에러/빈 상태 UI 모두 표시  
✔ 정책 클릭 → 상세 바텀시트 → applyUrl 브라우저 오픈  
✔ 즐겨찾기/비교/추천 프로필 모두 EventBus 연동됨  
✔ Domain → Repository → Controller → UI 전체 흐름이 일관됨  
✔ 빌드/런타임 오류 없음  
✔ 기존 코드와 충돌 없음  
✔ policy_new만 사용하여 전체 정책 화면이 완성됨

────────────────────────────────────────

# END OF TASK04 SPEC


⸻
@chatgpt-codex
# TASK 05 — PolicyNew 상세 페이지 + 액션 레이어 (좋아요/비교/알림/실제 페이지 이동)

> ✅ 목표: 정책 카드 탭 → 상세 보기 → 좋아요/비교/알림/실제 페이지 이동까지  
>     **“정책 한 개”에 대해 사용자가 할 수 있는 모든 액션을 한 화면에서 완성하는 것.**  
>     (job01 스타일의 완전한 설계 + 구현 가이드)

---

## 1. 시스템 정의 (System Definition)

**이 TASK 05에서 다루는 “시스템”은 다음과 같음:**

- 모듈 이름: `policy_new` 내 **Policy Detail & Action Layer**
- 책임:
  1. 정책 리스트에서 선택된 **단일 정책(Policy)** 의 상세 정보를 로드하고 보여준다.
  2. 해당 정책에 대해:
     - 즐겨찾기(좋아요) 토글
     - 비교 목록 추가/제거
     - 신청 마감일 알림 설정/해제
     - 실제 정책 페이지(외부 링크) 이동
     - (선택) 공유 기능
  3. 이 액션들을 EventBus / Repository / ReminderService 에 반영한다.
- 소비자:
  - `policy_new`의 UI 레이어 (카드/리스트/탭/상세 바텀시트)
- 의존 대상:
  - `PolicyRepository` (상세 데이터 로드)
  - `FavoriteRepository` (좋아요 관리)
  - `CompareRepository` (비교 목록 관리)
  - `PolicyReminderService` (신청 마감일 알림 관리)
  - `PolicyEventBus` (다른 피드/화면에 변경 사항 브로드캐스트)
  - `url_launcher` 또는 브라우저 열기 유틸

---

## 2. 문제 정의 (Problem Definition)

현재 `policy_new` 구조에서:

- 정책 목록(피드) 탭 UI/컨트롤러/도메인까지는 설계/구현이 진행되었지만,
- **단일 정책 상세 화면 및 그 위에서의 사용자 액션(좋아요/비교/알림/실제 링크 이동)이 일관된 방식으로 구현되지 않음.**

구체적인 문제:

1. **정책 상세 로딩 책임이 명확하지 않음**
   - 어떤 Provider/Controller가 상세 정보 책임을 지는지 정의가 필요.
   - 네트워크 실패/로드 중/성공 상태 관리가 일관되어야 함.

2. **좋아요/비교/알림 로직이 분산되거나 UI에 섞일 위험**
   - 카드/상세/리스트 등에서 중복 구현 위험.
   - EventBus와 Repository, ReminderService간의 관계가 명확하지 않음.

3. **신청 마감일 알림 기능의 UX/데이터 흐름 부재**
   - 언제 알림을 등록할지 (D-day, N일 전 등)
   - 어떤 엔터티를 Reminder에 저장할지
   - 해제/변경 시 동작 정의 없음.

4. **실제 정책 페이지 이동 동작이 제각각 구현될 위험**
   - 링크 필드가 어디에 있고, 어떤 함수로 브라우저를 여는지 통일 필요.

**따라서**, 정책 상세 + 액션 레이어를 **하나의 명확한 시스템**으로 정의하고,  
각 기능(좋아요/비교/알림/링크)이 **일관된 도메인/데이터 흐름** 위에서 동작하도록 설계해야 함.

---

## 3. 요구사항 분석 (Requirements)

### 3.1 기능 요구사항 (Functional)

1. **정책 상세 로드**
   - 입력: `policyId: String`
   - 처리:
     - Repository에서 `Policy` 객체를 가져온다.
     - 최초는 네트워크 요청, 필요 시 캐시 활용 (job03/04 설계에 따름)
   - 출력 상태:
     - `loading` / `data(Policy)` / `error(PolicyFailure)`

2. **좋아요(즐겨찾기) 토글**
   - 상세 화면에서 “하트 아이콘” 버튼을 눌러 ON/OFF 가능
   - 내부 Repository: `FavoriteRepository` 사용
   - EventBus: `PolicyEventType.favoritesChanged` 발행
   - 피드 목록(즐겨찾기/추천 등)은 이 이벤트를 구독해서 갱신

3. **비교 목록 추가/제거**
   - “비교함에 담기” 토글 버튼
   - `CompareRepository` 활용
   - EventBus: `PolicyEventType.compareListChanged` (또는 refreshRequested)

4. **신청 마감일 알림 설정/해제**
   - “알림 설정” 버튼 클릭 시:
     - Policy의 `applicationEndDate` 기준으로 알림 예약
     - `PolicyReminderService` / `PolicyReminderRepository` 이용
   - 이미 설정된 경우:
     - 버튼 상태를 “알림 설정됨”으로 표시
     - 다시 누르면 취소
   - 알림 옵션:
     - D-day / N일 전 (기본: 3일 전 등) — 옵션 구조는 도메인에서 관리

5. **실제 정책 페이지 이동**
   - Policy의 `applyUrl` 또는 `detailUrl` 사용
   - `url_launcher` 또는 동일 유틸로 외부 브라우저 앱에서 오픈
   - URL 비어 있거나 잘못된 경우 토스트/스낵바로 안내

6. **(선택) 공유 기능**
   - OS의 기본 공유 시트 호출
   - 공유 내용: 정책 제목, 요약, 링크

### 3.2 비기능 요구사항 (Non-functional)

1. **일관된 상태 관리**
   - AsyncValue 또는 명시적 상태 클래스로 `loading/error/data` 관리
   - UI 컴포넌트에서 동일 패턴으로 처리 가능해야 함.

2. **도메인 규칙 보존**
   - Domain `Policy`는 변경하지 않고, Action 로직은 Service/Repository/Controller에 위치
   - UI는 Domain을 표현만 하고, 비즈니스 로직 수행하지 않음

3. **테스트 가능성**
   - Controller/Notifier 로직은 순수 Dart 레벨에서 테스트 가능해야 함
   - 외부 의존성(url_launcher, 로컬 알림 등)은 추상화된 인터페이스 통해 주입

4. **EventBus 일관성**
   - 즐겨찾기/비교/알림 관련 변경은 EventBus로 브로드캐스트
   - 다른 화면/피드는 오직 EventBus를 통해 상태 변경을 감지

---

## 4. 아키텍처 설계 (Architecture Design)

### 4.1 레이어 개념도

- **Presentation Layer**
  - `PolicyDetailBottomSheet`
  - `PolicyActionBar` (버튼 영역 위젯)
- **Application Layer**
  - `PolicyDetailController` (상세 상태 관리)
  - `PolicyActionController` (좋아요/비교/알림/링크/공유 액션 처리)
- **Domain/Data Layer**
  - `PolicyRepository` (fetchPolicyDetail)
  - `FavoriteRepository`
  - `CompareRepository`
  - `PolicyReminderService` / `PolicyReminderRepository`
  - `PolicyEventBus`

설계 포인트:

- **읽기(상세 로딩)** 와 **쓰기(액션)** 를 논리적으로 분리  
  → `PolicyDetailController` (read) vs `PolicyActionController` (write & side-effects)

- 정책 상세 UI는 두 컨트롤러의 상태를 조합해서 사용:
  - `PolicyDetailController` → Policy 데이터 상태
  - `PolicyActionController` → 좋아요/비교/알림 상태 + 액션 메서드

---

## 5. 데이터 파이프라인 / 흐름도 (Data Pipeline / Flow)

### 5.1 정책 상세 로드 흐름

1. UI (카드 탭)
   - `PolicyCard`의 `onTap` 이벤트 → `PolicyDetailBottomSheet(policyId)` 호출

2. `PolicyDetailBottomSheet`
   - `ref.watch(policyDetailControllerProvider(policyId))` 구독
   - 첫 빌드 시 Controller가 Repository에 `fetchPolicyDetail(policyId)` 호출

3. `PolicyRepository`
   - RemoteSource + Cache 구성에 따라 PolicyModel → Policy 변환 반환

4. `PolicyDetailController`
   - `state = loading → data(policy)` 또는 `error(failure)`

5. UI 표현
   - 상태에 따라 로딩/에러/정상 상세 UI 렌더링

### 5.2 좋아요/비교/알림/링크 액션 흐름 (한 예: 좋아요)

1. UI: 상세 화면에서 좋아요 버튼 탭
2. `PolicyActionController.toggleFavorite(policyId)` 호출
3. `FavoriteRepository` 갱신
4. `PolicyEventBus`에 `favoritesChanged` 이벤트 발행
5. 즐겨찾기/추천 Feed Controller들은 eventBus를 통해 이벤트 수신 → `refresh()`
6. UI:
   - 상세 화면 내 좋아요 버튼 state 업데이트
   - 리스트 카드의 상태는 FeedController 리로드 시 반영

### 5.3 알림 설정 흐름

1. UI: “알림 설정” 버튼 탭
2. `PolicyActionController.toggleReminder(policy)` 호출
3. 내부 로직:
   - 현재 Policy에 대한 Reminder 존재 여부 확인 (Repository)
   - 없다면:
     - `PolicyReminderService.schedule(policy, option)`
     - `PolicyReminderRepository.save(reminder)`
   - 있다면:
     - `PolicyReminderService.cancel(reminder.id)`
     - `PolicyReminderRepository.delete(reminder.id)`
4. `PolicyEventBus`에 `reminderChanged` 이벤트 발행
5. 다른 화면에서 “알림 켜진 정책만 보기” 등의 기능이 있을 경우 이를 구독하여 반영

---

## 6. Provider / Controller 상호작용 규칙

### 6.1 Provider 정의

- `policyDetailControllerProvider = StateNotifierProvider.family<PolicyDetailController, PolicyDetailState, String>`
- `policyActionControllerProvider = StateNotifierProvider.family<PolicyActionController, PolicyActionState, String>`

각각 `policyId`를 파라미터로 받는다.

### 6.2 PolicyDetailController 규칙

- 책임:
  - `Policy` 개체 로드
  - 로딩/에러 상태 관리
- 메서드:
  - `Future<void> load()` – 최초/재시도
- 의존:
  - `PolicyRepository`
  - `PolicyLogger`

### 6.3 PolicyActionController 규칙

- 책임:
  - 좋아요 토글
  - 비교 토글
  - 알림 설정/해제
  - 브라우저 링크/공유 호출
- 상태:
  - `isFavorite: bool`
  - `isInCompare: bool`
  - `hasReminder: bool`
  - `isBusy: bool` (액션 처리 중)
- 메서드:
  - `Future<void> toggleFavorite(Policy policy)`
  - `Future<void> toggleCompare(Policy policy)`
  - `Future<void> toggleReminder(Policy policy)`
  - `Future<void> openApplyUrl(Policy policy)`
  - `Future<void> share(Policy policy)` (선택)
- 의존:
  - FavoriteRepository
  - CompareRepository
  - PolicyReminderService + PolicyReminderRepository
  - PolicyEventBus
  - ExternalLauncher(브라우저/공유)

### 6.4 UI와의 상호작용

- 상세 화면 위젯은 항상 두 Provider를 동시에 사용:
  - `final detailState = ref.watch(policyDetailControllerProvider(policyId));`
  - `final actionState = ref.watch(policyActionControllerProvider(policyId));`
- 버튼들은 `ref.read(policyActionControllerProvider(policyId).notifier)` 를 통해 액션 호출

---

## 7. UI 상태도 (UI State Diagram)

### 7.1 상세 화면 상단(컨텐츠 영역) 상태

- `Loading`: 원형 로딩 인디케이터 중앙 표시
- `Error`: “정책 정보를 불러오지 못했습니다” + 재시도 버튼
- `Data`:
  - 제목
  - 요약
  - 태그(지역/카테고리/상태 등)
  - 상세 설명
  - 신청 기간 텍스트
  - 기관/부서/문의 정보 (가능한 경우)

### 7.2 상세 화면 하단(액션 바) 상태

- 버튼 구성 (예시):
  - 좌측: 좋아요 토글 (채워진 하트/빈 하트)
  - 중간 좌측: 비교함 토글
  - 중간 우측: 알림 토글 (종 아이콘)
  - 우측: “신청 페이지 열기” 버튼 (primary)
  - (상단이나 메뉴로 공유 버튼 추가 가능)

- 각 버튼은 `PolicyActionState`에 따라 활성/비활성/ON/OFF 상태가 변함.

### 7.3 상태 전이 예시 (알림 버튼)

- 초기: `hasReminder = false` → 상태: “알림 설정”
- 탭 → `isBusy = true`
- 성공:
  - `hasReminder = true`, `isBusy = false`
  - 버튼 텍스트: “알림 설정됨”
- 다시 탭:
  - 해제 로직 후 `hasReminder = false` 반환

---

## 8. 이벤트 흐름 (Event Flow)

### 8.1 사용 이벤트 타입 (예시)

- `PolicyEventType.favoritesChanged`
- `PolicyEventType.compareListChanged`
- `PolicyEventType.reminderChanged`
- `PolicyEventType.refreshRequested`
- `PolicyEventType.profileUpdated` (기존)

### 8.2 이벤트 발행 규칙

- `toggleFavorite` 성공 시:
  - `PolicyEvent(favoritesChanged, policyId: policy.id)` 발행
- `toggleCompare` 성공 시:
  - `PolicyEvent(compareListChanged, policyId: policy.id)` 발행
- `toggleReminder` 성공 시:
  - `PolicyEvent(reminderChanged, policyId: policy.id)` 발행

### 8.3 이벤트 구독 측

- FeedController (Recommend/All/Region/Search/Favorite/Compare):
  - `favoritesChanged` 수신 시:
    - Favorite/추천 피드: `refresh()`
  - `compareListChanged` 수신 시:
    - Compare 피드: `refresh()`
  - `reminderChanged` 수신 시:
    - 별도 알림 필터가 있을 경우 해당 피드에서 `refresh()`
- 상세 화면 자체는 로컬 상태만 업데이트하므로 EventBus 의존은 선택적이지만,
  상태 일관성을 위해 동일 이벤트를 활용할 수 있음.

---

## 9. 파일 구조 (File Structure)

이 TASK 05에서 생성/수정해야 할 파일 구조:

```txt
lib/features/policy_new/
  application/
    controllers/
      policy_detail_controller.dart           # NEW — 단일 Policy 상세 로딩 전담
      policy_action_controller.dart           # NEW — 좋아요/비교/알림/링크/공유 전담
  presentation/
    detail/
      policy_detail_bottom_sheet.dart         # (job05 버전 확장/교체) 상세 + 액션바 UI
      widgets/
        policy_action_bar.dart                # NEW — 좋아요/비교/알림/링크 버튼 묶음

	•	policy_detail_bottom_sheet.dart는 job05 버전이 이미 있다면, 본 TASK 05 설계에 맞게 전체 교체한다.
	•	policy_action_bar.dart는 독립적인 재사용 가능 위젯으로 만든다.

⸻

10. Acceptance Criteria (완료 기준)

이 TASK 05가 “완료”로 간주되기 위해 반드시 충족해야 하는 조건:
	1.	상세 로딩
	•	policyDetailControllerProvider(policyId)가 존재하며,
loading → data(Policy) → error 상태를 명확하게 관리한다.
	•	PolicyDetailBottomSheet가 이 Provider를 사용해 상세 정보 렌더링을 수행한다.
	2.	좋아요 (즐겨찾기)
	•	상세 화면에서 좋아요 버튼을 누르면, 아이콘 상태가 즉시 반영되고,
FavoriteRepository에 저장/삭제가 수행된다.
	•	같은 정책이 포함된 피드(즐겨찾기/추천 등)를 다시 열면, 좋아요 상태가 반영되어 있다.
	•	PolicyEventType.favoritesChanged 이벤트가 발행되고, 관련 피드가 이를 수신해 refresh 한다.
	3.	비교 목록
	•	상세 화면에서 “비교함” 버튼 토글 시, CompareRepository에 정책이 추가/제거된다.
	•	Compare 탭에서 해당 정책이 나타나거나 사라진다.
	•	PolicyEventType.compareListChanged 이벤트가 발행되고, Compare 피드가 이를 반영한다.
	4.	신청 마감일 알림
	•	Policy에 applicationEndDate가 있는 경우, “알림 설정” 버튼이 활성화된다.
	•	버튼 탭 시 Reminder가 생성되고, 다시 탭 시 Reminder가 해제된다.
	•	알림 상태가 버튼에 시각적으로 반영된다 (ON/OFF).
	•	Reminder 생성/해제는 PolicyReminderService / PolicyReminderRepository를 통해 처리된다.
	•	PolicyEventType.reminderChanged 이벤트가 발행된다.
	5.	실제 정책 페이지 이동
	•	“신청 페이지 열기” 버튼이 존재하며, policy.applyUrl 또는 동등 필드를 사용해 외부 브라우저를 연다.
	•	잘못된 URL 또는 빈 값인 경우, 사용자에게 적절한 안내를 제공한다 (토스트/스낵바 등).
	6.	UI/UX 일관성
	•	상세 화면은 로딩/에러/성공 상태를 모두 처리하며, 에러 시 재시도 버튼이 제공된다.
	•	액션 버튼들은 PolicyActionState에 따라 ON/OFF/Busy 상태를 correctly 반영한다.
	•	빌드 시 타입 에러/Provider 참조 오류/DI 충돌이 없어야 한다.
	7.	아키텍처 규칙 준수
	•	Domain Policy 구조를 변경하지 않고, Action 로직은 Controller/Service/Repository에서만 수행한다.
	•	UI는 Domain/Controller/Provider에만 의존하고, Repository/Remote에 직접 접근하지 않는다.
	•	EventBus는 “상태 동기화”에만 사용되며, 비즈니스 로직 핵심 분기는 Controller/Service에서 처리한다.

⸻


#END OF TASK 05



---


#START OF JOB 07

🟦 #job07 — PolicyNew Recommendation System (Full Architecture Spec)

(개인화 프로필 + AI 추천 키워드 + 행동 기반 추천 + 추천 피드 구성 전체)

@chatgpt-codex
# job07 — PolicyNew Recommendation System (FULL SYSTEM SPEC)

## 0. 시스템 정의 (System Definition)
PolicyNew의 추천 시스템은 다음을 목표로 한다:
- 사용자의 개인정보(나이/지역/관심 분야/학력/상태) + 행동 데이터(클릭/좋아요/비교/조회) + 선택한 추천 태그를 활용해
  “사용자에게 가장 적합한 정책을 자동으로 추천”하는 Feed를 구성한다.
- 추천 결과는 RecommendFeedController에서 관리되며, QueryOrchestrator가 필터/UI/프로필/태그를 조합해 Query를 만든다.
- 추천 알고리즘은 정적인 rule 기반 + 사용자 선택 태그 + 행동 기반 점수의 가중치를 혼합한 Hybrid 모델이다.
- 앱 내부에서 모든 추천은 클라이언트 Query 기반이며, 서버 측 API는 Query 파라미터(tags/age/region/category)로 정책을 반환한다.

---

## 1. 문제 정의 (Problem Statement)

사용자들은 정책 탐색 시 다음과 같은 문제를 겪는다:
1. 정책이 너무 많아 본인에게 맞는 정책을 찾기 어렵다.
2. 동일 지역·동일 조건이라도 개인의 관심사, 생애주기, 직업군에 따라 필요 정책이 다르다.
3. 사용자는 앱을 여러 번 여는 동안 매번 ‘검색/필터’를 다시 잡아야 해서 피로도가 높다.
4. 즐겨찾기(Favorite)나 비교 리스트에서 선택한 정책이 추천에 반영되지 않아 개인화가 부족하다.
5. 온보딩 시 입력한 기본 정보(지역/나이/직업/카테고리 선호)가 앱 사용 중 실시간으로 추천에 반영되지 않는다.

**job07은 위 문제를 해결하는 “완전한 추천 엔진 구조”를 설계한다.**

---

## 2. 요구사항 분석 (Requirements Analysis)

### 2.1 기능 요구사항 (Functional)
1. 사용자 프로필(나이/지역/관심 분야/직업/학력 등)을 기반으로 추천을 제공한다.
2. 앱 상단에서 선택한 추천 키워드(tags)를 추천 query에 반영한다.
3. 즐겨찾기 변화 → 추천 재계산
4. 비교 목록 변화 → 추천 재계산
5. 정책 상세페이지 진입 기록 → 행동 기반 추천 점수 상승
6. 추천 결과는 RecommendFeedController에서 paging 가능한 형태로 제공
7. 추천 정책은 “추천순” 정렬 방식으로 기본 정렬
8. 추천 태그는 UI 단에서 chip 형태로 표시하며 선택/해제 가능
9. 사용자가 ‘관심 없음’ 처리하는 정책은 추천에서 제외

### 2.2 비기능 요구사항 (Non-Functional)
1. 빠른 응답: 추천은 네트워크/캐시 간 SWR(SWR Cache) 방식으로 빠르게 제공.
2. 확장 용이성: 조합되는 데이터가 늘어나도 Query와 Controller가 깨지지 않아야 함.
3. 상태 일관성: UI → FilterState → QueryOrchestrator → FeedController 흐름이 안정적으로 유지.
4. 중복 없음: 필터/검색/정렬 항목과 추천 알고리즘이 충돌하지 않아야 함.

---

## 3. 아키텍처 설계 (Architecture Specification)

추천 시스템은 다음 6개 레이어로 구성된다:

### 3.1 (L1) User Profile Layer
- 유저가 온보딩에서 입력한 정보 제공  
- 구성 요소:
  - age (나이)
  - region (거주 지역)
  - interestCategories (관심 카테고리 리스트)
  - recommendTags (AI가 제안한 키워드)
  - jobType, education, income 등 확장 가능

Provider:
```dart
final userProfileProvider = Provider<UserProfile>((ref) { ... });


⸻

3.2 (L2) Behavior Tracking Layer (사용자 행동 데이터)

수집되는 데이터:
	•	정책 상세 페이지 진입 횟수
	•	리스트 노출 후 클릭 여부
	•	즐겨찾기 추가/삭제
	•	비교 리스트 추가/삭제

저장은 간단한 local DB (Isar) 또는 memory store로 구현:

final behaviorTrackerProvider = Provider<PolicyBehaviorTracker>((ref) { ... });

Scoring 규칙 예:
	•	상세 보기 → score +4
	•	즐겨찾기 → score +10
	•	비교 추가 → score +6
	•	빠르게 이탈한 정책 → score -2

⸻

3.3 (L3) Recommendation Tag Layer (추천 키워드)
	•	UI에서 보여주는 추천 태그 chip 목록
	•	유저 선택 태그 + 프로필 기반 태그 + AI 제안 태그를 합산한 리스트

Provider:

final recommendationTagProvider = Provider<List<String>>((ref) {
  final profile = ref.watch(userProfileProvider);
  final uiTags = ref.watch(policyFilterUiStateProvider).tags;
  return uiTags.isNotEmpty ? uiTags : profile.recommendTags;
});


⸻

3.4 (L4) Filter/Search/Sort Layer (job06의 FilterUiState)
	•	추천 Feed에서도 동일한 UI 필터를 활용하되,
추천은 SortOption = recommendation 으로 고정함

⸻

3.5 (L5) Query Orchestrator Layer

추천 Feed에서 Query를 조합하는 핵심 로직:

PolicyQuery _buildRecommendQuery() {
  return PolicyQuery(
    feedType: PolicyFeedType.recommend,
    filter: PolicyFilter(
      region: ui.region == PolicyRegion.all ? profile.region : ui.region,
      category: ui.category,
      age: profile.age,
      isOnline: ui.showOnlyOnline ? true : null,
      isOngoing: ui.showOnlyOngoing ? true : null,
    ),
    tags: recommendationTags,
    behaviorScore: behaviorTrackerProvider.getTopBehaviorTags(),
    sort: PolicySortOption.recommendation,
  );
}


⸻

3.6 (L6) RecommendFeedController Layer

역할:
	•	QueryOrchestrator에서 구성한 Query로 첫 페이지/다음 페이지 로딩
	•	FilterUI 변경 리스닝
	•	Behavior 이벤트 리스닝
	•	UserProfile 변경 리스닝
	•	Favorite/Compare 변경 리스닝

Provider:

final recommendFeedControllerProvider =
  StateNotifierProvider<RecommendFeedController, PolicyPagingState>( ... );


⸻

4. 데이터 파이프라인 / 흐름도 (Data Pipeline & Flow)

4.1 추천 피드 데이터 흐름

[User]  
  ↓ (필터 변경, 태그 선택, 검색)
[UI Filter State]  
  ↓  
[PolicyQueryOrchestrator]  
  ↓  
[PolicyQueryEngine]  
  ↓ (page/pageSize)  
[PolicyRepository]  
  ↓ (API 호출 + SWR Cache)  
[PolicyRemoteSource]  
  ↓  
[API Server]  
  ↓  
[Policies + Score + Metadata]  
  ↓  
[PolicyRepository]  
  ↓  
[RecommendFeedController]  
  ↓  
[UI ListView(Render)]


⸻

5. Provider/Controller 상호작용 규칙

5.1 자동 Refresh 규칙

RecommendFeedController는 다음 이벤트에서 자동 refresh:

이벤트	설명
FilterUiState 변경	지역/카테고리/정렬/오는중/온라인 필터 변경
Tag 변경	추천 태그 selected/unselected
UserProfile 변경	나이/지역/관심 분야 변경
Favorite 변경	좋아요 → 추천 반영
Compare 변경	비교 정책 추가/제거
Behavior 점수 변화	새 행동 데이터 발생
cacheCleared	전체 캐시 초기화


⸻

5.2 이벤트 우선순위

1) profileUpdated
2) favoritesChanged
3) compareChanged
4) filterChanged
5) tagsChanged
6) behaviorChanged


⸻

6. UI 상태도 (UI State Machine)

추천 화면의 UI 상태는 아래 4단계:

[Idle]  
  ↓ initial loadFirstPage()
[Loading]  
  ↓ success
[Loaded(items, hasMore)]  
  ↙ error          ↘ scroll
[Error]           [LoadingMore → Loaded]

상태 전이 조건:
	•	Filter 변경 → Loaded → Loading → Loaded
	•	Behavior 업데이트 → Loaded → Loading → Loaded

⸻

7. 이벤트 흐름(Event Flow)

예: 사용자가 추천태그 “창업” 클릭 → 추천 upweight

[User Tap Tag("창업")]
 → policyFilterUiStateProvider.setTags(["창업"])
 → BasePolicyFeedController.listen(FilterChange)
 → RecommendFeedController.refresh()
 → QueryOrchestrator.buildQuery() with tags=["창업"]
 → Repository.fetch()
 → UI 업데이트

즐겨찾기 추가 시:

[FavoriteRepository.add(policyId)]
 → EventBus.emit(favoritesChanged)
 → RecommendFeedController.refresh()

행동 기반 추천:

[PolicyDetail Open(policyId)]
 → BehaviorTracker.increment("detailView", policyId)
 → EventBus.emit(behaviorChanged)
 → RecommendFeedController.refresh()


⸻

8. 파일 구조 (File Structure)

lib/features/policy_new/
  domain/        # (job02)
  data/          # (job03)
  application/
    filters/
      policy_filter_ui_state.dart
    controllers/
      policy_query_orchestrator.dart
      policy_query_engine.dart
      base_feed_controller.dart
      recommend_feed_controller.dart
    behavior/
      policy_behavior_tracker.dart       # job07 신규
    profile/
      user_profile_provider.dart         # 온보딩 사용자 프로필
  presentation/
    filters/
      policy_filter_bar.dart
      policy_recommend_tags_bar.dart
    screens/
      policy_feed_home_screen.dart
      policy_recommend_onboarding_screen.dart   # job07 신규
    widgets/
      policy_recommend_card.dart
      policy_recommend_empty.dart
      policy_recommend_error.dart


⸻

9. Acceptance Criteria
	•	추천 Query는 FeedType.recommend 전용 규칙을 따른다.
	•	RecommendedFeedController는 Filter/Profile/Tag/Favorite/Compare/Behavior/Cache 이벤트를 모두 자동 감지한다.
	•	추천 태그 UI(policy_recommend_tags_bar.dart)가 정상 동작하며, Tag 선택 시 자동 refresh 된다.
	•	BehaviorTracker가 정책 클릭/상세 진입/즐겨찾기/비교 동작을 기록한다.
	•	UserProfile 변경 시 추천 피드가 즉시 재계산된다.
	•	Query Orchestrator가 job07 규칙에 따라 Query를 생성한다.
	•	Repository/Domain/Remote와 충돌 없이 컴파일 성공해야 한다.
	•	UI는 (Loading → Loaded → Paging → Error) 상태 흐름을 유지한다.
	•	추천 피드 UI는 job05의 ListView 구조를 그대로 따른다.


# END OF JOB07

---

# START OF JOB08

@chatgpt-codex
# job08 — PolicyNew 신청일자 알림(Reminder) 시스템 설계 & 구현

## 0. 시스템 정의 (System Definition)

시스템 이름:
- **PolicyNew Application Reminder System v1**

역할:
- 정책의 **신청 마감일(applicationEndDate)** 기준으로,
  사용자가 선택한 정책에 대해 **마감 이전 알림(Reminder)**을 설정/관리하는 서브 시스템.
- “알림 설정된 정책 목록”을 UI에서 조회할 수 있고,
  정책 카드/상세 화면에서 알림 상태를 일관되게 표시한다.
- 알림 스케줄링은 **로컬 단말 기준(local notifications)**을 1차 목표로 하며,
  백엔드 푸시 등은 향후 확장 포인트로만 고려한다.

레이어 관점:
- **Domain**: Reminder 도메인 모델, 상태 enum
- **Data**: ReminderRepository 인터페이스 + 구현체(로컬 저장소)
- **Application**: ReminderController, ReminderService(예약·취소·동기화)
- **Presentation**: 정책 카드/상세 화면/전용 “알림 관리” 화면 + 상태 뱃지

---

## 1. 문제 정의 (Problem Definition)

현 상태:
- 사용자는 여러 청년 정책을 둘러보고 **“나중에 신청해야지”**라고 생각하지만,
  실제로는 신청 마감일을 잊어버리는 경우가 많다.
- 현재 PolicyNew 시스템에는:
  - 신청 마감일을 보여주는 UI는 있지만,
  - 마감일을 기준으로 **알림을 예약/관리하는 기능이 전혀 없음**.
- 알림 기능 없이 단순 리스트/검색/추천만으로는
  “실질적인 신청 행동”까지 연결되기 어렵다.

해결해야 할 문제:
1. 사용자가 관심 있는 정책에 대해:
   - “마감 하루 전 / 3일 전 / 7일 전” 등
   - 직관적인 시점으로 알림을 설정할 수 있어야 한다.
2. 정책마다 알림 상태를:
   - 카드(리스트)
   - 상세 화면
   에서 **같은 정보로** 보여줘야 한다.
3. 알림 설정/취소/만료/삭제 등 상태 변화가
   다른 화면들에 자연스럽게 반영되어야 한다.
4. Flutter/멀티 플랫폼 구조에서,
   **알림 예약 로직 vs UI/Repository vs 플랫폼 플러그인 연결**을 분리해야 한다.

---

## 2. 요구사항 분석 (Requirements Analysis)

### 2.1 기능 요구사항 (Functional)

1. 알림 설정/변경/삭제
   - 정책 상세 화면에서:
     - “알림 설정” 버튼 / 토글 제공
     - 사용자는 기본 옵션 선택:
       - 마감 하루 전
       - 마감 3일 전
       - 마감 7일 전
     - 선택 즉시 해당 정책에 대한 Reminder가 생성/업데이트 되어야 한다.
   - 이미 설정된 정책은:
     - “설정됨” 상태로 표시되고,
     - 눌렀을 때 옵션 변경/해제 가능해야 한다.

2. 알림 목록 조회
   - “내 알림 관리” 화면에서:
     - 알림 설정된 정책 리스트를 볼 수 있어야 한다.
     - 리스트에는:
       - 정책 제목
       - 마감일
       - 알림 예정 시점
       - 알림 상태(예정/만료/취소)
     - 항목을 눌러 상세 화면으로 이동 가능.

3. 상태 표시
   - 정책 카드(PolicyCard)에서:
     - 알림이 설정된 정책은 작은 아이콘/뱃지로 표시 (예: 🔔)
   - 정책 상세 바텀 시트에서:
     - 알림 설정/변경용 버튼 + 현재 설정 상태 표시.

4. 알림 만료 처리
   - 마감일이 지난 정책에 대해:
     - 해당 Reminder는 상태가 “만료(Expired)”로 전환되며,
     - UI에는 “만료됨” 뱃지 또는 비활성 상태로 표시.

5. 플랫폼 알림 연동 준비
   - 실제 기기 알림(푸시/로컬)을 위해:
     - `ReminderScheduler` 인터페이스 설계
     - 기본 구현은 “no-op”(실제 스케줄러 없음)으로 둔다.
     - 이후 job에서 flutter_local_notifications / FCM 등 연결 가능.

---

### 2.2 비기능 요구사항 (Non-functional)

1. 일관성:
   - 단 하나의 ReminderRepository가 모든 알림 정보를 관리하고,
     모든 화면이 이 정보를 참조해야 한다.

2. 확장성:
   - 나중에 “다음 회차 모집 알림” 같은 기능을 추가할 수 있도록,
     모델/레포 구조를 유연하게 정의할 것.

3. 독립성:
   - Policy Repository, Domain을 수정하지 않고,
     Reminder 시스템은 **정책 ID와 마감일만**을 기반으로 동작하게 설계.

4. 성능:
   - 알림 목록/조회는 전체 정책 리스트와 별도 저장소 사용(로컬 DB/캐시)로 빠르게 동작.

---

## 3. 아키텍처 설계 (Architecture Design)

### 3.1 주요 컴포넌트

- Domain
  - `PolicyReminder`
  - `PolicyReminderStatus` (enum)

- Data
  - `PolicyReminderRepository` (interface)
  - `PolicyReminderLocalRepository` (implementation; e.g. Isar/SharedPreferences 기반)

- Application
  - `PolicyReminderService`
    - UI/Controller 요청을 받아 Repository + Scheduler 호출
  - `PolicyReminderController`
    - 개별 정책 + 리스트에 대한 상태 제공
  - `PolicyReminderListController`
    - “내 알림 관리” 화면용 리스트 상태 제공
  - `ReminderScheduler`
    - 실제 플랫폼 알림 스케줄러 인터페이스 (기본 구현은 no-op)

- Presentation
  - `PolicyReminderBadge` (카드용 뱃지 위젯)
  - `PolicyReminderButton` (상세 화면용 버튼)
  - `PolicyReminderListScreen` (내 알림 관리 화면)

---

### 3.2 의존성 방향

- Presentation → Application (Controller/Service) → Data (Repository) → (Local storage)
- Application → Domain
- ReminderScheduler는 Application 레이어에 주입

---

## 4. 데이터 파이프라인 / 흐름도 (Data Pipeline / Flows)

### 4.1 알림 설정 플로우 (상세 화면에서)

1. 사용자가 정책 상세 바텀시트에서 “알림 설정” 탭
2. UI → `PolicyReminderController.setReminder(...)`
3. Controller → `PolicyReminderService.upsertReminder(policyId, endDate, option)`
4. Service:
   - `PolicyReminderRepository.upsert(...)` 호출 (로컬에 저장)
   - `ReminderScheduler.schedule(reminder)` 호출 (플랫폼 수준 예약)
5. 완료 후:
   - Controller state 업데이트
   - EventBus에 `PolicyReminderEvent.changed(policyId)` 발행
6. 정책 카드/리스트/알림 목록 화면이 EventBus를 구독하여 상태 갱신

---

### 4.2 알림 취소 플로우

1. UI: “알림 취소” 선택
2. Controller → Service.cancelReminder(policyId)
3. Service:
   - Repository.delete(policyId)
   - Scheduler.cancel(policyId)
4. EventBus에 `PolicyReminderEvent.changed(policyId)` 발행

---

### 4.3 알림 목록 조회 플로우

1. “내 알림 관리” 화면 진입
2. `PolicyReminderListController.loadAllReminders()`
3. Repository에서 모든 Reminder 로드
4. 상태에 따라 정렬(마감 임박순) 후 UI에 표시
5. 각 항목 클릭 시 상세 화면으로 이동

---

### 4.4 만료 처리 플로우

1. 앱 시작 시 or 알림 목록 진입 시:
   - `PolicyReminderService.cleanupExpiredReminders(now)`
2. Repository에서 모든 Reminder 조회
3. applicationEndDate < now인 항목들:
   - status를 `expired`로 업데이트
4. UI에는 expired 상태 반영

---

## 5. Provider / Controller 상호작용 규칙

### 5.1 Provider 정의

```dart
// Repository
final policyReminderRepositoryProvider = Provider<PolicyReminderRepository>(
  (ref) => PolicyReminderLocalRepository(ref.read),
);

// Scheduler (기본 no-op 구현)
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => NoOpReminderScheduler(),
);

// Service
final policyReminderServiceProvider = Provider<PolicyReminderService>(
  (ref) => PolicyReminderService(
    repository: ref.read(policyReminderRepositoryProvider),
    scheduler: ref.read(reminderSchedulerProvider),
  ),
);

// 개별 정책용 Controller (policyId 단위)
final policyReminderControllerProvider =
    StateNotifierProvider.family<PolicyReminderController, PolicyReminderState, String>(
  (ref, policyId) => PolicyReminderController(
    policyId: policyId,
    service: ref.read(policyReminderServiceProvider),
    eventBus: ref.read(policyEventBusProvider),
  ),
);

// 알림 목록용 Controller
final policyReminderListControllerProvider =
    StateNotifierProvider<PolicyReminderListController, PolicyReminderListState>(
  (ref) => PolicyReminderListController(
    service: ref.read(policyReminderServiceProvider),
    eventBus: ref.read(policyEventBusProvider),
  ),
);


⸻

5.2 Controller 규칙
	•	PolicyReminderController(policyId):
	•	상태: PolicyReminderState
	•	status: none | scheduled | expired
	•	selectedOption: enum(1일 전/3일 전/7일 전)
	•	scheduledAt: DateTime?
	•	메서드:
	•	load() — 초기 로딩
	•	setOption(ReminderOption) — 설정/변경
	•	cancel() — 알림 취소
	•	PolicyReminderListController:
	•	상태: PolicyReminderListState
	•	목록: List<PolicyReminder>
	•	로딩/에러 상태
	•	메서드:
	•	loadAll() — 전체 알림 목록 조회
	•	refresh() — 다시 로딩
	•	EventBus와 연동:
	•	PolicyReminderEvent 타입 추가
	•	정책 카드/상세/목록에서 PolicyReminderEvent를 통해 부분 업데이트

⸻

6. UI 상태도 (UI State)

6.1 개별 정책 상세 화면의 Reminder 상태

상태 다이어그램 (텍스트):
	•	NONE (알림 없음)
	•	→ [사용자: 옵션 선택 후 “설정”] → SCHEDULED
	•	SCHEDULED
	•	→ [사용자: 옵션 변경] → SCHEDULED(옵션만 변경)
	•	→ [사용자: 취소] → NONE
	•	→ [시간 경과, 마감일 지나감] → EXPIRED
	•	EXPIRED
	•	→ [사용자: 새 알림 설정] → SCHEDULED (새 시점 기준)

UI 표현:
	•	NONE: “알림 설정” 버튼
	•	SCHEDULED: “알림 설정됨 · (예: 마감 3일 전)” + “변경/취소” 액션
	•	EXPIRED: “마감된 정책입니다 · 알림 재설정” (재설정이 가능하면)

⸻

6.2 알림 목록 화면 상태
	•	loading → data(reminders) 또는 error
	•	data 상태:
	•	reminders 비어 있음 → “설정된 알림이 없습니다” 문구
	•	존재함 → 마감 임박순 정렬

⸻

7. 이벤트 흐름 (Event Flow)

7.1 EventBus 이벤트 타입

PolicyEventType에 아래 값 추가 (enum 확장):
	•	reminderChanged — 특정 policyId의 Reminder 상태 변경
	•	reminderBulkUpdated — cleanup/일괄 변경 등

PolicyEvent payload:
	•	type: PolicyEventType
	•	policyId: String?
	•	기타 필요한 데이터

7.2 발행 지점
	•	PolicyReminderService.upsertReminder(...) 완료 후:
	•	PolicyEventType.reminderChanged + policyId
	•	PolicyReminderService.cancelReminder(policyId) 완료 후:
	•	PolicyEventType.reminderChanged + policyId
	•	cleanupExpiredReminders로 여러 건 변경 시:
	•	PolicyEventType.reminderBulkUpdated

7.3 구독 지점
	•	PolicyReminderController:
	•	자기 policyId에 해당하는 이벤트 수신 시 load() 재실행
	•	PolicyFeedListView / PolicyCard:
	•	개별 카드가 직접 EventBus를 구독하기보다는,
해당 화면 진입 시 PolicyReminderController가 초기 로딩해 뱃지를 표시하는 것을 우선.
	•	필요 시 job09에서 “카드 레벨 최적화 구독” 고려.

⸻

8. 파일 구조 (File Structure)

job08에서 새로 추가/수정해야 하는 파일들:

lib/features/policy_new/
  domain/
    entities/
      policy_reminder.dart            # PolicyReminder, ReminderStatus, ReminderOption
  data/
    repositories/
      policy_reminder_repository.dart # 인터페이스
    sources/
      policy_reminder_local_source.dart (선택) # 로컬 저장소 접근
    repositories_impl/
      policy_reminder_local_repository.dart # 구현체
  application/
    services/
      policy_reminder_service.dart    # 비즈니스 로직
    controllers/
      policy_reminder_controller.dart       # 개별 정책용
      policy_reminder_list_controller.dart  # 알림 목록용
    schedulers/
      reminder_scheduler.dart         # 인터페이스 + NoOp 구현
  presentation/
    reminder/
      policy_reminder_badge.dart      # 카드용 뱃지 (🔔 등)
      policy_reminder_button.dart     # 상세 화면 버튼
      policy_reminder_list_screen.dart# “내 알림 관리” 화면

기존 파일(Policy, PolicyRepository 등)은 수정 금지.
단, PolicyEventType enum과 EventBus 타입은 job08에서 확장 가능.

⸻

9. Acceptance Criteria (수용 기준)
	•	PolicyReminder Domain 엔티티와 ReminderStatus, ReminderOption enum이 정의되어 있다.
	•	PolicyReminderRepository 인터페이스와 PolicyReminderLocalRepository 구현체가 존재하며,
최소한 아래 메서드를 제공한다:
- Future<void> upsert(PolicyReminder reminder)
- Future<void> delete(String policyId)
- Future<PolicyReminder?> getByPolicyId(String policyId)
- Future<List<PolicyReminder>> getAll()
	•	ReminderScheduler 인터페이스 및 NoOpReminderScheduler 구현이 존재한다.
	•	PolicyReminderService가 Repository + Scheduler를 사용해
upsert/cancel/cleanupExpired 기능을 제공한다.
	•	policyReminderControllerProvider(policyId)가 개별 정책의 reminder 상태를 관리하고,
setOption/cancel/load 메서드를 제공한다.
	•	policyReminderListControllerProvider가 “알림 관리 화면”을 위한 목록 상태를 제공한다.
	•	정책 상세 바텀시트에 PolicyReminderButton이 추가되어,
- 현재 알림 상태를 표시하고
- 알림 설정/변경/취소 UI를 제공한다.
	•	정책 카드에 PolicyReminderBadge가 추가되어,
알림 설정된 정책에 🔔 같은 아이콘을 일관되게 표시한다.
	•	PolicyEventType에 reminder 관련 이벤트가 추가되고,
PolicyReminderService에서 알맞게 이벤트를 발행한다.
	•	빌드시 타입 에러/순환 참조/Provider 충돌이 없어야 한다.
	•	플러터 앱을 실행했을 때,
- 정책 상세에서 알림을 설정/취소할 수 있고,
- “내 알림 관리” 화면에서 설정된 목록을 볼 수 있으며,
- 마감일이 지난 정책은 expired 상태로 보이는 것까지 동작한다
(실제 OS 레벨 알림 팝업은 NoOp로 처리해도 무방).

# END OF JOB09
---

⸻
# START OF JOB09

@chatgpt-codex
# job09 — PolicyNew Application Deadline Reminder & Notification Center
# (신청일자 알림 엔진 + 알림 센터 UI + Event / Provider / Controller 설계)

---

## 0. 시스템 정의 (System Definition)

### 0.1 목적

- PolicyNew 시스템에 **“신청일자 알림(Reminder)” 기능**을 추가한다.
- 정책 상세화면에서 사용자가 **“이 정책 신청 마감 전에 알려줘”**를 누르면:
  - 내부 DB/스토리지에 Reminder가 저장되고
  - 플랫폼별 Notification 스케줄러를 통해 로컬 푸시 알림이 예약되며
  - 앱 내 “알림 센터”에서 이 알림들을 목록/관리(켜기/끄기/삭제)할 수 있게 한다.
- 추후 iOS/Android/웹별 구현 차이는 하위 레이어(Platform Adapter)에서 처리하고,
  이번 job09에서는 **도메인/리포지토리/컨트롤러/Provider/화면 구조**를 정의한다.

### 0.2 범위

- Domain: `PolicyReminder` 엔티티 및 관련 Value Object 정의
- Data: Reminder 저장소(로컬 Persistence) 추상화 인터페이스
- Application:
  - Reminder 관리용 Repository/UseCase/Controller
  - NotificationGateway(알림 스케줄러 추상 포트) 정의
  - EventBus와 연계
- Presentation:
  - 정책 상세 화면에 “알림 설정/해제” 버튼 추가
  - 독립된 “알림 센터” 화면
  - 알림 상태 표시 UI(ON/OFF/만료됨 등)

---

## 1. 문제 정의 (Problem Statement)

1. 현재 PolicyNew 시스템은:
   - 정책의 신청 시작일/마감일/발표일 등 정보는 Domain에 존재하지만
   - 사용자가 “언제 알려줘”를 선택할 수 있는 기능이 없다.
   - 사용자는 마감일을 기억하지 못해서 정책을 놓칠 수 있다.

2. 지민님이 원하는 기능:
   - 정책마다 **“신청일자 알림 기능”**을 켜고 끌 수 있어야 한다.
   - 마감 하루 전, 마감 당일 등 설정된 타이밍에 푸시/로컬 알림이 와야 한다.
   - 어떤 정책들에 알림이 걸려있는지 한눈에 볼 수 있는 “알림 목록 화면”이 필요하다.
   - 즐겨찾기와는 별개로, **“실제 행동(신청)”을 돕는 기능**으로 설계되어야 한다.

3. 제약:
   - 백엔드 Push 서버를 전제하지 않고, **로컬 알림(Local Notification)** 기반으로 설계한다.
   - 플랫폼(iOS/Android/Web)에 따라 실제 스케줄링 구현은 다르므로, job09에서는 **추상 포트(Interface)**만 정의한다.

---

## 2. 요구사항 분석 (Requirements)

### 2.1 기능 요구사항 (Functional Requirements)

1. **Reminder 생성**
   - 정책 상세 화면에서 “신청일자 알림 설정” 버튼 클릭 시,
     해당 정책에 대한 Reminder가 생성되어 로컬 저장 + 알림 스케줄링이 이루어진다.
   - 기본 트리거:
     - 마감 N시간 전 (예: 24시간 전, 3시간 전 등 기본값)
     - 앱 내에서 기본값을 정의하고, 추후 커스터마이징 가능하게 설계만 열어둔다.

2. **Reminder 상태 조회**
   - 특정 정책 ID에 대해 지금 Reminder가 설정되어 있는지 여부를 조회할 수 있어야 한다.
   - 알림 센터에서는 현재 등록된 모든 Reminder 목록을 보여준다:
     - 정책 제목
     - 알림 예정 시각
     - 상태(예정, 만료, 취소 등)

3. **Reminder 수정/삭제**
   - 알림 센터에서 알림을 OFF 하거나 삭제할 수 있어야 한다.
   - 정책 상세 화면에서도 “알림 해제” 버튼으로 끌 수 있어야 한다.
   - 끌 경우:
     - 로컬 저장소에서 Reminder 제거
     - NotificationGateway를 통해 예약된 알림 취소

4. **만료 처리**
   - 과거 시간이 된 Reminder(마감 지남 등)는 “만료됨” 상태로 표시되거나,
     자동으로 삭제/아카이브 처리할 수 있는 정책(Policy)을 정의한다.
   - job09에서는 기본 동작:
     - 앱 진입 시, “현재 시각 < triggerAt” 인 것만 “유효”로 보고,
       과거인 것들은 “만료” 상태로 플래그를 바꾼다.

5. **다중 알림 정책 (옵션)**
   - 한 정책에 대해 복수의 알림(예: 3일 전 / 1일 전 / 당일)을 지원할 수 있게 모델은 설계하되,
     이번 구현은 “1개 알림(마감 N시간 전)”만 실제 사용.

### 2.2 비기능 요구사항 (Non-functional)

- 앱이 재시작되더라도 Reminder 정보는 유지되어야 한다.
  - 로컬 DB/파일/SharedPreferences/Isar 등 디스크 기반 저장 전제.
- 시간대(Timezone) 이슈를 고려하여,
  - 시스템 내부에서는 UTC 저장 + 로컬 시각 변환 규칙을 명시적으로 적어둔다.
- 네트워크가 없어도 알림이 동작해야 한다. (Pure Local)

---

## 3. 아키텍처 설계 (Architecture Design)

### 3.1 레이어별 역할

- **Domain**
  - `PolicyReminder` 엔티티
  - `PolicyReminderStatus` enum
  - `PolicyReminderConfig` (사용자 기본 설정, 예: “마감 24시간 전 알림”)
- **Data**
  - `PolicyReminderRepository` 인터페이스 (Domain에서 사용)
  - `PolicyReminderLocalDataSource` 구현 (로컬 DB/스토리지)
  - `NotificationGateway` 인터페이스 (플랫폼 알림 스케줄러 추상 포트)
- **Application**
  - `PolicyReminderController` (상태 + UI 액션 처리)
  - `PolicyReminderService/UseCase` (Reminder 생성/취소 로직)
  - EventBus와 연계 (알림 생성/삭제 시 이벤트 브로드캐스트)
- **Presentation**
  - 정책 상세 바텀시트에 알림 토글 버튼
  - “알림 센터” 화면 (리스트 + 조작)
  - 상태에 따른 UI 표시(ON/OFF/만료)

---

## 4. 데이터 파이프라인 / 흐름도 (Data Pipeline & Flow)

### 4.1 알림 생성 플로우 (정책 상세 → 알림 스케줄)

1. User: 정책 상세 화면에서 **“신청일자 알림 설정” 버튼 탭**
2. UI: `PolicyReminderController.toggleReminder(policy)` 호출
3. Controller:
   - 정책의 `applicationEndDate` 확인 (없으면 실패)
   - `PolicyReminderService.createReminder(policy)` 호출
4. Service:
   - `PolicyReminderConfig` 로부터 기본 오프셋(예: -24h) 가져옴
   - triggerAt = applicationEndDate - offset 계산
   - `PolicyReminderRepository.saveReminder(...)` 호출
   - 성공 시 `NotificationGateway.scheduleReminder(...)` 호출
5. NotificationGateway:
   - 플랫폼 별 native 스케줄링 (실제 구현은 다른 job에서)
6. EventBus:
   - `PolicyEventType.reminderChanged` 이벤트 발행
7. UI:
   - 정책 상세 화면의 알림 토글 상태 업데이트
   - 알림 센터 화면이 열려 있다면 Provider를 통해 자동 리빌드

### 4.2 알림 취소 플로우

1. User: 정책 상세 혹은 알림 센터에서 “알림 해제” 탭
2. Controller: `cancelReminder(policyId)` 호출
3. Service:
   - `PolicyReminderRepository.getReminderByPolicyId` 조회
   - 있으면 삭제 후 `NotificationGateway.cancelReminder(externalId)`
4. EventBus:
   - `PolicyEventType.reminderChanged` 브로드캐스트
5. UI:
   - 상세/알림 센터 UI 갱신

### 4.3 앱 시작 시 정리 플로우

1. 앱 시작 시 `PolicyReminderController.initialize()` 호출
2. Controller:
   - `Repository.getAllReminders()` 가져옴
   - 현재 시각 기준 `triggerAt < now` 인 것들을 `EXPIRED` 상태로 마킹 또는 삭제 정책 수행
3. 필요한 경우:
   - 만료된 알림에 대해 NotificationGateway에 `cancelReminder` 호출 (잔여 스케줄 정리)

---

## 5. Provider / Controller 상호작용 규칙

### 5.1 Provider 목록

- `policyReminderRepositoryProvider`
- `policyReminderControllerProvider`
- `policyReminderListProvider` (알림 센터용 목록)
- `policyReminderStatusProvider(policyId)` (특정 정책의 알림 상태용)

### 5.2 Controller 책임

- `PolicyReminderController`:
  - `initialize()` : 앱 시작 시 Reminder 상태 싱크
  - `toggleReminder(Policy policy)` : ON/OFF 토글
  - `createReminder(Policy policy)` : 명시적 생성
  - `cancelReminderByPolicyId(String policyId)`
  - `getReminderStatus(String policyId)` : PRESENTATION에서 사용

### 5.3 Provider 간 의존 관계

- `policyReminderControllerProvider`  
  → `policyReminderRepositoryProvider` + `notificationGatewayProvider` 의존
- `policyReminderListProvider`  
  → `policyReminderControllerProvider`를 통해 Repository 결과를 얻어 UI-friendly 리스트로 변환
- `policyReminderStatusProvider(policyId)`  
  → `policyReminderControllerProvider`의 메서드를 통해 해당 정책의 상태 반환

---

## 6. UI 상태도 (UI State Diagram — 논리 설명)

### 6.1 정책 상세 화면(Reminder 부분)

- 상태:
  - `OFF` : 알림 미설정
  - `ON(예정)` : 알림 설정됨 / 미래 triggerAt
  - `EXPIRED` : triggerAt 과거 / 알림 만료
- 상태 전이:
  - `OFF` → [사용자 토글] → `ON`
  - `ON` → [사용자 토글] → `OFF`
  - `ON` → [시간 경과 & 앱 초기화 로직] → `EXPIRED`
  - `EXPIRED` → [사용자 재설정] → `ON`

### 6.2 알림 센터 화면

- 전체 상태:
  - `Loading` : Repository에서 로드 중
  - `Empty` : Reminder 없음
  - `Data(reminderList)` : 하나 이상 존재
- 각 아이템 상태:
  - `Scheduled` (ON + future)
  - `Expired`
  - `Canceled` (옵션: 리스트에서 안 보이게 할 수도 있음)

---

## 7. 이벤트 흐름 (Event Flow)

### 7.1 EventBus 이벤트 타입 확장

- `PolicyEventType.reminderChanged`
  - payload: `policyId`, `newStatus(ON/OFF/EXPIRED)`
- `PolicyEventType.reminderTriggered` (선택)
  - 실제 알림 발생 시 앱이 포그라운드에서 수신하는 경우 사용 가능 (job11 수준에서 구현)

### 7.2 구독자

- 정책 상세 화면:
  - 해당 policyId에 대한 `reminderChanged` 이벤트를 수신해 UI 토글 상태 갱신
- 알림 센터 화면:
  - 전체 `reminderChanged` 이벤트를 수신해 리스트 갱신
- Recommend/All/Region/Search 피드:
  - 직접적인 갱신 필요는 없지만, 나중에 “곧 마감 정책 강조” 등의 UX를 위해 선택적으로 사용할 수 있음 (job10 이후).

---

## 8. 파일 구조 (File Structure)

아래 파일/디렉토리를 새로 생성한다. (기존 파일 삭제/수정 금지, 필요한 경우 전체 교체 명시)

```txt
lib/features/policy_new/
  domain/
    entities/
      policy_reminder.dart               # PolicyReminder 엔티티
    values/
      policy_reminder_status.dart        # ON / OFF / EXPIRED 등
      policy_reminder_config.dart        # 기본 알림 오프셋 설정 등
  data/
    sources/
      policy_reminder_local_data_source.dart   # 로컬 저장소 접근
    repositories/
      policy_reminder_repository_impl.dart     # Domain 인터페이스 구현
  domain/
    repositories/
      policy_reminder_repository.dart          # 추상 인터페이스
  application/
    controllers/
      policy_reminder_controller.dart          # 상태 + 액션
    services/
      policy_reminder_service.dart             # 비즈니스 로직
    gateways/
      notification_gateway.dart                # 플랫폼 알림 스케줄러 추상 인터페이스
    providers.dart (기존 파일에 아래 Provider들 추가)
      - policyReminderRepositoryProvider
      - policyReminderControllerProvider
      - policyReminderListProvider
      - policyReminderStatusProvider
  presentation/
    reminder/
      policy_reminder_center_screen.dart       # 알림 센터 화면
      widgets/
        policy_reminder_list_item.dart         # 리스트 아이템
    detail/
      (기존) policy_detail_bottom_sheet.dart   # 여기에 알림 토글 버튼 추가


⸻

9. Acceptance Criteria
	1.	Domain
	•	PolicyReminder 엔티티가 정의되어 있으며,
id, policyId, triggerAt, status, createdAt, updatedAt 등을 가진다.
	•	PolicyReminderStatus enum이 정의되어 scheduled / expired / canceled 등을 표현한다.
	•	PolicyReminderConfig가 기본 오프셋(예: -24h)을 저장할 수 있게 정의된다.
	2.	Data
	•	PolicyReminderRepository 인터페이스가 정의되고,
create/update/delete/getByPolicyId/getAll API를 제공한다.
	•	PolicyReminderRepositoryImpl이 로컬 데이터소스 + Mapper를 이용해 해당 인터페이스를 구현한다.
	•	실제 저장 매체(SharedPreferences/Isar 등)는 이 job에서 구현 여부를 명시하되,
적어도 in-memory mock 구현은 제공되어야 한다.
	3.	Application
	•	NotificationGateway 인터페이스가 정의되어:
scheduleReminder(PolicyReminder) / cancelReminder(PolicyReminder) 메서드를 제공한다.
	•	PolicyReminderService가 Reminder 생성/취소/만료 처리 핵심 로직을 담당한다.
	•	PolicyReminderController가 UI 액션용 API(toggle/create/cancel/getStatus/initialize)를 제공한다.
	•	EventBus에 reminderChanged 이벤트 타입이 추가되고,
Reminder 생성/삭제 시 발행된다.
	4.	Presentation
	•	정책 상세 바텀시트에 “신청일자 알림” 토글 버튼이 추가되고,
토글 시 Controller를 통해 ON/OFF가 수행된다.
	•	“알림 센터” 화면에서 현재 등록된 모든 Reminder가 리스트로 보이며,
각 항목에 대해 “해제” 기능을 제공한다.
	•	알림 센터는 다음 세 가지 상태를 처리한다:
Loading / Empty / Data(reminders).
	•	알림 토글/해제 후 화면이 즉시 갱신된다(EventBus 또는 Provider 연동).
	5.	통합
	•	앱 시작 시 PolicyReminderController.initialize()가 호출되어
만료된 Reminder를 정리한다는 로직이 존재한다.
	•	전체 빌드가 타입 에러 없이 통과한다.
	•	기존 job01~job08에서 정의한 구조(Domain/Repository/Controller/UI)와 충돌이 없다.
# END OF JOB09

---

# START OF JOB10


@chatgpt-codex
# job10 — Policy Application Deadline Reminder & Notification System
# (신청일자 알림/리마인더 시스템: 설계 + 저장 + 로컬 알림 + UI 연동)

---

## 0. 시스템 정의 (System Definition)

### 0.1 목적
- 사용자가 관심 있는 정책에 대해 **신청 마감일/시작일 기준으로 알림을 예약**하고,
- 기한이 다가오면 **디바이스 로컬 알림**으로 알려주는 시스템을 구축한다.
- 이 시스템은:
  - `Policy` 엔티티의 `applicationStartDate` / `applicationEndDate`를 기반으로,
  - 사용자가 선택한 패턴(D-7, D-3, D-1, 당일 등)에 맞춰,
  - 로컬 알림 + 앱 내 “알림 목록 화면”까지 제공하는 것을 목표로 한다.

### 0.2 범위
- 이 job10은 **클라이언트 앱 내 알림/리마인더 레이어**만 다룬다.
- 서버 푸시(Firebase FCM 등)는 고려하지 않고, **디바이스 로컬 알림** 위주로 설계한다.
- Flutter 환경에서 `flutter_local_notifications` 같은 패키지 사용을 전제로 하나,
  구체 패키지 명은 나중에 바꿔도 되도록 **NotificationGateway 인터페이스**로 추상화한다.

---

## 1. 문제 정의 (Problem Statement)

1. 사용자는 정책 상세 페이지를 보고 “좋네, 나중에 신청해야지”라고 생각하지만,
   앱을 닫고 나면 **신청 기한을 잊어버리는 경우가 많다**.
2. 단순 즐겨찾기만으로는 “언제 다시 봐야 하는지”를 알려주지 못한다.
3. 신청 마감일이 정책마다 다르고, D-7 / D-3 / D-1 등 **사용자 선호 알림 시점**도 다를 수 있다.
4. 현재 시스템(job01~job06)에는:
   - `Policy` 도메인 모델은 있지만,
   - “알림/리마인더 엔티티”와 이를 관리하는 Repository/Controller/UI가 없다.
5. 알림/리마인더 기능이 다른 레이어(UI/Controller/Repository)에 흩어지면 유지보수가 어려워진다.
   - 따라서 **전용 도메인 + 데이터 파이프라인 + Interaction 아키텍처**가 필요하다.

---

## 2. 요구사항 분석 (Requirement Analysis)

### 2.1 기능 요구사항 (Functional)

1. **리마인더 생성**
   - 사용자는 정책 상세 화면에서 “신청 알림 설정” 버튼을 누를 수 있다.
   - 옵션 예시:
     - D-7, D-3, D-1, 당일 09:00
     - “직접 날짜/시간 선택”
   - 각 선택은 하나의 또는 여러 개의 `Reminder`로 저장/스케줄링된다.

2. **리마인더 목록 관리**
   - “알림/리마인더” 전용 화면에서 **다가오는 알림 목록**을 볼 수 있어야 한다.
   - 항목: 정책 제목, 알림 예정 시각, 상태(예정/완료/취소), 알림 타입(D-3 등)

3. **리마인더 취소/수정**
   - 사용자는 개별 리마인더를 끄거나 삭제할 수 있어야 한다.
   - 편의상 **정책 단위**로 전체 리마인더를 Off 하는 옵션도 제공할 수 있다.

4. **로컬 알림 트리거**
   - 알림 시각이 되면 디바이스에 푸시(로컬 알림)가 뜬다.
   - 알림을 탭하면 해당 정책 상세 화면으로 이동한다.

5. **정책/알림 상태 동기화**
   - 정책이 이미 마감된 경우:
     - 새 리마인더를 만들 수 없게 막거나,
     - 경고 메시지를 보여준다.
   - `Policy` 정보 업데이트(마감일 변경) 시, 새롭게 리마인더를 설정해야 한다는 안내 가능(선택).

6. **다국어/텍스트 메시지** (간단)
   - 알림 제목/내용은 간단한 템플릿으로 처리 (예: `[청년정책] D-3: ○○○ 지원사업 신청 마감 예정`)

---

### 2.2 비기능 요구사항 (Non-Functional)

1. **신뢰성**
   - 앱을 재실행해도 알림 예약 상태가 유지되어야 하며,
   - 디바이스 재부팅 시에도 OS 수준에서 예약 알림을 유지/복구(패키지 기능 사용)할 수 있어야 한다.

2. **확장성**
   - 나중에 서버 푸시로 확장될 여지를 남겨두기 위해,
     알림 발송은 `NotificationGateway` 인터페이스로 추상화한다.

3. **성능**
   - 리마인더 목록을 조회/저장할 때 UI가 크게 느려지지 않아야 한다.
   - 로컬 DB(예: Isar) 사용 시, 배치 조회 기준으로 설계.

4. **일관성**
   - Domain/Repository/Controller/Presentation 레이어 분리 규칙(job01~job06)과 동일한 방식 유지.

---

## 3. 아키텍처 설계 (Architecture Design)

### 3.1 레이어 개요

- **Domain Layer**
  - `PolicyReminder` 엔티티
  - `ReminderType` enum (D-7 / D-3 / D-1 / custom 등)
  - `ReminderStatus` enum (scheduled / fired / canceled)
  - `ReminderRepository` 인터페이스

- **Data Layer**
  - `ReminderLocalSource` (Isar/SharedPreferences/SQLite 등의 구현)
  - `ReminderRepositoryImpl` (Domain 인터페이스 구현)
  - `NotificationGateway` (실제 로컬 알림 패키지 호출)

- **Application Layer**
  - `ReminderController` (리마인더 생성/수정/삭제/목록 조회)
  - `ReminderScheduler` (현재 시간 + 정책 마감일 + 타입 → 실제 알림 시각 계산 + 스케줄)
  - EventBus 연동 (PolicyEventType.reminderCreated / reminderCanceled 등)

- **Presentation Layer**
  - 정책 상세 화면: “알림 설정” BottomSheet
  - 알림 목록 화면: `ReminderListScreen`
  - 간단한 토글/삭제 UI

---

## 4. 데이터 파이프라인 / 흐름도 (Data Pipeline & Flow)

### 4.1 리마인더 생성 플로우

1. 사용자가 정책 상세 화면에서 “신청 알림 설정” 버튼 클릭  
2. “알림 설정 BottomSheet”에서:
   - D-7 / D-3 / D-1 / 당일 / 사용자 지정 옵션 선택
3. UI → `ReminderController.createReminders(policy, types[])` 호출
4. `ReminderController`는:
   - 각 `ReminderType`에 대해 `ReminderScheduler`를 호출:
     - 정책 마감일/시작일 + 타입 → `DateTime remindAt`
   - `ReminderRepository.create(...)`로 `PolicyReminder` 저장
   - `NotificationGateway.schedule(reminderId, remindAt, title, body, payload)` 호출
   - EventBus에 `PolicyEventType.reminderCreated` 이벤트 발행

### 4.2 알림 발동 플로우

1. OS/패키지에서 예약된 시각에 로컬 알림 발송
2. 사용자가 알림을 탭
3. 앱 런처 → payload의 `policyId`/`reminderId`로 정책 상세 화면 오픈
4. (선택) `ReminderController.markAsFired(reminderId)` 호출 → 상태 갱신

### 4.3 리마인더 취소/삭제 플로우

1. 알림 목록 화면에서 특정 리마인더 항목의 “삭제/비활성화” 버튼 클릭
2. UI → `ReminderController.cancelReminder(reminderId)` 호출
3. `ReminderController`:
   - `NotificationGateway.cancel(reminderId)` 호출
   - `ReminderRepository.markAsCanceled(reminderId)` 또는 삭제
   - EventBus에 `PolicyEventType.reminderCanceled` 발행

---

## 5. Provider / Controller 상호작용 규칙

### 5.1 Provider 정의

- `reminderRepositoryProvider` → `ReminderRepository`
- `reminderControllerProvider` → `ReminderController`
- `reminderListProvider` → `AsyncValue<List<PolicyReminder>>` (다가오는 알림 목록)
- `notificationGatewayProvider` → `NotificationGateway`

### 5.2 상호작용 규칙

1. **UI → Controller**
   - “알림 설정” UI는 오직 `ReminderController` 메서드만 호출한다.
     - createReminders
     - cancelReminder
     - cancelAllForPolicy
   - Repository/LocalSource/NotificationGateway에는 직접 접근하지 않는다.

2. **Controller → Repository/Gateway**
   - `ReminderController`는 리마인더 생성/수정/삭제/조회 로직을 담당한다.
   - 실제 데이터 저장/불러오기는 `ReminderRepository`에 위임.
   - 알림 스케줄링/취소는 `NotificationGateway`에 위임.

3. **EventBus**
   - 리마인더 생성/삭제 시 EventBus에 이벤트를 발행하고,
   - 알림 목록 화면이 이 이벤트를 구독하여 자동으로 목록을 갱신할 수 있다.

---

## 6. UI 상태도 (UI State Diagram - 요약)

### 6.1 정책 상세 화면 (PolicyDetailBottomSheet 확장)

- 상태:
  - `hasActiveReminder` (해당 정책에 대해 활성 리마인더가 하나 이상 존재)
  - `remindersForPolicy` (리마인더 리스트; 필요시 요약)

- 버튼:
  - “신청 알림 설정” (리마인더 없음 또는 추가 설정)
  - “알림 관리” (이미 설정된 경우 → 관리 시트/화면으로 이동)

---

### 6.2 알림 목록 화면 (ReminderListScreen)

- 상태:
  - `AsyncValue<List<PolicyReminder>>`
  - `isEmpty` / `isLoading` / `hasError` 분기

- UI:
  - 각 항목에:
    - 정책 제목
    - 알림 시각
    - 상태 (예정/완료/취소)
    - “삭제/끄기” 버튼

---

## 7. 이벤트 흐름 (Event Flow)

### 7.1 PolicyEvent 확장

`PolicyEventType`에 다음 타입을 추가:

- `reminderCreated`
- `reminderCanceled`
- (선택) `reminderFired`

각 이벤트는 payload로 `policyId` / `reminderId`를 포함한다.

### 7.2 Event 소비자

- ReminderListScreen
  - `reminderCreated` / `reminderCanceled` 수신 시 목록 재로딩
- PolicyDetailBottomSheet
  - `reminderCreated` / `reminderCanceled` 수신 시 `hasActiveReminder` UI 갱신

---

## 8. 파일 구조 (File Structure)

```txt
lib/features/policy_new/
  domain/
    entities/
      policy_reminder.dart           # PolicyReminder 엔티티
    values/
      reminder_type.dart             # D-7, D-3, D-1, custom 등
      reminder_status.dart           # scheduled, fired, canceled
    repositories/
      reminder_repository.dart       # 인터페이스

  data/
    sources/
      reminder_local_source.dart     # 로컬 DB/스토리지 접근
    repositories/
      reminder_repository_impl.dart  # Repository 구현
    notifications/
      notification_gateway.dart      # 추상화 인터페이스
      notification_gateway_impl.dart # 실제 flutter_local_notifications 사용 구현

  application/
    controllers/
      reminder_controller.dart       # 생성/수정/삭제/조회
      reminder_scheduler.dart        # Policy + ReminderType → DateTime 계산
    providers.dart                   # reminder 관련 provider 등록

  presentation/
    reminder/
      screens/
        reminder_list_screen.dart        # 알림 목록 화면
      widgets/
        reminder_list_item.dart          # 각 알림 행
        reminder_empty_view.dart         # 빈 상태
      sheets/
        reminder_setup_bottom_sheet.dart # 정책 상세에서 알림 옵션 선택 UI
        reminder_manage_sheet.dart       # 해당 정책의 리마인더 관리 UI


⸻

9. Acceptance Criteria
	1.	Domain
	•	PolicyReminder 엔티티가 정의되어 있으며, policyId, reminderId, remindAt, type, status, createdAt 등이 포함된다.
	•	ReminderType, ReminderStatus enum이 정의되어 있다.
	•	ReminderRepository 인터페이스에 create / listUpcoming / listByPolicy / cancel / cancelAllForPolicy / markAsFired 등의 메서드가 정의되어 있다.
	2.	Data
	•	ReminderLocalSource는 로컬 저장소(어떤 스토리지든) 기반 CRUD를 제공한다.
	•	ReminderRepositoryImpl은 ReminderRepository를 구현하고, LocalSource와 매핑한다.
	•	NotificationGateway 인터페이스가 존재하며, schedule/cancel/cancelAll 등의 메서드가 정의되어 있다.
	•	NotificationGatewayImpl은 실제 로컬 알림 패키지를 사용해 구현된다.
	3.	Application
	•	ReminderController가 리마인더 생성/삭제/목록 조회를 담당하며, UI는 이 컨트롤러만 호출해 리마인더를 조작한다.
	•	ReminderScheduler가 Policy + ReminderType을 입력받아 실제 알림 시각(DateTime)을 계산하는 로직을 구현한다.
	•	EventBus에 reminderCreated, reminderCanceled 이벤트 타입이 추가되고, 생성/삭제 시 적절히 발행된다.
	4.	Presentation
	•	정책 상세 화면(PolicyDetailBottomSheet)에 “신청 알림 설정” 버튼이 추가된다.
	•	“신청 알림 설정” 버튼 클릭 시 reminder_setup_bottom_sheet.dart가 표시되고, 사용자가 D-7/D-3/D-1/당일/직접입력 등의 옵션을 선택할 수 있다.
	•	알림 목록 화면(ReminderListScreen)에서 다가오는 알림들을 확인할 수 있고, 항목별 삭제/끄기 동작이 정상 작동한다.
	•	알림 삭제/끄기 시 해당 리마인더는 Repository에서 상태 변경(또는 삭제)되고, NotificationGateway를 통해 실제 알림 스케줄도 취소된다.
	5.	동작 및 일관성
	•	앱 재시작 후에도 리마인더 목록이 유지된다.
	•	알림을 탭하면 해당 정책 상세 화면으로 안전하게 이동한다(네비게이션 경로 정의 필요).
	•	기존 PolicyNew Domain/Repository/Controller/Presentation 구조에 타입/의존성 충돌 없이 빌드가 성공한다.
	•	서버 사이드 변경 없이 클라이언트만으로 동작 가능해야 한다.

⸻

# END OF JOB10
---
# START OF JOB11

# 🟦 #job11 — Policy Application Reminder & Notification Center

> **“신청일자 놓쳐서 뒤늦게 후회하는 경험을 없애는 시스템”**

이 문서는 **AGENTS.md에 그대로 붙여넣고 Codex에게 시킬 수 있는 설계서**예요.
job01 스타일 요구사항 전부 포함해서 정리할게요.

---

````md
@chatgpt-codex
# job11 — Policy Application Reminder & Notification Center
# (신청일자 알림 + 알림센터 + EventBus 연동)

---

## 1. 시스템 정의 (System Definition)

### 1.1 시스템 이름
- 이름: **Policy Application Reminder & Notification Center**
- 약칭: **PolicyReminderSystem**

### 1.2 담당 역할
- 각 정책의 **신청 마감일(applicationEndDate)** 을 기준으로:
  - 사용자가 원하는 시점(D-7, D-3, D-1, 당일 특정 시간)에 **로컬 알림**을 예약한다.
  - 이미 지난 정책/마감된 정책에 대한 알림은 자동으로 **무시 or 정리**한다.
- “내가 알림을 걸어둔 정책들”을 한 화면에서 모아볼 수 있는 **알림 센터 화면**을 제공한다.
- 전체 앱에서 알림 상태 변경(추가/삭제/만료)이 발생했을 때  
  다른 피드/화면(예: 상세 페이지, 즐겨찾기 탭)이 **일관된 상태**를 볼 수 있도록 EventBus로 통합한다.

### 1.3 경계 (Scope)
- job11은 **알림 예약/저장/표시/상태 관리**까지 담당하고,
- 실제 OS-level 푸시 구현(예: flutter_local_notifications)은
  - **NotificationGateway 인터페이스**로 추상화만 한다.
  - 실제 플러그인 연결/플랫폼 별 구현은 job12 이후의 책임으로 둔다.

---

## 2. 문제 정의 (Problem Definition)

### 2.1 현재 문제
- 사용자가 정책을 둘러보다가 “오 이거 나중에 신청해야지” 하고 넘어가면,  
  며칠 뒤에는 **마감일이 기억나지 않거나 이미 지남**.
- 앱 자체에는 “기억 장치”가 없어서,
  - 사용자가 직접 캘린더에 적거나,
  - 스크린샷만 남겨놓고,
  - 결국 마감일을 놓치게 된다.
- 정책 앱으로서 가장 중요한 경험 중 하나인  
  **“기회를 놓치지 않게 해주는 기능”** 이 부재한 상태.

### 2.2 해결하고 싶은 것
- 정책 상세에서 **1~2번 터치로 알림을 걸고**,  
  “내 알림” 화면에서 **한 번에 관리**할 수 있게 한다.
- 알림이 실제로 울릴 때, 사용자가:
  - “어떤 정책이 곧 마감인지” 바로 알 수 있고,
  - 바로 정책 상세/신청 페이지로 이동할 수 있게 만든다.

---

## 3. 요구사항 분석 (Requirements Analysis)

### 3.1 기능 요구사항 (Functional)

1. **알림 설정**
   - 정책 상세 화면에서 “알림 설정” 버튼을 통해 알림을 추가할 수 있다.
   - 제공 옵션 (기본값):
     - D-7, D-3, D-1, 당일(0일) + 특정 시간(기본 09:00)
   - 마감일이 없는 정책(applicationEndDate == null)은 알림을 설정할 수 없다 (비활성/경고).

2. **알림 관리**
   - 사용자 한 정책에 대해 **여러 개의 알림**을 둘 수 있다 (예: D-7, D-1).
   - 이미 지난 시점(현재 시각보다 과거인 알림)은 생성 시점에 자동으로 **무시 or 등록 불가**로 처리한다.
   - 사용자는 알림 센터에서 알림 개별 삭제, 정책 단위 전체 삭제가 가능하다.

3. **알림 센터 화면**
   - “내 알림” 탭 또는 화면에서:
     - 앞으로 울릴 예정인 알림 목록
     - 이미 지난 알림(옵션에 따라 숨김 or ‘지난 알림’ 섹션) 표시
   - 각 알림을 탭하면 해당 정책 상세(PolicyDetailBottomSheet)로 이동.

4. **알림 트리거**
   - 알림이 OS에서 울릴 때:
     - 알림 터치 → 앱 열기 → 해당 정책 상세로 이동 (policyId 기반 deep link / 라우팅).
   - 앱이 포그라운드 상태에서 알림 발생 시,  
     상단 토스트/스낵바 형태로도 표시 가능 (선택 항목, job11에서는 설계만).

5. **상태 연동**
   - 알림을 설정/삭제할 때:
     - PolicyDetail UI의 “알림 설정됨/해제됨” 상태가 즉시 반영.
     - 알림 센터 화면의 목록도 자동 업데이트.

### 3.2 비기능 요구사항 (Non-functional)

1. **안정성**
   - 앱 재시작 후에도 알림이 유지되어야 함 (로컬 저장 필수).
2. **성능**
   - 알림 개수가 많아져도(수십 개) Policy 리스트/피드 성능을 해치지 않도록 별도의 저장소/Provider에서 관리.
3. **플랫폼 독립성**
   - Notification 플러그인 flutter_local_notifications 등을 사용하되,
     코드 상에서는 **NotificationGateway** 인터페이스만 의존.

---

## 4. 아키텍처 설계 (Architecture Design)

### 4.1 주요 컴포넌트

- **Domain**
  - `PolicyReminder`
  - `ReminderTimeKind` (DAYS_BEFORE_DEADLINE, CUSTOM_DATETIME)
- **Repository**
  - `ReminderRepository` (Domain 인터페이스)
  - `ReminderRepositoryImpl` (로컬 저장소 구현, e.g. shared_preferences or Isar / 추상화)
- **Notification**
  - `NotificationGateway` (알림 예약/취소 인터페이스)
  - `LocalNotificationGateway` (실제 플러그인 사용 구현은 추후 job에서)
- **Application**
  - `ReminderController` (알림 추가/삭제/조회)
  - `NotificationCenterController` (알림 센터 화면용 상태)
- **Presentation**
  - Policy 상세 바텀시트에 “알림 설정” UI
  - 알림 센터 화면 (`PolicyReminderCenterScreen`)

### 4.2 레이어 간 의존성

- Presentation → Application(Controller) → Repository/NotificationGateway → Local storage + OS notification
- Domain 모델(`PolicyReminder`)은 어디서나 사용되지만, **Data 레이어의 저장 구조는 도메인에 노출하지 않는다.**

---

## 5. 데이터 파이프라인 / 흐름도 (Data Pipeline / Flow)

### 5.1 알림 설정 플로우

1. 사용자: 정책 상세 바텀시트에서 "알림 설정" 버튼 탭
2. UI: 옵션 BottomSheet 표시 (D-7 / D-3 / D-1 / 당일 / 사용자 지정)
3. 사용자: 옵션 선택 후 "저장"
4. UI → `ReminderController.addReminder(policy, option)` 호출
5. `ReminderController`:
   - 정책의 `applicationEndDate` 확인
   - 선택 옵션 → 실제 `scheduledAt: DateTime` 계산
   - `PolicyReminder` Domain 객체 생성
   - `ReminderRepository.save(reminder)` 호출
   - `NotificationGateway.scheduleNotification(reminder)` 호출
   - `PolicyEventBus`에 `reminderAdded` 이벤트 발행
6. UI:
   - 해당 상세 화면의 "알림 설정됨" 상태로 즉시 갱신
   - 알림 센터 화면에서는 EventBus 수신 후 목록 리로드

### 5.2 알림 삭제 플로우

1. 사용자: 알림 센터 화면에서 X 버튼 탭 or 상세 화면에서 "알림 해제"
2. UI → `ReminderController.removeReminder(reminderId)` 호출
3. `ReminderController`:
   - `ReminderRepository.delete(reminderId)`
   - `NotificationGateway.cancelNotification(reminderId)` 호출
   - `PolicyEventBus`에 `reminderRemoved` 이벤트 발행
4. UI:
   - 알림 센터 / 상세 화면 상태 즉시 반영

### 5.3 알림 트리거 플로우 (OS 알림 클릭)

1. OS: 예약된 시간에 로컬 알림 표시
2. 사용자가 알림을 탭
3. 앱 런처 → 초기 route 수신 → `NotificationGateway`의 클릭 payload(예: policyId, reminderId) 전달
4. 앱 라우터:
   - 해당 policyId로 Policy 상세 화면/바텀시트로 이동
5. `ReminderController`:
   - 필요 시 `ReminderRepository`에서 해당 알림 상태를 "triggered"로 변경 (선택 사항)

---

## 6. Provider / Controller 상호작용 규칙

### 6.1 Provider 목록

```dart
// Domain repository
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final storage = ref.read(localStorageProvider);
  final gateway = ref.read(notificationGatewayProvider);
  return ReminderRepositoryImpl(storage: storage, notificationGateway: gateway);
});

// Controllers
final reminderControllerProvider =
    StateNotifierProvider<ReminderController, ReminderState>(
  (ref) => ReminderController(
    repository: ref.read(reminderRepositoryProvider),
    eventBus: ref.read(policyEventBusProvider),
  ),
);

final notificationCenterControllerProvider =
    StateNotifierProvider<NotificationCenterController, NotificationCenterState>(
  (ref) => NotificationCenterController(
    repository: ref.read(reminderRepositoryProvider),
  ),
);
6.2 Controller 책임
ReminderController

알림 추가/삭제/업데이트 책임
EventBus에 reminder 관련 이벤트 송출
NotificationCenterController

"내 알림" 화면에서 사용할 리스트/필터/정렬 책임
repository에서 현재/과거 알림 조회
7. UI 상태도 (UI State Model)
7.1 ReminderState
@immutable
class ReminderState {
  final bool isProcessing;               // 알림 추가/삭제 중 여부
  final List<PolicyReminder> reminders;  // 현재 정책에 설정된 알림 목록 (상세 화면용)
  final PolicyFailure? failure;          // 알림 저장/삭제 과정의 에러

  const ReminderState({
    required this.isProcessing,
    required this.reminders,
    required this.failure,
  });

  const ReminderState.initial()
      : isProcessing = false,
        reminders = const [],
        failure = null;
}
7.2 NotificationCenterState
@immutable
class NotificationCenterState {
  final bool isLoading;
  final List<PolicyReminder> upcoming;   // 앞으로 울릴 알림
  final List<PolicyReminder> past;       // 이미 지난 알림(선택 표시)
  final PolicyFailure? failure;

  const NotificationCenterState({
    required this.isLoading,
    required this.upcoming,
    required this.past,
    required this.failure,
  });

  const NotificationCenterState.initial()
      : isLoading = false,
        upcoming = const [],
        past = const [],
        failure = null;
}
8. 이벤트 흐름 (Event Flow)
8.1 EventBus 이벤트 타입 확장
PolicyEventType에 다음 항목 추가:

reminderAdded
reminderRemoved
reminderUpdated
PolicyEvent payload 예시:

class PolicyEvent {
  final PolicyEventType type;
  final String? policyId;
  final String? reminderId;

  const PolicyEvent({
    required this.type,
    this.policyId,
    this.reminderId,
  });
}
8.2 구독 규칙
정책 상세 화면:

reminderAdded / reminderRemoved 이벤트 수신 시 해당 policyId가 현재 상세 policyId와 같다면, ReminderState 리프레시.
알림 센터 화면:

reminderAdded / reminderRemoved / reminderUpdated 시 전체 리프레시.
다른 피드(추천/전체/즐겨찾기 등)는

알림 여부 표시가 필요하다면, PolicyCard에서 ReminderController의 reminders를 참조 (선택).
9. 파일 구조 (File Structure)
lib/features/policy_new/
  domain/
    entities/
      policy_reminder.dart               # PolicyReminder 도메인 엔티티
    repositories/
      reminder_repository.dart           # ReminderRepository 인터페이스

  data/
    repositories/
      reminder_repository_impl.dart      # 로컬 저장소 + NotificationGateway 연동 구현
    sources/
      reminder_local_source.dart         # 실제 저장소(shared_prefs/Isar 등에 대한 추상화)

  application/
    controllers/
      reminder_controller.dart           # 알림 추가/삭제/조회
      notification_center_controller.dart# 알림 센터 상태
    filters/
      (기존 filter/search 관련 파일 그대로)

  infrastructure/
    notification/
      notification_gateway.dart          # schedule/cancel 인터페이스
      local_notification_gateway.dart    # 플러그인 래핑 구현 (stub 가능)

  presentation/
    screens/
      policy_reminder_center_screen.dart # "내 알림" 화면
    widgets/
      policy_reminder_badge.dart         # 카드/상세에서 '알림 O' 표시용 작은 UI
      policy_reminder_options_sheet.dart # D-7/D-3/D-1/당일 선택 바텀시트
10. Acceptance Criteria (수용 기준)
Domain & Repository

 PolicyReminder 엔티티가 id, policyId, scheduledAt, createdAt, timeKind(D-7 등) 필드를 가진다.

 ReminderRepository 인터페이스에 아래 메서드가 정의된다:

Future<List<PolicyReminder>> getRemindersForPolicy(String policyId)
Future<List<PolicyReminder>> getAllReminders()
Future<void> saveReminder(PolicyReminder reminder)
Future<void> deleteReminder(String reminderId)
 ReminderRepositoryImpl이 위 메서드들을 로컬 저장소 + NotificationGateway 호출로 구현한다.

Notification Gateway

 NotificationGateway에 최소 아래 메서드가 정의된다:

Future<void> scheduleReminder(PolicyReminder reminder)
Future<void> cancelReminder(String reminderId)
 구현체(LocalNotificationGateway)는 stub 형태라도 존재하며, 실제 플러그인 호출은 job12에서 구현 가능하도록 구조만 갖춘다.

Controllers

 ReminderController가 알림 추가/삭제 시:

Repository 호출
NotificationGateway 호출
EventBus에 reminderAdded / reminderRemoved 이벤트 발행
 NotificationCenterController가 전체 알림을 불러와 upcoming/past로 구분된 NotificationCenterState를 구성한다.

UI

 Policy 상세 바텀시트에 "알림 설정" 버튼과 현재 알림 요약(예: “D-3, 당일 09:00 알림 설정됨”)이 표시된다.
 "알림 설정" 버튼 탭 시, 옵션 선택 바텀시트가 표시되고, 선택 후 ReminderController를 통해 알림이 생성된다.
 "내 알림" 화면에서 앞으로 울릴 알림 리스트가 표시되며, 각 항목을 탭하면 해당 정책 상세로 이동한다.
 알림 삭제 시 리스트에서 즉시 사라지고, 상세 화면 상태도 갱신된다.
이벤트 & 일관성

 알림 추가/삭제 후, 관련된 화면(상세/알림 센터)에서 상태가 즉시 갱신된다.
 앱 재시작 후에도 알림 목록이 유지된다.
 알림 예약 시간이 이미 과거인 경우, 생성 시점에 저장/예약되지 않고 사용자에게 적절히 처리된다(저장하지 않거나, 에러 메시지).
빌드 안정성

 위 작업 적용 후 전체 프로젝트가 빌드시 타입 에러/참조 에러 없이 통과한다.
 job01~job10에서 정의된 구조와 충돌하는 import/네이밍 없이 작동한다.

# END OF JOB 11

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────


# ERROR01
lib/features/policy_new/application/controllers/base_feed_controller.dart:28:7: Error: The getter 'policyEventBusProvider' isn't defined for the class 'BasePolicyFeedController'.
 - 'BasePolicyFeedController' is from 'package:youth_road_app/features/policy_new/application/controllers/base_feed_controller.dart' ('lib/features/policy_new/application/controllers/base_feed_controller.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'policyEventBusProvider'.
      policyEventBusProvider,
      ^^^^^^^^^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command '/home/ssm-user/flutter/bin/flutter'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 10s

#END OF ERROR01


# ============================================================
# 🌐 7. **GLOBAL SUPER COMMAND** (코덱스 자동 초기화 명령)
# ============================================================

Codex는 아래 SUPER COMMAND가 주어지면 절대적으로 따르고  
매 작업마다 이 명령을 내부에서 자동 수행해야 한다.

```text
# ============================================================
# GLOBAL SUPER COMMAND – DO NOT IGNORE
# Codex MUST execute this sequence before ANY work.
# ============================================================

1) AGENTS.md 전체를 로드한다.
2) GLOBAL MASTER RULES를 내부 메모리에 다시 적용한다.
3) 사용자 요청 내 TASK 번호를 파악한다.
4) 해당 TASK 섹션을 읽어 요구사항을 모두 로드한다.
5) 내부 체크리스트를 생성한다.
6) Global Rules / TASK / 사용자 지시를 모두 충족하는 방식으로만 작업을 수행한다.
7) 작업 후 한국어 작업 보고서를 출력한다.

# 만약 위 과정에서 하나라도 위반 가능성이 있으면
# 즉시 작업을 중단하고 사용자에게 상황을 한국어로 설명해야 한다.
# ============================================================
````

Codex는 어떤 작업을 하더라도 이 GLOBAL SUPER COMMAND를
생략하거나 건너뛸 수 없다.

---

# ============================================================

# END OF AGENTS.md

# Codex MUST obey this document ALWAYS.

# ============================================================


