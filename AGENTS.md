
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

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────





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


