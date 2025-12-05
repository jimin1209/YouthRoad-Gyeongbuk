
---

# TASK 03 — 데이터 파이프라인 안정화 · 캐시 일관성 · Provider 상태 검증

---

## 1. 작업 목적

현재 구축된
DTO → Domain → Repository(TTL 캐시) → Provider
흐름이 실제 환경에서 일관성 있게 동작하는지 검증하고,
이상 발생 시 개선하는 것을 목표로 한다.

본 Task는 UI 개발 또는 화면 확장 이전 단계에서 수행된다.

---

## 2. 검증 범위

검증해야 하는 대상 계층은 아래와 같다.

```
RemoteSource
↓
DTO 변환
↓
Domain 생성
↓
Repository (TTL 포함)
↓
LocalCache 저장 및 조회
↓
Providers 상태 업데이트
```

검증은 아래 항목을 기준으로 수행해야 한다.

---

## 3. 검증 항목 상세 명세

---

### 3-1. Domain 데이터 무결성 검증

목표

> Domain은 null·비정상값·raw 값이 포함되지 않아야 한다.

검증 내용

| 항목          | 요구조건                                |
| ----------- | ----------------------------------- |
| Null Safety | Domain에 nullable 필드 존재 금지           |
| 값 정제        | “ ”, "", "-", "N/A" 등 변환 완료된 상태여야 함 |
| enum 여부     | 예상 외 입력은 Default Case 적용            |
| 가공 일관성      | 동일 입력은 동일 Domain으로 변환되어야 함          |

검증 방법
DTO → Domain 변환 후 객체 내부 상태를 로그 출력

예시

```
[DomainCheck] title="청년창업패키지"
[DomainCheck] ageRange={19~34}
```

---

### 3-2. Paging 안정성 검증

검증 항목

#### Case A — 정상 append

조건
pageIndex=1 호출 → 결과 수신
pageIndex=2 호출 → 이전 결과에 append

검증 결과
데이터 길이 정상 증가 여부 확인

---

#### Case B — 마지막 페이지 요청 시 No-Op 처리

조건
마지막 페이지 도달 후 동일 pageIndex 재호출

필수 조건

* fetch 불필요한 재호출 방지
* append 또는 reset 금지
* 동일 데이터 유지

로그 예시

```
[PAGING] lastPageReached=true
[PAGING] NO-OP
```

---

#### Case C — 조건 변경 시 초기화

조건
검색/필터 변경 발생

필수 조건

* pageIndex 1로 초기화
* 기존 리스트 폐기
* 새 데이터 요청

로그 예시

```
[PAGING] filterChanged=true → reset pageIndex=1
```

---

### 3-3. TTL 기반 캐싱 검증

TTL 조건 예시
TTL = 5분

검증 항목

#### Case 1 — TTL 내 접근

필수 조건

* Remote 호출 금지
* LocalCache 즉시 반환

로그 예시

```
[CACHE] HIT:FRESH
```

---

#### Case 2 — TTL 경과

필수 조건

1. stale 데이터 즉시 반환
2. Remote 비동기 fetch 수행
3. Provider는 fresh 데이터로 교체

로그 예시

```
[CACHE] STALE → REFRESH
```

---

#### Case 3 — 캐시 부재

필수 조건

* Remote 즉시 호출

로그 예시

```
[CACHE] MISS → FETCH
```

---

### 3-4. Provider 상태 일관성 검증

검증 항목

| 항목                                | 요구조건                 |
| --------------------------------- | -------------------- |
| 중복 fetch 금지                       | 동일 파라미터 요청 시 한 번만 수행 |
| 화면 이동 시 dispose                   | 기존 Future cancel     |
| 새로고침 시 이전 pending 제거              | cancellation 확인      |
| stale → fresh data 교체 시 화면 깜빡임 없음 | state 변환 일관성         |

필수 로그 예시

```
[ProviderLifecycle] disposed → pending request cancelled
```

---

## 4. 완료 조건

아래 항목을 모두 충족할 경우 Task 완료로 판정한다.

1. Domain이 유효한 값만 포함하는 로그 확인
2. 마지막 페이지에서 append 발생하지 않음
3. 필터 변경 시 데이터 초기화 정상 작동
4. TTL 내 접근 시 remote 호출이 발생하지 않음
5. TTL 경과 시 stale → fresh 업데이트 수행
6. Provider dispose 시 pending async 취소 확인
7. 테스트 케이스 실행 로그 확보

---

## 5. Codex 수행 지침

Codex에게 다음 명령을 수행하도록 지시할 것:

```
아래 상황별로 Repository/Provider 내부에 명시적 로그를 추가하고,
로그를 기반으로 정상 동작 여부를 검증하라.

로그 상태 정의:
1) CACHE-HIT:FRESH
2) CACHE-STALE:REFRESH
3) CACHE-MISS:FETCH
4) PAGING-LAST-PAGE:NO-OP
5) PROVIDER-DISPOSE:CANCELLED
```

로그는 반드시 해당 클래스 내부에서 출력하며
stdout 또는 Logger 기반 출력 방식 모두 허용한다.

---
