아래는 지금까지 논의된 요구사항을 모두 반영한
**최종 명세(Task Final Version)**입니다.
이 문서는 Codex가 그대로 수행해도 오류 없이 작업 가능하도록 작성되어 있습니다.

---

---

# TASK 401 — 청년 API DTO 생성 (Final Version)

---

## 1. 목적

다음 3종 API 응답(JSON)을 기반으로
Flutter 환경에서 사용할 DTO(Data Transfer Object)를 생성한다.

* 청년정책 API
* 청년콘텐츠 API
* 청년센터 API

DTO는 외부 응답 데이터를 원본 그대로 보존하는 역할을 수행하며
추후 Domain 변환, Repository 구축, 캐싱 구조 설계의 기반이 된다.

---

## 2. 참고 대상 파일 (Contract Source)

```
docs/청년정책API.json
docs/청년콘텐츠API.json
docs/청년센터API.json
```

해당 JSON 구조는 변경할 수 없다.
필드 누락, 타입 변경, 재해석, 키명 변경 모두 금지한다.

---

## 3. 산출물

아래 3개 DTO 파일을 생성한다.

```
lib/features/policy_new/data/dto/policy_youthcenter_dto.dart
lib/features/policy_new/data/dto/content_youthcenter_dto.dart
lib/features/policy_new/data/dto/center_youthcenter_dto.dart
```

조건:

* 각 파일은 전체 코드 단위 생성
* 부분 코드 제공 금지
* Freezed 기반 정의 필수
* toJson/fromJson 생성 가능 상태 유지
* 필요한 DTO가 다수일 경우 동일 파일 내부에서 정의 가능

---

## 4. 구현 표준

### 4-1 필수 import

```
import 'package:freezed_annotation/freezed_annotation.dart';
```

### 4-2 part directive

```
part '<파일명>.freezed.dart';
part '<파일명>.g.dart';
```

### 4-3 생성 함수

```
factory XxxDto.fromJson(Map<String, dynamic> json) =>
  _$XxxDtoFromJson(json);

Map<String, dynamic> toJson() => _$XxxDtoToJson(this);
```

### 4-4 Naming 규칙

| JSON Key   | DTO Field         |
| ---------- | ----------------- |
| snake_case | lowerCamelCase 변환 |
| PascalCase | lowerCamelCase    |
| mixedCase  | 동일 유지             |

예:

```
"polyBizSjnm" → polyBizSjnm
"total_count" → totalCount
```

키명 변경 금지.

### 4-5 Nullable 처리

모든 필드는 nullable 로 선언한다.

예:

```
final String? polyBizSjnm;
final int? totalCount;
final List<ItemDto>? data;
```

### 4-6 List 구조

JSON 배열은 반드시 DTO 기반 리스트로 정의해야 한다.

예:

```
final List<ContentItemDto>? results;
```

Map<String, dynamic> 형태 저장 금지
dynamic 타입 사용 금지

---

## 5. Validation Rules (검증 기준)

DTO 변환 후 다음 검증이 통과해야 한다.

### Case 1

필드가 모두 존재하는 JSON → 정상 변환 되어야 함

### Case 2

일부 필드 누락 → Null 값으로 받아야 함

### Case 3

빈 배열 → 빈 리스트로 처리 가능해야 함

### Case 4

문자 `"123"` 은 반드시 String으로 유지해야 함
(int 로 변환 시 오류)

### Case 5

toJson 수행 시 필드 손실 없어야 한다

아래 코드는 그대로 round trip 되어야 한다.

```
final dto = XxxDto.fromJson(jsonMap);
final back = dto.toJson();
```

back 내용은 jsonMap과 key 단위로 일치해야 한다.

---

## 6. 변경 금지 범위

아래 항목이 발생하면 즉시 실패 처리한다.

* JSON key명 변경
* DTO에서 필드 삭제
* 타입 임의 추정 및 캐스팅
* required 키워드 사용
* dynamic 사용
* Map<String, dynamic> raw data 저장
* Freezed 미사용
* 조각 코드 제출

---

## 7. Version Marker 기록 (필수)

각 DTO 파일 상단에 다음 정보를 주석으로 남긴다.

```
SOURCE: docs/청년정책API.json (또는 해당 파일명)
GENERATED_AT: YYYY-MM-DD
API_SN: (정책=86, 콘텐츠=20, 센터=10001)
PURPOSE: External data preservation (contract level)
```

이 기록은 추후 API 변경 시 근거 자료가 된다.

---

## 8. 후속 영향 명시

DTO는 다음 Task의 기반이므로 구조 변경 금지.

| 후속 Task  | 영향                   |
| -------- | -------------------- |
| Task 402 | DTO → Domain 변환      |
| Task 403 | Remote Repository 구성 |
| Task 404 | 캐싱 구조 정의             |
| Task 405 | Provider 계층 설계       |

DTO 정의 변경 시 전체 로직 영향 가능
따라서 JSON을 기준으로 DTO를 고정한다.

---

## 9. 작업 완료 조건

아래 항목을 모두 충족하면 Task 401 완료로 간주한다.

1. DTO 파일 3개 생성 완료
2. Freezed + serialization 정상 동작
3. JSON 필드와 DTO 구조 1:1 대응 검증
4. round-trip 변환 성공
5. Version Marker 포함

---

---

이 문서가 Task 401의 최종 공식 명세입니다.
이제 Codex에 본 명세를 그대로 전달하면 작업을 안전하게 수행할 수 있습니다.
