# YouthRoad-Gyeongbuk 앱 – Codex 전용 개발 가이드 & Issue 리스트 (1–9)

이 문서는 YouthRoad-Gyeongbuk Flutter 앱의 **기존 구조를 해치지 않고**  
기능을 확장/수정하기 위한 **엄격한 규칙 + 구체 Issue 명세**를 제공합니다.

Codex(또는 자동 에이전트)는 아래 규칙을 **절대적으로 준수**해야 합니다.

---

## 0. 전역 개발 규칙 (MUST)

1. **이슈 순서 엄수**
   - Issue #1 → #2 → #3 → … → #9 순서로만 작업
   - Issue를 건너뛰거나, 여러 Issue를 섞어 작업하지 말 것

2. **파일/구조 변경 제한**
   - 아래 파일/디렉터리는 **절대 수정/삭제/이동 금지**
     - `android/app/build.gradle`
     - `android/unityLibrary/**` 전체
     - `pubspec.yaml` (버전/플러그인 변경, 의존성 추가 금지)
   - Android / Unity / Gradle 설정 리팩토링 금지
   - Flutter / Dart / Kotlin / Gradle 버전 변경 금지

3. **리팩토링 / 구조개편 금지**
   - Issue에서 **명시한 부분 외에**:
     - 클래스/파일 이름 변경 금지
     - 폴더 구조 변경 금지
     - 공통 위젯/테마/라우터/DI 구조 리팩토링 금지
   - “깔끔하게 정리”, “최적화” 등의 이유로 기존 코드 삭제 금지

4. **UI 디자인 변경 금지**
   - 이미 구현된 화면의:
     - 레이아웃 구조
     - 색상 / 폰트 / 여백
   - 은 최대한 그대로 유지.
   - Issue에서 **명확히 요구하는 추가 UI 요소(에러 뷰, 설명 텍스트, 다이얼로그 등)** 만 추가.

5. **상태관리 체계 유지**
   - 기존 Riverpod 기반 구조 유지
   - Provider / Notifier를 새로 설계하지 말고, **기존 구조를 확장하는 방향**으로 구현
   - 다른 상태관리 라이브러리(MobX, Bloc 등) 추가 금지

6. **코드 특성**
   - Null-safe
   - 빌드 가능 (Analyzer 에러/경고 최소화)
   - 기존 기능과 호환 (Backwards compatible)

7. **Mock 데이터 사용 규칙**
   - Issue #1 완료 후:
     - 정책 목록/상세/추천 정책은 **실제 API 없이는 동작하지 않아야 함** (mock만으로 화면 유지 금지)
   - 단, 개발 편의를 위한 mock 소스는 **Flag/주석 기반으로만** 남기고 실제 런타임에는 사용하지 않음.

8. **에러 노출 정책**
   - 사용자 화면에는:
     - “불러오지 못했습니다. 다시 시도해 주세요.” 등 **친절한 메시지 + 재시도 UI** 만 노출
   - HTTP 에러 코드, 스택 트레이스 등은:
     - `debugPrint` 또는 로깅 유틸만 사용 (화면엔 절대 노출 금지)

9. **테스트 & 검증**
   - 각 Issue 작업 후:
     - 관련 화면(홈, 정책 목록 v2, 정책 상세, 카테고리, 기관/부서, 챗봇, 설정)을 실제 단말/에뮬레이터에서 수동 검증
     - Null/빈값/네트워크 에러 등 코너 케이스도 최소 1번씩 확인

---

## 1. 런타임 환경 & 빌드 설정

### 1.1 Flutter 실행 시 필수 `--dart-define`

앱 실행 시 다음과 같이 `--dart-define`을 통해 키를 주입한다.

```bash
flutter run \
  --dart-define=KAKAO_MAP_API_KEY=... \
  --dart-define=CHAT_ENDPOINT=https://worker.youthroad-chat.workers.dev \
  --dart-define=YOUTH_API_KEY=실제승인된키
````

* `KAKAO_MAP_API_KEY`

  * 카카오 지도 연동용 키.
* `CHAT_ENDPOINT`

  * **OpenAI API를 직접 호출하지 않고**,
    백엔드/Cloudflare Worker 등에서 OpenAI API를 호출해주는 **프록시 엔드포인트** URL.
  * Flutter 앱은 이 엔드포인트로만 요청을 보내며, OpenAI API 키는 **프론트에서 직접 다루지 않는다.**
* `YOUTH_API_KEY`

  * 경상북도 청년정책 OpenAPI 인증 키.

#### 규칙

* **새로운 dart-define 이름을 임의로 추가하지 말 것.**
* 정책 API 키는 `YOUTH_API_KEY` 라는 이름으로만 주입된다고 가정한다.
* 앱 내부에서는 `const String.fromEnvironment('YOUTH_API_KEY')` 방식 등으로 접근한다.
* AI 챗봇은 반드시 `CHAT_ENDPOINT`를 통해서만 통신한다.
  (OpenAI API Endpoint/Key를 Flutter 코드에 직접 노출 금지)

---

## 2. YouthRoad OpenAPI 스펙

### 2.1 정책 목록 API

* **URL**

  ```text
  GET https://gbyouth.co.kr/openapi/policy/list.json
  ```

* **요청 파라미터**

| 파라미터명              | 설명         | 타입     | 비고                                                  |
| ------------------ | ---------- | ------ | --------------------------------------------------- |
| `apiKey`           | API 키 (필수) | String | 승인된 API 키. 앱에서는 `YOUTH_API_KEY` dart-define을 사용해 설정 |
| `searchYear`       | 연도         | String | 4자리 연도 (예: `2024`)                                  |
| `searchPolicyNm`   | 정책명        | String | 정책명 LIKE 검색                                         |
| `searchPolicyType` | 정책유형       | String | 콤마(,) 구분 다중 선택. 예: `YTH0040001,YTH0040002`          |
| `searchRgnSe`      | 지역         | String | 콤마(,) 구분 다중 선택. 예: `PLA0020001,PLA0020002`          |
| `instNo`           | 연관기관번호     | String | 기관 목록 API 의 `no`                                    |
| `deptNo`           | 연관부서번호     | String | 부서 목록 API 의 `no` (사용 시 `instNo`와 동시 사용 불가)          |
| `pageIndex`        | 페이지 번호     | Int    | 기본값: 1                                              |
| `recordCount`      | 결과 표출 건수   | Int    | 기본값: 10                                             |
| `pageSize`         | 페이지 수 표출건수 | Int    | 기본값: 10                                             |
| `pagingYn`         | 페이징 여부     | String | `Y`(기본) / `N`(전체)                                   |
| `searchDsplyYn`    | 노출 여부      | String | 기본: `Y` (`all`, `Y`, `N` 사용 가능)                     |

* **정책유형 코드 예시 (`searchPolicyType`)**

  * 일자리(창업): `YTH0040009`
  * 일자리(취업): `YTH0040010`
  * 건강: `YTH0040001`
  * 교육: `YTH0040002`
  * 금융: `YTH0040003`
  * 문화: `YTH0040004`
  * 복지: `YTH0040005`
  * 주거비 지원: `YTH0040006`
  * 주택공급: `YTH0040007`
  * 참여: `YTH0040008`

* **지역 코드 예시 (`searchRgnSe`)**

  * 경상북도(광역): `PLA0010001`
  * 포항시: `PLA0020001`
  * 경주시: `PLA0020002`
  * 김천시: `PLA0020003`
  * 안동시: `PLA0020004`
  * 구미시: `PLA0020005`
  * 영주시: `PLA0020006`
  * 영천시: `PLA0020007`
  * 상주시: `PLA0020008`
  * 문경시: `PLA0020009`
  * 경산시: `PLA0020010`
  * 군위군: `PLA0020011`
  * 의성군: `PLA0020012`
  * 청송군: `PLA0020013`
  * 영양군: `PLA0020014`
  * 영덕군: `PLA0020015`
  * 청도군: `PLA0020016`
  * 고령군: `PLA0020017`
  * 성주군: `PLA0020018`
  * 칠곡군: `PLA0020019`
  * 예천군: `PLA0020020`
  * 봉화군: `PLA0020021`
  * 울진군: `PLA0020022`
  * 울릉군: `PLA0020023`

* **응답(JSON) 구조**

```jsonc
{
  "success": true,
  "msg": "정상조회",
  "resultList": [
    {
      "no": 123,                 // 고유번호
      "policyYr": "2024",        // 연도
      "rgnSeNm": "구미시",       // 지역명
      "policyTypeNm": "취업",    // 정책유형명
      "sprvsnInstNm": "경북일자리재단",  // 주관기관
      "operInstNm": "청년취업팀",       // 운영기관
      "policyNm": "청년 취업 지원",     // 정책명
      "policyBgngYmd": "2024-01-01",   // 운영 시작일
      "policyEndYmd": "2024-12-31",    // 운영 종료일
      "policyScl": "지원규모 텍스트",
      "policyCn": "정책 내용...",
      "policyEnq": "문의처 정보",
      "aplyYn": "Y",                   // 온라인 신청 여부 (Y/N)
      "aplyBgngDt": "2024-01-01",
      "aplyEndDt": "2024-12-31",
      "aplyPsbltyYn": "Y",             // 현재 신청 가능 여부 (Y/N)
      "dtlLinkUrl": "https://...",
      "dsplyYn": "Y",
      "crtDt": "2023-12-01 10:00:00",
      "updtDt": "2024-01-05 12:00:00"
    }
  ],
  "paginationInfo": {
    "currentPageNo": 1,
    "recordCountPerPage": 10,
    "pageSize": 10,
    "totalRecordCount": 123,
    "totalPageCount": 13,
    "firstPageNo": 1,
    "lastPageNo": 13,
    "firstPageNoOnPageList": 1,
    "lastPageNoOnPageList": 10
  }
}
```

> **정책 상세/추천 정책도 별도 API 없이 이 목록 API를 활용하며**,
> 필요 시 `no`(고유번호)를 기준으로 단일 정책을 조회하거나, 지역/카테고리 기준으로 필터링된 목록을 리턴하도록 앱 내에서 가공한다.

---

### 2.2 기관 목록 API

* **URL**

  ```text
  GET https://gbyouth.co.kr/openapi/inst/list.json
  ```

* **요청 파라미터**

| 파라미터명        | 설명        | 타입     | 비고        |
| ------------ | --------- | ------ | --------- |
| `apiKey`     | API 키(필수) | String | 승인된 API 키 |
| `srchInstNm` | 기관명       | String | 키워드 검색용   |

* **응답(JSON) 구조**

```jsonc
{
  "success": true,
  "msg": "정상조회",
  "resultList": [
    {
      "no": 101,                 // 기관 고유번호
      "instNm": "경북청년지원센터",
      "crtDt": "2023-01-01 10:00:00",
      "deptCnt": 3               // 부서 개수
    }
  ]
}
```

---

### 2.3 부서 목록 API

* **URL**

  ```text
  GET https://gbyouth.co.kr/openapi/dept/list.json
  ```

* **요청 파라미터**

| 파라미터명    | 설명        | 타입     | 비고                 |
| -------- | --------- | ------ | ------------------ |
| `apiKey` | API 키(필수) | String | 승인된 API 키          |
| `instNo` | 기관 고유번호   | String | 기관 목록 API 의 `no` 값 |

* **응답(JSON) 구조**

```jsonc
{
  "success": true,
  "msg": "정상조회",
  "resultList": [
    {
      "no": 201,                // 부서 고유번호
      "instNm": "경북청년지원센터",
      "deptNm": "청년정책과",
      "crtDt": "2023-01-01 10:00:00"
    }
  ]
}
```

---

## 3. 도메인 모델 규칙

### 3.1 PolicyModel

* `PolicyModel`(또는 이미 존재하는 정책 도메인 모델)은 **위 정책 목록 API의 `resultList` 구조를 1:1로 커버**해야 한다.
* 각 필드는 **한 번만** 맵핑한다. (중복 필드/alias 금지)
* 예시 필드(실제 필드명은 프로젝트 기준 유지):

```dart
class PolicyModel {
  final int id;                 // no
  final String? year;           // policyYr
  final String? regionName;     // rgnSeNm
  final String? typeName;       // policyTypeNm
  final String? ownerInstName;  // sprvsnInstNm
  final String? operatorInstName; // operInstNm
  final String? name;           // policyNm
  final DateTime? startDate;    // policyBgngYmd
  final DateTime? endDate;      // policyEndYmd
  final String? scale;          // policyScl
  final String? content;        // policyCn
  final String? contact;        // policyEnq
  final bool? onlineApply;      // aplyYn == 'Y'
  final DateTime? applyStart;   // aplyBgngDt
  final DateTime? applyEnd;     // aplyEndDt
  final bool? isApplyNow;       // aplyPsbltyYn == 'Y'
  final String? detailUrl;      // dtlLinkUrl
  final String? displayYn;      // dsplyYn
  final DateTime? createdAt;    // crtDt
  final DateTime? updatedAt;    // updtDt

  // 기타 UI 전용 필드 (D-day, 태그 리스트 등)는
  // API 필드를 가공하여 계산하는 형태로 추가.
}
```

> **중요:**
>
> * 날짜 필드는 파싱 실패에 대비해 `String` → `DateTime?` 변환 시 예외 처리 필수.
> * Null이 가능한 모든 필드는 `?` 로 선언해야 함.

### 3.2 Institution / Department Model

기관/부서 모델도 API 응답 구조를 기준으로 다음과 같이 단순 매핑한다.

```dart
class Institution {
  final int id;            // no
  final String name;       // instNm
  final int? deptCount;    // deptCnt
}

class Department {
  final int id;            // no
  final String institutionName; // instNm
  final String name;       // deptNm
}
```

---

## 4. 상태 저장(SharedPreferences) 규칙

로컬 저장소는 `shared_preferences`(이미 사용 중)를 그대로 활용하며,
아래 **Key 이름을 고정**하고, Codex는 새로운 Key를 함부로 만들지 않는다.

| 기능         | Key 이름                 | 값 타입                     |
| ---------- | ---------------------- | ------------------------ |
| 선택 지역      | `selected_region_code` | String (예: `PLA0020005`) |
| 선택 지역 이름   | `selected_region_name` | String (예: `구미시`)        |
| 즐겨찾기 정책 목록 | `favorite_policy_ids`  | List<int> as JSON        |
| 비교함 정책 목록  | `compare_policy_ids`   | List<int> as JSON        |
| AI 챗 기록    | `chat_history_json`    | String(JSON)             |

> 이미 프로젝트에 사용하는 Key 가 있다면, **새 Key를 만들지 말고 기존 Key를 재사용**해야 한다.
> (단, 이 문서에서는 위 Key 이름을 기준으로 설명한다.)

---

## 5. 라우팅 규칙 (개념적)

GoRouter 기반 라우팅은 이미 구현되어 있으며, 아래 경로 의미를 유지한다.

| 화면       | 예시 Route Path        | 설명                               |
| -------- | -------------------- | -------------------------------- |
| 홈 허브     | `/`                  | 청년 정책 추천 (지역 선택 + 버튼들)           |
| 정책 목록 v2 | `/policy/list/v2`    | 정책 검색/필터/무한스크롤 목록                |
| 정책 상세 v2 | `/policy/detail/:id` | 단일 정책 상세 화면                      |
| 지역 선택    | `/region/select`     | 23개 시·군 + 전체 선택 화면               |
| 카테고리 탐색  | `/category/browse`   | 카테고리별 카드 → 목록으로 이동               |
| 지도 + 리스트 | `/map/list`          | Unity 지도 + 정책 미니 리스트             |
| 기관 목록    | `/inst/list`         | 기관 검색/선택 화면                      |
| 부서 목록    | `/dept/list`         | 선택된 기관의 부서 목록                    |
| 설정       | `/settings`          | 앱 설정(Tab)                        |
| 챗봇       | `/chatbot`           | **AI(OpenAI) 기반 챗봇 + 카카오톡 상담 탭** |

> Codex는 **기존 Route path를 변경하거나 제거하지 않는다.**
> Issue에서 언급하는 기능은 해당 Route 안의 로직만 보완하는 형태로 구현한다.

---

## 6. 공통 UI 규칙 (로딩/에러/빈 상태)

1. **로딩 상태**

   * 정책 목록: 카드 스켈레톤 또는 중앙 로딩 인디케이터
   * 추천 정책: 카드 영역 로딩 인디케이터
   * 챗봇: 메시지 전송 중 “생각 중…” 또는 로딩 인디케이터

2. **빈 상태**

   * 정책 목록: “현재 조건에 맞는 정책이 없습니다.”
   * 챗봇: 초기 진입 시 안내 메시지(예: “경북 청년정책에 대해 궁금한 점을 물어보세요.”)

3. **에러 상태**

   * 정책 관련:

     * “정책을 불러오지 못했습니다. 다시 시도해 주세요.”
   * 챗봇 관련:

     * “응답을 가져오지 못했습니다. 잠시 후 다시 시도해 주세요.”
   * 모두 재시도 버튼 포함.

> 에러/빈/로딩 UI는 가능한 한 **공통 위젯**(예: `ErrorView`, `EmptyView`, `LoadingView`)를 사용해 일관성을 유지한다.
> 이미 정의된 공통 컴포넌트가 있다면 새로 만들지 말고 그것을 재사용한다.

---

# Issue 상세 (1–9)

아래부터는 실제 작업해야 할 Feature/Bugfix Issue들이다.
**반드시 #1부터 순서대로 처리**한다.

---

## Issue 1. 정책 목록/상세를 실제 API와 연동하기

### 설명

현재 정책 목록 v2, 정책 상세, 추천 정책이 **mock 또는 고정 데이터**로만 동작한다.
앱의 핵심은 “실제 정책 정보 제공”이므로, YouthRoad 정책 API와의 실연동이 우선되어야 한다.

### 요구사항

1. **데이터 소스 교체**

   * 정책 목록 v2, 정책 상세, 추천 정책에서 사용하는 데이터 소스를

     * 모두 `https://gbyouth.co.kr/openapi/policy/list.json` 기반 실제 API로 변경한다.
   * 추천 정책/유사 정책도 동일 API를 사용하되,

     * 지역(`searchRgnSe`), 정책유형(`searchPolicyType`) 등 파라미터를 조합하는 방식으로 구현한다.

2. **HTTP 클라이언트 및 DTO 정의**

   * Retrofit 또는 Dio 기반 클라이언트 사용 (이미 사용하는 라이브러리가 있으면 그대로 활용).
   * 2장에 정의한 Policy API 스펙을 기준으로 DTO(응답 모델)을 설계하고,

     * `PolicyModel`로 변환하는 Mapper를 구현한다.

3. **상태 관리 (Riverpod 활용)**

   * 정책 목록 v2, 정책 상세, 추천 정책 각각에 대해:

     * `loading / success / error` 상태를 명확히 구분하는 State 클래스를 사용.
     * 기존 Provider 구조를 유지하고, 내부에서 mock 대신 실제 Repository를 호출하도록 수정.

4. **에러 처리**

   * 네트워크/서버 에러시:

     * UI: “정책을 불러오지 못했습니다. 다시 시도해 주세요.” + 재시도 버튼
     * 내부: HTTP 상태 코드, 메시지, 스택 트레이스를 `debugPrint` 등으로 로깅

5. **Mock 처리**

   * mock 데이터는 필요시 **개발 플래그**로만 사용 가능:

     * 예: `bool useMock = false;` 와 같은 상수/환경 변수를 통해 분기
   * 기본 설정에서는 **실제 API 없이는 화면이 실패해야 한다.**

     * 즉, API 호출이 없는 상태로 정책 목록/상세/추천이 정상 노출되어서는 안 된다.

### 완료 기준 (Acceptance Criteria)

* [ ] **정책 목록 v2 진입 시**, 서버에서 받아온 정책 리스트가 최소 1개 이상 정상 노출된다.
* [ ] **정책 카드 탭 시**, 해당 정책의 상세 정보가 API 응답 기준(`policyCn`, `policyBgngYmd`, `policyEndYmd` 등)으로 표시된다.
* [ ] 네트워크 끊김/서버 에러 발생 시,
  “정책을 불러오지 못했습니다. 다시 시도해 주세요.” 메시지 + 재시도 버튼이 보인다.
* [ ] 콘솔/로그에서는 실제 HTTP 에러 내용 확인 가능하지만, 화면에는 노출되지 않는다.
* [ ] mock 데이터만으로는 더 이상 화면이 동작하지 않고, 실제 API가 없으면 실패 상태로 간주된다.

---

## Issue 2. 추천 정책 – 지역 변경 시 LateInitializationError 및 재로딩 버그

### 설명

홈 화면에서 지역을 선택한 뒤 추천 정책이 보이다가,
지역을 다시 선택하면 다음 에러가 발생한다.

```text
LateInitializationError: Field '_repo@...' has already been initialized
```

그 이후 추천 정책 로딩이 실패한다.

### 요구사항

1. **late 변수 구조 개선**

   * 추천 정책에서 사용하는 Repository/Client/Service 필드(`late final _repo`) 등이

     * 여러 번 초기화되지 않도록 구조를 수정한다.
   * 예: Provider 내부에서 `ref.read(...)`로 의존성을 주입하고,

     * 클래스 생성자에서 한 번만 할당되도록 한다.

2. **지역 변경 시 상태 초기화**

   * 지역 선택(예: `selected_region_code` 변경) 시:

     * 추천 정책 Provider/state를 **안전하게 초기화**하고,
     * 새로운 지역 정보를 기준으로 다시 fetch 한다.
   * A → B → C로 빠르게 바꾸더라도,

     * 마지막 선택 지역 기준으로만 call 되도록 처리한다.

3. **에러 노출 방식**

   * LateInitializationError, HTTP 에러 등 내부 에러는:

     * 화면에 노출하지 않고 공통 에러 뷰/토스트만 노출.
   * 필요하다면 홈 화면 추천 영역에:

     * “추천 정책을 불러오지 못했습니다. 다시 시도해 주세요.” + 재시도 버튼 제공.

### 완료 기준

* [ ] 지역을 A → B → C로 연속 변경해도 추천 정책이 정상적으로 갱신된다.
* [ ] 더 이상 `LateInitializationError`가 발생하지 않는다.
* [ ] 에러 상황을 인위적으로 발생시켜도 화면에는 사용자 친화적인 메시지만 노출되고, 내부 로그에만 스택트레이스가 남는다.

---

## Issue 3. 좋아요(즐겨찾기) 및 정책 비교 기능 구현

### 설명

정책 카드에 ❤️(좋아요)와 ⚖(비교) 아이콘이 노출되지만,
현재는 실제 기능이 없고, 좋아요 모음/비교 화면도 없다.

### 요구사항

1. **즐겨찾기 토글**

   * 정책 카드, 정책 상세 상단의 ❤️ 버튼 탭 시:

     * 해당 정책을 즐겨찾기 목록에 추가/제거.
   * 상태는 Riverpod 기반으로 관리하고,

     * SharedPreferences `favorite_policy_ids` 에 **정책 고유번호(no)** 목록을 JSON 으로 저장.
   * 앱 재시작 후에도 즐겨찾기 상태가 유지되어야 한다.

2. **좋아요 모음 화면**

   * “좋아요 모음” 화면을 추가 (경로/위치는 기존 디자인에 맞게).
   * `favorite_policy_ids`에 저장된 정책만 정책 목록 카드 형태로 리스트업.

3. **비교 목록 관리**

   * ⚖ 아이콘 탭 시:

     * 비교 목록에 추가/해제.
   * 비교 목록은 SharedPreferences `compare_policy_ids` 에 int 리스트로 저장.
   * **최대 2개** 까지만 선택 가능:

     * 3개째를 추가하려 할 경우, 기존 정책 중 하나를 제거하거나,
       안내 메시지를 통해 제한을 알려준다.

4. **정책 비교 화면**

   * 비교할 정책이 정확히 2개 이상일 때 진입하는 “정책 비교 화면” 구현.
   * 최소한 아래 항목을 나란히 비교:

     * 정책명
     * 주관기관
     * 지역
     * 연령/대상 (API에 직접 항목이 없으면, 현재 표시 중인 기준에 맞게)
     * 신청기간
     * 신청 가능 여부(D-day 포함)

5. **일관성**

   * 즐겨찾기/비교 상태는:

     * 홈 추천 카드, 정책 목록 v2 카드, 정책 상세 화면 어디에서든 **동일하게 표시**되어야 한다.
   * 즉, 한 화면에서 ❤️/⚖ 상태를 바꾸면 다른 화면에서도 즉시 반영.

### 완료 기준

* [ ] 어떤 정책 카드에서든 ❤️ 탭 시 즐겨찾기 상태가 즉시 반영되고, 앱 재시작 후에도 유지된다.
* [ ] “좋아요 모음” 화면에서 즐겨찾기한 정책 목록만 확인할 수 있다.
* [ ] ⚖ 버튼으로 정책을 선택하고, 비교 화면에서 두 정책의 주요 항목이 나란히 비교된다.
* [ ] 즐겨찾기/비교 상태는 동일 정책 카드가 나타나는 모든 화면에서 일관되게 유지된다.

---

## Issue 4. 카테고리별 탐색 기능 활성화

### 설명

카테고리별 탐색 화면이 존재하지만, 현재는 데모 수준으로만 동작하며
실제 필터링/탐색 기능이 없다.

### 요구사항

1. **카테고리 카드 → 정책 목록 연동**

   * 카테고리별 탐색 화면에서 “창업”, “주거”, “취업” 등 카드 탭 시:

     * 정책 목록 v2 화면으로 이동하면서 선택된 카테고리 정보를 함께 전달한다.
     * 예: `searchPolicyType` 파라미터에 해당 카테고리의 코드(`YTH0040002` 등)를 세팅.

2. **정책 목록 v2의 카테고리 필터**

   * 정책 목록 v2에서:

     * 초기 진입 시 전달받은 카테고리 필터가 있으면 API 파라미터에 반영.
     * 상단에 현재 적용된 카테고리를 태그/칩 형태로 노출.
   * 카테고리 칩을 탭하면:

     * 필터 해제 → 전체 정책 목록 재조회.

3. **카테고리 코드 매핑**

   * 카테고리 UI 라벨과 `searchPolicyType` 값 간 매핑을 명확하게 유지.
   * 예:

     * “건강” → `YTH0040001`
     * “교육” → `YTH0040002`
     * “금융” → `YTH0040003`
     * “문화” → `YTH0040004`
     * “복지” → `YTH0040005`
     * “주거비 지원” → `YTH0040006`
     * “주택공급” → `YTH0040007`
     * “참여/네트워크” → `YTH0040008`
     * “일자리(창업)” → `YTH0040009`
     * “일자리(취업)” → `YTH0040010`

### 완료 기준

* [ ] 카테고리별 탐색에서 특정 카테고리를 선택하면, 해당 카테고리 정책만 나오는 목록 화면으로 이동한다.
* [ ] 상단 카테고리 필터를 제거하면 전체 정책 목록으로 되돌아간다.
* [ ] 실제 API 응답 기준으로 카테고리 데이터가 반영된다.

---

## Issue 5. 챗봇 탭 Riverpod assertion 에러 및 OpenAI 기반 AI 챗봇 + 카카오톡 상담 연동

### 설명

챗봇 탭은 **OpenAI API를 직접 호출하는 것이 아니라**,
`--dart-define=CHAT_ENDPOINT=...` 로 주입된 **백엔드 프록시(예: Cloudflare Worker)** 를 통해
OpenAI API를 사용하는 **AI 챗봇** 화면이다.

현재 문제:

1. 챗봇 탭 진입 시 Riverpod assertion 에러:

   ```text
   ref.listen can only be used within the build method of a ConsumerWidget
   ```

   로 인해 붉은 에러 화면이 뜨는 문제가 있다.

2. 카카오톡 상담 버튼은 **청년 정책 관련 1:1 / 오픈채팅 상담**을 위한 버튼인데,
   현재 아무 동작도 하지 않는다.

3. AI 챗봇 응답 실패 시:

   * 붉은 에러 화면 또는 아무 반응이 없는 상태가 발생할 수 있다.

챗봇 탭에서 사용자는:

* **AI(OpenAI) 기반 챗봇**과 자연어로 Q&A를 할 수 있어야 하며,
* 필요 시 **카카오톡 상담 버튼**을 눌러 실제 상담 채널로 바로 이동할 수 있어야 한다.

### 요구사항

1. **ref.listen 사용 위치 / 방식 수정 (Riverpod Assertion 해결)**

   * 현재 `ref.listen` 이 `build` 외부 혹은 올바르지 않은 위치에서 호출되고 있어 assertion 이 발생하고 있다.
   * 수정 방향:

     * `ConsumerWidget` / `ConsumerStatefulWidget` 의 `build` 안에서 `ref.listen` 을 호출하거나,
     * `ref.listenManual` 를 사용하고, `ref.onDispose` 또는 State의 `dispose` 에서 정리하는 패턴으로 변경.
   * 목표:

     * 챗봇 탭 진입/이동/재빌드 시 Riverpod assertion 이 더 이상 발생하지 않도록 한다.

2. **AI 챗봇 – OpenAI 프록시 엔드포인트 사용 규칙**

   * Flutter 앱은 **직접 OpenAI API를 호출하지 않는다.**

   * 반드시 `CHAT_ENDPOINT` (dart-define 로 주입된 URL) 로만 HTTP 요청을 보낸다.

   * 요청 형태 예시 (개념적):

     ```http
     POST {CHAT_ENDPOINT}
     Content-Type: application/json

     {
       "message": "사용자의 질문 내용",
       "context": {
         "regionCode": "PLA0020005",
         "regionName": "구미시"
       }
     }
     ```

   * 응답 예시 (개념적):

     ```jsonc
     {
       "success": true,
       "reply": "AI가 생성한 응답 텍스트",
       "meta": {
         "model": "gpt-4.1-mini",
         "tokens": 123
       }
     }
     ```

   * 실제 필드명/구조는 백엔드 구현에 맞추되,

     * Flutter 쪽에서는 `success` 여부와 `reply`(본문 텍스트)만 사용해 UI를 그릴 수 있도록 한다.

3. **챗봇 상태 관리 (Riverpod)**

   * 챗봇 탭에서는 아래와 같은 상태를 관리할 수 있어야 한다:

     * 메시지 리스트 (사용자/AI)
     * 현재 전송 중 여부 (`isSending`)
     * 마지막 에러 상태 (`errorMessage` 혹은 `hasError`)
   * Riverpod Notifier/Provider를 사용해 상태를 관리하고,

     * `ref.listen` 또는 `ref.watch`로 UI 갱신을 처리한다.
   * 메시지 전송 프로세스:

     1. 사용자가 입력 후 전송 버튼 탭.
     2. 사용자 메시지를 리스트에 추가.
     3. `CHAT_ENDPOINT`로 비동기 HTTP 요청.
     4. 로딩 동안 “생각 중…” 등의 로딩 UI 노출.
     5. 성공 시 → AI 응답 메시지를 리스트에 추가.
     6. 실패 시 → 에러 상태 업데이트 + 에러 안내 메시지 노출.

4. **에러/타임아웃 처리 – 사용자 UX**

   * AI 응답 실패(네트워크 오류, 백엔드 에러, 타임아웃 등) 시,

     * 붉은 에러 화면(Flutter Error Widget)을 띄우지 말 것.
     * 아래와 같이 처리:

       * 채팅 영역 상단 또는 메시지 영역에:

         * “응답을 가져오지 못했습니다. 잠시 후 다시 시도해 주세요.” 등의 사용자 친화적 안내 문구.
       * 재시도 버튼:

         * 마지막 사용자 메시지를 기준으로 다시 요청을 보낼 수 있도록 구현해도 좋다.
   * 내부적으로는:

     * `debugPrint` 등을 통해 스택 트레이스 / HTTP 상태 코드 기록.

5. **챗 기록 저장/초기화 연동 (선택적 활용)**

   * `chat_history_json` SharedPreferences Key를 사용해:

     * 최근 대화 일부를 로컬에 저장해둘 수 있다.
   * 설정 화면의 “AI 챗 기록 초기화” 기능과 자연스럽게 연동되도록,

     * 저장 형식을 일관되게 유지한다. (Issue 9와 연결)

6. **카카오톡 상담 버튼 연동**

   * 챗봇 탭에는 “카카오톡 상담” 버튼이 존재한다.

   * 이 버튼은 **실제 청년정책 상담용 카카오톡 채널/오픈채팅 URL**을 연동해야 한다.

   * 구현 방식:

     * `url_launcher` 패키지를 사용해 URL을 오픈.
     * 우선 카카오톡 앱을 열 수 있으면 앱으로 연동,
     * 그렇지 않으면 브라우저에서 해당 URL을 연다.

   * 예시 코드 (개념):

     ```dart
     Future<void> openKakaoChat() async {
       final url = Uri.parse('https://open.kakao.com/o/xxxxxxx'); // 실제 오픈채팅/채널 URL
       if (await canLaunchUrl(url)) {
         await launchUrl(url, mode: LaunchMode.externalApplication);
       } else {
         await launchUrl(url, mode: LaunchMode.inAppBrowserView);
       }
     }
     ```

   * URL 문자열은 상수/환경파일 등에서 관리하여,

     * 코드 내에서 하드코딩하더라도 한 군데만 수정하면 되도록 한다.

7. **초기 진입 UX**

   * 챗봇 탭 첫 진입 시:

     * 기본 안내 메시지를 노출:

       * 예: “경북 청년정책에 대해 궁금한 점을 물어보세요.”
       * 예: “AI 챗봇이 경북 청년정책 정보를 도와드리고, 필요하면 카카오톡 상담으로 연결해 드려요.”
   * 이전 대화가 있다면:

     * 필요에 따라 `chat_history_json`에서 복원해 보여줄 수 있다. (선택 사항)

### 완료 기준

* [ ] 챗봇 탭을 열었을 때 더 이상 Riverpod `ref.listen` assertion 에러가 발생하지 않는다.
* [ ] AI 챗봇은 `CHAT_ENDPOINT`를 통해 백엔드(OpenAI 프록시)와 통신하며, 사용자 메시지에 대한 AI 응답이 정상 표시된다.
* [ ] 네트워크 에러/프록시 에러/타임아웃 시 붉은 에러 화면 대신,
  “응답을 가져오지 못했습니다. 잠시 후 다시 시도해 주세요.” 등의 안내 문구 + 재시도 동작이 보인다.
* [ ] 카카오톡 상담 버튼 클릭 시 실제 카카오톡(또는 웹)이 열려 상담 채널로 이동한다.
* [ ] OpenAI API 키/엔드포인트는 Flutter 코드에 직접 노출되지 않고, 오직 `CHAT_ENDPOINT` 프록시를 통해서만 사용된다.

---

## Issue 6. 정책 목록 v2 – 초기 로딩/빈 상태/에러 상태 처리

### 설명

정책 목록 v2 첫 진입 시 정책 카드가 보이지 않고
‘더 불러오기’ 버튼만 노출되는 경우가 있어,
사용자가 현재 상황(로딩/빈/실패)을 구분하기 어렵다.

### 요구사항

1. **초기 진입 시 자동 로딩**

   * 정책 목록 v2에 진입하면:

     * 첫 페이지(예: pageIndex=1)는 자동으로 요청한다.
   * 사용자가 별도로 “더 불러오기”를 누르지 않아도 최소 1페이지는 조회되어야 한다.

2. **상태별 UI 분리**

   * **로딩 상태**: 상단 또는 전체에 로딩 인디케이터/스켈레톤 표시.
   * **빈 상태**: “현재 조건에 맞는 정책이 없습니다.” 메시지와 함께 빈 상태 UI.
   * **에러 상태**: “정책을 불러오지 못했습니다. 다시 시도해 주세요.” 메시지 + 재시도 버튼.

3. **더 불러오기 버튼 표시 조건**

   * 실제 정책 수가 0건일 때:

     * “더 불러오기” 버튼은 숨긴다.
   * 더 이상 다음 페이지가 없을 경우:

     * “더 불러오기” 버튼 비활성화 또는 숨김.

### 완료 기준

* [ ] 정책이 존재할 때: 화면 진입 후 짧은 로딩 뒤 정책 카드가 최소 1개 이상 보인다.
* [ ] 정책이 0건일 때: “표시할 정책이 없습니다” 메시지가 보이고, ‘더 불러오기’ 버튼은 보이지 않는다.
* [ ] 네트워크 에러 시: 에러 메시지 + 재시도 버튼이 나타나며, 재시도 시 정상 로딩 가능하다.

---

## Issue 7. 화면 타이틀/버전/DEBUG 문구 정리 (사용자용 텍스트 정제)

### 설명

현재 화면 이름에 “v2”, “p7”, “webview” 등의 개발용 문구가 포함되고,
설정 화면에는 “1.0.0 (mock)” 및 우측 상단 DEBUG 리본이 노출된다.

### 요구사항

1. **AppBar 타이틀 정리**

   * 모든 화면의 타이틀에서 버전/페이지 번호/기술 용어 제거:

     * “정책 목록 v2” → “정책 목록”
     * “정책 상세 p7” → “정책 상세”
     * “정책 상세 webview” → “정책 상세”
   * 기타 화면도 동일 원칙 적용 (카테고리, 기관 목록 등).

2. **버전 표기 정리**

   * 설정 화면 “앱 버전”에:

     * “1.0.0 (mock)”이 아닌 “1.0.0” 형태로만 노출.

3. **DEBUG 리본 표시 조건**

   * `kDebugMode` 등을 활용하여:

     * Debug 빌드에서만 DEBUG 리본이 보이도록 처리.
   * Release 빌드에서는 어떠한 DEBUG/SANDBOX 문구도 보이지 않도록 한다.

### 완료 기준

* [ ] 모든 화면의 AppBar 타이틀이 사용자 친화적인 이름으로 정리된다.
* [ ] 설정 화면 버전에는 “1.0.0” 등 버전만 노출되고, “mock” 문구가 없다.
* [ ] Release 빌드에서 DEBUG 리본이 노출되지 않는다.

---

## Issue 8. ‘정보 없음’ 과다 노출 정리

### 설명

정책 상세 화면에서 다수의 항목이 “정보 없음”으로 채워져 있어
시각적 피로도가 높고 정책 신뢰도가 떨어져 보인다.

### 요구사항

1. **비핵심 항목 숨김**

   * 필요 서류, 문의처 등 **핵심이 아닌 필드**의 값이 없으면:

     * 해당 행(아이콘+레이블+값)을 **아예 숨긴다.**
   * 즉, “정보 없음”이라는 문구를 보이지 않게 한다.

2. **행동 안내 문구로 대체**

   * 꼭 보여야 하는데 값이 없는 항목(예: 문의처, 신청 기간 등)은:

     * “기관 문의 필요” 등 사용자 행동을 안내하는 문구로 대체.

3. **리스트/카드에서의 처리**

   * 카드/리스트에서도 반복되는 “정보 없음” 출력 최소화:

     * 예: 문의처가 없으면 해당 줄을 숨기거나, 아이콘만으로 요약.

### 완료 기준

* [ ] 정책 상세 화면을 스크롤해도 “정보 없음” 문구가 거의 보이지 않는다.
* [ ] 값이 없는 항목은 화면에 아예 나타나지 않거나, “기관 문의 필요” 등의 의미 있는 안내로 대체된다.

---

## Issue 9. 설정 화면 초기화 기능의 안내/안전장치 추가

### 설명

설정 화면에 “AI 챗 기록 초기화”, “저장된 지역 초기화”, “저장소 전체 초기화”가 있으나,
설명/경고가 부족해 사용자가 잘못 눌러도 인지하기 어렵다.

### 요구사항

1. **각 초기화 메뉴 설명 추가**

   * 각 항목 아래에 짧은 설명 텍스트를 추가:

     * AI 챗 기록 초기화
       → “지금까지의 AI 챗 대화 기록이 모두 삭제됩니다.”
     * 저장된 지역 초기화
       → “선택해 둔 거주/관심 지역 설정이 초기화됩니다.”
     * 저장소 전체 초기화
       → “앱에 저장된 모든 설정과 기록이 삭제됩니다.”

2. **저장소 전체 초기화 확인 다이얼로그**

   * “저장소 전체 초기화” 선택 시:

     * **반드시 확인 다이얼로그**를 띄운다.
     * 예시 문구:

       * 제목: “정말 모든 데이터를 초기화하시겠습니까?”
       * 내용: “즐겨찾기, 비교함, 지역 설정, 챗봇 기록 등 앱에 저장된 모든 데이터가 삭제됩니다.”
   * 버튼:

     * 취소: “취소”
     * 확인: “모두 삭제”

3. **취소/확인 동작**

   * 취소 선택 시:

     * 어떠한 데이터도 변경되지 않아야 한다.
   * 확인 선택 시:

     * SharedPreferences에 저장된 YouthRoad 관련 Key 전체 삭제.

### 완료 기준

* [ ] 각 초기화 메뉴 아래에 설명 문구가 보인다.
* [ ] “저장소 전체 초기화” 클릭 시 확인 다이얼로그가 등장하고, 사용자가 취소하면 아무 변경이 일어나지 않는다.
* [ ] 실수로 초기화를 누를 위험이 기존보다 명확히 줄어든다.

---

이 문서에 명시되지 않은 리팩토링/구조 변경/플러그인 추가는 **절대 수행하지 말 것.**
각 Issue를 순서대로, 최소한의 변경으로 구현한다.

```
```
