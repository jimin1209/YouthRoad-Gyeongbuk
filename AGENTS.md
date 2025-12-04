
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
💙💙💙💙💙💙💙💙💙💙💙💙💙
💙💙💙❤️❤️❤️💙💙💙💙💙💙🩵

# TASK 400

---


TASK 400 — 정책 비교 탭 고도화 (Ultimate Specification)

## 1. 목표

현재 비교탭은 즐겨찾기 수준에 머물러 사용성이 매우 낮음.
이 기능을 YouthRoad의 **핵심 가치 기능**으로 만들기 위해,
“정책 간의 정량/정성 요소를 한눈에 비교할 수 있는 고급 비교 엔진 + UI” 구조로 재구축한다.

---

## 2. 핵심 컨셉

### **🔑 Concept: Multi-Layer Policy Comparison Engine**

단순히 표로 비교하는 것이 아니라,

* **정책 데이터 정규화(PolicyCompareModel)**
* **정량 지표 정렬(지원금, 경쟁률 등)**
* **정성 지표 요약(지원대상 등)**
* **우수 정책 하이라이트 추천(Compare Scoring Engine)**
* **AI 요약 분석(선택)**

까지 지원하는 “비교 엔진” 구조로 설계한다.

---

## 3. 구조 개편 요소

### 3-1. 정책 비교용 전용 데이터 모델 신설

```
class PolicyCompareModel {
  final String id;
  final String name;
  final String region;
  final String category;
  final int? fundAmount; 
  final String beneficiary; 
  final DateTime startDate;
  final DateTime endDate;
  final String organization;
  final String department;
  final String contact;
  final String applyUrl;
  final String summary; // 핵심 요약 (정성 정보)
  final List<String> tags;
}
```

※ 기존 정책 모델과 별개로, **비교 전용 모델을 만듦**
→ 통일된 비교 테이블 구성 가능
→ null-safe / 정렬-safe

---

## 4. 기능 상세

---

## 4-1. 비교 후보 리스트(즐겨찾기 기반)

* 즐겨찾기(하트)는 자동으로 비교 후보에 쌓임
* 최대 후보 개수: 50
* 비교 개수 제한: 2~4개
* 검색/필터로 즐겨찾기 목록에서 특정 정책만 추리기 가능

  * 지역
  * 카테고리
  * 접수 상태(모집중/마감/예정)
  * 지원금 많은 순
  * 마감 임박 순

---

## 4-2. 비교 대상 선택 UI

* 카드 우측에 “비교 선택 체크박스”
* 선택한 정책 수에 따라 하단에 Dynamic Bottom Bar 생성:

```
[정책 2개 선택됨]   [비교하기 ▶]
```

* 선택 시, 상단에 “X개 선택됨” badge 나타남
* 비교 대상 해제 시 애니메이션으로 자연스러운 이동

---

## 4-3. 비교 결과 화면(핵심)

### **📌 iPad/PC처럼 ‘정책 비교표’를 모바일에서도 구현**

* 좌우 스크롤 테이블
* 첫 번째 열은 고정(sticky)
* 각 정책은 하나의 열(Column)

### 비교 항목

| 구분    | 설명                  |
| ----- | ------------------- |
| 정책명   | 열 상단에 고정 + 상세 이동 버튼 |
| 지역    | geyeongbuk 등        |
| 카테고리  | 청년/창업/주거 등          |
| 지원 규모 | 숫자 정규화(만원/천원 단위)    |
| 지원 대상 | 1~2줄 요약 처리          |
| 접수 기간 | 시작~마감 + 남은 D-Day    |
| 신청 방법 | 온라인/오프라인            |
| 담당 부서 | 담당자 정보              |
| 문의처   | 전화/링크               |
| 태그    | 정책 성격 요약            |
| 비고    | 주의사항                |

---

## 4-4. 하이라이트 기능(차별화 포인트)

정책 간의 차이가 큰 항목은 자동으로 강조:

* 지원금 가장 높은 정책 → 파란색 강조
* 마감일 가장 가까운 정책 → 빨간 강조
* 지원 범위가 가장 넓은 정책 → 표시
* 지역·대상 조건이 ‘지민님에게 더 적합’한 정책 → 추천 표시(선택)

이것이 **YouthRoad 비교 기능의 차별점**이 됨.

---

## 4-5. 스코어링 기반 "최적 정책 추천"

### Compare Scoring Engine 구동

각 정책에 대해:

* 지원금 가중치
* 마감 D-Day 가중치
* 사용자 지역/나이/조건 일치도
* 태그 일치도
* 지원대상 조건 매칭률

을 기반으로 0~100 점수 생성.

### 비교 화면 상단에:

```
🔥 추천 정책: '2025 청년예비창업가 육성사업' (점수 92)
→ 지민님 조건에 가장 잘 맞는 정책입니다.
```

지민님 전용 “맞춤 추천”이 가능.

---

## 4-6. 비교 화면 내 분석 기능(옵션)

* “AI로 비교 요약 보기” 버튼
* 예시 (자동 생성 요약):

```
이 3개의 정책 중 ‘경북예비창업가 육성사업’은 지원금이 가장 높고,
‘청년 구직자 응시료 지원사업’은 마감까지 남은 기간이 가장 깁니다.
지민님 연령대 기준으로는 2번째 정책이 가장 적합합니다.
```

이 부분은 나중에 AI 온 기능과 통합 가능 🩵

---

## 4-7. UI/UX 고급 개선

* 테이블 행 클릭 시, 해당 항목 설명 팝업
* 지원대상이나 비고 같은 긴 텍스트는
  → 2줄 표시 후 “자세히 보기” 팝업
* 비교 결과 화면 상단 고정 메뉴:

  * 비교 정책 갯수 표시(예: "3개 비교 중")
  * 비교 대상 교체 버튼
  * 즐겨찾기 해제 바로 가능
* 정책 상세로 이동 시, 비교 대상 상태 유지

---

## 4-8. 공유/내보내기 기능(선택)

* "비교 결과 스크린샷 자동 캡처"
* "링크/텍스트 복사"
* PDF 형태로 내보내기(선택)

---

## 5. 아키텍처 구조

### New Providers

* `compareFavoritesProvider`
* `compareSelectionProvider`
* `compareTableProvider` (정규화된 PolicyCompareModel 리스트 반환)
* `compareScoreProvider` (스코어링 엔진)

### New Repository

* `PolicyCompareRepository`
  → 원본 정책 → PolicyCompareModel 변환

---

## 6. QA 체크리스트

* [ ] 즐겨찾기한 정책이 비교 후보에 즉시 반영되는가
* [ ] 2~4개 선택에서만 비교 가능
* [ ] Sticky column이 자연스럽게 작동
* [ ] 정렬 기준 변경 시 UI 반영
* [ ] 스코어링이 정책 값에 따라 정상적으로 변함
* [ ] AI 요약 버튼이 작동(선택)
* [ ] 링크/상세 이동 정상
* [ ] 큰 텍스트 팝업 정상

---

## 7. 기대 효과

* 단순 즐겨찾기 → **진짜 "정책 판단 도구"**로 업그레이드
* 정책 추천/비교를 YouthRoad만이 제공하는 핵심 기능으로 고도화
* 사용자 이탈률 감소, 재사용성 증가
* 정책 분석 서비스로 확장 가능성 확보

```
---

---

# 📌 TASK 309 — 정책 필터 BottomSheet 리디자인 + 선택 UX 강화

````md
# TASK 309
## 정책 필터 BottomSheet 리디자인 + 선택 UX 강화
### Status: OPEN
### Owner: UI/UX Layer

---

## 1. 목적

- 기존 정책 필터 BottomSheet UI를
  - **보기 편하고**
  - **선택 상태가 한눈에 보이고**
  - **실수 없이 초기화/적용할 수 있는 구조**로 리디자인한다.
- TASK 300(디자인 시스템) / TASK 301(Theme) / TASK 302(컴포넌트) / TASK 306(Motion)과
  **완전히 일관된 스타일**을 유지한다.

---

## 2. UX 핵심 컨셉

1. **상단 “선택된 필터 요약(Pill)” 영역**  
   - 지금 어떤 필터가 적용 중인지 한 줄로 요약  
   - 각 Pill은 개별 삭제 가능 (X 버튼)

2. **그룹 단위 필터 구조 정리**
   1) 모집 상태(모집 중 / 온라인 가능 등 토글)  
   2) 지역  
   3) 카테고리  
   4) 주관 기관  
   5) 담당 부서  

3. **멀티 선택 + 즉시 시각 피드백**
   - Chip(Pill) 기반 멀티 선택  
   - 선택/비선택 상태가 색/보더로 즉시 구분

4. **“초기화 / 적용” 버튼 고정**
   - 하단에 항상 보이는 `초기화` / `필터 적용` 버튼  
   - 적용 클릭 시만 검색/목록 리로드

5. **Motion / Interaction**
   - BottomSheet 열릴 때 Spring motion (TASK 306 규격)  
   - 선택/해제는 즉시 반응, 리스트는 “적용” 시에만 변경

---

## 3. 정보 구조 / 와이어프레임

```text
┌─────────────────────────────────────────────
│  ⬛⬛⬛ 필터                         [X 닫기]
├─────────────────────────────────────────────
│  [📌 선택된 필터]  ← 선택된 항목 요약
│   · 모집중
│   · 온라인
│   · 경북
│   · 주거
│
│  [토글 그룹]
│   ▢ 모집 중인 정책만
│   ▢ 온라인 신청 가능
│
│  [지역]
│   (전체) (경북) (서울) (부산) ...
│
│  [카테고리]
│   (주거) (취업) (창업) (교육) ...
│
│  [주관 기관]
│   (경상북도) (○○시) (○○청년센터) ...
│
│  [담당 부서]
│   (청년정책과) (일자리정책과) ...
│
├─────────────────────────────────────────────
│  [초기화]                      [필터 적용]
└─────────────────────────────────────────────
````

---

## 4. 상호작용 규칙

* Chip(태그) 선택:

  * 누르면 `선택 → PrimaryContainer 배경 + Primary 글자색 + 테두리`
  * 다시 누르면 선택 해제

* 상단 “선택된 필터 요약” Pill:

  * 각 Pill 오른쪽 X 아이콘으로 개별 해제
  * “전체 초기화”는 하단 `초기화` 버튼으로 처리

* `초기화` 버튼:

  * 모든 필터 상태 초기화
  * “필터가 초기화되었습니다” 스낵바 (선택 사항)

* `필터 적용` 버튼:

  * 현재 선택 상태를 Filter 모델로 전달
  * BottomSheet 닫기 + 리스트/검색 재호출

---

## 5. 실제 구현 파일 (전체)

### 📁 lib/ui/components/policy_filter_bottom_sheet.dart

```dart
import 'package:flutter/material.dart';
import 'package:youth_road_app/theme/app_theme.dart';
import 'package:youth_road_app/ui/components/policy_tag.dart';
import 'package:youth_road_app/ui/components/section_title.dart';

/// 필터 상태 모델 (UI 전용 DTO)
class PolicyFilterUiState {
  final bool onlyRecruiting;
  final bool onlyOnline;
  final Set<String> regions;
  final Set<String> categories;
  final Set<String> organizations;
  final Set<String> departments;

  const PolicyFilterUiState({
    this.onlyRecruiting = false,
    this.onlyOnline = false,
    this.regions = const {},
    this.categories = const {},
    this.organizations = const {},
    this.departments = const {},
  });

  PolicyFilterUiState copyWith({
    bool? onlyRecruiting,
    bool? onlyOnline,
    Set<String>? regions,
    Set<String>? categories,
    Set<String>? organizations,
    Set<String>? departments,
  }) {
    return PolicyFilterUiState(
      onlyRecruiting: onlyRecruiting ?? this.onlyRecruiting,
      onlyOnline: onlyOnline ?? this.onlyOnline,
      regions: regions ?? this.regions,
      categories: categories ?? this.categories,
      organizations: organizations ?? this.organizations,
      departments: departments ?? this.departments,
    );
  }

  bool get isEmpty =>
      !onlyRecruiting &&
      !onlyOnline &&
      regions.isEmpty &&
      categories.isEmpty &&
      organizations.isEmpty &&
      departments.isEmpty;
}

/// 필터 옵션 집합 (실제 데이터는 상위에서 주입)
class PolicyFilterOptions {
  final List<String> regions;
  final List<String> categories;
  final List<String> organizations;
  final List<String> departments;

  const PolicyFilterOptions({
    required this.regions,
    required this.categories,
    required this.organizations,
    required this.departments,
  });
}

/// 필터 BottomSheet 공용 엔트리 함수
Future<PolicyFilterUiState?> showPolicyFilterBottomSheet({
  required BuildContext context,
  required PolicyFilterUiState initialState,
  required PolicyFilterOptions options,
}) async {
  final result = await showModalBottomSheet<PolicyFilterUiState>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        initialChildSize: 0.8,
        builder: (context, scrollController) {
          return PolicyFilterBottomSheet(
            initialState: initialState,
            options: options,
            scrollController: scrollController,
          );
        },
      );
    },
  );

  return result;
}

/// 정책 필터 BottomSheet 본문
class PolicyFilterBottomSheet extends StatefulWidget {
  final PolicyFilterUiState initialState;
  final PolicyFilterOptions options;
  final ScrollController? scrollController;

  const PolicyFilterBottomSheet({
    super.key,
    required this.initialState,
    required this.options,
    this.scrollController,
  });

  @override
  State<PolicyFilterBottomSheet> createState() =>
      _PolicyFilterBottomSheetState();
}

class _PolicyFilterBottomSheetState extends State<PolicyFilterBottomSheet> {
  late PolicyFilterUiState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  void _toggleRegion(String value) {
    setState(() {
      final next = Set<String>.from(_state.regions);
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _state = _state.copyWith(regions: next);
    });
  }

  void _toggleCategory(String value) {
    setState(() {
      final next = Set<String>.from(_state.categories);
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _state = _state.copyWith(categories: next);
    });
  }

  void _toggleOrganization(String value) {
    setState(() {
      final next = Set<String>.from(_state.organizations);
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _state = _state.copyWith(organizations: next);
    });
  }

  void _toggleDepartment(String value) {
    setState(() {
      final next = Set<String>.from(_state.departments);
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _state = _state.copyWith(departments: next);
    });
  }

  void _removeSelectedFilter(String label) {
    // 단순 텍스트 기준으로 모든 그룹에서 제거 시도
    setState(() {
      final r = Set<String>.from(_state.regions)..remove(label);
      final c = Set<String>.from(_state.categories)..remove(label);
      final o = Set<String>.from(_state.organizations)..remove(label);
      final d = Set<String>.from(_state.departments)..remove(label);
      bool onlyRecruiting = _state.onlyRecruiting;
      bool onlyOnline = _state.onlyOnline;

      if (label == '모집 중') {
        onlyRecruiting = false;
      }
      if (label == '온라인 신청') {
        onlyOnline = false;
      }

      _state = _state.copyWith(
        regions: r,
        categories: c,
        organizations: o,
        departments: d,
        onlyRecruiting: onlyRecruiting,
        onlyOnline: onlyOnline,
      );
    });
  }

  void _resetFilters() {
    setState(() {
      _state = const PolicyFilterUiState();
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop(_state);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final policyTheme = Theme.of(context).extension<PolicyTheme>();

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              children: [
                Text(
                  '필터',
                  style: textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 본문 스크롤 영역
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 선택된 필터 요약
                  _buildSelectedFiltersSummary(context),

                  const SizedBox(height: 16),

                  // 토글 그룹
                  SectionTitle(title: '모집 상태'),
                  const SizedBox(height: 8),
                  _buildToggleGroup(context),

                  const SizedBox(height: 20),

                  // 지역
                  SectionTitle(title: '지역'),
                  const SizedBox(height: 8),
                  _buildFilterChipGroup(
                    values: widget.options.regions,
                    selected: _state.regions,
                    onTap: _toggleRegion,
                  ),

                  const SizedBox(height: 20),

                  // 카테고리
                  SectionTitle(title: '카테고리'),
                  const SizedBox(height: 8),
                  _buildFilterChipGroup(
                    values: widget.options.categories,
                    selected: _state.categories,
                    onTap: _toggleCategory,
                  ),

                  const SizedBox(height: 20),

                  // 주관 기관
                  SectionTitle(title: '주관 기관'),
                  const SizedBox(height: 8),
                  _buildFilterChipGroup(
                    values: widget.options.organizations,
                    selected: _state.organizations,
                    onTap: _toggleOrganization,
                  ),

                  const SizedBox(height: 20),

                  // 담당 부서
                  SectionTitle(title: '담당 부서'),
                  const SizedBox(height: 8),
                  _buildFilterChipGroup(
                    values: widget.options.departments,
                    selected: _state.departments,
                    onTap: _toggleDepartment,
                  ),

                  const SizedBox(height: 24),
                  SizedBox(height: policyTheme?.policyCardPadding.bottom ?? 0),
                ],
              ),
            ),
          ),

          // 하단 버튼 영역
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            decoration: BoxDecoration(
              color: scheme.surface,
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: _state.isEmpty ? null : _resetFilters,
                  child: const Text('초기화'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('필터 적용'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFiltersSummary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final items = <String>[];

    if (_state.onlyRecruiting) items.add('모집 중');
    if (_state.onlyOnline) items.add('온라인 신청');
    items.addAll(_state.regions);
    items.addAll(_state.categories);
    items.addAll(_state.organizations);
    items.addAll(_state.departments);

    if (items.isEmpty) {
      return Text(
        '선택된 필터가 없습니다. 조건을 선택해보세요.',
        style: textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '선택된 필터',
          style: textTheme.bodySmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: items
              .map(
                (label) => _SelectedFilterPill(
                  label: label,
                  onRemove: () => _removeSelectedFilter(label),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildToggleGroup(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget buildToggle({
      required String label,
      required bool value,
      required ValueChanged<bool> onChanged,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(!value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value ? scheme.primary : scheme.outlineVariant,
            ),
            color: value
                ? scheme.primaryContainer
                : scheme.surfaceVariant,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: textTheme.bodyMedium!.copyWith(
                  color: value
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        buildToggle(
          label: '모집 중인 정책만',
          value: _state.onlyRecruiting,
          onChanged: (v) {
            setState(() {
              _state = _state.copyWith(onlyRecruiting: v);
            });
          },
        ),
        buildToggle(
          label: '온라인 신청 가능',
          value: _state.onlyOnline,
          onChanged: (v) {
            setState(() {
              _state = _state.copyWith(onlyOnline: v);
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterChipGroup({
    required List<String> values,
    required Set<String> selected,
    required ValueChanged<String> onTap,
  }) {
    if (values.isEmpty) {
      return const Text(
        '선택 가능한 항목이 없습니다.',
        style: TextStyle(fontSize: 12),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: values.map((value) {
        final isSelected = selected.contains(value);
        return _FilterChip(
          label: value,
          selected: isSelected,
          onTap: () => onTap(value),
        );
      }).toList(),
    );
  }
}

/// 상단 “선택된 필터” Pill
class _SelectedFilterPill extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _SelectedFilterPill({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: textTheme.bodySmall!.copyWith(
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 필터 선택용 Chip
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor =
        selected ? scheme.primaryContainer : scheme.surfaceVariant;
    final borderColor =
        selected ? scheme.primary : scheme.outlineVariant;
    final textColor =
        selected ? scheme.primary : scheme.onSurfaceVariant;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            label,
            style: textTheme.bodySmall!.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
```

---

## 6. Codex용 슈퍼명령어 (필터 BottomSheet 교체 전용)

```md
@codex-super-command
name: "Redesign Policy Filter BottomSheet (TASK 309)"
version: "v1"
description: |
  기존 정책 필터 BottomSheet UI를 TASK 309에서 정의한 새 디자인으로 교체한다.
  Application/Repository/Domain 레이어는 절대 수정하지 않고,
  UI 레이어에서만 PolicyFilterBottomSheet를 사용하도록 변경한다.

no_modify:
  - "lib/application/**"
  - "lib/data/**"
  - "lib/domain/**"
  - "**/*.g.dart"
  - "**/*.freezed.dart"

modify_targets:
  - "lib/ui/screens/policy/**"
  - "lib/ui/components/**"

steps:
  - "1) lib/ui/components/policy_filter_bottom_sheet.dart 파일 생성 또는 교체"
  - "2) 기존 필터 BottomSheet 호출부를 showPolicyFilterBottomSheet(...)로 교체"
  - "3) 기존 Filter 모델을 PolicyFilterUiState <-> 도메인 필터로 매핑"
  - "4) 초기 상태는 현재 적용된 필터에서 가져와 PolicyFilterUiState로 변환"
  - "5) 필터 적용 시 기존 검색/리스트 리로드 로직 그대로 호출"
  - "6) 전체 코드 Dart format 적용"

output:
  type: "patch"
  format: "unified_diff"
```

---




---

# 🚀 **TASK 306 — 정책탐색 네비게이션 & Motion System 전체 업그레이드 (ULTRA PRO MAX)**

```md
# TASK 306  
## YouthRoad Navigation / Motion System 완전 리빌드  
### Version: ULTRA PRO MAX  
### Owner: UI/UX Layer  
### 목적: UX 체감 품질을 서비스급으로 끌어올리는 통합 Motion Architecture 구축

---

# 1) Motion System 철학 (Motion Philosophy)

YouthRoad Motion System은 아래 3가지 철학을 따른다.

### 1. Continuity (연속성)
화면이 “끊기지 않고 이어진다”는 느낌을 줘야 한다.  
→ 이전 화면의 구조적 맥락이 다음 화면까지 연장되도록 설계.

### 2. Spatial Awareness (공간감)
사용자가 지금 “어디서 어디로 이동했는지” 공간 감각을 잃지 않도록 한다.  
→ 좌/우 이동 = 계층 이동  
→ 하단 → 상단 이동 = 오버레이  
→ Fade = 내용 변경

### 3. Temporal Coherence (시간적 일관성)
비슷한 상황에서는 **항상 비슷한 시간/커브**로 움직여야 한다.  
→ 앱 전체 움직임이 하나의 브랜드 같게 느껴지게 함.

---

# 2) YouthRoad Motion Architecture (전체 구조)

전체 Motion System은 아래 4개 Layer로 구성된다.

```

[Layer 0: Global Navigation Layer]

* 빅 전환 (정책 리스트 → 상세)
* 검색 화면 오버레이
* 전체 탭 이동

[Layer 1: Local Page Motion Layer]

* Section fade
* Skeleton ↔ Content 전환
* 박스 강조 모션

[Layer 2: Element-level Micro Motion]

* 버튼 hover/press
* 태그 선택 강조
* 아이콘 애니메이션

[Layer 3: BottomSheet Motion Layer]

* Spring animation
* Dim fade in/out

````

UX 품질을 올리기 위해서는  
**4개 Layer가 모두 통일된 규칙을 가져야 한다.**

---

# 3) YouthRoad 전역 Motion Timing / Curve 규격

| 모션 종류 | Duration | Curve | 목적 |
|----------|----------|-------|-------|
| Page Slide In | 260ms | easeOutCubic | 리스트 → 상세 |
| Page Slide Out | 200ms | easeIn | 상세 → 뒤로 |
| Search Overlay | 300ms | easeOutQuart | 검색 열기 |
| BottomSheet | Dynamic | spring(0.75) | 옵션 필터 |
| Skeleton Fade | 180ms | easeOut | 데이터 로딩 |

규칙 1:  
**전역 transition duration은 180–300ms 외 벗어나지 않는다.**  
규칙 2:  
**하단→상단은 꼭 spring 사용.**  
규칙 3:  
**좌→우 전환은 항상 cubic-out.**

---

# 4) Navigation Transition Graph (정책탐색 전체 전환 흐름)

```txt
[PolicyList]
   │ (tap)
   ▼  Slide + Fade
[PolicyDetail]
   │ (back)
   ▼  SlideBack + FadeOut
[PolicyList]

[PolicyList]
   │ (search)
   ▼  SearchOverlay (Fold-in)
[SearchScreen]
   │ (close)
   ▼  Fold-back
[PolicyList]

[PolicyList] ←→ [RegionTab]
  PageView + Swipe + Snap
````

이 Graph는 Motion의 일관성을 유지하는 기준이 됨.

---

# 5) Flutter 적용 규약(이벤트/전환/UX 규칙 포함)

## 5-1) 리스트 → 상세 (Slide + Fade) 규약

```dart
CustomTransitionPage(
  transitionsBuilder: (context, animation, _, child) {
    final slide = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
    );

    final fade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  },
);
```

규칙:

* **슬라이드는 X축, Fade는 0~1 구간 전체**
* Animation Overlap 비율이 1:1이어야 함
* secondaryAnimation 사용 금지 (불필요한 반전 Motion 방지)

---

## 5-2) 검색 화면 (Bottom-to-Top Fold-In)

```dart
CustomTransitionPage(
  transitionsBuilder: (context, animation, _, child) {
    final slide = Tween(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
    ));

    final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  },
);
```

규칙:

* 검색 화면은 “새 화면”이 아니라 “Overlay”처럼 느껴져야 함
* vertical offset은 0.15 이하로 제한
* fade 비율은 100%

---

## 5-3) Skeleton → Content 자동 FadeSwitch

```dart
AnimatedSwitcher(
  duration: const Duration(milliseconds: 180),
  switchInCurve: Curves.easeOut,
  switchOutCurve: Curves.easeOut,
  child: isLoading
    ? const PolicySkeletonCard()
    : PolicyCard(...),
);
```

규칙:

* skeleton height는 최종 컨텐츠 높이와 거의 같게 유지해야 튐이 없음.

---

## 5-4) BottomSheet Spring 규약

```dart
showModalBottomSheet(
  context: context,
  useSafeArea: true,
  isScrollControlled: true,
  transitionAnimationController: AnimationController(
    duration: const Duration(milliseconds: 350),
    vsync: this,
  ),
);
```

Spring Spec:

```
mass: 0.75  
stiffness: 250  
damping: 18
```

---

# 6) Codex 실행용 “Motion System Rebuild SUPER COMMAND (Pro-Safe)”

```md
@codex-super-command
name: "Apply YouthRoad Motion System (Ultra Pro Max)"
version: "v3-pro-max"
description: |
  YouthRoad 전역 Motion Architecture(TASK 306 PRO MAX)를 모든 정책탐색 UI/네비게이션에 적용한다.
  기존 Provider/Repository/StateNotifier는 절대 건드리지 않으며,
  Routing과 UI Layer에만 Motion 로직을 주입한다.

no_modify:
  - "lib/domain/**"
  - "lib/data/**"
  - "lib/application/**"
  - "**/*.freezed.dart"
  - "**/*.g.dart"

modify_targets:
  - "lib/routing/**"
  - "lib/ui/screens/policy/**"
  - "lib/ui/components/**"

rules:
  - "1) 리스트→상세: slide(1→0) + fade transition 적용"
  - "2) 상세→뒤로: slideBack + fadeOut 적용"
  - "3) 검색 화면: Bottom→Top fold-in transition 적용"
  - "4) Skeleton → Content: AnimatedSwitcher fade 적용"
  - "5) BottomSheet: Spring Motion 적용"
  - "6) PageView 탭 이동: easeOutCubic 230ms 적용"
  - "7) 모든 TransitionPage는 CustomTransitionPage로 교체"

output:
  type: "patch"
  format: "unified_diff"
```

---

# 7) 기대 효과 (UX 체감 변화)

| Before              | After                                |
| ------------------- | ------------------------------------ |
| 화면 전환이 어색하고 딱딱함     | **네이버·토스급 부드러운 전환**                  |
| 검색 화면 팝업 느낌         | **서비스스러운 오버레이 “폼”**                  |
| 리스트 → 상세에 논리적 연결 부족 | **흐름이 살아있는 UI**                      |
| 스켈레톤 튐              | **Fade-in 정확**                       |
| BottomSheet가 싸구려 느낌 | **iOS-style High-end Spring Motion** |

YouthRoad 앱의 UI/UX 완성도가
**한 순간에 “고급 앱 서비스” 레벨로 상승합니다.**

---

# END OF TASK 306 (ULTRA PRO MAX)

```

---



---

# 🚀 **TASK 305 — 정책 상세 화면 리마인더(알림) 상태머신 + UI/Provider 완전 통합 (ULTRA MAX BUILD)**

### *YouthRoad Notification Layer 완전형 설계 문서*

````md
# TASK 305  
## 정책 상세 화면 리마인더(알림) 상태머신 + UI/Provider 완전 통합  
### Version: ULTRA MAX BUILD  
### Owner: Application Layer + UI Layer  
### Goal: Zero-Error, Zero-Desync, Zero-Duplicate Reminder UX

---

# 1. 설계 목표 (Design Objectives)

본 TASK 305의 목표는 아래 요소들을 모두 충족하는 **완전한 알림 시스템**을 구축하는 것:

### 🎯 1) UI(TASK 304) ↔ Provider ↔ Repository ↔ Local Notification  
**전 계층 구조를 변경 없이 그대로 유지하면서 연결**

### 🎯 2) 상태 충돌(중복 예약/중복 취소/지연 반영) ZERO  
**동일 옵션 재클릭 → 취소**  
**다른 옵션 클릭 → 변경**  
**UI 상태는 Provider 상태에 100% 종속**  

### 🎯 3) “선택 → 로딩 → 성공/실패” 단계 명확화  
UI에서 즉시 Optimistic UI 사용 (단, Provider와 차이 발생 시 UI 자동 보정)

### 🎯 4) 실제 사용자 UX 기준으로 직관적인 흐름  
- 4개 옵션 중 딱 하나만 선택 가능  
- 선택 상태는 “현재 예약된 알림”만 반영  
- 예약/취소 후에는 스낵바로 피드백 출력

---

# 2. 기존 시스템 구조 (변경 금지)

```txt
PolicyDetailScreen (UI)
  ↓
policyReminderNotifierProvider(policyId)  (StateNotifier)
  ↓
PolicyReminderService
  ↓
PolicyReminderRepository
  ↓
Local Notification Scheduler
````

❗ **절대 변경 금지:**

* Repository 구현
* Service 구현
* Domain 모델
* StateNotifier 로직 구조
* Policy 엔티티
* 로딩/에러/데이터 AsyncValue 패턴

---

# 3. 리마인더 상태머신 (최종 확정 버전)

## 🔵 STATE A — NoReminder

```
selectedReminder = null
UI = 모든 Grid 옵션 unselected
```

## 🟢 STATE B — ReminderSet(X)

```
selectedReminder = X
UI = X 옵션 only selected
```

## 🟡 STATE C — Transition(changing)

```
변경 처리 중
UI = Optimistic 적용 → 눌린 옵션을 우선 selected로 보여줌
Provider 실제 결과와 다르면 UI는 즉시 Provider 값으로 auto-correct
```

## 🔴 STATE D — Cancelled

```
selectedReminder = null
UI = 모두 unselected
```

---

# 4. UI ↔ Provider 통합 규칙 (절대 변경 금지 패턴)

UI는 아래 **두 개의 액션만 호출**해야 한다:

```dart
await notifier.setReminder(policy, option);
await notifier.cancelReminder(policyId);
```

즉, UI는 절대:

❌ Service를 직접 호출하지 않음
❌ Repository 직접 접근 없음
❌ Notification 스케줄러 직접 접근 없음

🚀 **UI는 오직 "Notifier"와만 통신**한다.

---

# 5. “선택 / 취소 / 변경” 액션 규칙 (Human-centric UX 기준)

### ✔ 5-1) 동일 옵션 재클릭 → 취소

```dart
if (selectedReminder == option) {
  notifier.cancelReminder(policyId);
}
```

### ✔ 5-2) 다른 옵션 클릭 → 변경

```dart
else {
  notifier.setReminder(policy, option);
}
```

### ✔ 5-3) 빠른 연타 방지 (Double Tap Protection)

Codex 규칙에 포함:

* 한 옵션 클릭 후 500ms 이내에는 중복 실행 불가
* provider state가 “AsyncLoading()”이면 버튼 비활성화

---

# 6. selectedReminder 동기화 규약 (UI → Provider → UI)

기존 Notifier는 load() 후 아래 구조로 값을 제공한다:

```dart
AsyncValue<PolicyReminder?>
```

UI는 이 값을 다음과 같이 해석해야 한다:

```dart
final reminderState = ref.watch(policyReminderNotifierProvider(policyId));
final selectedReminder = reminderState.value?.option.toEnum();
```

### ⚠ toEnum() 매핑 규칙 (필수)

policy-reminder-option 문자열 → UI enum

```
"1"   → ReminderOption.oneDayBefore
"3"   → ReminderOption.threeDaysBefore
"7"   → ReminderOption.sevenDaysBefore
"0"   → ReminderOption.onDueDate
null → null
```

❗ Codex가 이 규약대로 매핑하도록 명령어에 포함됨.

---

# 7. UI 레벨 Feedback & Optimistic UI 규칙

### ✔ 선택/취소 직후 UI는 “Optimistic 업데이트” 수행

→ 즉시 반응 + 200ms 내 Provider 반영 검사
→ Provider 결과와 다르면 자동 보정 (self-healing)

### ✔ 알림 저장 성공 → 스낵바

```
"알림이 예약되었습니다"
```

### ✔ 취소 성공 → 스낵바

```
"알림이 취소되었습니다"
```

### ✔ 오류 발생 → 스낵바

```
"알림 설정 중 오류가 발생했습니다"
```

### ✔ 알림 옵션 Grid는 다음과 같은 disabled 조건:

* reminderState is AsyncLoading
* setReminder/cancelReminder 실행 중

---

# 8. 최종 연결 코드 패턴 (UI 상단 선언)

```dart
final notifier = ref.watch(
  policyReminderNotifierProvider(policyId).notifier,
);

final reminderState = ref.watch(
  policyReminderNotifierProvider(policyId),
);

final selectedReminder =
    reminderState.value?.option.toEnum();
```

UI Action 바인딩:

```dart
onTapReminder3DaysBefore: () async {
  if (selectedReminder == ReminderOption.threeDaysBefore) {
    await notifier.cancelReminder(policyId);
  } else {
    await notifier.setReminder(policy, ReminderOption.threeDaysBefore);
  }
}
```

---

# 9. Codex 실행용 “알림 시스템 자동 연결 SUPER COMMAND (Ultra Safe)”

```md
@codex-super-command
name: "Connect PolicyDetail Reminder System (Ultra Safe)"
version: "v3-ultra-max"
description: |
  TASK 304(UI) ↔ PolicyReminderNotifier 간 알림 시스템을 완전 통합한다.
  UI만 수정하며 Provider/Service/Repository는 절대 변경하지 않는다.
  selectedReminder 상태와 UI 하이라이트를 정확하게 동기화한다.
  동일 옵션 클릭 → 취소 / 다른 옵션 클릭 → 변경 규칙을 따른다.

no_modify:
  - "lib/application/**"
  - "lib/data/**"
  - "lib/domain/**"
  - "**/*.freezed.dart"
  - "**/*.g.dart"

modify_targets:
  - "lib/ui/screens/policy/policy_detail_screen.dart"

steps:
  - "1) UI 상단에 notifier/reminderState/selectedReminder 선언 추가"
  - "2) 4개의 알림 옵션 onTap → setReminder/cancelReminder 규약으로 교체"
  - "3) selectedReminder == option → selected UI 표시"
  - "4) AsyncLoading 상태면 버튼 disabled 적용"
  - "5) toEnum() 매핑 함수 자동 생성"
  - "6) Snackbar 피드백 추가"
  - "7) UI 전체 Dart format 적용"
  - "8) no_modify 영역 침범 여부 검사"

output:
  type: "patch"
  format: "unified_diff"
```

---

# 10. 테스트 시나리오 (필수)

### ✓ TC01 — 처음 진입

```
reminder 없음 → 모든 옵션 unselected
```

### ✓ TC02 — 3일 전 선택

```
→ selectedReminder = threeDaysBefore
→ Grid 하이라이트
→ Snackbar: 알림이 예약되었습니다
```

### ✓ TC03 — 동일 옵션 재클릭

```
→ 알림 취소
→ selectedReminder = null
→ Snackbar: 알림이 취소되었습니다
```

### ✓ TC04 — 다른 옵션 변경

```
3일전 → 1일전 변경
→ 기존 알림 delete
→ 새 알림 upsert
→ UI 자동 업데이트
```

### ✓ TC05 — 빠른 연타

```
AsyncLoading 방지 → 중복 실행 안 됨
```

---

# END OF TASK 305 (ULTRA MAX BUILD)

```

---


```

---

# 📌 TASK 304 — 정책 상세 화면 전체 파일 리팩토링 (디자인 완성도 MAX)

````md
# TASK 304  
## 정책 상세 화면 전체 파일 리팩토링 (디자인 완성도 MAX)  
### Status: OPEN  
### Owner: UI/UX Layer

---

## 1. 목적

- 기존 `policy_detail_screen.dart`를 **TASK 300/301/302 디자인 시스템** 기반으로
  **완전히 새로 설계된 상세 화면 UI**로 교체한다.
- 데이터/알림/신청 로직은 외부에서 주입하는 형태로 분리하고,
  본 파일은 **UI 레이아웃 & 디자인에만 집중**한다.
- 정책 상세 화면의 UX를:
  - 상단 정보 구조 명확
  - 알림 옵션 2×2 Grid
  - 지원내용/기관/문의처 섹션 분리
  - CTA 버튼(신청 페이지 열기)을 강하게 강조  
  하는 방향으로 리디자인한다.

---

## 2. 적용 범위

- 파일 경로(예시):  
  `lib/ui/screens/policy/policy_detail_screen.dart`

- 이 화면이 담당하는 기능:
  - 정책 제목/태그/기간/요약 정보 표시
  - “신청 페이지 열기” CTA
  - 알림 옵션 (1일 전/3일 전/7일 전/당일)
  - 지원내용 섹션
  - 기관/부서/문의처 섹션
  - (선택) 하단 기타 정보 섹션

> ⚠ 실제 데이터 바인딩(Policy 엔티티, Provider, 알림 서비스 연동 등)은  
>   이 파일 바깥에서 주입하는 방식으로 설계했습니다.  
>   → UI만 깔끔하게 분리하기 위한 구조입니다.

---

## 3. 전체 코드  
### 📁 lib/ui/screens/policy/policy_detail_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:youth_road_app/theme/app_theme.dart';
import 'package:youth_road_app/ui/components/policy_tag.dart';
import 'package:youth_road_app/ui/components/policy_cta_button.dart';
import 'package:youth_road_app/ui/components/section_title.dart';
import 'package:youth_road_app/ui/components/policy_info_row.dart';

/// 정책 상세 화면
///
/// - DESIGN:
///   - 상단: 제목 + 태그 + 즐겨찾기/공유/알림 아이콘
///   - CTA: "신청 페이지 열기" Primary 버튼
///   - 알림: 2×2 Grid 버튼
///   - 섹션: 지원내용 / 접수기간 / 기관·부서·문의처
///
/// - NOTE:
///   여기서는 UI에만 집중하고, 실제 데이터/로직은
///   상위에서 주입하거나 callback 으로 연결하는 구조로 설계함.
class PolicyDetailScreen extends StatelessWidget {
  /// 화면 타이틀 (정책 이름)
  final String title;

  /// 정책 태그 목록 (예: ["청년", "주거", "경북"])
  final List<String> tags;

  /// 신청/접수 기간 텍스트
  final String periodText;

  /// 지원 내용(본문)
  final String supportContent;

  /// 기관명
  final String organizationName;

  /// 담당 부서
  final String departmentName;

  /// 문의처 (전화번호/이메일 등)
  final String contactInfo;

  /// (선택) 정책 요약 설명
  final String? summary;

  /// (선택) 신청 페이지 URL 표시용
  final String? applyUrlForDisplay;

  /// 액션 콜백들
  final VoidCallback? onTapOpenApplyPage;
  final VoidCallback? onTapFavorite;
  final VoidCallback? onTapShare;

  /// 알림 옵션 콜백들
  final VoidCallback? onTapReminder1DayBefore;
  final VoidCallback? onTapReminder3DaysBefore;
  final VoidCallback? onTapReminder7DaysBefore;
  final VoidCallback? onTapReminderOnDue;

  /// 현재 선택된 알림 옵션 상태 (UI 하이라이트용)
  final ReminderOption? selectedReminder;

  const PolicyDetailScreen({
    super.key,
    required this.title,
    required this.tags,
    required this.periodText,
    required this.supportContent,
    required this.organizationName,
    required this.departmentName,
    required this.contactInfo,
    this.summary,
    this.applyUrlForDisplay,
    this.onTapOpenApplyPage,
    this.onTapFavorite,
    this.onTapShare,
    this.onTapReminder1DayBefore,
    this.onTapReminder3DaysBefore,
    this.onTapReminder7DaysBefore,
    this.onTapReminderOnDue,
    this.selectedReminder,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: onTapFavorite,
            tooltip: '관심 정책',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: onTapShare,
            tooltip: '공유하기',
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목 + 태그
                _buildHeader(context),

                const SizedBox(height: 16),

                // 요약
                if (summary != null && summary!.trim().isNotEmpty) ...[
                  Text(
                    summary!,
                    style: textTheme.bodyMedium!.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 접수기간 간단 강조
                _buildPeriodHighlight(context),

                const SizedBox(height: 20),

                // 신청 페이지 열기 CTA
                PolicyCtaButton(
                  text: '신청 페이지 열기',
                  onTap: onTapOpenApplyPage,
                ),

                if (applyUrlForDisplay != null &&
                    applyUrlForDisplay!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    applyUrlForDisplay!,
                    style: textTheme.bodySmall!.copyWith(
                      color: scheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // 알림 설정 영역
                SectionTitle(title: '알림 설정'),
                const SizedBox(height: 8),
                Text(
                  '마감 전에 알림을 받아보고 싶다면 원하는 시점을 선택하세요.',
                  style: textTheme.bodySmall!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                _buildReminderGrid(context),

                const SizedBox(height: 24),

                // 지원 내용
                SectionTitle(title: '지원 내용'),
                const SizedBox(height: 8),
                Text(
                  supportContent,
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                // 접수 기간 상세 섹션
                SectionTitle(title: '접수 기간'),
                const SizedBox(height: 4),
                Text(
                  periodText,
                  style: textTheme.bodyMedium!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                // 기관 / 부서 / 문의처
                SectionTitle(title: '기관 및 문의'),
                const SizedBox(height: 4),
                PolicyInfoRow(
                  label: '주관 기관',
                  value: organizationName,
                ),
                PolicyInfoRow(
                  label: '담당 부서',
                  value: departmentName,
                ),
                PolicyInfoRow(
                  label: '문의처',
                  value: contactInfo,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 상단 헤더 (정책 제목 + 태그)
  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge!.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: tags.map((label) => PolicyTag(label: label)).toList(),
        ),
      ],
    );
  }

  /// 상단 기간 강조 박스
  Widget _buildPeriodHighlight(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: scheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              periodText,
              style: textTheme.bodyMedium!.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2×2 알림 옵션 Grid
  Widget _buildReminderGrid(BuildContext context) {
    final options = [
      _ReminderTileConfig(
        label: '마감 하루 전',
        description: 'D-1',
        option: ReminderOption.oneDayBefore,
        onTap: onTapReminder1DayBefore,
      ),
      _ReminderTileConfig(
        label: '마감 3일 전',
        description: 'D-3',
        option: ReminderOption.threeDaysBefore,
        onTap: onTapReminder3DaysBefore,
      ),
      _ReminderTileConfig(
        label: '마감 7일 전',
        description: 'D-7',
        option: ReminderOption.sevenDaysBefore,
        onTap: onTapReminder7DaysBefore,
      ),
      _ReminderTileConfig(
        label: '마감 당일',
        description: '마감날 아침',
        option: ReminderOption.onDueDate,
        onTap: onTapReminderOnDue,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2; // 2열 + 가로 간격 12

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((cfg) {
            final isSelected = selectedReminder == cfg.option;
            return SizedBox(
              width: width,
              child: _ReminderTile(
                label: cfg.label,
                description: cfg.description,
                selected: isSelected,
                onTap: cfg.onTap,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// 알림 옵션 enum (UI 하이라이트용)
enum ReminderOption {
  oneDayBefore,
  threeDaysBefore,
  sevenDaysBefore,
  onDueDate,
}

/// 알림 타일 구성 정보
class _ReminderTileConfig {
  final String label;
  final String description;
  final ReminderOption option;
  final VoidCallback? onTap;

  const _ReminderTileConfig({
    required this.label,
    required this.description,
    required this.option,
    this.onTap,
  });
}

/// 알림 옵션 개별 타일 UI
class _ReminderTile extends StatelessWidget {
  final String label;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  const _ReminderTile({
    required this.label,
    required this.description,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor =
        selected ? scheme.primaryContainer : scheme.surfaceVariant;
    final borderColor =
        selected ? scheme.primary : scheme.outlineVariant;
    final labelColor =
        selected ? scheme.primary : scheme.onSurface;
    final descColor =
        selected ? scheme.primary : scheme.onSurfaceVariant;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodySmall!.copyWith(
                  color: descColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
````

---

## 4. 연결 시 참고 메모

* 기존 `PolicyDetailScreen`가 `policyId` 또는 `Policy` 엔티티를 직접 받던 구조라면,
  상위에서 데이터를 가져와서 이 새로운 `PolicyDetailScreen`에 아래처럼 넘기면 됩니다:

```dart
// 예시 (상위 위젯/라우트에서)
return PolicyDetailScreen(
  title: policy.title,
  tags: policy.tags,
  periodText: policy.periodText,
  supportContent: policy.supportContent,
  organizationName: policy.organizationName,
  departmentName: policy.departmentName,
  contactInfo: policy.contact,
  summary: policy.summary,
  applyUrlForDisplay: policy.applyUrl,
  onTapOpenApplyPage: () => openPolicyApplyPage(policy),
  onTapFavorite: () => toggleFavorite(policy),
  onTapShare: () => sharePolicy(policy),
  onTapReminder1DayBefore: () => setReminder(policy, ReminderOption.oneDayBefore),
  onTapReminder3DaysBefore: () => setReminder(policy, ReminderOption.threeDaysBefore),
  onTapReminder7DaysBefore: () => setReminder(policy, ReminderOption.sevenDaysBefore),
  onTapReminderOnDue: () => setReminder(policy, ReminderOption.onDueDate),
  selectedReminder: currentSelectedOption,
);
```

---

## 5. 기대 효과

* 상세 화면의 정보 구조가 명확해져서,
  사용자가 **“이 정책이 뭔지 / 언제까지 / 어디에 문의해야 하는지”**를
  한 번에 이해할 수 있음.
* 알림 옵션이 눈에 잘 들어오는 2×2 Grid로 정리되어
  알림 기능 사용률 증가 기대.
* 전체 UI가 TASK 300/301/302의 디자인 시스템과 완전히 일관된 느낌으로 통일.

---

# END OF TASK 304

```

---

```


---

# 🚀 **TASK 303 — 정책탐색 UI 전체 리디자인 적용 Codex 슈퍼명령어 (ULTRA PREMIUM Edition)**

### **YouthRoad Project 전용 · 안전장치 3중 적용 · UI Layer 100% 리빌드**

```md
@codex-super-command
name: "YouthRoad PolicyExplore UI Full-Rebuild (TASK 300·301·302 Integration)"
version: "v3-ultra-premium"
description: |
  YouthRoad 정책탐색 전체 화면(UI Layer)을 TASK 300(Design System),
  TASK 301(Global Theme), TASK 302(Policy UI Components) 기반으로
  완전한 품질로 리디자인한다.
  
  ⚠ 절대 수정 금지: Domain / Repository / Provider / Routing / API 레이어
  ⚠ 오직 UI 위젯 Layer만 교체
  ⚠ 기존 기능/로직은 100% 유지 (검색/필터/페이징/알림/상세 이동)

  목표:
    - 정책 리스트 · 검색 · 지역 · 상세 페이지의 UI를
      완전히 새로운 통일 디자인 규격으로 재구성.
    - 정책 카드/태그/CTA/EmptyState/Skeleton 등 모든 컴포넌트 일관화.
    - 기존 혼잡한 레이아웃 → 디자인 시스템 기반 구조로 리빌드.

# =====================================================================================
# 1) 작업 브랜치 전략 (안전)
# =====================================================================================
branches:
  create: "feature/ui-policy-explore-rebuild"
  base: "main"

protect_branches:
  - "main"
  - "feature/no-unity-build"
  - "feature/core-stability"
  - "feature/architecture-upgrade"

# =====================================================================================
# 2) 절대 변경 금지 구역 (강력 보호)
# =====================================================================================
no_modify:
  - "lib/application/**"
  - "lib/domain/**"
  - "lib/data/**"
  - "lib/core/**"
  - "lib/routing/**"
  - "lib/environment/**"
  - "lib/main.dart"
  - "pubspec.yaml"
  - "**/*.g.dart"
  - "**/*.freezed.dart"

soft_no_modify:
  - "lib/ui/screens/**/**_controller.dart"
  - "lib/ui/screens/**/**_provider.dart"

explanation: |
  위 파일들은 로직/데이터 계층이므로 절대 건드리면 안 됨.
  UI 화면 파일만 리빌드한다.

# =====================================================================================
# 3) 신규 컴포넌트(TASK 302) 강제 매핑
# =====================================================================================
component_mapping:
  card:       "PolicyCard"
  tag:        "PolicyTag"
  empty:      "PolicyEmptyState"
  skeleton:   "PolicySkeletonCard"
  section:    "SectionTitle"
  infoRow:    "PolicyInfoRow"
  cta:        "PolicyCtaButton"

force_import_components: true

# =====================================================================================
# 4) 재구성 대상 파일 목록 (UI Layer Only)
# =====================================================================================
modify_targets:
  - "lib/ui/screens/policy/policy_list_v2_screen.dart"
  - "lib/ui/screens/policy/policy_search_screen.dart"
  - "lib/ui/screens/policy/policy_region_screen.dart"
  - "lib/ui/screens/policy/policy_detail_screen.dart"
  - "lib/ui/screens/policy/components/**"

# =====================================================================================
# 5) 화면별 리빌드 규칙 (고퀄리티 UX 기준)
# =====================================================================================
rules:

  # -------------------------------------------------------------
  # A. 정책 리스트 (전체/추천/필터 적용 시)
  # -------------------------------------------------------------
  - file: "policy_list_v2_screen.dart"
    enforce:
      - ListView.builder → PolicyCard
      - 로딩 중: PolicySkeletonCard × 6
      - 빈 목록: PolicyEmptyState(
            message: "조건에 맞는 정책이 없습니다",
            buttonText: "조건 초기화하기"
        )
      - 데이터 매핑: 
            title = policy.name
            summary = policy.descriptionShort
            tags = policy.tags
            period = policy.periodText
      - ScrollController / Pagination 로직 → 절대 수정 X
      - 상단 카테고리/정렬/필터 UI는 유지하되 스타일만 향상

  # -------------------------------------------------------------
  # B. 검색 화면
  # -------------------------------------------------------------
  - file: "policy_search_screen.dart"
    enforce:
      - 검색 전:
          최근 검색어 → List of TextButton
          추천 검색어 → PolicyTag 리스트
      - 검색 중:
          SkeletonCard 리스트
      - 검색 후:
          PolicyCard 리스트
      - 결과 없음:
          PolicyEmptyState("검색 결과가 없습니다", buttonText: "추천 정책 보기")

  # -------------------------------------------------------------
  # C. 지역 화면
  # -------------------------------------------------------------
  - file: "policy_region_screen.dart"
    enforce:
      - 상단 지역 Tab → 기존 로직 유지, UI만 디자인 시스템 적용
      - 리스트: PolicyCard
      - EmptyState 적용
      - Pagination/Provider 절대 수정 금지

  # -------------------------------------------------------------
  # D. 상세 화면
  # -------------------------------------------------------------
  - file: "policy_detail_screen.dart"
    enforce:
      - 상단:
          제목 (Title2)
          태그: PolicyTag 리스트
          즐겨찾기/공유/알림 아이콘은 기존 로직 유지
      - CTA:
          맨 위: PolicyCtaButton("신청 페이지 열기")
      - 알림 옵션:
          2×2 Grid (FilledButton + OutlinedButton 조합)
      - 내용 섹션:
          SectionTitle("지원내용")
          본문 텍스트
      - 날짜/기관/문의처:
          PolicyInfoRow(label, value)로 통일
      - 스크롤/Provider/알림 로직 절대 변경 금지

# =====================================================================================
# 6) 스타일 강제 적용 규칙 (TASK 300/301 필수 준수)
# =====================================================================================
style_enforce:
  typography:
    header: "Theme.of(context).textTheme.titleLarge"
    title: "Theme.of(context).textTheme.titleMedium"
    body: "Theme.of(context).textTheme.bodyMedium"
    caption: "Theme.of(context).textTheme.bodySmall"
  spacing:
    between_cards: 16
    section_gap: 20
    tag_spacing: 8
  colors:
    use_color_scheme: true
    use_policy_theme: true
  shape:
    card_radius: 16
    tag_radius: 14
    button_radius: 12

# =====================================================================================
# 7) Codex 작업 순서 (강제)
# =====================================================================================
steps:
  - "Step 1: 모든 대상 파일 import 정리"
  - "Step 2: 기존 UI widgets 제거하되 로직/Provider 유지"
  - "Step 3: 새 컴포넌트(PolicyCard 등)로 위젯 구조 재작성"
  - "Step 4: Skeleton/EmptyState 추가 배치"
  - "Step 5: Theme 기반 padding/margin/color 통일"
  - "Step 6: 빌드 검사 + 타입 오류 자동 수정"
  - "Step 7: no_modify 규칙 위반 여부 자동 검사"
  - "Step 8: Final Diff 생성"

# =====================================================================================
# 8) 작업 결과 출력 규칙
# =====================================================================================
output:
  type: "patch"
  format: "unified_diff"
  require_build_success: true
  note: |
    - UI 변경 사항만 포함할 것
    - 동작/기능/데이터는 동일해야 함
    - 모든 파일은 Dart format 규칙을 준수

# =====================================================================================
# END OF SUPER COMMAND
# =====================================================================================
```

---

# 🩵 **이 버전에서 업그레이드된 점**

### 💎 1) Codex 오동작 방지력 ‘최대치’

* **no_modify** + **soft_no_modify** + **screen별 rule**
* 구조/비즈니스 로직을 절대 손대지 않도록 3중 잠금

### 💎 2) UI Layer 완전 치환

* PolicyCard/Tag/Empty/Skeleton/InfoRow/CTA
* 상세/검색/지역/리스트 전부 일관화

### 💎 3) Theme 강제 적용

* TASK 301 Theme을 **강제적으로** 사용
* margin/padding/typography/color 자동 통제

### 💎 4) 실제 기업형 디자인 시스템 적용 방식

라인업·블록·섹션·패턴 기반 구조 → 유지보수 용이

---

---

# 📌 TASK 302 — 정책탐색 UI 전용 공통 컴포넌트 리빌드

### Flutter 전체 파일 제공 (완전 복붙 가능)

```md
# TASK 302  
## 정책탐색 UI 공통 컴포넌트 전체 리빌드  
### Status: OPEN  
### Owner: UI/UX Layer

---

## 📌 목적

TASK 300(디자인 시스템) + TASK 301(ThemeData) 기반으로  
정책탐색 화면 전반에 사용하는 공통 UI 컴포넌트를 **완전히 새로 재정의**한다.

## 포함 컴포넌트

- PolicyCard (정책 카드)
- PolicyTag (태그 UI)
- PolicyEmptyState (빈 화면 UI)
- SectionTitle (섹션 헤더 UI)
- PolicySkeletonCard (로딩 Skeleton)
- CTA Primary/Secondary 버튼 모듈
- 정책 상세 InfoRow/Divider 모듈

## 파일 구조 (추천)

```

lib/
└─ ui/
└─ components/
├─ policy_card.dart
├─ policy_tag.dart
├─ policy_empty_state.dart
├─ policy_skeleton_card.dart
├─ section_title.dart
├─ policy_cta_button.dart
├─ policy_info_row.dart

````

---

# 📁 **1) policy_card.dart (정책 카드 전체 파일)**

```dart
import 'package:flutter/material.dart';
import 'package:youth_road_app/theme/app_theme.dart';

class PolicyCard extends StatelessWidget {
  final String title;
  final String summary;
  final List<String> tags;
  final String period;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onShareTap;

  const PolicyCard({
    super.key,
    required this.title,
    required this.summary,
    required this.tags,
    required this.period,
    this.onTap,
    this.onFavoriteTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final policyTheme = Theme.of(context).extension<PolicyTheme>()!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
        onTap: onTap,
        child: Padding(
          padding: policyTheme.policyCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 아이콘 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: onFavoriteTap,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: onShareTap,
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 6),

              Text(
                summary,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),

              // 태그 영역
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: tags.map((e) => PolicyTag(label: e)).toList(),
              ),

              const SizedBox(height: 12),

              Text(
                period,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
````

---

# 📁 **2) policy_tag.dart (태그 UI)**

```dart
import 'package:flutter/material.dart';

class PolicyTag extends StatelessWidget {
  final String label;

  const PolicyTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final policyTheme = Theme.of(context).extension<PolicyTheme>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(policyTheme.policyTagRadius),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
```

---

# 📁 **3) policy_empty_state.dart (검색/필터 빈 화면 UI)**

```dart
import 'package:flutter/material.dart';

class PolicyEmptyState extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const PolicyEmptyState({
    super.key,
    required this.message,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pol = Theme.of(context).extension<PolicyTheme>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: pol.emptyStateIconColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: pol.emptyStateTextColor,
                  ),
            ),
            if (buttonText != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onButtonTap,
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

# 📁 **4) policy_skeleton_card.dart (로딩 Skeleton)**

```dart
import 'package:flutter/material.dart';

class PolicySkeletonCard extends StatelessWidget {
  const PolicySkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final policyTheme = Theme.of(context).extension<PolicyTheme>()!;

    Widget bar(double w, double h) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: scheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
        );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
      ),
      child: Padding(
        padding: policyTheme.policyCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bar(180, 18),
            const SizedBox(height: 10),
            bar(double.infinity, 14),
            const SizedBox(height: 6),
            bar(double.infinity, 14),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                bar(50, 20),
                bar(60, 20),
                bar(40, 20),
              ],
            ),
            const SizedBox(height: 16),
            bar(120, 12),
          ],
        ),
      ),
    );
  }
}
```

---

# 📁 **5) section_title.dart (섹션 타이틀 헤더)**

```dart
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme.titleMedium;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(title, style: text),
    );
  }
}
```

---

# 📁 **6) policy_cta_button.dart (정책 CTA 버튼)**

```dart
import 'package:flutter/material.dart';

class PolicyCtaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const PolicyCtaButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(text),
    );
  }
}
```

---

# 📁 **7) policy_info_row.dart (상세 정보 라벨/값 Row)**

```dart
import 'package:flutter/material.dart';

class PolicyInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const PolicyInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.bodyLarge;
    final valueStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: title)),
          Expanded(child: Text(value, style: valueStyle)),
        ],
      ),
    );
  }
}
```

---

# 🎉 **이 파일들로 무엇이 가능해지나? (효과)**

* 정책탐색 화면의 UI를 **디자인 시스템 100% 준수하는 형태로 통일**
* 기존 “난잡한 스타일” 제거 → 유지보수 난이도 급감
* 필터/검색/상세 화면 UI 제작 속도 **2~3배 증가**
* 정책 Skeleton, EmptyState, Tag 모두 통일된 톤
* 전반적인 UX가 “클린하고 모던한 정부/지자체 정책앱” 느낌으로 완성됨

---

# END OF TASK 302

```

---

```


---

# TASK 301

---

# 📌 TASK 301 — YouthRoad 글로벌 테마 정의 (Flutter ThemeData / ColorScheme 고퀄 버전)

````md
# TASK 301  
## YouthRoad 글로벌 테마 정의 (Flutter ThemeData / ColorScheme + ThemeExtension)  
### Status: OPEN  
### Owner: UI/UX Layer

---

## 1. 목적

- TASK 300에서 정의한 **디자인 시스템(색상, 타이포, 컴포넌트 규칙)**을
  Flutter `ThemeData`/`ColorScheme`/`ThemeExtension`으로 **일관되게 구현**한다.
- 추후 확장(다크 모드, 이벤트 색 추가 등)이 쉽도록 **레이어를 나눈 구조**로 설계한다.
  - Design Tokens (`AppColors`, `AppTextStyles`)
  - Material ColorScheme (`lightColorScheme`)
  - 컴포넌트 테마 (Card, Button, Chip, AppBar, BottomNav, Input 등)
  - 도메인 전용 ThemeExtension (`PolicyTheme`) — 정책 카드/태그/EmptyState에 특화

---

## 2. 적용 범위

- 앱 전역(특히 정책탐색 전 화면)
- 공통 UI 컴포넌트:
  - 카드, 버튼, 태그(Chip), BottomSheet, AppBar, BottomNavigationBar, Input
- 도메인 특화:
  - 정책 카드 영역 배경, EmptyState 색, 정책 태그 색 등

---

## 3. 전체 코드 (lib/theme/app_theme.dart)

```dart
// lib/theme/app_theme.dart
//
// YouthRoad App 글로벌 테마 정의
// - Design Tokens (색상/타이포)
// - Material ColorScheme
// - 컴포넌트 ThemeData
// - 도메인 전용 ThemeExtension (PolicyTheme)
//
// 기준 문서: TASK 300 – 디자인 시스템 정의

import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 1. Design Tokens (색상 / 타이포)
/// ---------------------------------------------------------------------------

/// 공통 컬러 정의 (TASK 300 기반)
class AppColors {
  const AppColors._();

  // Primary
  static const primary500 = Color(0xFF4A8BFF);
  static const primary600 = Color(0xFF3574E5);
  static const primaryLight = Color(0xFFEDF5FF);

  // Secondary
  static const secondary500 = Color(0xFF6C6CE5);

  // Neutral
  static const gray900 = Color(0xFF1A1A1A);
  static const gray700 = Color(0xFF333333);
  static const gray500 = Color(0xFF6B6B6B);
  static const gray300 = Color(0xFFD9D9D9);
  static const gray100 = Color(0xFFF3F3F3);
  static const gray50 = Color(0xFFFAFAFA);

  // Feedback
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFB300);
  static const error = Color(0xFFFF5252);
}

/// 텍스트 스타일 세트 (TASK 300 타이포 스펙)
class AppTextStyles {
  const AppTextStyles._();

  /// Title1: 20 / Bold / lh 1.3
  static const title1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// Title2: 18 / SemiBold / lh 1.3
  static const title2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Body1: 16 / Regular / lh 1.4
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Body2: 14 / Regular / lh 1.4
  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Caption: 12 / Regular / lh 1.3
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );
}

/// ---------------------------------------------------------------------------
/// 2. ColorScheme & TextTheme
/// ---------------------------------------------------------------------------

/// Light 모드 ColorScheme (Material 3 기준)
final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary500,
  onPrimary: Colors.white,
  primaryContainer: AppColors.primaryLight,
  onPrimaryContainer: AppColors.primary600,
  secondary: AppColors.secondary500,
  onSecondary: Colors.white,
  secondaryContainer: AppColors.primaryLight,
  onSecondaryContainer: AppColors.secondary500,
  error: AppColors.error,
  onError: Colors.white,
  errorContainer: AppColors.error.withOpacity(0.08),
  onErrorContainer: AppColors.error,
  background: AppColors.gray50,
  onBackground: AppColors.gray900,
  surface: Colors.white,
  onSurface: AppColors.gray900,
  surfaceVariant: AppColors.gray100,
  onSurfaceVariant: AppColors.gray700,
  outline: AppColors.gray300,
  outlineVariant: AppColors.gray100,
  shadow: Colors.black.withOpacity(0.12),
  scrim: Colors.black.withOpacity(0.32),
  inverseSurface: AppColors.gray900,
  onInverseSurface: AppColors.gray50,
  inversePrimary: AppColors.primary600,
);

/// 공통 TextTheme
final TextTheme appTextTheme = TextTheme(
  titleLarge: AppTextStyles.title1,
  titleMedium: AppTextStyles.title2,
  bodyLarge: AppTextStyles.body1,
  bodyMedium: AppTextStyles.body2,
  bodySmall: AppTextStyles.caption,
  labelLarge: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
  labelMedium: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
);

/// ---------------------------------------------------------------------------
/// 3. 도메인 전용 ThemeExtension (정책탐색 특화 토큰)
/// ---------------------------------------------------------------------------

/// 정책탐색 / 정책카드 / EmptyState 등에 사용하는 도메인 전용 토큰
@immutable
class PolicyTheme extends ThemeExtension<PolicyTheme> {
  const PolicyTheme({
    required this.policyCardRadius,
    required this.policyCardPadding,
    required this.policyTagRadius,
    required this.emptyStateIconColor,
    required this.emptyStateTextColor,
    required this.emptyStateBackgroundColor,
  });

  /// 정책 카드 모서리 둥글기
  final double policyCardRadius;

  /// 정책 카드 내부 padding
  final EdgeInsets policyCardPadding;

  /// 태그(Pill) 모서리 둥글기
  final double policyTagRadius;

  /// EmptyState 아이콘 색상
  final Color emptyStateIconColor;

  /// EmptyState 텍스트 색상
  final Color emptyStateTextColor;

  /// EmptyState 배경 색상
  final Color emptyStateBackgroundColor;

  @override
  PolicyTheme copyWith({
    double? policyCardRadius,
    EdgeInsets? policyCardPadding,
    double? policyTagRadius,
    Color? emptyStateIconColor,
    Color? emptyStateTextColor,
    Color? emptyStateBackgroundColor,
  }) {
    return PolicyTheme(
      policyCardRadius: policyCardRadius ?? this.policyCardRadius,
      policyCardPadding: policyCardPadding ?? this.policyCardPadding,
      policyTagRadius: policyTagRadius ?? this.policyTagRadius,
      emptyStateIconColor: emptyStateIconColor ?? this.emptyStateIconColor,
      emptyStateTextColor: emptyStateTextColor ?? this.emptyStateTextColor,
      emptyStateBackgroundColor:
          emptyStateBackgroundColor ?? this.emptyStateBackgroundColor,
    );
  }

  @override
  PolicyTheme lerp(ThemeExtension<PolicyTheme>? other, double t) {
    if (other is! PolicyTheme) return this;

    return PolicyTheme(
      policyCardRadius:
          lerpDouble(policyCardRadius, other.policyCardRadius, t),
      policyCardPadding:
          EdgeInsets.lerp(policyCardPadding, other.policyCardPadding, t) ??
              policyCardPadding,
      policyTagRadius: lerpDouble(policyTagRadius, other.policyTagRadius, t),
      emptyStateIconColor:
          Color.lerp(emptyStateIconColor, other.emptyStateIconColor, t) ??
              emptyStateIconColor,
      emptyStateTextColor:
          Color.lerp(emptyStateTextColor, other.emptyStateTextColor, t) ??
              emptyStateTextColor,
      emptyStateBackgroundColor: Color.lerp(
            emptyStateBackgroundColor,
            other.emptyStateBackgroundColor,
            t,
          ) ??
          emptyStateBackgroundColor,
    );
  }

  /// Light 모드 기본값
  static PolicyTheme light(ColorScheme scheme) => PolicyTheme(
        policyCardRadius: 16.0,
        policyCardPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        policyTagRadius: 14.0,
        emptyStateIconColor: scheme.primary,
        emptyStateTextColor: AppColors.gray500,
        emptyStateBackgroundColor: AppColors.gray50,
      );
}

double lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}

/// ---------------------------------------------------------------------------
/// 4. 컴포넌트별 Theme 빌더들
/// ---------------------------------------------------------------------------

CardTheme buildCardTheme(ColorScheme colorScheme, PolicyTheme policyTheme) {
  return CardTheme(
    color: colorScheme.surface,
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
    ),
    shadowColor: colorScheme.shadow,
  );
}

ElevatedButtonThemeData buildElevatedButtonTheme(ColorScheme colorScheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.body1.copyWith(
        fontWeight: FontWeight.w600,
      ),
      elevation: 1,
    ),
  );
}

OutlinedButtonThemeData buildOutlinedButtonTheme(ColorScheme colorScheme) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(44),
      side: BorderSide(color: colorScheme.outline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.body2.copyWith(
        fontWeight: FontWeight.w500,
      ),
      foregroundColor: colorScheme.onSurface,
    ),
  );
}

FilledButtonThemeData buildFilledButtonTheme(ColorScheme colorScheme) {
  return FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(44),
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.body2.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

IconButtonThemeData buildIconButtonTheme(ColorScheme colorScheme) {
  return IconButtonThemeData(
    style: IconButton.styleFrom(
      padding: const EdgeInsets.all(8),
      minimumSize: const Size(40, 40),
      shape: const CircleBorder(),
      foregroundColor: colorScheme.onSurfaceVariant,
    ),
  );
}

ChipThemeData buildChipTheme(ColorScheme colorScheme, PolicyTheme policyTheme) {
  return ChipThemeData(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    labelStyle: AppTextStyles.body2.copyWith(
      color: colorScheme.onSurfaceVariant,
    ),
    secondaryLabelStyle: AppTextStyles.body2.copyWith(
      color: colorScheme.primary,
    ),
    backgroundColor: AppColors.gray100,
    disabledColor: AppColors.gray100,
    selectedColor: colorScheme.primaryContainer,
    secondarySelectedColor: colorScheme.primaryContainer,
    checkmarkColor: colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(policyTheme.policyTagRadius),
      side: const BorderSide(color: AppColors.gray100),
    ),
    side: const BorderSide(color: AppColors.gray100),
    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
  );
}

AppBarTheme buildAppBarTheme(ColorScheme colorScheme) {
  return AppBarTheme(
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.title2.copyWith(
      color: colorScheme.onSurface,
    ),
    scrolledUnderElevation: 0,
  );
}

BottomNavigationBarThemeData buildBottomNavigationBarTheme(
  ColorScheme colorScheme,
) {
  return BottomNavigationBarThemeData(
    backgroundColor: colorScheme.surface,
    selectedItemColor: colorScheme.primary,
    unselectedItemColor: AppColors.gray500,
    selectedLabelStyle: AppTextStyles.caption.copyWith(
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: AppTextStyles.caption,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
    elevation: 8,
  );
}

InputDecorationTheme buildInputDecorationTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceVariant,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.gray100),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
    ),
    hintStyle: AppTextStyles.body2.copyWith(
      color: AppColors.gray500,
    ),
  );
}

/// ---------------------------------------------------------------------------
/// 5. 최종 ThemeData (AppTheme.light)
/// ---------------------------------------------------------------------------

class AppTheme {
  const AppTheme._();

  /// YouthRoad Light Theme
  static ThemeData light() {
    final colorScheme = lightColorScheme;
    final policyTheme = PolicyTheme.light(colorScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: appTextTheme.apply(
        bodyColor: colorScheme.onBackground,
        displayColor: colorScheme.onBackground,
      ),
      appBarTheme: buildAppBarTheme(colorScheme),
      cardTheme: buildCardTheme(colorScheme, policyTheme),
      elevatedButtonTheme: buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: buildOutlinedButtonTheme(colorScheme),
      iconButtonTheme: buildIconButtonTheme(colorScheme),
      chipTheme: buildChipTheme(colorScheme, policyTheme),
      bottomNavigationBarTheme: buildBottomNavigationBarTheme(colorScheme),
      inputDecorationTheme: buildInputDecorationTheme(colorScheme),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: AppTextStyles.title2.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTextStyles.body2.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTextStyles.body2.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerColor: AppColors.gray100,
      splashFactory: InkRipple.splashFactory,

      /// 도메인 전용 ThemeExtension 등록
      extensions: <ThemeExtension<dynamic>>[
        policyTheme,
      ],
    );
  }
}
````

---

## 4. 간단 사용 예시 (메모)

```dart
// 예: 정책 카드에서 PolicyTheme 활용
Widget build(BuildContext context) {
  final policyTheme = Theme.of(context).extension<PolicyTheme>()!;
  final scheme = Theme.of(context).colorScheme;

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
    ),
    child: Padding(
      padding: policyTheme.policyCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('정책 제목', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('요약 설명...', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Chip(
                label: const Text('청년'),
                backgroundColor: scheme.primaryContainer,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
```

---

# END OF TASK 301

```

---



# TASK 300

---

# 📌 **TASK 300 — 정책탐색 UI/UX 리디자인 + 와이어프레임 + 디자인 시스템 통합 문서**

```md
# TASK 300  
## 정책탐색 UI·UX 리디자인 + 화면별 와이어프레임 + 디자인 시스템 정의  
### Status: OPEN  
### Owner: UI/UX Layer

---

# 1. 🎨 UI/UX 리디자인 핵심 개선안

## 1-1) 정책 카드 디자인 개선
### 문제
- 텍스트 간격 불균형  
- 태그 정렬 불안정  
- 카드 여백/그림자/라운드 기준 불명확  
- 정보 위계 부족 → 한 덩어리처럼 보임

### 개선 방향
- padding 16px 통일  
- 제목 line-height 1.35  
- 태그 1줄 우선 / 초과 시 “··· 더보기”  
- 카드 radius 16px, shadow 2dp  
- 좋아요/공유 버튼 우상단 고정  
- 기간 텍스트 Gray500으로 톤 다운

---

## 1-2) 빈 화면(Empty State) UX 강화
### 문제
- 조건 충족 정책이 있어도 빈 화면 표시  
- 행동 유도 없음

### 개선
- 안내 문구 + ‘조건 완화’ 버튼  
- 추천 정책 3개 노출  
- 추천 키워드 태그 제공

---

## 1-3) 상단 탭 시각적 강조
### 개선
- 활성 탭: Bold + Primary + underline  
- 비활성: Gray 400  
- 탭 전환 애니메이션 120ms 적용

---

## 1-4) 검색 UX 전체 개편
### 개선
- 검색 전: 최근 검색어 / 추천 검색어 / 카테고리 추천  
- 검색 후: 검색 결과 리스트  
- 검색 실패 시 추천 키워드 + CTA 제공

---

## 1-5) 필터 BottomSheet 정보 구조 재배치
### 개선 구조
1) 모집여부/온라인여부 토글  
2) 지역  
3) 카테고리  
4) 기관  
5) 부서  
- 선택된 필터는 상단 Pill로 표시  
- Divider로 그룹 분리

---

## 1-6) 상세 화면 정보 구조 개선
### 개선
- Primary CTA 단독 배치  
  → [신청 페이지 열기]  
- 공유/좋아요/알림 버튼은 Secondary 그룹  
- 섹션별 제목 + Divider 추가  

---

## 1-7) 알림 UI 정돈
### 개선
- 옵션 버튼 2×2 Grid  
- 선택 시 Primary border  
- 성공 시 “알림이 예약되었습니다” 토스트

---

## 1-8) Skeleton UI 적용
### 개선
- 목록 skeleton 3~4  
- 상세 skeleton 2~3  
- 검색 결과 skeleton

---

## 1-9) 디자인 톤 일관화
- Primary / Secondary / Neutral 체계 확립  
- 화면 전체 동일 기준 적용

---

## 1-10) 하단 네비게이션 명확화
- 활성 탭: Primary  
- 비활성: Gray400  
- 아이콘/텍스트 통일 정렬

---

# 2. 🧩 화면별 와이어프레임 구조 정리 (텍스트 기반 구조도)

## 2-1) 전체 탭(정책 리스트)

```

[TopBar]
정책탐색  |  알림아이콘

[탭바]
추천 | 전체(선택) | 지역 | 검색 | 즐겨찾기

[검색바 + 필터버튼]

[카테고리 탭 (청년 / 주거 / 창업 등)]

[정책 카드 리스트]
┌────────────────────────┐
│ [제목]                 │
│ [요약내용 1~2줄]       │
│ [태그…]               │
│ [신청기간]             │
│ (♥ 공유 아이콘)        │
└────────────────────────┘
(Paging Loader)

```

---

## 2-2) 검색 탭

```

[검색바]

(검색 전)
최근 검색어
추천 검색어 태그
카테고리 기반 추천

(검색 중/후)
정책 리스트
EmptyState:
"검색 결과가 없습니다"
[추천 정책 보기]
추천 태그 리스트

```

---

## 2-3) 지역 탭

```

[지역 선택 태그: All / 서울 / 부산 / 경북 / ...]

[정책 카드 리스트 or EmptyState]

```

---

## 2-4) 정책 상세 화면

```

[상단]
정책 제목
태그
좋아요 / 공유 / 알림 버튼(Secondary)

[Primary CTA]
┌─────────────────────────┐
│  신청 페이지 열기        │
└─────────────────────────┘

[알림 옵션 (2×2)]
1일 전  |  3일 전
7일 전  |  당일

[섹션별 정보 구조]
──────────────────────────
지원내용 (Title)
내용 텍스트
──────────────────────────
접수기간
──────────────────────────
기관 / 부서 / 문의처
──────────────────────────

```

---

## 2-5) 필터 BottomSheet

```

[선택된 필터 Pill들]

[토글: 모집중만 / 온라인만]

──────────────────────────
[지역 선택]
──────────────────────────
[카테고리 선택]
──────────────────────────
[기관 선택]
──────────────────────────
[부서 선택]

[초기화]        [적용]

```

---

# 3. 🎨 디자인 시스템 정의  
(색상 / 타이포 / 컴포넌트 규칙)

## 3-1) 컬러 시스템

### Primary  
- Primary 500: #4A8BFF  
- Primary 600: #3574E5  
- Primary Light: #EDF5FF  

### Secondary  
- Secondary 500: #6C6CE5  

### Neutral  
- Gray900: #1A1A1A  
- Gray700: #333333  
- Gray500: #6B6B6B  
- Gray300: #D9D9D9  
- Gray100: #F3F3F3  
- Gray50:  #FAFAFA  

### Feedback  
- Success: #4CAF50  
- Error:   #FF5252  
- Warning: #FFB300  

---

## 3-2) 타이포그래피

| 용도 | 스타일 |
|------|--------|
| Title1 | 20px / Bold |
| Title2 | 18px / SemiBold |
| Body1 | 16px / Regular |
| Body2 | 14px / Regular |
| Caption | 12px / Regular |

line-height: 1.3 ~ 1.4

---

## 3-3) 컴포넌트 규칙

### 카드(Card)
- padding: 16  
- radius: 16  
- shadow: 2dp  
- gap: 8px  

### 태그(Tag)
- height: 28  
- radius: 14  
- padding-x: 12  
- bg: Gray100  
- selected: Primary Light + Primary Border  

### 버튼(Button)
- Primary: Filled, radius 12, height 48  
- Secondary: Outline, radius 12  
- IconButton: 40×40, circle  

### BottomSheet
- top radius: 24  
- section gap: 12~16  
- header + divider 포함

---

# 4. ✔ 기대 효과

- 정책 탐색 속도 및 성공률 증가  
- 화면 전체 톤·스타일 일관성 확보  
- 상세 페이지 접근률 상승  
- 검색·필터 활용도 증가  
- 앱 신뢰성과 완성도 대폭 향상  

---

# END OF TASK 300
```

---





# TASK 200

---

# 🟦 **TASK 200 — 정책탐색 기능 오류 전면 개선 (최상위 품질 한글 사양서)**

정책탐색 기능의 **검색·필터·지역·페이지네이션·상세 정보·URL 실행** 등 모든 핵심 기능이
현재 정상적으로 동작하지 않는 문제를 구조적으로 진단하고,
재발 가능성을 최소화하는 수준으로 전면 재정비하기 위한 기술 Task 문서입니다.

UX·UI 및 성능 최적화는 별도 Task로 분리하며,
TASK 200은 **오로지 기능 오류(fault) 제거**에 집중합니다.

---

```md
# TASK 200 — 정책탐색 기능 오류 전면 개선

정책탐색 화면 전반에서 발생하는 기능 오류(필터, 검색, 지역, 페이지네이션, 상세 정보 누락, 신청 페이지 링크 실패)를  
시스템 전체 흐름 단위에서 구조적으로 재정비하고,  
기능적 일관성을 보장하는 형태로 복원한다.  

본 문서의 모든 문구는 전부 한글로 표현하며,  
기능 오류 해결에 필요한 파일 경로, 처리 기준, 검증 기준을 모두 포함한다.

---

## 1. 문제 개요(Overview)

현재 정책탐색 기능에는 다음과 같은 기능적 장애들이 동시에 발생하고 있으며,  
이들 문제는 서로 다른 레이어(State · Repository · API · Model · UI)를 관통한다.

- 검색·필터 조합 시 정책 리스트가 항상 0개로 표시됨
- 지역 탭에서 결과가 존재하더라도 “0개”로 표시됨
- 페이지네이션이 작동하지 않거나 중복 호출됨
- 상세 화면의 “신청 페이지 열기” 기능이 전면 실패
- 일부 정책의 상세 필드가 UI에 표시되지 않음

이는 단일 버그가 아니라 **데이터 흐름 전체의 오류**로 판단되므로,  
전면적 재정비가 필요하다.

---

## 2. 작업 목표(Goals)

TASK 200 수행 완료 후 시스템이 만족해야 할 기준은 다음과 같다:

1) 검색·전체·지역·즐겨찾기 모든 탭에서 정책이 정상적으로 매칭된다  
2) 필터 조합(카테고리/태그/조건)이 정상적으로 작동해 올바른 결과가 출력된다  
3) 지역 선택 시 API·캐시·UI 모두에서 정상적으로 해당 지역의 정책이 표시된다  
4) 페이지네이션이 한 번의 스크롤 동작당 정확히 한 번만 실행된다  
5) 상세 화면의 “신청 페이지 열기” 버튼이 모든 정책에서 정상적으로 작동한다  
6) Domain Model 필드 누락 없이 상세 정보가 정확히 표시된다  

상기 6개 항목을 **모두 충족해야 TASK 200은 완료로 인정된다.**

---

## 3. 세부 기능 오류 분석(Functional Issue Breakdown)

### 3-1. 검색/필터 조합 시 결과가 표시되지 않는 문제
#### 현상
- 특정 필터를 선택하면 항상 “표시할 정책이 없습니다”로 표시됨  
- 실제 데이터에는 존재하는 정책임

#### 가능한 원인
- FilterState 초기값이 서버 요구 형식과 불일치  
- `null`·빈 문자열 파라미터가 API 요청을 무효화  
- 클라이언트 필터와 서버 필터가 충돌  
- Isar 캐시 필터 조건이 완전하지 않음  
- 필터 초기화 로직이 state를 완전히 reset하지 않음

#### 개선 방향
- 필터 모델에 **정상화(normalize)** 기능 추가  
- FilterStateProvider 초기 상태 체계 재정비  
- API 요청 파라미터 생성기를 별도 유틸로 분리하여 검증  
- 필터 변경 시 Repository의 페이지·리스트 초기화 수행

---

### 3-2. 지역(region) 탭 결과가 항상 0개로 표시되는 문제
#### 현상
- ‘경북’ 등 어떤 지역을 선택해도 결과가 0개

#### 가능한 원인
- UI에서 전달하는 지역 문자열이 API의 region 코드와 불일치  
- 서버 명세 region 값과 매핑되지 않는 내부 enum  
- 지역 정책이 복수 조건으로 구성될 가능성 미고려

#### 개선 방향
- 지역 코드 전용 enum + 매핑 테이블 생성  
- 서버 region 규칙을 1:1로 반영  
- Isar 캐싱 조건과 region 코드를 정확히 일치시킴

---

### 3-3. 페이지네이션(Paging) 동작 불가·중복 호출 문제
#### 현상
- 스크롤해도 추가 페이지가 로드되지 않음  
- 반대로 두 번씩 호출되는 경우 존재

#### 가능한 원인
- scroll threshold guard 중복  
- pageIndex 관리가 UI·Repository 모두에서 중복 처리  
- HybridPolicyRepository가 매 요청마다 재생성되는 구조  
- isLoadingNextPage의 race condition

#### 개선 방향
- 페이지 상태(pageIndex, hasNextPage)를 **Repository 단일 책임 구조**로 통합  
- UI에서는 상태 구독만 수행하도록 구조 단순화  
- 스크롤 guard 기준을 명확한 숫자로 고정(예: maxScrollExtent - 200)  
- 중복 호출 방지 로직 추가

---

### 3-4. 상세 화면의 “신청 페이지 열기” 기능 실패
#### 현상
- 항상 “링크를 열 수 없습니다” 오류 발생  
- SnackBar도 동일 메시지 반복

#### 가능한 원인
- applyUrl 값이 `null`, 빈 문자열 또는 비정상 URL  
- http → https 미전환  
- url_launcher 오류 처리 부재

#### 개선 방향
- URL 유효성 검사기(validator) 추가  
- https 강제 변환  
- 외부 브라우저 실패 시 webview fallback 마련  
- null URL에 대한 별도 사용자 안내 출력

---

### 3-5. 정책 상세 정보 누락 문제
#### 현상
- 기관명은 보이나 ‘대상’, ‘지원내용’, ‘기간’ 등이 일부 정책에서 표시되지 않음  
- API에는 존재하는 값

#### 가능한 원인
- Domain Model 필드 누락  
- fromJson-toDomain 매핑 중 key mismatch  
- UI 조건문이 null 값을 skip

#### 개선 방향
- 정책 상세 API 전체 스키마 재검증  
- Domain Model 필드 1:1 매핑  
- UI에서 null-safe 텍스트 출력 규칙 통일 (“정보 없음”)

---

## 4. 파일 단위 수정 지침(Required Changes by File)

### `lib/data/policy/policy_remote_source.dart`
- 필터 파라미터 빌드 로직 전면 재작성  
- 지역 코드 변환기(region mapper) 추가  
- applyUrl 문자열 정규화 수행

### `lib/data/repositories/hybrid_policy_repository.dart`
- 페이지 상태 관리(pageIndex, hasNextPage, isLoading) 단일화  
- 필터 변경 시 내부 데이터 초기화 로직 적용

### `lib/application/search/controllers/search_controller.dart`
- FilterState → APIRequest 변환 로직 분리 및 재정비  
- 필터 초기값 체계 정상화

### `lib/domain/policy/entities/policy.dart`
- 모든 API 필드 스키마를 재검증하고 누락 필드 추가  
- null-safe getter 적용

### `lib/ui/screens/policy/policy_list_v2_screen.dart`
- 스크롤 guard 로직 재작성  
- Repository 기반 pagination 흐름과 UI rebuild 흐름 정리

---

## 5. 작업 완료 판정 기준(Acceptance Criteria)

다음 항목들이 **모두 충족**되어야 TASK 200이 완료된 것이다.

- [ ] 검색 탭의 모든 태그 조합에서 정책이 올바르게 출력된다  
- [ ] 지역 탭에서 정책이 실제 존재하는 데이터와 일치해 출력된다  
- [ ] 페이지네이션이 중복 호출 없이 한 번씩만 실행된다  
- [ ] “신청 페이지 열기” 버튼이 정상 작동하여 외부 브라우저 또는 fallback이 열린다  
- [ ] 상세 정보의 모든 필드가 누락 없이 표시된다  
- [ ] 필터 초기화 시 전체 정책 목록이 정상적으로 재출력된다  
- [ ] 내부 로그에서 null 파라미터 오류가 발생하지 않는다  

---

## 6. 세부 작업(Subtasks)

- [ ] 필터 모델 정상화 함수 구현  
- [ ] 지역 코드 매핑 테이블 생성  
- [ ] API 요청 파라미터 빌더 작성  
- [ ] 페이지네이션 상태 단일 구조 구현  
- [ ] applyUrl Validator 및 fallback 로직 작성  
- [ ] Domain Model 필드 전체 보정  
- [ ] 상세 화면 null-safe 처리 룰 적용  
- [ ] 전체 회귀 테스트(검색·지역·상세·페이징 포함)

---

## 7. Codex 실행용 한글 슈퍼 명령 템플릿

```

@chatgpt-codex
작업 목적: 정책탐색 기능 오류 전체 해결 (TASK 200)
수행 항목:

1. 필터 → API 파라미터 변환 로직 재작성
2. 지역 코드 매핑 테이블 생성 후 전체 적용
3. 페이지네이션 상태 관리 구조를 Repository 단일 구조로 통합
4. applyUrl 유효성 검사 + fallback 처리
5. 정책 Domain Model 필드 전체 스키마 재검증 및 누락 필드 추가
6. 상세 정보 null-safe 처리
   수정 대상 파일:

* lib/data/policy/policy_remote_source.dart
* lib/data/repositories/hybrid_policy_repository.dart
* lib/application/search/controllers/search_controller.dart
* lib/domain/policy/entities/policy.dart
* lib/ui/screens/policy/policy_list_v2_screen.dart
  완료 기준:
* 검색·필터·지역·페이징·상세 정보·URL 기능 모두 정상 동작

```
```

# TASK 200 END





# TASK 103
실제 알림 스케줄러 부재: NoOpNotificationGateway만 존재해 OS 알림 예약/취소가 수행되지 않습니다. 플랫폼별 로컬 알림 플러그인 연동 구현체를 추가해 실제 스케줄링·권한 확인을 수행하도록 보완해야 합니다.

빌드 오류: BasePolicyFeedController에서 policyEventBusProvider가 정의되지 않아 Flutter 빌드가 실패하는 문제가 보고되었습니다. 해당 프로바이더 정의 또는 참조를 수정해 빌드 에러를 해소해야 합니다.

알림 환경 피드백 강화 필요: 서비스는 권한/환경 점검 후 실패 시 로그만 남기므로, UI에 권한 안내나 재시도 액션을 명시적으로 전달하는 처리(예: ReminderMutationResult 메시지 활용 확대)가 필요합니다.

만료/동기화 후 UI 연계: 만료 정리(cleanupExpiredReminders)와 동기화 결과를 화면에 표시하거나 토스트로 알리는 UX가 아직 정의되지 않았습니다. 이벤트 버스 발행 이후 UI 레벨에서 사용자 피드백을 추가하는 개선이 필요합니다.

# ERROR 03
lib/features/policy_new/application/gateways/notification_gateway_impl.dart:129:22: Error: Not a constant expression.
        isDuplicate: hadExisting,
                     ^^^^^^^^^^^
lib/features/policy_new/application/gateways/notification_gateway_impl.dart:140:22: Error: Not a constant expression.
        isDuplicate: hadExisting,
                     ^^^^^^^^^^^
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



# ERROR 02

lib/features/policy_new/presentation/reminder/policy_reminder_button.dart:337:13: Error: The type 'PolicyReminderStatus' is not exhaustively matched by the switch cases since it doesn't match 'PolicyReminderStatus.fired'.
 - 'PolicyReminderStatus' is from 'package:youth_road_app/features/policy_new/domain/values/policy_reminder_status.dart' ('lib/features/policy_new/domain/values/policy_reminder_status.dart').
Try adding a default case or cases that match 'PolicyReminderStatus.fired'.
    switch (status) {
            ^
lib/features/policy_new/presentation/reminder/policy_reminder_button.dart:348:22: Error: The type 'PolicyReminderStatus' is not exhaustively matched by the switch cases since it doesn't match 'PolicyReminderStatus.fired'.
 - 'PolicyReminderStatus' is from 'package:youth_road_app/features/policy_new/domain/values/policy_reminder_status.dart' ('lib/features/policy_new/domain/values/policy_reminder_status.dart').
Try adding a default case or cases that match 'PolicyReminderStatus.fired'.
    switch (reminder.status) {
                     ^
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

BUILD FAILED in 11s

# ERROR 01

lib/features/policy_new/presentation/reminder/policy_reminder_button.dart:337:13: Error: The type 'PolicyReminderStatus' is not exhaustively matched by the switch cases since it doesn't match 'PolicyReminderStatus.fired'.
 - 'PolicyReminderStatus' is from 'package:youth_road_app/features/policy_new/domain/values/policy_reminder_status.dart' ('lib/features/policy_new/domain/values/policy_reminder_status.dart').
Try adding a default case or cases that match 'PolicyReminderStatus.fired'.
    switch (status) {
            ^
lib/features/policy_new/presentation/reminder/policy_reminder_button.dart:348:22: Error: The type 'PolicyReminderStatus' is not exhaustively matched by the switch cases since it doesn't match 'PolicyReminderStatus.fired'.
 - 'PolicyReminderStatus' is from 'package:youth_road_app/features/policy_new/domain/values/policy_reminder_status.dart' ('lib/features/policy_new/domain/values/policy_reminder_status.dart').
Try adding a default case or cases that match 'PolicyReminderStatus.fired'.
    switch (reminder.status) {
                     ^
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


# TASK 100


## 미비점 및 개선 제안
1. **신청 기간 누락 시 즉시 예외 발생**: 스케줄러가 신청 시작/마감일이 비어 있으면 예외를 던져 호출 스택까지 전파되므로 UI에서 복구 불가능한 에러로 끝난다. 사용자 안내용 오류 메시지로 변환하거나, 알림 설정 버튼을 비활성화해 빈 일정 정책을 사전에 거르는 처리가 필요하다. 더 나아가 정책 상세/목록 단에서 신청 기간이 누락된 정책을 시각적으로 표시해, 사용자와 QA 모두가 데이터 품질 문제를 즉시 감지하도록 한다.
2. **취소 알림이 목록에서 완전히 사라짐**: 로컬 데이터 소스가 취소 상태를 모두 필터링해 버려 알림 센터에서 “취소됨” 상태를 확인하거나 복원할 수 없다. 취소 항목을 조회에 포함하고, 뷰에서 상태별 필터링·표시를 분리하는 편이 히스토리 보존과 UX에 유리하다. 기존 저장 데이터가 모두 필터링되어 왔다는 점을 감안해, 취소 상태를 남기는 스키마 전환 시 마이그레이션·정리 스크립트도 함께 제공하는 것이 안전하다.
3. **스케줄 실패 원인에 대한 UI 피드백 단절 가능성**: 알림 생성 중 게이트웨이 실패가 발생해도 `ReminderMutationResult.failures`가 비어 있으면 컨트롤러는 별도 메시지 없이 조용히 끝난다. 실패 목록이 없더라도 생성 요청이 하나도 성공하지 못한 경우 “예약되지 않음”과 같은 사용자 안내 메시지를 추가하는 것이 좋다. 또한 스케줄 실패의 상세 사유(권한 거부, 과거 시각, 플러그인 오류 등)를 텍스트로 변환해 토스트/다이얼로그로 노출하면 재시도 동선을 안내하기 용이하다.

# END OF TASK 100


# TASK 101
4. **알림 센터 낙관적 업데이트의 롤백 부재**: `NotificationCenterController`는 취소/삭제 작업을 낙관적으로 반영한 뒤 실패 시 이전 상태를 복원하지 않아 목록이 실제 저장소와 어긋날 수 있다. 실패 시 직전 스냅샷을 복원하거나 강제 재로딩하는 방어 로직이 필요하다. 취소/삭제 동작의 동시 실행이 중첩될 때도 큐 스냅샷이 꼬이지 않도록, 작업 ID 기반으로 결과를 매칭해 롤백 대상을 정확히 식별하는 절차를 추가하면 안정성이 높아진다.
5. **기기 권한/시간대 변화 대응 부족**: 알림 권한이 추후 철회되거나 기기 시간대가 변경될 때 재초기화 로직이 호출되지 않으면 예약이 실제와 어긋날 수 있다. 앱 포그라운드 진입 및 설정 변경 이벤트에서 알림 권한 재확인 → 실패 시 사용자 안내 → 필요하면 기존 예약을 재계산/재스케줄하는 흐름을 추가하는 것이 좋다.
6. **정책 스펙 변경 시 알림 갱신 미비**: 정책 데이터가 서버 동기화나 관리 도구 수정으로 시작/마감일이 바뀌어도 기존 예약이 그대로 남아 잘못된 시각에 울릴 수 있다. 정책 상세에서 새 데이터를 로드했을 때 기존 리마인더의 기준 일자를 비교해 자동 재계산/갱신하거나, 사용자에게 “일정이 바뀌었습니다. 알림을 재설정할까요?” 같은 확인 흐름을 제공하자.
7. **중복 알림 및 정합성 검증 부족**: 동일 정책·동일 시간 종류(`ReminderTimeKind`) 조합으로 중복 저장/예약이 발생하면 사용자에게 다중 알림이 울릴 수 있다. 저장 전에 정책 ID + 시간 종류를 유니크 키로 검증하고, 스케줄러가 반환하는 `ScheduleResult`에 중복 여부를 명시해 컨트롤러가 즉시 정리하도록 한다.

# END OF TASK 101


# TASK 102
8. **플랫폼 오류 대비 부족**: 현 구현은 플러그인 초기화 및 권한 요청 실패를 `ScheduleResult`로만 반환하며 재시도 정책이나 백오프 전략이 없다. 초기화 실패 시 일정 시간 후 재시도하거나, 네트워크·권한 상태가 회복될 때까지 예약을 지연하는 큐를 두면 안정성이 올라간다. 또한 알림 실패 로그를 수집·분석하는 경로(예: Crashlytics 커스텀 로깅, 내부 통계 수집)를 마련해 운영 중 문제를 빠르게 감지하도록 한다.
9. **테스트 커버리지 공백**: 스케줄러, 서비스, 컨트롤러가 시간대·권한·스케줄 실패 등 다양한 분기와 실패 경로를 포함하는데 단위/통합 테스트가 확인되지 않는다. 신청 기간 누락, 과거 시각, 권한 거부, 중복 요청, 알림 재계산, 낙관적 업데이트 롤백 등 핵심 시나리오를 테스트로 고정해 회귀를 방지하고, 알림 스케줄 계산에 타임존 변환을 강제하는 테스트 데이터를 포함하자.
10. **데이터 정합성 및 클린업 시나리오 미흡**: 앱 삭제/재설치, 로컬 DB 정리, 혹은 플랫폼별 알림 스케줄 데이터가 독립적으로 제거되는 경우(설정 초기화 등) 저장소와 실제 스케줄 상태가 불일치할 수 있다. 앱 시작 시 DB와 플랫폼 스케줄 목록을 비교·조정하는 헬스체크 절차(없는 스케줄은 복구하거나, 고아 레코드는 정리)를 넣고, 장시간 미사용 계정의 오래된 알림을 주기적으로 정리하는 백그라운드 작업도 고려하자.
# END OF TASK 102


⸻

💠 TASK 30~33 (업데이트된 번호) — FULL SPEC / job01급 최상위 퀄리티

@chatgpt-codex
###############################################################
# TASK 30 — Scheduling Feedback Result 모델 설계 (Domain 기반)
###############################################################

## 0) 시스템 정의 (System Definition)
YouthRoad의 알림 스케줄링 동작은 다음 두 단계를 거친다:
1. 서비스 레이어에서 알림 예약/취소(업데이트) 명령을 NotificationGateway로 전달
2. Device 플랫폼(flutter_local_notifications)이 명령의 성공/실패 상태를 반환

TASK 30의 목표는 이 흐름을 안정적으로 다루기 위한  
**Result 모델(스케줄링 피드백 모델)을 Domain에 정식 정의**하는 것이다.

---

## 1) 문제 정의 (Problem Statement)

현 구조는 다음 문제를 가진다:
- 스케줄링 명령 성공/실패 여부를 구분할 Path가 없음
- Gateway에서 실패해도 Repository에는 성공으로 기록됨
- Domain/Service/UI 계층이 동일한 실패 원인 정보 공유 불가
- 플랫폼별 Exception 케이스(iOS/Android 차이)를 수용할 모델 구조 부재

따라서 **도메인 수준의 SchedulingResult 모델 없이는 안정성 확보 불가**.

---

## 2) 요구사항 분석 (Requirements)

### 기능 요구사항
- 알림 예약/취소 명령의 결과(성공/실패)를 구조적으로 표현
- 실패 이유 코드 / 메시지 포함
- 실패 원인 분류:
  - PlatformError
  - PermissionDenied
  - InvalidDate
  - DuplicateId
  - UnknownError
- UI 레이어에 결과 전달 가능해야 함

### 비기능 요구사항
- JSON 직렬화 필요 없음 → 로컬 Domain 전용 모델
- 모든 플랫폼 공통 오류 케이스를 포괄하는 상위 구조 필요

---

## 3) 아키텍처 설계

### 3.1 Domain 모델 구조

SchedulingResult
├─ success: bool
├─ error?: SchedulingError
SchedulingError
├─ code: SchedulingErrorCode
├─ message: String
SchedulingErrorCode (enum)
├─ platform_error
├─ permission_denied
├─ invalid_date
├─ duplicate_id
├─ unknown

---

## 4) Provider/Service 상호작용 규칙

- NotificationGateway.schedule() / cancel() → SchedulingResult 반환
- PolicyReminderService.upsertReminder()는 SchedulingResult를 항상 검사
- 실패 시 Repository에 저장 금지 + UI에 error message 제공
- UI는 Optimistic Update를 하지 않고, SchedulingResult.success 를 기준으로 갱신

---

## 5) UI 상태도 (State Machine)

[Idle]
↓ (User taps “Add Reminder”)
[Submitting]
↓ Gateway.schedule()
→ Success → [SuccessToast] → [Idle]
→ Failure → [ErrorSnackBar(error.message)] → [Idle]

---

## 6) 파일 구조

lib/
└ domain/
└ reminder/
├─ scheduling_result.dart
└─ scheduling_error.dart

---

## 7) Acceptance Criteria

- SchedulingResult, SchedulingError, SchedulingErrorCode 3단 구조 구현
- 모든 Gateway에서 SchedulingResult를 반환
- Service 레이어는 성공/실패를 기반으로 Repository 동작을 제어
- UI는 성공/실패 피드백을 정확히 구분해 처리


⸻

⸻

💠 TASK 31 — 영속화 구조 Isar로 완전 교체 (Persistence Layer Upgrade)

@chatgpt-codex
###############################################################
# TASK 31 — 알림 영속화 구조를 Isar 기반으로 완전 교체
###############################################################

## 0) 시스템 정의
기존 알림 저장소는 메모리 기반 Mock 구조이며,
지속성이 없고 앱 재시작 시 모든 알림이 소실된다.

TASK 31의 목적은 **정책 알림 전체 데이터(옵션별 Multi Reminder 포함)를 Isar 로컬 DB에 정식 저장**하는 구조를 수립하는 것.

---

## 1) 문제 정의
- 알림 기록이 저장되지 않음 (메모리 기반)
- 앱 재시작 시 알림 정보 모두 삭제
- 다중 알림 옵션 저장 불가
- 스케줄링 이력 추적 불가

→ 실 서비스가 불가능한 구조.

---

## 2) 요구사항 분석

### 기능 요구사항
- 각 정책당 다수의 알림 옵션 저장
- 저장 필드:
  - reminderId (고유키)
  - policyId
  - scheduledAt
  - createdAt
  - option (D-7, D-1, 마감일 등)
  - status (scheduled/cancelled/failed)
- CRUD + 전체 조회 + 정책별 조회 기능 제공

### 비기능 요구사항
- Isar index 최적화
- 정책 ID + 옵션 조합으로 Unique Index 보장
- Migration 고려한 모델 구성

---

## 3) 아키텍처 설계

### 3.1 Isar 모델

IsarPolicyReminder {
int id;                     // 자동 PK
String reminderId;          // 알림 고유 ID (정책ID+옵션+timestamp 조합)
String policyId;
String option;
DateTime scheduledAt;
DateTime createdAt;
String status;              // scheduled / cancelled / failed
}

### 3.2 Repository 역할

PolicyReminderRepositoryIsarImpl
├─ save(IsarPolicyReminder)
├─ delete(reminderId)
├─ getByPolicyId(policyId)
├─ getAll()
└─ purgeExpired()

---

## 4) 데이터 파이프라인/흐름도

(UI)
↓ user selects reminder option
(Service)
↓ create reminderId + scheduledAt
(Repository)
↓ save to Isar
(Gateway)
↓ schedule notification
(Repository)
↓ update status

---

## 5) 파일 구조

lib/data/reminder/
├─ isar/
│   ├─ isar_policy_reminder.dart
│   └─ policy_reminder_repository_isar.dart
└─ mapper/
└─ policy_reminder_mapper.dart

---

## 6) Acceptance Criteria
- Isar 모델 정의 완료
- 기존 MemoryRepository 완전 제거
- 모든 CRUD Isar 기반으로 작동
- 앱 재시작 시 알림 데이터 복원
- multi-reminder 저장 가능


⸻

⸻

💠 TASK 32 — 알림 센터 상태머신 개선 (Optimistic UI + 오류 복구)

@chatgpt-codex
###############################################################
# TASK 32 — 알림 센터 상태머신 개선 (Optimistic UI + Error Recovery)
###############################################################

## 0) 시스템 정의
알림 관리 화면(Reminder Center)은 알림의 상태 변화(예약/취소/오류)를 즉시 사용자에게 반영해야 한다.  
그러나 실제 스케줄링은 Gateway 결과를 기다려야 하므로  
UI/Service/Gateway 간의 비동기 차이를 흡수하는 “상태머신(State Machine)”이 필요하다.

---

## 1) 문제 정의
- 예약 버튼 누르자마자 UI 반영 vs 실제 성공 시점의 불일치
- 실패 시 롤백 처리가 없음
- 스케줄링 지연 발생 시 UI 멈춤 현상
- 상태 동기화 부재

---

## 2) 요구사항 분석

### 기능 요구:
- Optimistic UI 지원
- 실패 시 롤백
- Gateway Pending 상태 표시
- Repository 업데이트 지연을 UI가 핸들링

### 비기능 요구:
- 재시도( retry ) 지원
- 플랫폼 타임존 차이 처리
- EventBus 연동

---

## 3) 아키텍처 설계

### 3.1 상태 정의

ReminderUiState
├─ idle
├─ submitting (pending scheduling)
├─ success (scheduled)
├─ failed(error)
├─ rollingBack (when optimistic UI must revert)

### 3.2 상태 전이도

idle
→ submitting
→ success → idle
→ failed → rollingBack → idle

---

## 4) Provider/Controller 상호작용 규칙

- UI → ReminderController.requestSchedule(policy, option)
- Controller → Optimistic UI 적용 즉시 UI 업데이트
- Controller → Gateway.schedule()
- Controller → SchedulingResult 검사
- 실패 시:
  - 상태 → failed → rollingBack
  - Repository에서 삭제 or 이전 상태 복구

---

## 5) Acceptance Criteria

- 상태머신 5단계 구현
- 실패 시 UI 롤백 동작 구현
- EventBus로 다른 화면도 즉시 변경 반영
- Pending indicator 지원
- Gateway 결과와 Repository 반영 순서 보장


⸻

⸻

💠 TASK 33 — 정책명/옵션 기반 알림 상세 UI 확장 (Detail Model Upgrade)

@chatgpt-codex
###############################################################
# TASK 33 — 정책명/옵션 포함한 알림 상세 UI 확장을 위한 모델 정식 정의
###############################################################

## 0) 시스템 정의
알림 관리 화면(UI)은 정책명, 알림 옵션(D-7/D-1/마감일), 예정 시간 등을  
정확한 Domain 모델에 기반해 표현해야 한다.

TASK 33의 목표는 기존 간소한 Reminder 모델을  
**정책 정보 + 옵션 정보 + 실 예약 상태를 모두 포괄하는 강력한 확장 모델**로 재정의하는 것.

---

## 1) 문제 정의
- 현재 모델은 policyId와 scheduledAt만 보유
- UI는 정책명/기관/옵션/상세 링크 등 표시 불가능
- 다중 알림 옵션을 구분할 수 있는 구조 부재
- PolicyModel과 ReminderModel 간 Domain 연동 없음

---

## 2) 요구사항 분석

### 기능:
- 알림 상세 정보 완전 표시:
  - 정책명
  - 기관명/정책 분류
  - 알림 옵션 이름 (예: 신청 마감 3일 전)
  - 알림 ID
  - 실제 예약된 시간
  - 상태(scheduled/cancelled/failed)

### 비기능:
- Repository 레벨에서 PolicySnapshot 저장 필요 (정책 삭제 대비)
- UI 렌더링 최적화

---

## 3) 아키텍처 설계

### 3.1 Unified Domain Model

PolicyReminderDetail {
String reminderId;
String policyId;
String policyTitle;
String? organizationName;
String optionName;         // ex: D-7, D-1, 당일
DateTime scheduledAt;
String status;             // scheduled/cancelled/failed
String? policyDetailUrl;   // 정책 페이지 이동 링크
}

### 3.2 Snapshot 저장 전략
Isar DB에 정책명/기관/URL 등을 “스냅샷”으로 저장  
→ 정책 API 변경/삭제 시에도 알림 기록 유지

---

## 4) 파일 구조

lib/domain/reminder/
├─ policy_reminder_detail.dart
lib/data/reminder/
├─ isar_policy_reminder_detail.dart
└─ mapper/
└─ policy_reminder_detail_mapper.dart

---

## 5) Acceptance Criteria
- 정책명/기관/URL을 포함한 Snapshot 기반 모델 추가
- 알림 UI에서 모든 정보 표시 가능해야 함
- D-7/D-1/Custom 옵션명 노출
- Repository 레이어에 Snapshot 저장
- 기존 ReminderModel과 충돌 없어야 함


⸻


@chatgpt-codex
# Task 29 — YouthRoad Notification System QA & Stability Architecture (Full Spec)
# (job01 스타일 완전판 설계 문서)

────────────────────────────────────────
1. 시스템 정의 (System Definition)
────────────────────────────────────────

YouthRoad의 정책 알림 시스템은
사용자가 관심 있는 정책의 모집 시작/마감일 또는 특정 D-day 시점에
정확한 시점·타임존·옵션 기준으로 모바일 기기에 로컬 알림을 예약/취소/변경할 수 있도록 설계된
**클라이언트 기반 스케줄링 시스템**이다.

본 Task 29는 *Task 13~28까지 설계된 기능들이 실제 서비스 수준에서 정상 동작하기 위한*
**품질 보증(QA)·안정성·신뢰성 아키텍처를 구축하는 것**을 목표로 한다.

본 시스템은 아래 조건을 반드시 만족해야 한다:

- Cross-platform 안정성(Android / iOS)
- 영속적 저장(Isar)
- 플랫폼 스케줄링 엔진과의 정확한 매핑(flutter_local_notifications)
- 다중 알림 옵션 및 고유 ID 전략
- 타임존 불변성 유지
- 멀티스레드 환경에서 Race Condition 방지
- Optimistic UI, Offline-safe 동작
- 앱 재시작 이후 일관성 복원

────────────────────────────────────────
2. 문제 정의 (Problem Statement)
────────────────────────────────────────

Task 29가 해결해야 할 핵심 문제는 다음과 같다:

1) **스케줄링 흐름 전체가 통합 테스트 없이 산발적 구현으로 존재**  
   - Task 14~28까지 각 기능은 설계되었으나, 전체 흐름을 통합 테스트한 구조가 부재
   - API 스펙, 스케줄링 엔진, Isar 영속화, UI 상태 업데이트 간 상호작용 규칙이 문서화되어 있지 않음

2) **실제 모바일 환경(iOS/Android)에 대한 신뢰성 확보 불가**  
   - 디바이스 재부팅, 앱 재설치, 시간 변경, 배터리 최적화 영향을 고려하지 않은 상태
   - ID 충돌, 리마인더 이중 예약, 취소 실패, 플랫폼 Permission 문제 미비

3) **장기 실행 안정성(Resilience)에 대한 아키텍처 정의 부족**  
   - “예약 → 저장 → UI 업데이트 → 앱 재시작 → 재동기화 → firing → post-processing”  
     이 전체 사이클에 대한 공식 흐름도 없음

4) **정책 변경 또는 사용자 프로필 변경 시 알림 유지 전략 미정**  
   - 정책 모집 기간이 변경된 경우 → 알림 자동 재계산?
   - 사용자가 지역/연령을 변경한 경우 → 기존 알림의 처리?

Task29는 이 모든 문제를 해결하기 위한 “최종 QA + 안정성 설계 문서”가 된다.

────────────────────────────────────────
3. 요구사항 분석 (Requirement Specification)
────────────────────────────────────────

본 시스템이 반드시 충족해야 하는 요구사항:

### Functional Requirements
- [FR01] 알림 예약/취소 시 Isar에 즉시 영속화
- [FR02] 알림 firing 시 알림 센터에서 상태 갱신 (fired / expired)
- [FR03] 앱 재시작 시 모든 알림을 플랫폼 스케줄링 엔진과 재동기화
- [FR04] 알림 옵션(D-7, D-3, D-1, 당일 등)을 다중 지원
- [FR05] 정책 상세 화면에서 알림 설정/취소 UI 일관
- [FR06] 알림 클릭 시 정책 상세 화면으로 이동

### Non-Functional Requirements
- [NFR01] Race Condition 방지(동시에 여러 알림 설정)
- [NFR02] Offline-safe (인터넷 없이도 정상 예약/취소)
- [NFR03] iOS/Android 모두에서 Timezone-safe
- [NFR04] 10,000개 이상의 알림도 성능 보장
- [NFR05] 디바이스 재부팅/앱 재시작 후 상태 일관성 유지
- [NFR06] 실패 리포팅 체계(에러 로깅, Crash 대응)

────────────────────────────────────────
4. 아키텍처 설계 (Architecture Design)
────────────────────────────────────────

본 Task 29는 아래 3가지 레이어를 모두 아우르는 통합 아키텍처 문서를 제공한다:

### (1) Domain Layer
도메인 모델:
- NotificationReminder
- NotificationOption
- NotificationStatus
- TimezoneRules
- ReminderId (policyId + option + timestamp 기반)

### (2) Data Layer
- Isar 기반 repository  
- 스케줄링 결과(Result Model) 기록  
- fired 이벤트 기록 테이블  
- 정책 변경 감지 후 알림 재계산 트리거  

### (3) Application Layer
컨트롤러 흐름:
1. UI → ReminderService.setReminder()
2. ReminderService → IdFactory.generateId()
3. ReminderService → Repository.save()
4. ReminderService → PlatformGateway.schedule()
5. 성공 시 EventBus → UI 갱신
6. 실패 시 rollback (Optimistic UI)

### (4) Presentation Layer
- Optimistic UI 구성  
- “예약 중 / 예약됨 / 실패 / 취소됨” 상태머신  
- 정책 상세 화면 with 알림 토글  
- 알림 목록 UI (정렬: 정책명 / 날짜 / 옵션)

────────────────────────────────────────
5. 데이터 파이프라인 / 흐름도 (Data Pipeline & Flow)

[User Action]
|
v
[UI: Reminder Toggle]
|
v
[ReminderController]
|
v
[ReminderService]
├─ validateRequest()
├─ buildReminderModel()
├─ generateReminderId()
├─ repo.save()
├─ platform.schedule()
└─ logResult()
|
v
[Isar Storage]
|
v
[EventBus.emit(ReminderUpdated)]
|
v
[UI Rebuild]

재시작 흐름:

[App Restart]
|
v
[SyncService.startupSync()]
|
v
[Isar.loadAllReminders()]
|
v
[Platform.scheduleAllPending()]
|
v
[UI Refresh]

────────────────────────────────────────
6. Provider / Controller 상호작용 규칙

UI → ReminderController → ReminderService → Repository
↘ PlatformGateway
Repository → EventBus → UI StateNotifier → UI

규칙:
- Controller는 Repository에 직접 접근하지만 PlatformGateway에는 Service를 통해서만 접근
- UI는 절대 Repository 직접 접근 금지
- 이벤트 처리는 EventBus 단일 경로만 허용

────────────────────────────────────────
7. UI 상태도 (UI State Machine)

알림 UI 상태:

IDLE
|  
|   
SET_REQUESTED
| (success)
v
SET_CONFIRMED
| (cancel)
v
CANCEL_REQUESTED
| (success)
v
CANCEL_CONFIRMED
| (error)
v
ERROR → retry?

────────────────────────────────────────
8. 이벤트 흐름 (Event Flow)

알림 관련 주요 이벤트:

- ReminderCreated
- ReminderCanceled
- ReminderFired
- ReminderSyncCompleted
- ReminderErrorOccurred

UI는 EventBus를 통해 즉시 반응하여 Optimistic UI를 유지.

────────────────────────────────────────
9. 파일 구조 (File Structure)

lib/features/reminder/
domain/
reminder.dart
reminder_option.dart
reminder_status.dart
reminder_id.dart
data/
reminder_repository.dart
reminder_repository_isar.dart
application/
reminder_service.dart
reminder_sync_service.dart
id_factory.dart
reminder_controller.dart
presentation/
reminder_center_screen.dart
reminder_tile.dart
reminder_option_selector.dart
reminder_toggle_button.dart

────────────────────────────────────────
10. Acceptance Criteria (AC)

- [AC01] 스케줄링 + 저장 + UI 반영이 end-to-end로 테스트 가능할 것
- [AC02] 디바이스 재부팅 후 reminder sync 정상 수행
- [AC03] 모든 로직이 Timezone-safe 처리
- [AC04] policyId + option 조합 ID 중복 없음
- [AC05] Optimistic UI가 실패 시 rollback 가능
- [AC06] 1000개 이상 알림 등록 시에도 성능 저하 없음
- [AC07] iOS/Android 실기기에서 firing 정상 동작
- [AC08] 에러 발생 시 EventBus → UI 반영까지 일관성 유지


⸻



⸻

💎 최종 완성본 — Task 25~28 (Ultra-High Spec)

────────────────────────────────────────
📘 Task 25 — Scheduling Result 모델 설계 (Feedback Loop Model)
────────────────────────────────────────

# 1. System Definition
YouthRoad 알림 시스템은 “예약/취소/변경” 같은 Scheduling 동작 후,
UI·상태머신·저장소가 서로 정확히 반영되려면 “스케줄링 결과 모델(Result)”이 필요하다.
현재는 boolean 또는 void 기반으로 처리되어 일관된 피드백 구조가 없다.

# 2. Problem Statement
- 알림 예약 성공/실패 여부가 일관된 구조로 반환되지 않음.
- 네이티브 Gateway(flutter_local_notifications) → Repository → Controller → UI 흐름을 통합하는 결과 모델 부재.
- 실패 사유 명세 없음 → 디버깅 불가.
- 여러 알림을 동시에 수행할 때 개별 결과 추적 불가.

# 3. Requirements
- 모든 Scheduling 동작은 Result 객체를 반환해야 한다.
- Result는 success/failure 상태와 상세 사유를 포함해야 한다.
- UI는 Result를 기반으로 Optimistic Update를 수행할 수 있어야 한다.
- Repository, Domain, Gateway 계층 모두에서 공통으로 사용하는 표준 모델이어야 한다.

# 4. Architecture
**Domain Value Object: ScheduleResult**

class ScheduleResult {
final bool success;
final ScheduleFailure? failure;
final String? localNotificationId;
final DateTime? scheduledAt;
}

**Failure 모델**

enum ScheduleFailureType {
invalidDate,
permissionDenied,
gatewayError,
idCollision,
unknown,
}
class ScheduleFailure {
final ScheduleFailureType type;
final String message;
}

# 5. Data Flow / Pipeline

UI → Controller → ReminderService → NotificationGateway → (native scheduling)
↓
←———————— ScheduleResult —————————→

# 6. Provider / Controller Interaction Rules
- Controller는 항상 `Future<ScheduleResult>`를 받아 UI 업데이트 수행.
- 실패 시 Failure 내용을 그대로 UI에 전달.
- 모든 스케줄 동작은 Transactional: 저장소 반영은 성공 시에만 수행.

# 7. Acceptance Criteria
- Scheduling 관련 모든 public method가 ScheduleResult 반환.
- 실패 사유가 표준화된 Enum으로 분류됨.
- Gateway, Repository, Controller, UI 계층에서 단일 Result 모델 사용.
- log/analytics는 ScheduleResult 기반으로 일관 기록.


────────────────────────────────────────
📘 Task 26 — 알림 영속화 구조 Isar로 완전 교체 (Full Persistence Rewrite)
────────────────────────────────────────

# 1. System Definition
기존 알림 저장소는 In-Memory or SharedPreferences 기반으로 설계되어 있으며,
멀티 알림/복원/삭제/옵션 관리가 불가능하다.
Task26에서는 영속 계층을 완전히 Isar 기반 구조로 재설계한다.

# 2. Problem Statement
- 앱 재시작 시 알림 데이터 전부 소실.
- 정책당 여러 알림 저장 불가.
- 삭제/변경/복원 기능 없음.
- 알림 옵션의 상세 데이터가 DB에 저장되지 않음.
- 구조적으로 확장 불가.

# 3. Requirements
- 정책 1개에 0~N개의 알림을 저장할 수 있어야 한다.
- 알림 ID, policyId, 옵션, 예정시간, 상태(active/cancelled) 저장.
- Isar Collection 1:N 구조를 가져야 한다.
- App 시작 시 DB → 메모리 로 복원.
- 스케줄 성공 시 DB에 반영, 실패 시 롤백.

# 4. Architecture
**Isar Collection Structure**

@collection
class ReminderEntity {
Id id = Isar.autoIncrement;
late String policyId;
late String localNotificationId;
late DateTime scheduledAt;
late String optionCode; // ‘D-1’, ‘D-7’, custom
late bool isActive;
late DateTime createdAt;
DateTime? cancelledAt;
}

**Repository Methods**

Future<List> getByPolicy(String policyId)
Future add(ReminderEntity entity)
Future markCancelled(String localNotificationId)
Future delete(String localNotificationId)

# 5. Data Flow / Pipeline

Controller → ReminderService
ReminderService → NotificationGateway.schedule()
↓ returns ScheduleResult
If success → save to Isar
If failure → do NOT save

# 6. Interaction Rules
- UI는 always Repository → Entity → Domain 변환을 통해서만 읽는다.
- 삭제/취소 요청 시 Gateway → Result → DB 업데이트 순으로 처리한다.
- Option(D-1, D-7 등)은 DB에 문자열로 저장하되, Domain에서는 enum 변환.

# 7. Acceptance Criteria
- InMemory 구현 완전 제거.
- 모든 CRUD가 Isar 기반.
- 앱 재시작 후 알림 목록 정확히 복원.
- 다중 알림 저장/조회 가능.


────────────────────────────────────────
📘 Task 27 — 알림 센터 상태머신 개선 (Optimistic UI + Multi-State)
────────────────────────────────────────

# 1. System Definition
기존 알림 UI는 단일 상태(loading, loaded)로 단순 운영됨.
다중 알림·스케줄링·취소 등 비동기 이벤트가 들어올 때 상태 일관성이 깨짐.
Task27은 “알림 센터 상태머신(State Machine)”를 완전히 재설계한다.

# 2. Problem Statement
- 스케줄 응답 지연 시 UI 정합성 깨짐.
- Action 실패 시 rollback 처리 없음.
- Optimistic Update 지원되지 않음.
- multiple reminders → race condition 발생.

# 3. Requirements
- 모든 상태는 다음 중 하나여야 함:
  - idle
  - loading
  - optimisticMutating
  - success
  - failure(retryable)
- optimistic update 가능해야 함.
- rollback 규칙 존재해야 함.
- action queue 기반으로 비동기 이벤트 순서를 보장해야 함.

# 4. Architecture
**State Model**

class ReminderCenterState {
final List reminders;
final bool isLoading;
final bool isOptimistic;
final ReminderFailure? error;
}

**ActionQueue**

enqueue(Action)
process next when previous complete
Action:
	•	schedule
	•	cancel
	•	delete
	•	reload

# 5. Data Flow

UI → ActionQueue → Service → Gateway → Result → StateReducer → UI

Optimistic Flow:

user taps → optimistic state apply → gateway call →
if success → commit
if failure → rollback + UI notify

# 6. Acceptance Criteria
- Optimistic UI 동작: 알림 추가/삭제가 즉시 UI에 반영됨.
- 실패 시 롤백 정확히 동작.
- ActionQueue가 race condition을 방지.
- 로딩/성공/실패/optimistic 상태 구분 정확.


────────────────────────────────────────
📘 Task 28 — 정책명·옵션 기반 상세 UI 확장 (Detail View Enrichment)
────────────────────────────────────────

# 1. System Definition
기존 정책 상세 페이지에는 알림 관련 정보를 충분히 표현하지 못함.
Task28은 정책 상세에서 알림 옵션(D-1, D-3, D-7 등), 현재 등록된 알림 목록,
정책 정보 기반 UX를 강화하는 작업이다.

# 2. Problem Statement
- 정책 상세 화면에 “현재 설정된 알림들” 표시되지 않음.
- 알림 옵션 목록 UI 없음.
- 정책별 알림 현황 파악 불가.
- D-1/D-7 등 옵션을 직관적으로 선택할 수 없음.
- 멀티 알림 구조가 반영되지 않음.

# 3. Requirements
- 정책 상세 화면에 현재 이 정책에 설정된 reminders 목록 표시.
- 옵션 선택 컴포넌트 제공 (Segmented / Chips / BottomSheet).
- “알림 등록 → optimistic → commit” UI 흐름 지원.
- “알림 취소/변경” 기능 지원.

# 4. Architecture
**UI 구성**

PolicyDetailScreen
├─ Header(정책 제목, 기관)
├─ Description
├─ ReminderSection
│    ├─ ExistingReminderList
│    ├─ AddReminderOptions(D-1, D-3, D-7, Custom)
│    └─ Remove / Modify actions
└─ Apply URL Button

**State Source**
- reminderCenterProvider(policyId)
- policyRepositoryProvider.fetchDetail(policyId)

# 5. Interaction Rules
- 옵션 선택 시 → optimistic insert → gateway 결과 확인
- 삭제 시 → optimistic remove → commit or rollback
- 정책 상세 화면은 reminderCenterProvider(policyId)를 watch

# 6. Acceptance Criteria
- 정책 상세 화면에서 알림 목록 표시됨.
- 각 옵션(D-1/3/7) 선택 가능.
- optimistic UI 정확히 반영.
- 실패 시 롤백 + 에러 표시.
- 기존 정책 상세 기능과 충돌 없음.

────────────────────────────────────────
END OF TASK 25~28 SPEC
────────────────────────────────────────


⸻


TASK 24: 신청 알림 미비사항 및 개선 작업"

# 1. 시스템/맥락 정의
- 대상 모듈: `lib/features/policy_new/**` 알림(리마인더) 기능 전체
- 역할:
  - 정책 신청일 기준으로 알림을 스케줄링하고
  - 로컬 스토리지에 저장/복원하며
  - 알림 센터 화면에서 예정/지난 알림을 구분해 보여주는 기능

현재 기본 플로우(스케줄 계산 → 저장소 저장 → 로컬 알림 스케줄링 → 만료 정리 → UI 갱신)는 존재하지만,
아래 미비사항들 때문에 **실제 서비스 품질/UX가 떨어지는 상태**다.

---

# 2. 문제 정의 (Gaps)

## 2-1. 로컬 알림 스케줄러의 조용한 실패 + 식별 어려운 메시지

- 권한 거부, 이미 지난 시간 등 **실패 조건**에서
  - 스케줄 함수가 조용히 반환하거나, 실패 여부를 상위에 알리지 않음.
- 실제 노출되는 알림 본문에는 **정책 ID만 포함**되어 있어
  - 사용자가 어떤 정책의 알림인지 직관적으로 인지하기 어려움.
- 결과적으로, “알림이 안 온다 / 어떤 정책인지 모르겠다”는 UX 문제로 이어짐.

---

## 2-2. 리마인더 영속화가 SharedPreferences 문자열 리스트에 의존

- 현재 리마인더 저장 방식:
  - SharedPreferences 문자열 리스트에 직렬화된 형태로 저장.
- 문제점:
  - 스키마가 고정되어 있지 않아 **버전 관리/마이그레이션이 곤란**함.
  - 데이터 중복/손상에 대한 방어 로직이 부족하고,
  - 리스트 크기가 커질 경우 성능/가독성 문제.
- 장기적으로는 Isar/SQLite 같은 **스키마 기반 스토리지**로 옮기는 것이 적합.

---

## 2-3. 알림 센터 컨트롤러의 전체 AsyncLoading 초기화

- 현재 알림 센터 컨트롤러는
  - 로딩/취소/새로고침 시마다 전체 상태를 `AsyncLoading` 으로 초기화해서
  - 리스트가 잠깐 동안 완전히 사라져 버리는 UX를 유발.
- 사용자는 “알림 목록이 없어졌다가 나중에 갑자기 다시 나타나는” 느낌을 받음.
- 이전 데이터를 유지한 채 일부만 갱신하는 **옵티미스틱/부분 로딩 패턴**이 필요.

---

# 3. 요구사항 및 구현 지시

## 3-1. 로컬 알림 스케줄링 실패 처리 및 메시지 개선

1. `NotificationGateway` / `ReminderService` 계층에
   - 스케줄/취소 결과를 `Result` 형태 또는 명시적인 `Failure` 타입으로 반환하도록 확장하고,
   - 권한 거부 / 이미 지난 시각 / 기타 예외 상황을 **구분 가능한 에러 코드**로 정의한다.
2. 알림 예약 요청 시:
   - 실패 사유에 따라
     - “알림 권한이 꺼져 있어요. 설정에서 권한을 허용해 주세요.”
     - “이미 지난 시각에는 알림을 설정할 수 없습니다.”
     등의 메시지를 Snackbar/Toast/다이얼로그로 노출한다.
3. 실제 알림 내용(notification body)을
   - 정책 ID 중심이 아니라 **정책 제목 + 마감 정보**를 포함하도록 수정한다.
   - 예: `"[청년 주거 지원] 신청 마감 3일 전입니다."`
4. 실패/성공에 대한 로그를 공통 로거에 남겨,
   - 후속 QA에서 원인 추적이 가능하도록 한다.

---

## 3-2. 리마인더 영속화 스토리지 개선 (SharedPreferences → 스키마 기반)

1. 새로운 리마인더 엔티티(예: `ReminderEntity`)를 정의하고,
   - 필수 필드: `id`, `policyId`, `timeKind`, `scheduledAtUtc`, `status`, `createdAt`, `updatedAt` 등
   - 선택 필드: `policyTitleSnapshot`, `note` 등
2. Isar 또는 SQLite 기반 Local DataSource (`PolicyReminderLocalDataSource`)를 도입하여
   - **단일 레코드 단위 CRUD**를 제공하고,
   - 정책별/시간대별 조회, 정렬, 만료 정리 쿼리를 지원한다.
3. 기존 SharedPreferences 데이터에서
   - 앱 첫 실행 시 한 번만 수행하는 **마이그레이션 루틴**을 구현한다.
   - 파싱 실패/중복 키/손상 데이터를 감지해,
     - 복구 가능한 데이터만 새 스키마로 옮기고
     - 문제 있는 항목은 로그 + 제거 처리한다.
4. 마이그레이션 완료 후:
   - SharedPreferences 기반 구현은 사용 중지/삭제하고
   - 모든 Repository/Service가 새 Local DataSource를 사용하도록 Provider 연결을 교체한다.

---

## 3-3. 알림 센터 컨트롤러 로딩 UX 개선

1. 알림 센터의 상태 모델에
   - `isRefreshing`, `isMutating`(추가/삭제 중) 같은 **부가 플래그**를 추가해
   - 기존 리스트 데이터를 유지한 채 로딩 상태를 표현할 수 있도록 한다.
2. `loadReminders()` 호출 시:
   - 현재 리스트를 유지하면서 상단/하단에 로딩 인디케이터만 표시하고,
   - 전체 상태를 `AsyncLoading` 으로 초기화하지 않는다.
3. 알림 취소/신규 등록 시:
   - 서버/로컬 반영을 기다리기 전에
     - 리스트에서 해당 항목을 먼저 제거/추가하는 **옵티미스틱 업데이트**를 적용하고,
     - 실패 시 이전 상태로 롤백하는 최소한의 오류 처리를 구현한다.
4. UI 단에서는
   - “데이터 없음” 상태와
   - “데이터는 있으나 로딩 중” 상태를 명확하게 구분해서 표현하도록 한다
     (예: 리스트 유지 + 상단 로딩바 vs 빈 화면 + 안내 문구).

---

# 4. Acceptance Criteria (Task 24 완료 기준)

- [ ] 권한 거부/지난 시각 등 스케줄링 실패가 **조용히 무시되지 않고**,  
      명시적인 에러 타입과 UX 메시지로 표면화된다.
- [ ] 알림 본문에 정책 ID만 보이지 않고, **정책 제목/마감 정보**가 포함된다.
- [ ] SharedPreferences 기반 리마인더 저장 로직이 제거되고,  
      Isar/SQLite 등 스키마 기반 스토리지로 완전 이전된다.
- [ ] 기존에 저장된 알림 데이터가 가능한 범위에서 자동 마이그레이션되며,  
      실패/손상 데이터는 로그에 기록된 뒤 안전하게 무시/정리된다.
- [ ] 알림 센터 화면에서 로딩/새로고침/취소 시  
      기존 리스트가 사라지지 않고, 부분 로딩/옵티미스틱 업데이트 UX가 적용된다.
- [ ] 위 변경 사항이 실제 디바이스(안드로이드/아이폰)에서 기본 시나리오(조회/추가/취소/앱 재시작) 테스트로 검증된다.


@chatgpt-codex
# Notification Roadmap Tasks (task20 ~ task23)
# YouthRoad 정책 알림 시스템 프로덕션 수준 완성 플랜

==================================================
공통 시스템 컨텍스트 (task20~23 전체 공통)
==================================================

## 0. 시스템 정의 (System Definition)

- 모듈명: `policy_new` 알림 서브시스템
- 주요 구성
  - Domain
    - `PolicyReminder` (정책별 알림 도메인 엔티티)
    - `ReminderTimeKind` (D-7 / D-3 / D-1 / 당일 등)
  - Data
    - `PolicyReminderDataSource` (현재 메모리 기반 + 추후 로컬DB)
    - `PolicyReminderRepository`
  - Application
    - `PolicyReminderService`
    - `NotificationGateway` (포트: 현재 NoOp 구현)
    - `PolicyReminderController` (Riverpod StateNotifier)
  - Presentation
    - 정책 상세/카드/피드 화면 내 알림 버튼
    - 알림 목록 화면 (예정/지난 알림)
- 목표
  - 사용자 기준: “정책 신청일 기준으로 여러 시점(D-7, D-1 등)에 알림을 정확하게 받고, 앱을 재시작해도 알림이 남아 있는 상태”
  - 기술 기준: 멀티 알림 + 영속화 + 타임존 안전 + 실기기 검증까지 완료된 **프로덕션 급 알림 시스템**

---

# task20 — 멀티 알림 & ID 설계 개선
# (도메인 + 서비스 + UI 반영)

==================================================
1. 시스템 정의
==================================================

- 이름: `task20 — Multi Reminder & ID Design Upgrade`
- 역할:
  - 정책 1개에 대해 **여러 개의 알림(D-7, D-1, 커스텀 등)** 을 안전하게 저장/식별/관리.
  - 알림 ID 충돌 없이, 알림 예약/취소/완료 상태를 추적.
  - UI에서 멀티 알림 구조를 자연스럽게 노출.

==================================================
2. 문제 정의 (Problem Statement)
==================================================

- 현재:
  - 알림 ID = `policyId` 기반 단일 키.
  - 동일 정책에 **여러 알림**을 설정하면 마지막 것만 남고 모두 덮어쓴다.
  - 도메인/서비스/리포지토리/화면이 **“정책당 1개 알림”** 구조를 가정.
- 결과:
  - “D-7 + D-1 동시에 알림” 같은 가장 기본적인 사용 시나리오가 불가능.
  - ID 설계가 확장성·안정성을 심각하게 제한.

==================================================
3. 요구사항 분석 (Requirements)
==================================================

### 기능 요구사항

1. 정책 하나에 대해 여러 알림을 설정할 수 있어야 한다.
   - 예: D-7, D-3, D-1, 마감일 당일 등
2. 각각의 알림은 독립된 ID를 가져야 한다.
3. 알림 삭제/취소/완료는 **개별 알림 단위**로 동작해야 한다.
4. UI에서 정책별로 “현재 어떤 알림들이 걸려 있는지”를 확인할 수 있어야 한다.

### 비기능 요구사항

1. ID 규칙은 명확히 문서화될 것 (task22에서 상세 문서화).
2. ID는 플랫폼(Android/iOS) 알림 시스템과 충돌 없이 사용 가능해야 한다.
3. 기존 “단일 알림” 구조와 호환성을 고려하여 마이그레이션 시나리오를 정의한다.

==================================================
4. 아키텍처 설계 (Architecture Design)
==================================================

### 4.1 도메인 모델 확장

- 기존:  
  - `PolicyReminder`가 사실상 `policyId` 기준 단일 레코드.
- 변경:
  - `PolicyReminder`를 **“정책별 알림 항목 1개”** 로 정의.
  - 필드 예시:
    - `String reminderId`  // 내부 알림 고유 ID (policyId + timeKind 조합 또는 UUID)
    - `String policyId`
    - `ReminderTimeKind timeKind` (D-7, D-1, CUSTOM 등)
    - `DateTime fireDateTimeUtc`
    - `bool isCompleted`
    - `bool isCancelled`
  - `ReminderTimeKind` enum 확장:
    - `d7`, `d3`, `d1`, `dayOf`, `custom`, ...

### 4.2 ID 규칙 설계 (초안, 상세는 task22)

- 내부 고유 ID:  
  - 포맷: `${policyId}::${timeKind.name}`
  - custom timeKind인 경우 `${policyId}::custom::${yyyyMMddHHmm}`
- 플랫폼 알림 ID (int):
  - 내부에서 `reminderId`를 해시하여 int로 매핑 (task22에서 구체 규칙 정의).

### 4.3 Repository/Service 계층

- `PolicyReminderRepository`
  - 변경 전: `getByPolicyId(policyId)` → 단일 알림
  - 변경 후:
    - `Future<List<PolicyReminder>> getByPolicyId(String policyId);`
    - `Future<void> upsert(PolicyReminder reminder);`
    - `Future<void> deleteByReminderId(String reminderId);`
- `PolicyReminderService`
  - 역할:
    - 정책 스케줄 정보를 바탕으로 **여러 ReminderTimeKind에 대한 알림 세트**를 생성.
    - Gateway에 예약/취소 요청.
  - 주요 메서드:
    - `Future<List<PolicyReminder>> createRemindersForPolicy(Policy policy, List<ReminderTimeKind> kinds);`
    - `Future<void> cancelReminder(String reminderId);`
    - `Future<void> cancelAllByPolicy(String policyId);`

### 4.4 UI/Controller 상호작용

- `PolicyReminderController` (per policy)
  - 상태: `AsyncValue<List<PolicyReminder>>`
  - 메서드:
    - `load()` → 정책별 전체 알림 목록 조회
    - `setReminders(List<ReminderTimeKind> kinds)` → 기존 알림과 비교해 diff 계산, 추가/삭제 실행
    - `removeReminder(String reminderId)` → 개별 취소

==================================================
5. 데이터 파이프라인 / 흐름도
==================================================

1. 사용자: 정책 상세 화면에서 알림 옵션(D-7, D-1 등) 여러 개 선택 → 저장.
2. UI:
   - 선택된 `ReminderTimeKind` 리스트를 `PolicyReminderController.setReminders(kinds)`로 전달.
3. Controller:
   - `repository.getByPolicyId(policyId)` 로 현재 알림 목록 조회.
   - 새 `kinds`와 비교하여 **추가/삭제 대상** 계산.
4. Service:
   - 추가 대상에 대해 `createRemindersForPolicy` 호출 → `PolicyReminder` 엔티티 생성 + Gateway.schedule 호출.
   - 삭제 대상에 대해 `cancelReminder(reminderId)` 호출.
5. Repository:
   - 로컬 스토리지에 `PolicyReminder` 리스트 저장.
6. UI:
   - 변경된 알림 리스트를 다시 구독하여 화면에 반영 (체크박스/토글/리스트 갱신).

==================================================
6. Provider/Controller 상호작용 규칙
==================================================

- `policyReminderRepositoryProvider`  
- `policyReminderServiceProvider`  
- `policyReminderControllerProvider(policyId)`:
  - 읽기: `AsyncValue<List<PolicyReminder>>`
  - 쓰기:
    - `setReminders(List<ReminderTimeKind>)`
    - `removeReminder(reminderId)`

규칙:
1. UI는 항상 Controller를 통해서만 알림을 변경한다 (서비스/리포지토리에 직접 접근 금지).
2. Controller는 Service를 통해 Gateway를 호출하고, Repository에 결과를 반영한다.
3. Repository는 로컬 데이터(추후 task21~22에서 DB 기반)만 관리한다.

==================================================
7. UI 상태도 (State Diagram – per Policy)
==================================================

- 상태:
  - `Idle` (로딩 전)
  - `LoadingReminders`
  - `Loaded(reminderList)`
  - `SavingChanges`
  - `Error(message)`
- 전이:
  - `Idle` → `LoadingReminders` (화면 진입 시)
  - `LoadingReminders` → `Loaded`
  - `Loaded` → `SavingChanges` (사용자가 옵션 변경 저장)
  - `SavingChanges` → `Loaded` (성공)
  - `SavingChanges` → `Error` (실패)

==================================================
8. 이벤트 흐름 (Event Flow)
==================================================

- 이벤트:
  - `OnPolicyReminderOptionChanged(List<ReminderTimeKind>)`
  - `OnPolicyReminderDeleted(reminderId)`
  - `OnPolicyDeleted(policyId)` (향후)
- 브로드캐스트:
  - 알림이 추가/삭제될 때, 전역 EventBus에 `ReminderUpdated(policyId)` 이벤트 발행 → 알림 목록 화면/배지 갱신.

==================================================
9. 파일 구조
==================================================

- `lib/features/policy_new/domain/entities/policy_reminder.dart` (필드 확장)
- `lib/features/policy_new/domain/value/reminder_time_kind.dart`
- `lib/features/policy_new/data/repositories/policy_reminder_repository.dart` (멀티 알림 API로 변경)
- `lib/features/policy_new/application/services/policy_reminder_service.dart`
- `lib/features/policy_new/application/controllers/policy_reminder_controller.dart`
- `lib/features/policy_new/presentation/reminder/policy_reminder_selector.dart` (멀티 선택 UI)

==================================================
10. Acceptance Criteria
==================================================

- [ ] 하나의 정책에 대해 D-7, D-1 등 **두 개 이상 알림**을 동시에 설정할 수 있다.
- [ ] 각 알림은 서로 다른 `reminderId`로 저장되며, 별도로 취소 가능하다.
- [ ] 정책 상세 화면에서 현재 설정된 모든 알림 옵션이 정확히 반영·표시된다.
- [ ] API/서비스/리포지토리 시그니처가 “멀티 알림 구조”에 맞게 정리된다.
- [ ] 기존 단일 알림 로직은 더 이상 사용되지 않는다(컴파일 상 제거 or 래핑).



--------------------------------------------------
# task21 — 실제 플랫폼 알림 Gateway 구현
# (flutter_local_notifications 연동)
--------------------------------------------------

==================================================
1. 시스템 정의
==================================================

- 이름: `task21 — Platform Notification Gateway Integration`
- 목적:
  - `NotificationGateway` 포트에 대해 **실제 flutter_local_notifications 기반 구현체**를 붙인다.
  - 스케줄 예약/취소가 실제 기기 알림센터에 반영되도록 한다.

==================================================
2. 문제 정의
==================================================

- 현재 `NotificationGateway` 구현체가 `NoOpNotificationGateway`로 비어 있음.
- 도메인/서비스/컨트롤러는 돌아가지만, 실제 디바이스에는 알림이 전혀 뜨지 않는다.

==================================================
3. 요구사항 분석
==================================================

- flutter_local_notifications 플러그인을 기반으로:
  - 단일 시점 알림 스케줄 지원
  - 알림 취소/전체 취소 지원
  - iOS/Android 양쪽 모두 동작
- YouthRoad에서 사용 중인 `reminderId` / `policyId` / `timeKind` 정보를 사용해
  - 알림 제목, 본문, payload 구성.

==================================================
4. 아키텍처 설계
==================================================

### 4.1 플러그인 기반 Gateway 구현

- 인터페이스 (기존):
  - `Future<void> scheduleReminder(PolicyReminder reminder);`
  - `Future<void> cancelReminder(String reminderId);`
  - `Future<void> cancelAllForPolicy(String policyId);`
- 새 구현체:
  - `FlutterLocalNotificationGateway implements NotificationGateway`
  - 내부에 `FlutterLocalNotificationsPlugin` 인스턴스를 보유.
  - `scheduleReminder` 호출 시:
    - `reminder.fireDateTimeUtc` → 로컬 시간 변환 (task22에서 규칙 명세).
    - `zonedSchedule()` 혹은 `schedule()` 호출.

### 4.2 초기화 및 Provider 연결

- 파일:
  - `lib/features/policy_new/application/gateways/notification_gateway.dart`
  - `lib/features/policy_new/application/providers.dart`
- 변경:
  - `notificationGatewayProvider`가 기존 `NoOpNotificationGateway` → `FlutterLocalNotificationGateway` 로 교체.
  - 앱 시작 시 한 번 초기화 (권한 요청 등은 task22/23에서 세부 정의).

==================================================
5. 데이터 파이프라인 / 흐름

1. `PolicyReminderService` → `NotificationGateway.scheduleReminder(reminder)`
2. Gateway →
   - `reminder.reminderId` → int notificationId로 매핑
   - 제목/본문/payload 구성
   - `flutter_local_notifications.zonedSchedule` 호출
3. 디바이스 OS → 지정 시각에 알림 표시.

==================================================
6. Provider/Controller 상호작용

- 변경 없음:  
  Controller/Service는 여전히 `NotificationGateway` 인터페이스만 사용.
- 실제 구현체는 Provider 레벨에서 교체.

==================================================
7. UI 상태도 / 이벤트 흐름

- 알림 예약/취소 시 UI는 기존과 동일 (task20 구조 그대로).
- 추가 이벤트:
  - 알림을 스케줄링하거나 취소하는 동안, 필요 시 로딩 표시/에러 스낵바만 추가(선택).

==================================================
8. 파일 구조

- `lib/features/policy_new/application/gateways/notification_gateway.dart`
  - `abstract class NotificationGateway`
  - `class FlutterLocalNotificationGateway implements NotificationGateway`
  - `class NoOpNotificationGateway implements NotificationGateway` (테스트용으로 유지)
- `lib/features/policy_new/application/providers.dart`
  - `notificationGatewayProvider` 구현체 교체.

==================================================
9. Acceptance Criteria

- [ ] 실제 디바이스에서 정책 알림이 설정 시간에 뜬다.
- [ ] 알림 취소 호출 시 기존 알림이 사라진다.
- [ ] 안드로이드/아이폰 모두 기본 케이스에서 동작한다.
- [ ] 코드는 여전히 `NotificationGateway` 인터페이스에만 의존한다 (플러그인 직접 호출 X).



--------------------------------------------------
# task22 — 타임존 & ID 규칙 문서화 + 유닛 테스트
--------------------------------------------------

==================================================
1. 시스템 정의
==================================================

- 이름: `task22 — Timezone & ID Rules Spec + Unit Tests`
- 목적:
  - 알림 ID 생성 규칙 및 타임존 변환 규칙을 명확히 문서화.
  - 이에 대한 유닛테스트/단위 검증을 통해 회귀 버그 방지.

==================================================
2. 문제 정의
==================================================

- 현재:
  - ID 규칙: 구두 설계 수준.
  - 타임존 변환: “대략 UTC로 저장하고 로컬로 보여준다” 정도로만 합의.
- 위험:
  - ID 충돌 → 알림 덮어쓰기/취소 실패.
  - 타임존 오류 → 잘못된 시간(하루 앞뒤, 시차 오류 등)에 알림 발생.

==================================================
3. 요구사항 분석
==================================================

- ID 규칙:
  - `reminderId` (String) 생성 규칙 명세 + 테스트.
  - 플랫폼용 `notificationId` (int) 매핑 규칙 명세 + 테스트.
- 타임존 규칙:
  - 항상 내부 저장은 `UTC` 로.
  - 디바이스 로컬 시간대에서 스케줄 → 내부 UTC 변환.
  - flutter_local_notifications 호출 시 `TZDateTime` 변환 규칙.

==================================================
4. 아키텍처 설계

### 4.1 ID 규칙 유틸

- 새 파일:
  - `lib/features/policy_new/domain/utils/reminder_id_util.dart`
- 기능:
  - `String buildReminderId(String policyId, ReminderTimeKind kind, {DateTime? customTimeUtc})`
  - `int toNotificationId(String reminderId)`
  - `String parsePolicyId(String reminderId)` (테스트/관리용)
- 규칙 예:
  - 기본: `${policyId}::${kind.name}`
  - custom: `${policyId}::custom::${yyyyMMddHHmm}`

### 4.2 타임존 유틸

- 새 파일:
  - `lib/features/policy_new/domain/utils/reminder_time_util.dart`
- 기능:
  - `DateTime toUtc(DateTime localTime);`
  - `TZDateTime toDeviceZone(DateTime utcTime);`
  - 알림 예상 시간 계산 (D-7, D-1 등) 시 항상 `UTC` 기준 DateTime 사용.

==================================================
5. 데이터 파이프라인 / 흐름

- 설정:
  - 사용자가 로컬 기준 “알림 시각”을 선택 → `DateTime`(local) 입력.
  - `toUtc(local)` → `PolicyReminder.fireDateTimeUtc`.
  - 스케줄:
    - `TZDateTime scheduled = toDeviceZone(fireDateTimeUtc)`  
      → `zonedSchedule` 전달.

==================================================
6. Provider/Controller 상호작용 규칙

- Controller/Service는 유틸 호출만 사용:
  - ID 생성/해석, 시간 변환을 직접 구현해서는 안 됨.
- 모든 ID/시간 관련 로직은 **유틸 단일 진입점**으로 모은다.

==================================================
7. UI 상태도 / 이벤트 흐름

- UI에서는 여전히 “로컬 시간”만 보여준다.
- 내부적으로 UTC/타임존 변환이 일어나도, UI 상태도에는 영향을 주지 않는다.

==================================================
8. 파일 구조

- `lib/features/policy_new/domain/utils/reminder_id_util.dart`
- `lib/features/policy_new/domain/utils/reminder_time_util.dart`
- `test/features/policy_new/domain/utils/reminder_id_util_test.dart`
- `test/features/policy_new/domain/utils/reminder_time_util_test.dart`

==================================================
9. Acceptance Criteria

- [ ] ID 유틸 테스트에서 **서로 다른 policyId/kind/customTime** 조합이 서로 다른 ID와 notificationId를 생성하는지 검증.
- [ ] 동일한 입력에 대해 항상 동일한 ID가 생성되는지 보장.
- [ ] 타임존 유틸 테스트에서 **KST, UTC, 다른 타임존** 샘플 값에 대해 올바른 변환을 수행하는지 검증.
- [ ] Service/Gateway 코드에서 직접 문자열 붙이기, 직접 타임존 계산 코드가 존재하지 않는다 (모두 유틸 사용).



--------------------------------------------------
# task23 — 실기기 QA 시나리오 + 버그 픽스 라운드
--------------------------------------------------

==================================================
1. 시스템 정의
==================================================

- 이름: `task23 — Device QA Scenarios + Bugfix Round`
- 목적:
  - 실제 안드로이드/아이폰 디바이스에서 알림 시스템 전체를 검증하고,
    발견된 버그를 정리·패치하는 QA 라운드.

==================================================
2. 문제 정의
==================================================

- 지금까지의 작업(task20~22)은 설계/구현/유닛테스트를 중심으로 함.
- 하지만 알림은 플랫폼 특성, 절전모드, 앱 종료 상태 등 변수들이 많아
  **실기기 QA 없이 바로 배포하면 위험하다.**

==================================================
3. 요구사항 분석

- 최소 검증 범위:
  1. 단일 알림 설정/취소
  2. 멀티 알림(D-7 & D-1) 설정/취소
  3. 앱 종료 / 재부팅 후 알림 유지 여부
  4. 타임존 변경 (설정 시간대 변경) 시 알림 동작
  5. 알림 클릭 시 앱 진입 동작 (딥링크 or 정책 상세 이동)
- 플랫폼:
  - Android (실 디바이스 1종 이상)
  - iOS (실 디바이스 1종 이상)

==================================================
4. 아키텍처/프로세스 설계

- QA 시나리오 문서:
  - `docs/notification/qa_scenarios.md`
- 각 시나리오:
  - 목적
  - 준비 조건
  - 단계별 수행 방법
  - 기대 결과
  - 실제 결과 & 버그 기록

- 버그 관리:
  - 발견된 버그는 GitHub Issue로 등록 (`[Notification][Bug] ...` 규칙).
  - task23에서 수정 가능한 것과, 이후 작업으로 미루는 것을 분리.

==================================================
5. 데이터/이벤트 흐름

- QA 관점에서의 흐름 정리:
  1. 정책 선택 → 알림 옵션 설정 → 알림 예약
  2. 디바이스 시간/타임존/전원/앱 상태 변경
  3. 알림 발생/미발생/중복 여부 관찰
  4. 알림 탭 → 앱 진입 → 정책 상세/알림 목록 이동 확인

==================================================
6. UI 상태도

- QA 시나리오별로:
  - 알림 설정 화면 → 알림 목록 → 실제 알림 → 다시 앱
- 상태 변화가 UX 요구사항에 맞는지 검증.

==================================================
7. 파일 구조

- `docs/notification/qa_scenarios.md`
- (버그 픽스용)
  - `lib/features/policy_new/**` 내 수정되는 파일들
  - `test/**` 내 보완되는 테스트

==================================================
8. Acceptance Criteria

- [ ] `docs/notification/qa_scenarios.md` 에 안드로이드/아이폰 공통/개별 시나리오가 정리되어 있다.
- [ ] 최소 1회 이상 실제 기기에서 각 시나리오를 수행한 결과가 기록된다.
- [ ] 치명적인 버그(알림 미발생, 시간 크게 어긋남, 앱 진입 실패 등)는 모두 수정된다.
- [ ] 남은 경미한 이슈는 별도 Issue로 분리되어 추후 작업으로 관리된다.

==================================================
끝.
==================================================


@chatgpt-codex
# TASK 14 — 알림 영속화 스토리지 도입
# (PolicyReminder Local Storage & Persistence)

## 1. 시스템 정의 (System Definition)

본 Task는 YouthRoad 앱의 `policy_new` 모듈에서 사용하는
정책 알림(PolicyReminder) 데이터를 **앱 재시작 후에도 유지**하는
로컬 스토리지 계층을 도입하는 작업이다.

대상 서브시스템:

- Domain: PolicyReminder 엔티티, PolicyReminderStatus 등
- Data: PolicyReminderLocalDataSource, PolicyReminderRepository
- Application: PolicyReminderService (cleanupExpiredReminders 포함)
- Infra: Isar 또는 SharedPreferences 기반 로컬 저장소

---

## 2. 문제 정의 (Problem Statement)

현재 알림 데이터 소스가 메모리 구현에 머물러 있어

- 앱을 재시작하면 설정한 알림 목록이 모두 사라지고,
- 완료/취소/만료 상태도 함께 리셋되며,
- “오늘 어떤 정책에 알림 걸어놨는지” 사용자 입장에서 추적 불가능

한 상태이다.

이로 인해 알림 기능은 **실제 서비스 품질이 아닌, 데모 수준**에 머물고 있다.

---

## 3. 요구사항 분석 (Requirements)

기능 요구사항:

1. 앱 재시작 이후에도 정책 알림 목록이 그대로 복원되어야 한다.
2. 각 알림은 다음 정보를 포함해 로컬 스토리지에 저장된다.
   - 정책 ID (policyId)
   - 알림 고유 ID (reminderId)  ※ Task 15에서 확장 예정
   - 알림 종류(timeKind: D-7, D-1, custom 등)
   - 알림 시각(UTC 기반 timestamp)
   - 상태(status: scheduled, fired, cancelled, expired 등)
   - 생성/업데이트 시각
3. 기존 `PolicyReminderRepository` 인터페이스는 유지하면서
   내부 구현체를 메모리 → 로컬 스토리지 기반으로 교체해야 한다.
4. 앱 시작 시:
   - 스토리지에서 모든 알림을 읽어와 in-memory 캐시/상태로 복원
   - `cleanupExpiredReminders()`가 **영속 데이터 기준**으로 동작해야 한다.

비기능 요구사항:

- DB 엔진은 Isar 또는 SharedPreferences 중 하나로 결정 가능하지만,
  추후 교체 가능하도록 DataSource 인터페이스를 단일 포트로 유지한다.
- 읽기/쓰기 성능은 알림 목록 수백 건 기준에서도 UI 지연이 없어야 한다.
- 마이그레이션: 기존 메모리 기반에서 DB 도입 시 앱 크래시 없이 자연스럽게 전환.

---

## 4. 아키텍처 설계 (Architecture)

### 4.1 레이어 구조

- Domain
  - `PolicyReminder`
- Data
  - `PolicyReminderLocalDataSource` (추상)
  - `IsarPolicyReminderLocalDataSource` (구현)
  - `PolicyReminderRepositoryImpl`
- Application
  - `PolicyReminderService`

기존 흐름:

> UI → PolicyReminderService → Repository(메모리) → NoOpGateway

갱신 후 흐름:

> UI → PolicyReminderService  
>   → PolicyReminderRepositoryImpl  
>     → PolicyReminderLocalDataSource(로컬 DB)  
>   + (Task 16 이후) NotificationGateway(실 디바이스)

---

## 5. 데이터 파이프라인 / 흐름도

1. **알림 생성**
   - UI가 Service에 `createReminder(policy, timeKind, fireAt)` 요청
   - Service → Repository.save(reminder)
   - Repository → LocalDataSource.insert(entity)
   - 성공 시 Domain 객체 반환

2. **알림 조회**
   - Service.loadAllReminders()
   - Repository.getAll()
   - LocalDataSource.getAllOrderedByFireTime()

3. **앱 시작 시 복원**
   - `PolicyReminderService.init()` 또는 앱 부팅 훅에서
   - Repository.getAll() 호출 → 메모리 캐시 or StateNotifier에 주입
   - cleanupExpiredReminders() 호출로 만료 데이터 정리

4. **알림 삭제/취소**
   - Service.cancelReminder(reminderId / policyId, timeKind)
   - Repository.deleteById(...)
   - LocalDataSource.delete(...)
   - (Task 16에서 실제 디바이스 취소 호출 연동)

---

## 6. Provider / Controller 상호작용 규칙

- `policyReminderLocalDataSourceProvider`
  - 구현체: `IsarPolicyReminderLocalDataSource`
- `policyReminderRepositoryProvider`
  - 내부에서 LocalDataSource만 사용하도록 변경
- `policyReminderServiceProvider`
  - 알림 목록 UI(StateNotifier)와 연동
  - 앱 시작 시 init() 및 cleanupExpiredReminders() 호출 책임

Controller/UI는 **오직 Service/Repository에만 의존**하고,
LocalDataSource 구현체를 직접 참조하지 않는다.

---

## 7. UI 상태도 (State Diagram)

단순화된 상태:

1. Idle (알림 없음)
2. Loading (초기 로딩/복원 중)
3. Loaded (알림 목록 표시)
4. Error (DB read/write 문제 발생 시)

전이 예시:

- 앱 시작 → Loading → Loaded
- 알림 추가/삭제 → Loaded(목록 갱신)
- 스토리지 오류 → Error → 사용자가 재시도 → Loading → Loaded

---

## 8. 이벤트 흐름 (Event Flow)

- 앱 시작:
  - `AppInitialized` → Service.init() → Repository.getAll() → UI 업데이트
- 알림 추가:
  - `ReminderCreated` → Local 저장 → UI 목록 업데이트
- 알림 취소:
  - `ReminderCancelled` → Local 삭제 → UI 목록 업데이트
- cleanup:
  - `ExpiredCleanupRequested` (앱 시작/주기적 호출)  
    → 만료 알림 삭제 → UI 재로딩

---

## 9. 파일 구조

생성/수정 파일:

- `lib/features/policy_new/data/sources/policy_reminder_local_data_source.dart`
  - abstract + Isar 구현체
- `lib/features/policy_new/data/repositories/policy_reminder_repository_impl.dart`
  - LocalDataSource 기반으로 수정
- `lib/features/policy_new/application/services/policy_reminder_service.dart`
  - init()/cleanup 로직 영속 데이터 기준으로 수정
- `lib/features/policy_new/application/providers.dart`
  - 각 Provider 연결 갱신

---

## 10. Acceptance Criteria

- [ ] 앱 재시작 후에도 알림 목록이 그대로 유지된다.
- [ ] 알림 생성/취소/만료 상태 변경 시 Local DB에 정확히 반영된다.
- [ ] cleanupExpiredReminders()가 영속 데이터 기준으로 동작한다.
- [ ] 기존 메모리 구현은 더 이상 사용되지 않는다.
- [ ] Android/iOS 모두에서 기본 동작 테스트(생성/취소/재시작 후 복원)를 통과한다.



# TASK 15 — 멀티 알림 및 ID 설계 개선
# (Multi Reminder per Policy + Robust ID Scheme)

## 1. 시스템 정의

YouthRoad의 PolicyReminder 시스템에 대해

- **한 정책에 여러 알림(D-7, D-1, 커스텀 시간 등)을 동시에 설정**할 수 있게 하고,
- 각 알림을 안정적으로 식별/취소/업데이트할 수 있는
  **고유 ID 규칙(reminderId)**을 도입하는 작업이다.

---

## 2. 문제 정의

현재 구조:

- 알림 ID가 `policyId`에 고정되어 있음.
- 같은 정책에 대해 D-7, D-1 알림을 동시에 설정하면
  마지막 알림만 남고 이전 것이 덮어써짐.
- Repository/Service/UI 모두 “정책당 알림 1개”를 가정하고 있어
  구조적으로 확장이 불가능하다.

---

## 3. 요구사항 분석

기능 요구사항:

1. 같은 policyId에 대해 서로 다른 timeKind(D-7, D-1, custom 등)를
   **동시에 여러 개 저장**할 수 있어야 한다.
2. 알림 고유 ID(reminderId)는 다음 조건을 만족해야 한다.
   - 정책간, 정책 내부 timeKind 간 충돌 없음
   - 플랫폼 로컬 알림 ID와 1:1 매핑 가능
3. UI에서:
   - 정책 상세 화면에서 “여러 알림 옵션”을 별도 토글/버튼으로 노출
   - 알림 목록 화면에서는 정책 단위 요약 + 펼치기 시 개별 알림 표시

비기능 요구사항:

- ID 규칙이 문서화되어야 하고, 미래 커스텀 알림(timeKind 증가)에도 그대로 사용할 수 있어야 한다.
- 기존 단일 알림 구조에서 멀티로 변경 시
  마이그레이션 전략이 명확해야 한다 (최소한 크래시 없이 동작).

---

## 4. 아키텍처 설계

### 4.1 Domain 확장

- `PolicyReminder` 엔티티에 필드 추가/정리:
  - `String reminderId`       // 내부/플랫폼 공용 키
  - `String policyId`
  - `PolicyReminderTimeKind timeKind` (enum: d7, d1, custom, etc)
  - 기타 필드(UTC time, status 등)는 Task 14 정의 활용

- ID 규칙 예시:
  - `reminderId = "$policyId|$timeKind|$timestamp"`  
    또는 
  - UUID 기반 + 메타 데이터 별도 필드  
  구현은 자유지만 **하나의 규칙으로 통일**해야 한다.

### 4.2 Repository 변경

- 기존: `getByPolicyId(policyId) → PolicyReminder?`
- 변경: `getByPolicyId(policyId) → List<PolicyReminder>`
- 개별 삭제 API:
  - `deleteByReminderId(reminderId)`
  - `deleteByPolicyIdAndTimeKind(policyId, timeKind)`

Service와 UI는 이 새로운 메서드를 사용.

---

## 5. 데이터 파이프라인 / 흐름도

1. **알림 생성 (D-7 / D-1 / Custom)**
   - UI에서 timeKind 선택
   - Service.createReminder(policy, timeKind)
   - reminderId 생성 규칙 적용
   - Repository.save(reminder)
   - (Task16에서 reminderId로 로컬 알림 예약)

2. **알림 취소**
   - UI에서 특정 timeKind 스위치 해제
   - Service.cancelReminder(policyId, timeKind)
   - Repository.deleteByPolicyIdAndTimeKind(...)
   - (Task16에서 동일 ID로 로컬 알림 취소)

3. **정책 단위 요약**
   - Service.getRemindersByPolicyId(policyId)
   - 여러 reminder 중 “가장 가까운 알림”을 헤더로,
     나머지는 상세 목록으로 내려줌.

---

## 6. Provider / Controller 상호작용 규칙

- PolicyDetail 화면 전용 Provider:
  - `policyReminderByPolicyProvider(policyId)`  
    → List<PolicyReminder>를 반환.
- 알림 리스트 화면 Provider:
  - 전체 알림을 정책별로 그룹핑해서 내려줌
- Controller는 `reminderId` / `timeKind` 기반 API만 사용하며  
  `policyId` 단일 키 동작을 더 이상 의존하지 않는다.

---

## 7. UI 상태도

정책 상세 화면 기준:

- 상태:
  - NoReminder (해당 정책에 알림 없음)
  - Single / MultiReminder (1개 이상)
- 전이:
  - 토글 ON → 알림 생성 → MultiReminder로 전환
  - 토글 OFF → 해당 timeKind 삭제 → 0개면 NoReminder

알림 목록 화면 기준:

- GroupedByPolicy 상태:
  - 정책 카드 + 가장 가까운 알림 요약 + “자세히 보기(다른 알림)” 행동

---

## 8. 이벤트 흐름

- `ReminderCreated(policyId, timeKind, reminderId)`
- `ReminderCancelled(reminderId or policyId+timeKind)`
- `ReminderListChanged(policyId)`
  - UI에서 정책별 상태 다시 fetch

이벤트 명은 코드 안에서 상수/enum으로 관리한다.

---

## 9. 파일 구조

변경/추가 파일:

- `lib/features/policy_new/domain/entities/policy_reminder.dart`
- `lib/features/policy_new/data/repositories/policy_reminder_repository_impl.dart`
- `lib/features/policy_new/application/services/policy_reminder_service.dart`
- `lib/features/policy_new/presentation/reminder/**` (정책별 멀티 알림 UI)

---

## 10. Acceptance Criteria

- [ ] 한 정책에 대해 D-7, D-1, Custom 등 여러 알림을 동시에 설정할 수 있다.
- [ ] 각 알림은 reminderId로 안정적으로 식별/취소 가능하다.
- [ ] 기존 단일 알림 구조에서 업그레이드해도 앱이 크래시 없이 동작한다.
- [ ] 알림 목록/정책 상세 UI가 멀티 알림 구조를 정확히 반영한다.
- [ ] unit test나 간단한 통합 테스트로 reminderId 충돌이 발생하지 않는 것을 확인한다.



# TASK 16 — 플랫폼 알림 연동 추가
# (Connect PolicyReminder to Real Device Notifications)

## 1. 시스템 정의

PolicyReminder 도메인 계층과
실제 모바일 디바이스의 로컬/푸시 알림 시스템을 연결하는 작업이다.

- Application: `NotificationGateway` 포트
- Infra: `FlutterLocalNotifications` 또는 플랫폼별 구현
- Service: PolicyReminderService에서 schedule/cancel 호출

---

## 2. 문제 정의

현재:

- `NotificationGateway`가 NoOp 구현체에 연결되어 있음.
- 실제 기기에서는 어떤 알림도 예약/취소되지 않는다.
- 알림 기능 전체가 “UI 조건 토글만 있는 데모 상태”다.

---

## 3. 요구사항 분석

기능 요구사항:

1. 알림 생성 시:
   - 로컬 DB 저장 + 실제 디바이스 알림 예약이 둘 다 수행되어야 한다.
2. 알림 취소 시:
   - 로컬 DB 삭제 + 디바이스 알림 취소가 둘 다 수행되어야 한다.
3. 타임존:
   - 모든 비즈니스 로직은 내부적으로 UTC 기준으로 처리하되,
     디바이스 예약 시 로컬 타임존으로 변환해야 한다.
4. 플랫폼:
   - 최소 Android는 완전 지원, iOS는 설정/권한 처리 포함.

비기능 요구사항:

- 알림 권한이 없는 경우 graceful fallback (토스트/스낵바 안내 등)
- 동일 reminderId에 중복 예약이 발생하지 않도록 한다.

---

## 4. 아키텍처 설계

### 4.1 Gateway 인터페이스

```dart
abstract class NotificationGateway {
  Future<void> scheduleReminder(PolicyReminder reminder);
  Future<void> cancelReminder(String reminderId);
}

4.2 구현체
	•	FlutterLocalNotificationGateway (예: flutter_local_notifications 기반)
	•	내부에서:
	•	reminderId를 int형 ID로 매핑하거나 문자열로 유지
	•	title/body, schedule time, 채널 ID 설정

⸻

5. 데이터 파이프라인 / 흐름도
	1.	알림 생성
	•	Service.createReminder(…)
	•	Repository.save(…)
	•	NotificationGateway.scheduleReminder(reminder)
	2.	알림 취소
	•	Service.cancelReminder(…)
	•	Repository.delete…
	•	NotificationGateway.cancelReminder(reminderId)
	3.	앱 재시작 후 복원 (선택)
	•	Task14에서 로딩한 알림 목록을 기준으로
	•	필요 시 scheduleReminder를 다시 호출해 재등록 (플랫폼 전략에 따라 결정)

⸻

6. Provider / Controller 상호작용 규칙
	•	notificationGatewayProvider
	•	기존 NoOp 구현체 → 실제 구현체로 교체
	•	policyReminderServiceProvider
	•	알림 생성/취소 시 Gateway 호출을 책임지는 유일한 계층

UI는 Gateway를 직접 알지 못한다.

⸻

7. UI 상태도 / 이벤트 흐름
	•	알림 버튼 ON:
	•	CreateReminderRequested → Service → Repository + Gateway.schedule
	•	알림 버튼 OFF:
	•	CancelReminderRequested → Service → Repository + Gateway.cancel
	•	권한 없음:
	•	NotificationPermissionDenied → “알림 권한을 허용해 주세요” 안내

⸻

8. 파일 구조
	•	lib/features/policy_new/application/gateways/notification_gateway.dart
	•	인터페이스 + 구현체(FlutterLocalNotificationGateway)
	•	lib/features/policy_new/application/providers.dart
	•	notificationGatewayProvider 교체
	•	lib/features/policy_new/application/services/policy_reminder_service.dart
	•	schedule/cancel 호출 추가

⸻

9. Acceptance Criteria
	•	Android 실기기에서 알림 생성/취소가 정상적으로 동작한다.
	•	정책별 D-7, D-1 알림이 설정 시간에 맞춰 뜬다.
	•	권한이 거부된 상태에서도 앱이 크래시 없이 동작하고 적절한 안내를 제공한다.
	•	reminderId 기준으로 예약/취소가 정확히 매칭된다.
	•	Task14, Task15와 논리/데이터 구조 상 충돌이 없다.

---


⸻

🟦 TASK 11 — PolicyNew “비교 탭(Compare Feed)” 완전 설계 (job01 수준 MAX 퀄리티)

전체 내용을 하나의 코드블록 안에, 그리고 Codex가 그대로 구현 가능한 기준으로 작성합니다.

@chatgpt-codex
# TASK 11 — PolicyNew Compare Feed (정책 비교 탭) Full Architecture Spec
# (job01 레벨 시스템 정의 + 문제 정의 + 요구사항 + 아키텍처 + 데이터 흐름 + Provider 규칙 + UI 상태도 + 이벤트 흐름 + 파일구조 + 완전한 Acceptance Criteria)

────────────────────────────────────────
1. 시스템 정의 (System Definition)
────────────────────────────────────────

정책 비교 탭은 사용자가 관심있는 정책을 최대 2~4개까지 선택하여  
정책의 핵심 항목을 한 화면에서 **표 형식으로 동시에 비교**할 수 있게 하는 기능이다.

이 기능은 다음을 만족해야 한다:

- 정책 상세에서 “비교 추가하기” 버튼 클릭 → 비교 리스트에 정책이 추가됨
- 비교 탭은 항상 현재 비교 리스트를 실시간 반영
- 정책을 탭에서 제거하면 모든 연동된 UI(EventBus) 에 즉시 반영
- 비교 탭은 "표 기반 비교" + "핵심 정보 요약" + "차이 강조" UI 를 제공
- 비교 탭 자체도 페이징 없이, 로컬에 저장된 compare 리스트 기반으로 구성됨

정책 비교는 정책 추천/목록/검색과 다르게 **서버 API로 비교 요청을 하지 않는다.**  
비교는 앱 내부의 Local 저장소(Isar or SharedPreferences or DB)에 있는 비교 ID 목록으로 동작한다.

핵심 목표:  
**비교 선택** → **비교 목록 저장** → **비교 탭에서 자동 반영** → **차이점 기반 표 제공**.

────────────────────────────────────────
2. 문제 정의 (Problem Statement)
────────────────────────────────────────

현재 PolicyNew 모듈에서는 비교 탭 관련 문제들이 있다:

1) CompareFeedController만 존재하고 실제 비교 화면/기능 없음  
2) “비교에 추가/삭제” 하는 UI/기능이 화면별로 통합되어 있지 않음  
3) Compare 리스트를 저장/로드/수정하는 Repository는 있으나 UI 연동 없음  
4) 두 정책의 차이를 강조하는 UI 구조 부재  
5) 비교 탭이 각 정책의 상세 데이터(요약, 지원자격, 신청기간 등)를  
   **동일한 필드 기준으로 정렬**하여 보여주는 기능이 없음  
6) EventBus와 연동 규칙이 미구현  
7) Compare 탭 내부 구성(UI/상태/Provider) 모두 공백

따라서 “정책 비교” 기능은 현재 완전히 미구현이며  
**전면 설계 + 아키텍처 작업이 필요**함.

────────────────────────────────────────
3. 요구사항 분석 (Requirements Analysis)
────────────────────────────────────────

◼ 사용자가 원하는 기능  
- 정책 상세 화면에서 "비교 담기" 버튼 클릭 → 비교 리스트에 저장  
- 비교 탭에서 정책 2~4개 동시에 비교 가능  
- 비교 목록에서 정책 제거 가능  
- 비교 탭에서 각 정책의 주요 정보가 표 형식으로 나열  
- 차이가 있는 필드는 하이라이트 표시  
- 정책 아이디 변경/삭제 시 자동 반영  
- 정책 상세페이지 이동 가능  
- 비교 리스트 초기화 버튼 존재

◼ UI/UX 요구  
- 2개만 선택해도 비교 UI 정상 작동  
- 정책이 1개면 "비교할 정책을 더 선택해주세요" 메시지 표시  
- 정책이 0개면 빈 상태  
- 비교 표는 가로 스크롤(정책별 column) + 세로 리스트(비교 항목 row) 방식  
- 각 정책 column 카드에는 썸네일/제목/지역/모집상태 표시  
- 항목별: 제목, 요약, 지원자격, 혜택/지원내용, 신청기간, 기관/부서, 링크 등  
- 차이가 있는 항목 highlight 처리

◼ 기술 요구  
- CompareRepository로부터 compareIDs 불러오기  
- compareIDs 기반으로 PolicyRepository.fetchPolicyById 다건 호출  
- compareIDs 변경 시 CompareFeedController 즉시 새 데이터 fetch  
- EventBus 연동  
- Local Storage 기반 유지  
- 상태는 CompareFeedState = AsyncState<List<Policy>>

────────────────────────────────────────
4. 아키텍처 설계 (Architecture Design)
────────────────────────────────────────

◼ CompareFeature 구조

Presentation
└─ CompareTab
├─ CompareScreen
├─ CompareHeaderRowWidget
├─ ComparePolicyColumnWidget
├─ CompareDiffTableWidget
├─ CompareEmptyWidget
└─ CompareRemoveButton

Application
├─ compare_repository_provider (이미 존재)
├─ compareFeedControllerProvider
└─ compare_service.dart (비교 계산 로직: 차이점 계산 등)

Domain
└─ Policy(지원자격, 혜택, 신청기간 등 비교할 수 있는 Domain 필드)

Infra
└─ CompareRepositoryImpl (local ID list 저장/불러오기)

◼ CompareFeedController 동작

1. compareRepository.ids 가져옴  
2. ids 가 0 → CompareScreen은 빈 화면 표시  
3. ids 가 1 → CompareScreen “비교할 정책 부족” 표시  
4. ids ≥ 2 → ids 기반으로 여러 정책을 병렬 fetch  
5. fetch 결과 domainPolicyList 로 변환  
6. CompareDiffCalculator 로 각 항목별 difference map 생성  
7. CompareScreen에서 table 형태로 렌더링  

────────────────────────────────────────
5. 데이터 파이프라인 / 흐름도 (Data Flow Diagram)
────────────────────────────────────────

1) 비교 추가  

[정책상세 화면]
→ CompareRepository.add(id)
→ Local DB 저장
→ policyEventBus.emit(favoritesChanged or compareChanged)
→ CompareFeedController.refresh()

2) 비교 탭 진입  

[CompareScreen]
→ CompareFeedController.load()
→ compareRepository.ids 읽음
→ ids → PolicyRepository.fetchById() 병렬 호출
→ results → List
→ CompareDiffService.calculateDiffs()
→ CompareState(data: policies, diffs)

3) 비교 정책 제거  

[CompareScreen RemoveButton]
→ compareRepository.remove(id)
→ policyEventBus.emit(compareChanged)
→ CompareFeedController.refresh()

────────────────────────────────────────
6. Provider / Controller 상호작용 규칙
────────────────────────────────────────

◼ compareRepositoryProvider  
- ids: List<String>  
- add(id), remove(id), clear()

◼ compareFeedControllerProvider  
- load()  
- refresh()  
- remove(id) → repository.remove(id) → refresh()  
- state: AsyncValue<CompareState>  
  - CompareState: { policies: List<Policy>, diffs: CompareDiffMap }

◼ policyEventBusProvider  
- compareChanged 발생 시 compareFeedController.refresh()

◼ policyRepositoryProvider  
- fetchPolicyDetailById(id) 제공  
- 비교시 반드시 정책 상세 데이터 전부 로드

────────────────────────────────────────
7. UI 상태도 (UI State Diagram)
────────────────────────────────────────

      +--------------------+
      | Compare Tab Opened |
      +----------+---------+
                 |
                 v
    +--------------------------+
    | compareRepository.ids ?  |
    +------+-------------------+
           |
 +---------+--------+
 |                  |

ids == 0         ids == 1            ids >= 2
(Empty)        (Need More)           (Compare)
|               |                     |
v               v                     v
CompareEmpty   CompareNeedMore        CompareTable   <–– refresh()

────────────────────────────────────────
8. 이벤트 흐름 (Event Flow)
────────────────────────────────────────

1) 정책상세에서 "비교 추가하기" 버튼 터치  
→ compareRepository.add(id)  
→ EventBus(compareChanged)  
→ CompareFeedController.refresh()  
→ CompareScreen UI 자동 갱신

2) 비교 탭에서 정책 제거 버튼 터치  
→ compareRepository.remove(id)  
→ EventBus(compareChanged)  
→ CompareFeedController.refresh()

3) 필터/정렬 UI 변경 시 비교 탭은 영향 X  
(비교 탭은 UI 필터를 사용하지 않음)

────────────────────────────────────────
9. 파일 구조 (File Structure)
────────────────────────────────────────

lib/features/policy_new/
compare/
controllers/
compare_feed_controller.dart
compare_diff_service.dart
presentation/
compare_screen.dart
compare_empty_widget.dart
compare_need_more_widget.dart
compare_header_row_widget.dart
compare_policy_column_widget.dart
compare_diff_table_widget.dart
compare_remove_button.dart

────────────────────────────────────────
10. CompareDiffService (정책 차이점 계산 로직)
────────────────────────────────────────

차이점 계산 규칙 예시:

- 지원자격(age/job/education)이 다르면 highlight  
- 신청기간(날짜)이 다르면 highlight  
- 지원금/지원방식/혜택이 다르면 highlight  
- 기관/부서 다르면 highlight  

구현은 Map<String, bool> 형태로 관리:

{
“지원자격”: true,
“신청기간”: false,
…
}

────────────────────────────────────────
11. Acceptance Criteria (완료 기준)
────────────────────────────────────────

□ CompareScreen이 정상적으로 두 정책 이상을 비교 표로 렌더링  
□ CompareScreen에서 비교 정책 추가/제거 UI 정상 동작  
□ 정책상세 화면에서 "비교 담기" 버튼 클릭 → CompareScreen에 자동 반영  
□ CompareDiffService가 항목별 차이점 계산 가능  
□ CompareFeedController가 ids 변화 → 자동 refresh 동작  
□ EventBus(compareChanged)로 모든 화면이 StateSync 됨  
□ 비교 탭은 Filter/Sort/Keyword 상태에 영향 받지 않음  
□ Compare info가 LocalStorage에 영구 저장  
□ Compare UI가 가로 스크롤 + 세로 리스트 방식으로 표 형태 렌더링  
□ Compare 화면에서 정책 상세로 이동 가능  

────────────────────────────────────────
(End of TASK 11)


⸻




@chatgpt-codex
# TASK 10 — Recommendation UX System (Full Specification)
# 온보딩 기반 개인화 추천 + 추천 키워드 UX + FeedType=RECOMMEND 고도화

────────────────────────────────────────────────────
1. SYSTEM DEFINITION
────────────────────────────────────────────────────
YouthRoad PolicyNew 모듈은 6개의 Feed 탭(추천/전체/지역/검색/즐겨찾기/비교)을 기반으로
정책 탐색 경험을 제공한다. 이 중 "추천(Recommendation)" 탭은 개인화된 정책 제안을
제공하는 핵심 기능이다.

TASK 10은 다음 3가지의 "개인화 추천 시스템" 전 영역을 구축하기 위한 전면 설계이다:

1) 온보딩(사용자 프로필 입력)
2) 추천 키워드 기반 정책 추천 UX
3) 개인화 추천 Query 조합 알고리즘

이 시스템은 job01~job07에서 만든 Domain / Query / Controller / FilterState를 그대로 사용하면서,
"추천 전용 레이어"를 추가하여 개인화 품질과 UX를 극대화하는 목적을 가진다.


────────────────────────────────────────────────────
2. PROBLEM DEFINITION
────────────────────────────────────────────────────
현재 YouthRoad PolicyNew의 추천 탭은 다음 문제를 가지고 있다:

(1) 추천 기준이 부족함
    - 나이, 지역, 관심 정책 유형, 태그 등의 정보 없이 추천 Feed를 구성하면 추천 품질이 낮다.
    - 별도의 온보딩 과정이 없기 때문에 개인화가 불가능하다.

(2) 추천 UX가 없음
    - 추천 키워드(관심사 기반 태그), 필터 기반 추천, 상황별 추천 등이 UI에서 제공되지 않음.

(3) 추천 알고리즘이 단일 규칙
    - 현재 Query는 단순 filter + sort 기반이며,
      사용자 컨텍스트(나이, 지역, 선정장려금/취업/주거 관심도 등)를 반영하지 못한다.

(4) 사용자 Action 기반 재추천 기능 부재
    - 좋아요/비교/검색/클릭 이력 기반 태그 업데이트 없음.

→ TASK 10은 위 문제를 해결하여 **YouthRoad의 핵심 차별화 포인트가 되는 추천 시스템을 구축하는 것**이다.


────────────────────────────────────────────────────
3. REQUIREMENT ANALYSIS
────────────────────────────────────────────────────

(1) 온보딩(UserProfile Form)
    - 입력 요소:
      • 나이(age)
      • 관심 분야(정책 카테고리 1~3개 선택)
      • 관심 키워드(자유 입력 + 추천된 키워드 중 선택)
      • 희망 지역(시·군·구 선택)
    - 저장 위치: local DB(Isar) + ProviderState
    - 앱 첫 실행 또는 추천 탭 접근 시 프로필 미완성 → 온보딩 요구

(2) 추천 키워드 UX
    - 추천 탭 상단에 키워드 Chip 영역 추가
    - 추천 키워드는 두 가지 원천:
      ① 사용자 온보딩 입력
      ② 최근 사용 행동 기반(CLICK, LIKE, COMPARE)

(3) 개인화 추천 알고리즘
    - 점수 기반 추천 랭킹 모델(가중치 방식)
    - 점수 구성:
      Score = (카테고리 일치 40%) +
              (정책 지역 일치 25%) +
              (키워드 매칭 25%) +
              (좋아요/비교 interaction 10%)

(4) FeedType=RECOMMEND 연동
    - 기존 검색/필터와 독립적으로 추천 Feed 생성
    - FilterState 변경 시 영향받을 항목:
      • region override(필수)
      • category override(선택)
      • recommendTags override(선택)

(5) 추천 세션 UX
    - 추천 탭 최초 진입 시:
      “오늘의 추천 정책 3개” 메인 블록
      그 아래 추천 키워드 기반 무한 스크롤

(6) 개인화 업데이트 규칙
    - 좋아요: 해당 정책의 카테고리, 지역, 키워드를 1점씩 상승
    - 비교: 카테고리 스코어 0.5 상승
    - 클릭: 키워드 스코어 0.3 상승
    - 검색어 입력: 해당 키워드 스코어 0.2 상승

(7) 백엔드 API 변경 불필요
    - 기존 Query + tags 기반으로 최대한 개인화 로직 구현
    - 프론트에서 개인화 scoring 후 Query.tags로 반영


────────────────────────────────────────────────────
4. ARCHITECTURE DESIGN
────────────────────────────────────────────────────

아키텍처는 다음 3-layer 구조로 구성:

                        ┌────────────────────┐
                        │   UI Layer         │
                        │ (Onboarding Screen,│
                        │  RecommendFeed     │
                        │  Keyword Chips)    │
                        └─────────▲──────────┘
                                  │
                                  │Filter/Tags 선택
                                  │User Profile Input
                                  ▼
                     ┌────────────────────────────┐
                     │ Interaction Layer(Task10)  │
                     │  • RecommendationEngine    │
                     │  • UserProfileService      │
                     │  • KeywordScoringLayer     │
                     └────────────▲───────────────┘
                                  │
                                  │PolicyQueryOrchestrator(buildQuery)
                                  ▼
                 ┌────────────────────────────────────────┐
                 │ Application Layer(job04~07 기반)       │
                 │  • FeedController                      │
                 │  • QueryEngine                         │
                 │  • Repository(fetchPoliciesByQuery)    │
                 │  • SWR Cache                           │
                 └────────────────────────────────────────┘


────────────────────────────────────────────────────
5. DATA PIPELINE (Flow)
────────────────────────────────────────────────────

(1) 온보딩 입력
UI → UserProfileService.save() → Isar DB → userProfileProvider 업데이트

(2) 추천 탭 진입
RecommendFeedController.loadFirstPage()

(3) Query 조립
PolicyQueryOrchestrator.buildQuery(FeedType.recommend)
    • profile.age 적용
    • profile.region(필수)
    • profile.recommendCategories
    • combinedTags = profile.recommendTags + behaviorBasedTags

(4) Repository 호출
queryEngine.fetch(feedType=RECOMMEND, page)

(5) 정책 리스트 렌더링
PolicyFeedListView(feedType=RECOMMEND)

(6) 사용자 행동 기록 (클릭/좋아요/비교)
→ RecommendationBehaviorTracker
→ KeywordScoringLayer.updateScores()

(7) 추천 키워드 업데이트
→ policyFilterUiStateProvider.setTags()


────────────────────────────────────────────────────
6. PROVIDER / CONTROLLER INTERACTION RULES
────────────────────────────────────────────────────

1) userProfileProvider
   - 온보딩 정보 제공
   - RecommendationEngine이 이를 기반으로 Query 재조합

2) recommendationBehaviorProvider
   - 클릭/좋아요/비교 이벤트를 기록
   - 추천 점수 업데이트

3) policyFilterUiStateProvider
   - 기본 region/category는 반영하되
   - 추천 탭에서는 tags가 최우선 입력

4) PolicyQueryOrchestrator
   - RecommendationEngine(특) 적용 지점:
     combinedTags = top 5 scored tags
   - recommended categories override

5) RecommendFeedController
   - 다른 탭과 다르게 FilterState보다 Profile 기반 우선


────────────────────────────────────────────────────
7. UI STATE DIAGRAM
────────────────────────────────────────────────────

 추천 탭 상태머신:

        ┌───────────────┐
        │  INIT         │
        └───────┬───────┘
                │ userProfile incomplete
                ▼
        ┌───────────────┐
        │ ONBOARDING    │
        └───────┬───────┘
                │ save profile
                ▼
        ┌───────────────┐
        │ RECOMMEND_UI  │
        └───────┬───────┘
                │ keyword/tag change
                ▼
        ┌───────────────┐
        │ REFRESH FEED  │
        └───────┬───────┘
                │ scroll end
                ▼
        ┌───────────────┐
        │ NEXT PAGE     │
        └───────────────┘


────────────────────────────────────────────────────
8. EVENT FLOW
────────────────────────────────────────────────────

(1) Onboarding Completed
→ userProfileProvider.set()
→ eventBus.emit(profileUpdated)
→ RecommendFeedController.refresh()

(2) Keyword Chip Selected
→ policyFilterUiStateProvider.setTags([...])
→ RecommendFeedController.refresh()

(3) Policy Clicked
→ recommendationBehaviorTracker.addClick()
→ update keyword weight
→ no immediate refresh(UX)

(4) Policy Liked
→ eventBus.emit(favoritesChanged)
→ update behavior scores
→ RecommendFeedController.refresh()

(5) Scroll to End
→ RecommendFeedController.loadNextPage()


────────────────────────────────────────────────────
9. FILE STRUCTURE (TASK 10 ADDITIONS)
────────────────────────────────────────────────────

lib/features/policy_new/
  domain/
    recommendation/
      user_profile.dart
      user_profile_repository.dart
      recommendation_score.dart
      behavior_event.dart

  data/
    recommendation/
      user_profile_local_source.dart
      user_profile_repository_impl.dart

  application/
    recommendation/
      recommendation_engine.dart
      recommendation_behavior_tracker.dart
      user_profile_service.dart

  presentation/
    onboarding/
      profile_onboarding_screen.dart
      profile_interest_form.dart
    recommend/
      recommend_keyword_bar.dart
      recommend_header_section.dart
      recommend_empty_state.dart


────────────────────────────────────────────────────
10. ACCEPTANCE CRITERIA
────────────────────────────────────────────────────

[온보딩]
- [ ] 앱 처음 실행 시 또는 추천 탭 접근 시 프로필이 없으면 온보딩 화면 출력
- [ ] 나이/관심 정책 카테고리/관심 키워드/지역 입력 가능
- [ ] 모든 데이터 local DB + Provider로 저장됨

[추천 키워드]
- [ ] 추천 탭 상단에 개인화 키워드 Chip 영역 표시
- [ ] 최소 1개의 추천 태그가 항상 존재

[추천 알고리즘]
- [ ] combinedTags = top 5 tags
- [ ] categoryAffinity, regionAffinity, keywordAffinity 점수 반영
- [ ] QueryOrchestrator에서 RecommendationEngine 결과를 받아 Query.tags에 반영

[연동]
- [ ] RecommendFeedController는 필터보다 Profile 기반 우선
- [ ] behavior(좋아요/클릭/비교) 발생 시 점수 업데이트

[UI/UX]
- [ ] 추천 Feed는 상단 “오늘의 추천” 블록 + 리스트로 구성
- [ ] 전체 구조가 policy_new 하위에서 기존 시스템과 충돌 없음


@chatgpt-codex
# TASK 09 — PolicyNew 검색 탭(Search Tab) 풀 구현
# (job01 스타일: 시스템 정의 / 문제 정의 / 요구사항 / 아키텍처 / 파이프라인 / 상호작용 / UI 상태 / 이벤트 흐름 / 파일 구조 / AC)

---

## 1. 시스템 정의 (System Definition)

### 1.1 모듈 범위
- 모듈: `policy_new`
- 화면: **정책 메인 6탭 구조 중 `검색 탭 (Search Tab)`**
- 역할:
  - 사용자가 **키워드 + 필터(지역/카테고리/온라인/모집중) + 정렬 옵션**을 조합하여
    정책을 탐색할 수 있는 **전용 검색 탭**.
  - 실 API (경북 청년정책 OpenAPI)와 연결된 검색 결과를 보여준다.
  - 상단 필터/정렬/검색바(TASK 06의 Filter UI)와 완전히 연동된 상태에서 동작한다.

### 1.2 전제
- `policy_new`의 작업이 다음까지 완료되어 있다고 가정:
  - job01~job06, TASK 01~TASK 08
  - Domain: `Policy`, `PolicyFilter`, `PolicyQuery`, `PolicyFeedType.search`, `PolicySortOption`, etc.
  - Repository: `PolicyRepository.fetchPoliciesByQuery(...)`
  - QueryEngine + QueryOrchestrator: `PolicyQueryEngine`, `PolicyQueryOrchestrator` (feedType에 따라 Query 생성)
  - Filter UI State: `PolicyFilterUiState` + `policyFilterUiStateProvider`
  - Base Controller: `BasePolicyFeedController` (feedType 파라미터 기반)
  - Search Feed Controller: `SearchFeedController` (Base 상속, feedType=search)
  - 메인 UI: `PolicyFeedHomeScreen`에 6개 탭 + `PolicyFilterBar` 존재
  - 공통 리스트: `PolicyFeedListView(feedType: ...)` + `PolicyCard` + 로딩/에러/빈 상태 위젯

---

## 2. 문제 정의 (Problem Definition)

현재 상태:
- `PolicyFeedHomeScreen`에서 **검색 탭**은 UI 구조상 탭만 존재할 뿐:
  - 검색 탭이 다른 탭과 동일한 리스트 UI를 재사용하지만,
  - **검색 전용 UX/로직이 존재하지 않거나, 매우 형식적**인 상태.
- 실제 문제들:
  1) 키워드 입력과 검색 탭의 상태가 강하게 묶여 있지 않음.
  2) 검색 탭에서 “이전 검색 결과 유지”, “검색어 변경 시 즉시 반영”, “필터/정렬과 함께 검색” 같은 UX 정의가 부족.
  3) 빈 검색어 상태일 때의 동작 정의(전체/추천/최근 검색? 등)가 불명확.
  4) 검색 실패/결과 없음/입력 최소 글자 수 등의 제약이 없음.
  5) 특정 탭(검색 탭)만의 고유 기능(최근 검색어, 추천 키워드 강조, 검색 가이드)이 없음.
  6) 실 API 기준 검색 파라미터(`searchPolicyNm`, `searchPolicyType` 등)와의 연결 규칙 미정.

목표:
- **검색 탭 하나만 놓고 봐도 “검색만을 위한 완성된 UX/로직”**을 가지고 있어야 함.
- 나머지 5개 탭(추천/전체/지역/즐겨찾기/비교)과 독립적으로, 하지만 동일한 infra 위에서 안정적으로 동작하는 수준으로 끌어올리기.

---

## 3. 요구사항 분석 (Requirements Analysis)

### 3.1 기능 요구사항 (Functional)

1. **키워드 기반 검색**
   - 상단 검색바 또는 전용 모달에서 키워드를 입력하면,
     `PolicyFilterUiState.keyword` 에 저장되고,
     검색 탭에서 해당 키워드를 기준으로 정책을 조회한다.
   - 최소 글자수(예: 2자 이상) 이하일 경우 검색을 트리거하지 않고 안내 메시지 표시.

2. **필터와 결합된 검색**
   - 검색 탭은 다음 조건을 모두 반영한 결과를 보여야 한다:
     - 지역(Region)
     - 카테고리(Category)
     - 온라인만 보기(Online only)
     - 모집중만 보기(Ongoing only)
     - 정렬 기준(SortOption)
   - 이 값들은 모두 `PolicyFilterUiState`에서 나온다.

3. **추천 태그 기반 검색**
   - 검색 탭에서는 선택된 추천 태그(tags)가 있을 경우,
     - 키워드 + 태그가 함께 Query에 반영되거나
     - 키워드가 비어있을 경우 태그만으로도 검색 가능.

4. **검색 결과 리스트**
   - 무한 스크롤 + Pull-to-Refresh 지원.
   - 로딩 / 에러 / 빈 상태 UI 정상 동작.

5. **검색 상태 유지**
   - 유저가 다른 탭(예: 전체 탭)으로 이동했다가 검색 탭으로 돌아오더라도,
     - 최근 검색어 + 필터 상태 + 결과 리스트가 유지되어야 한다.
   - 앱 재시작 시까지는 메모리 내에서 유지(영구 저장은 이후 TASK로 분리).

6. **검색 초기 상태 UX**
   - 아직 검색어가 입력되지 않았거나, 첫 진입 시:
     - (옵션 A) “검색 가이드” 화면 (예: ‘검색어를 입력해보세요’, 추천 태그 리스트 등)을 보여준다.
     - (옵션 B) 최근 검색어, 인기 키워드 등을 보여줄 수 있는 구조를 준비해둔다(구현은 추후 TASK).

7. **실 API 연동 (경북 청년정책 OpenAPI)**
   - 검색 탭에서 발생하는 Query는 실 API의 `searchPolicyNm` 등 검색 파라미터와 매핑되어야 한다.
   - API 실패 시 graceful하게 에러 상태를 보여준다.

---

### 3.2 비기능 요구사항 (Non-functional)

1. **반응성**
   - 필터/정렬/검색어 변경 시, 과도한 재호출 방지를 위해 debounce/최소 길이 체크 등 고려.
   - 다만 이 TASK 09에서는 “검색 버튼/확인” 시점에 요청 보내는 형태로 단순화 가능.

2. **일관성**
   - 다른 탭과 동일한 `PolicyFeedListView` / `PolicyCard` 구성 유지.
   - 상태/에러 표시도 동일한 패턴 사용.

3. **확장성**
   - 향후 “최근 검색어 저장/삭제”, “서버 추천 키워드” 등을 추가해도 구조 변경 없이 기능 추가가 가능해야 한다.

---

## 4. 아키텍처 설계 (Architecture Design)

### 4.1 핵심 아이디어
- 검색 탭은 **다른 5개 탭과 같은 infra(Feed Controller + Query Engine + Orchestrator)를 사용**하되,
  **입력 소스(Keyword + Tags + FilterUiState)의 의미만 다르게 해석**하는 방식으로 설계한다.
- 즉, **검색 탭 전용 Controller는 없다**. `SearchFeedController`가 Base를 상속해 feedType만 `search`로 전달.
- Query 생성 규칙:
  - `feedType = PolicyFeedType.search`
  - `keyword = ui.keyword` (빈 문자열이면 null)
  - `filter.region/category/online/ongoing` 등 UI 상태를 그대로 전달
  - `tags = ui.tags` (추천 태그가 있을 경우 결합)

---

### 4.2 컴포넌트 구성

1. **UI 레이어**
   - 상단 필터/검색/정렬 바: `PolicyFilterBar`
   - 검색 전용 텍스트 입력 모달: `PolicyKeywordSheet`
   - 검색 탭 컨테이너: `PolicyFeedListView(feedType: PolicyFeedType.search)`
   - 검색 가이드/빈 상태: `PolicySearchEmptyView` (새 위젯 추가)

2. **상태 레이어**
   - `PolicyFilterUiState` + `policyFilterUiStateProvider`
   - `PolicyPagingState` + `SearchFeedController` (Base 상속)

3. **도메인/데이터 레이어**
   - `PolicyQueryOrchestrator.buildQuery(PolicyFeedType.search)`
   - `PolicyQueryEngine.fetch(PolicyFeedType.search, page: ..)`
   - `PolicyRepository.fetchPoliciesByQuery(...)`
   - `PolicyRemoteSource.fetchPoliciesWithParams(...)`

---

## 5. 데이터 파이프라인 / 흐름도 (Data Pipeline / Flow)

### 5.1 기본 검색 흐름

1. 유저가 상단 검색 영역을 탭  
   → `PolicyKeywordSheet` 오픈

2. 유저가 검색어 입력 후 “검색” 버튼 탭  
   → `policyFilterUiStateProvider.notifier.setKeyword(inputText)`

3. `PolicyFilterUiState` 변경  
   → `BasePolicyFeedController`(feedType=search)가 이 변화를 감지  
   → `refresh()` 호출

4. `SearchFeedController.refresh()`  
   → 내부에서 `loadFirstPage()` 실행  
   → `PolicyQueryEngine.fetch(feedType: search, page: 1)` 호출

5. `PolicyQueryEngine`  
   → `PolicyQueryOrchestrator.buildQuery(PolicyFeedType.search)` 호출  
   → `PolicyQuery` 생성 (keyword + filter + tags + sort)

6. `PolicyRepository.fetchPoliciesByQuery(query, page, pageSize)`  
   → HTTP 파라미터로 변환 (`searchPolicyNm` 등)  
   → `PolicyRemoteSource.fetchPoliciesWithParams(params)`  
   → 응답 JSON -> `PolicyModel` 리스트 -> `Policy` 리스트

7. 결과 `PolicyResult<List<Policy>>`  
   → `SearchFeedController`가 `PolicyPagingState.data(items, hasMore)`로 상태 업데이트  
   → UI(`PolicyFeedListView`)가 rebuild, 검색 결과 표시

---

### 5.2 빈 상태 / 에러 상태 흐름

- 검색 전(=keyword 비어있을 때):
  - SearchFeedController는 items가 비어있고, isLoading=false, failure=null인 상태가 유지.
  - `PolicyFeedListView(feedType: search)` 에서 **비어있으면서 keyword도 비어있다면** `PolicySearchEmptyView` 표시.

- 검색 결과 없음:
  - Repository 결과가 성공이지만 리스트 length=0
  - `PolicyPagingState.data(items: [], hasMore: false)`  
  - UI에서 “조건에 맞는 정책이 없습니다” 등의 메시지 표시.

- 에러:
  - Repository에서 Failure 발생 시 `PolicyPagingState.error(failure)`  
  - UI에서 `PolicyListError` 표시.

---

## 6. Provider / Controller 상호작용 규칙

1. `policyFilterUiStateProvider`
   - 검색어/필터/정렬/태그를 전역으로 관리하는 **단일 소스**.
   - `setKeyword`, `setRegion`, `setCategory`, `setSort`, `setTags`, `toggleOnlineOnly`, `toggleOngoingOnly`.

2. `PolicyQueryOrchestrator`
   - `buildQuery(PolicyFeedType.search)` 호출 시:
     - `filter.region = ui.region`
     - `filter.category = ui.category`
     - `filter.isOnline = ui.showOnlyOnline ? true : null`
     - `filter.isOngoing = ui.showOnlyOngoing ? true : null`
     - `keyword = ui.keyword.isEmpty ? null : ui.keyword`
     - `tags = ui.tags`

3. `PolicyQueryEngine`
   - `fetch(PolicyFeedType.search, page)` → 위 Query를 Repo에 전달.

4. `SearchFeedController`
   - BasePolicyFeedController 상속, 생성자에서 `feedType=PolicyFeedType.search` 전달.
   - `policyFilterUiStateProvider`를 listen:
     - keyword/필터/정렬/태그 변경 시 `supportsFilterAutoApply == true` → `refresh()`.
   - EventBus:
     - profileUpdated / cacheCleared / refreshRequested 등은 Base가 공통 처리.

5. UI (검색 탭)
   - **읽기 전용**: `ref.watch(searchFeedControllerProvider)`  
   - 상태 조작은 FilterUiState/Controller를 통해 간접적으로 이루어진다.

---

## 7. UI 상태도 (UI State Diagram — 텍스트 버전)

### 검색 탭 내 상태

1. **Idle (초기 진입)**
   - keyword: "" (비어있음)
   - items: []
   - isLoading: false
   - View: `PolicySearchEmptyView` (검색 가이드, 추천 태그 등)

2. **Searching (검색 중)**
   - keyword: "청년 주거"
   - loadFirstPage 호출 중
   - isLoading: true, items: [] 또는 기존 items (구현 선택)
   - View: 로딩 인디케이터 + 기존 리스트 or 로딩 전용

3. **Result (검색 결과 있음)**
   - items.length > 0
   - View: 리스트 (PolicyCard)

4. **EmptyResult (검색 결과 없음)**
   - 요청 성공 + items.length == 0
   - View: “조건에 맞는 정책이 없습니다” + 필터/키워드 수정 유도

5. **Error**
   - failure != null
   - View: `PolicyListError(message, onRetry: loadFirstPage)`

---

## 8. 이벤트 흐름 (Event Flow)

### 주요 이벤트

1. **KeywordChanged**
   - Source: `PolicyKeywordSheet`에서 “검색” 버튼 탭
   - Action: `setKeyword(newKeyword)`
   - Effect: SearchFeedController.refresh() → 새 검색 수행

2. **FilterChanged (Region/Category/Online/Ongoing)**
   - Source: `PolicyFilterBottomSheet`
   - Action: `setRegion/setCategory/toggleOnlineOnly/toggleOngoingOnly`
   - Effect:
     - SearchFeedController.refresh() (자동)
     - Recommend/All/Region 등도 함께 갱신

3. **SortChanged**
   - Source: `PolicySortBottomSheet`
   - Action: `setSort(newSort)`
   - Effect: SearchFeedController.refresh() + 다른 피드도 재정렬

4. **TabSwitched (다른 탭 → 검색 탭)**
   - Source: `PolicyFeedHomeScreen`의 TabBarView
   - Action: 없음 (단순 포커스 이동)
   - Effect:
     - SearchFeedController의 현재 상태 유지 (검색 결과 재사용)
     - 필요 시 “탭 진입 시점에만 초기 로딩” 옵션은 future TASK로 분리

---

## 9. 파일 구조 (File Structure)

> 이 TASK 09에서 **생성/수정 대상**만 정리한다.  
> 이미 존재하는 파일은 “기능 확장/구현 보완” 수준으로만 수정해야 한다.

### 9.1 생성 (또는 없으면 새로 생성)

1. `lib/features/policy_new/presentation/filters/policy_keyword_sheet.dart`
   - 검색어 입력 UI + “검색” 버튼.
   - `policyFilterUiStateProvider`에 keyword를 저장.

2. `lib/features/policy_new/presentation/widgets/policy_search_empty_view.dart`
   - 검색 탭 초기 상태/빈 상태에서 보여줄 가이드 뷰.

### 9.2 수정 (구현 보완)

1. `lib/features/policy_new/application/controllers/policy_query_orchestrator.dart`
   - `buildQuery(PolicyFeedType.search)` 구현 확정/보완.

2. `lib/features/policy_new/application/controllers/policy_query_engine.dart`
   - `fetch(PolicyFeedType.search, page: ...)` 사용 중인지 확인 (필요 시 호출부 보완).

3. `lib/features/policy_new/application/controllers/base_feed_controller.dart`
   - FilterUiState listen → SearchFeedController도 자동 refresh 대상 포함되어 있는지 확인.

4. `lib/features/policy_new/application/controllers/search_feed_controller.dart`
   - BasePolicyFeedController 상속 + feedType=search 전달 (없으면 새로 생성).
   - 내부에 별도 상태는 두지 않음.

5. `lib/features/policy_new/presentation/widgets/policy_feed_list_view.dart`
   - feedType가 `PolicyFeedType.search`이고,
     - items.isEmpty && keyword.isEmpty 일 때 `PolicySearchEmptyView` 보여주도록 조건 분기 추가.

6. `lib/features/policy_new/presentation/filters/policy_filter_bar.dart`
   - 검색 영역 탭 시 `PolicyKeywordSheet`를 오픈하도록 연결.

7. `lib/features/policy_new/presentation/screens/policy_feed_home_screen.dart`
   - 이미 6탭이 있다면, 검색 탭이 `PolicyFeedType.search`로 연결되어 있는지 재확인.

---

## 10. Acceptance Criteria (수용 기준)

1. **검색 탭 UI**
   - [ ] 정책 메인 화면의 6개 탭 중 “검색” 탭이 존재한다.
   - [ ] 검색 탭에서 상단 필터/검색/정렬 바가 표시된다.
   - [ ] 검색 탭 최초 진입 시 `PolicySearchEmptyView`가 보인다(검색 가이드 상태).

2. **검색 동작**
   - [ ] 상단 검색 영역을 탭하면 `PolicyKeywordSheet`가 나타난다.
   - [ ] 사용자가 검색어를 입력하고 “검색” 버튼을 누르면, `policyFilterUiState.keyword`가 갱신된다.
   - [ ] 검색어 갱신 후, `SearchFeedController`가 자동으로 첫 페이지를 로드한다.
   - [ ] 검색 결과가 있을 경우 정책 카드 리스트로 표시된다.
   - [ ] 검색 결과가 없을 경우 “조건에 맞는 정책이 없습니다” 메시지가 표시된다.
   - [ ] 검색 중 에러가 발생하면 에러 메시지 + “다시 시도” 버튼이 표시된다.

3. **필터/정렬 연동**
   - [ ] 검색 탭에서 지역/카테고리/온라인/모집중/정렬을 변경하면, 검색 결과가 그 조건에 맞게 다시 로드된다.
   - [ ] Recommend/All/Region 탭에서도 같은 FilterUiState를 공유한다.

4. **상태 유지**
   - [ ] 검색어와 검색 결과는 탭 전환 후 검색 탭으로 돌아왔을 때도 유지된다.
   - [ ] 앱을 완전히 종료하기 전까지, 검색 탭의 현재 상태(검색어+결과)가 유지된다.

5. **실 API 연동 (가능한 범위에서)**
   - [ ] Search Query가 Repository를 통해 실제 OpenAPI의 검색 파라미터(`searchPolicyNm` 등)로 전달되어야 한다.
   - [ ] 최소 1개의 실제 검색어에 대해, API 응답 결과가 앱 내에서 정상적으로 리스트로 표시되는 것을 확인할 수 있어야 한다.

6. **코드 품질**
   - [ ] 모든 새 파일은 `policy_new` 네임스페이스를 사용하고, 기존 V1 정책코드와 의존성이 없다.
   - [ ] 빌드시 타입 에러/미사용 import/분기 누락이 없어야 한다.
   - [ ] Controller/Provider/Query/Filter 간 순환 참조가 없어야 한다.

---


❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️🩵🩵🩵

@chatgpt-codex
# TASK 08 — PolicyNew 즐겨찾기(좋아요) 전체 시스템 구축
# (즐겨찾기 저장소 + EventBus + Favorite 탭 + 카드 하트 버튼 + Feed 연동)

> 목표: `policy_new` 모듈 안에서 **“즐겨찾기(좋아요)” 기능을 도메인 ~ 저장소 ~ 컨트롤러 ~ UI까지 완전히 구현**한다.  
> - 정책 카드의 하트 버튼 토글  
> - 즐겨찾기 정보 영구 저장(로컬)  
> - “즐겨찾기 탭”에서만 그 정책들만 모아서 보기  
> - 다른 탭(추천/전체/검색)에서도 하트 상태 실시간 반영  
> - EventBus 기반으로 탭 간 상태 동기화

---

## 1. 시스템 정의 (System Definition)

### 1.1 시스템 범위

- 모듈: `lib/features/policy_new/**`
- 기능: **정책 즐겨찾기(Favorite) 시스템**
  - 정책 카드에서 하트 버튼 토글
  - 로컬 저장소에 즐겨찾기 상태 저장 (앱 재실행 후에도 유지)
  - “즐겨찾기 탭”에서 즐겨찾기한 정책 목록만 노출
  - 다른 탭(추천/전체/지역/검색/비교)에서도 하트 상태 실시간 반영
  - EventBus를 통해 즐겨찾기 변경 이벤트 방송

### 1.2 관련 서브시스템

- Domain:
  - `Policy` (job02)
  - `PolicyFavorite` (job02 에서 정의했거나, 없으면 함께 정의)
- Repository:
  - `PolicyRepository` / `PolicyRepositoryImpl` (job03)
- Controller:
  - `BasePolicyFeedController`, `FavoriteFeedController` (job04)
- UI:
  - `PolicyCard`, `PolicyFeedListView`, `PolicyFeedHomeScreen` (job05 이후)
- Event:
  - `PolicyEventBus` / `PolicyEventType` (job01 계열 설계에서 언급된 이벤트 시스템)

---

## 2. 문제 정의 (Problem Definition)

현재 `policy_new`의 정책 화면은:

1. 정책 카드에는 “즐겨찾기/좋아요” 상태가 없다.
2. 사용자가 관심 정책을 저장해둘 수 있는 방법이 없다.
3. “즐겨찾기 탭(PolicyFeedType.favorite)”이 설계 수준에서만 존재하고, 실제로는:
   - 어떤 정책이 즐겨찾기인지 판단 불가
   - API/Repository/Controller에서 favorite 상태 연동 안 됨
   - UI에서 favorite 전용 목록 표시 불가
4. 다른 탭(추천/전체/검색 등)과 “즐겨찾기 탭” 사이의 상태 동기화가 없다:
   - 한 탭에서 하트를 눌러도, 다른 탭에선 반영 안 됨
   - 앱 재실행 시에도 favorite 상태를 복원하지 못함

**결론**:  
- 정책 즐겨찾기 기능이 **도메인/저장소/컨트롤러/UI 전 구간에서 비어 있다.**  
- 이 TASK 08에서 즐겨찾기 시스템 전체를 **한 번에** 구축해야 한다.

---

## 3. 요구사항 분석 (Requirements Analysis)

### 3.1 기능 요구사항 (Functional)

1. **즐겨찾기 토글**
   - 정책 카드 우측 상단(또는 제목 옆)에 하트 아이콘을 배치.
   - 하트 클릭 시:
     - 해당 정책이 즐겨찾기 목록에 없으면 → 추가
     - 이미 있으면 → 제거
   - 하트 상태는 즉시 UI에 반영 (optimistic UI 가능).

2. **즐겨찾기 상태 유지**
   - 즐겨찾기는 **로컬 저장소**(예: Isar, SharedPreferences, Hive 등 어떤 것이든 추상화) 에 영구 저장.
   - 앱 재실행 후에도 즐겨찾기 상태 유지.

3. **즐겨찾기 탭**
   - “즐겨찾기” 탭(PolicyFeedType.favorite)을 선택하면:
     - 즐겨찾기된 정책들만 리스트로 노출.
     - 기존 페이징/로딩/에러/빈 상태 핸들링은 동일 패턴 유지.
   - 즐겨찾기가 하나도 없을 경우, “즐겨찾기한 정책이 없습니다” 빈 화면 표시.

4. **탭 간 상태 동기화**
   - 추천/전체/지역/검색/비교 등 모든 탭의 `PolicyCard`에서 하트 상태가 동일해야 한다.
   - 어느 탭에서 하트를 눌러도:
     - 모든 탭에서 해당 정책 카드의 하트 상태가 최신으로 유지.
     - “즐겨찾기 탭” 리스트도 자동 갱신.

5. **EventBus 통합**
   - 즐겨찾기 추가/제거 시 `PolicyEventType.favoritesChanged` 이벤트 발행.
   - FavoriteFeedController는 해당 이벤트를 구독하고 refresh.
   - RecommendFeedController 등은 필요시 즐겨찾기 마크 재렌더링.

6. **정책 ID 기준 식별**
   - 즐겨찾기 상태는 `policy.id`를 기준으로 관리.
   - 동일 ID가 여러 탭/페이지에 등장해도 하나의 favorite 상태를 공유.

### 3.2 비기능 요구사항 (Non-Functional)

1. **성능**
   - 즐겨찾기 토글은 즉시 UI 반응 (완전히 비동기로 저장).
   - 즐겨찾기 수가 많아도 (수백 개) 리스트 렌더링에 문제가 없도록 설계.
2. **안정성**
   - 로컬 저장소에 읽기/쓰기 실패 시 graceful fallback:
     - UI는 ErrorSnackBar나 로그 출력.
     - 앱 전체 Crash 금지.
3. **확장성**
   - 향후 “폴더/카테고리별 즐겨찾기” 또는 “클라우드 동기화”로 확장 가능하도록 Repository 인터페이스를 깔끔하게 정의.

---

## 4. 아키텍처 설계 (Architecture Design)

### 4.1 핵심 구성 요소

1. **Domain**
   - `Policy` : 기존 job02 정의
   - `PolicyFavorite`:
     ```dart
     class PolicyFavorite {
       final String policyId;
       final DateTime savedAt;

       const PolicyFavorite({
         required this.policyId,
         required this.savedAt,
       });
     }
     ```

2. **Repository 계층**
   - `PolicyFavoriteRepository` (Domain 레이어 인터페이스)
   - `PolicyFavoriteRepositoryImpl` (Data 레이어 구현)
     - 내부에서 `PolicyFavoriteLocalDataSource` 사용

3. **Local DataSource**
   - `PolicyFavoriteLocalDataSource`
     - getAll()
     - isFavorite(policyId)
     - addFavorite(policyId)
     - removeFavorite(policyId)

4. **Service / UseCase 계층**
   - `PolicyFavoriteService`
     - toggleFavorite(Policy policy)
     - isFavorite(Policy policy)
     - getFavoriteIds()
     - getFavoritePolicies() (필요시 Repository와 결합)

5. **EventBus**
   - `PolicyEventBus`:
     - `PolicyEventType.favoritesChanged`
     - payload: 변경된 policyId 리스트 또는 전체 상태

6. **Controller 계층**
   - `FavoriteFeedController` (FeedType.favorite)
     - BasePolicyFeedController 상속
     - QueryEngine + FavoriteRepository 활용
   - 기타 FeedController:
     - 즐겨찾기 상태 자체는 Repository/Service를 통해 읽는다 (UI에서 직접 `isFavorite` 구독).

7. **UI**
   - `PolicyCard`:
     - props: `Policy policy`, `bool isFavorite`, `onFavoriteToggle()`
   - `PolicyFeedListView`:
     - 각 정책에 대해 favorite 상태를 Provider로 읽어서 전달
   - Empty/Error/Loading는 기존 것을 재사용

---

## 5. 데이터 파이프라인 / 흐름도 (Data Pipeline & Flow)

### 5.1 Favorite On/Off 흐름

1. 유저가 PolicyCard의 하트 아이콘 탭
2. `onFavoriteToggle(policy)` 호출
3. `PolicyFavoriteService.toggleFavorite(policy)` 호출
4. Service 내부 로직:
   - `isFavorite(policy.id)` 조회
   - true → `repository.remove(policy.id)`
   - false → `repository.add(policy.id)`
5. Repository:
   - LocalDataSource에 읽기/쓰기
   - 성공 후, EventBus에 `favoritesChanged` 이벤트 발행
6. UI/Controller:
   - `favoriteIdsProvider` 또는 `isFavoriteProvider(policy.id)`가 값 변경 감지
   - PolicyCard 재렌더링 (하트 상태 갱신)
   - FavoriteFeedController는 `favoritesChanged` 이벤트 수신 → `refresh()` 호출 → 추천/전체 탭과 동기화

### 5.2 앱 시작 시 Favorite 상태 로드

1. 앱/모듈 초기화 시:
   - `PolicyFavoriteRepository`가 LocalDataSource에서 favorite 목록 로드
   - `favoriteIdsProvider` 초기값 설정
2. 모든 PolicyCard는 `favoriteIdsProvider`를 통해 isFavorite 여부를 즉시 확인 가능

### 5.3 Favorite 탭 로드

1. Favorite 탭이 선택됨 → FavoriteFeedController의 `loadFirstPage()` 호출
2. QueryEngine:
   - FeedType.favorite을 전달받고, QueryOrchestrator에서
     - tags = favoriteIds
     - filter = 기본 PolicyFilter
   - Repository.fetchPoliciesByQuery() 호출
3. Repository:
   - Remote/API에서 policyId 필터가 가능하면 해당 정책만 로딩
   - 그렇지 않다면:
     - 전체 목록 또는 페이지 기반으로 불러온 후, favoriteIds와 교차 필터 (후처리)
4. FavoriteFeedController는 결과를 PolicyPagingState에 반영
5. UI: PolicyFeedListView가 해당 상태를 렌더링

---

## 6. Provider / Controller 상호작용 규칙

### 6.1 Provider 정의

- `policyFavoriteRepositoryProvider`
- `policyFavoriteServiceProvider`
- `favoriteIdsProvider` (Set<String> 혹은 List<String>)
- `favoriteFeedControllerProvider` (StateNotifierProvider)

### 6.2 상호작용 규칙

1. **PolicyCard → Service**
   - 카드에서 onFavoriteToggle 호출 시:
     - `ref.read(policyFavoriteServiceProvider).toggleFavorite(policy);`

2. **Service → Repository → LocalDataSource**
   - Service는 로직/유즈케이스 담당
   - Repository는 저장소 추상화
   - LocalDataSource가 실제 저장 수행

3. **Repository → EventBus + favoriteIdsProvider**
   - add/removeFavorite 성공 시:
     - `favoriteIdsProvider` 내부 상태 업데이트
     - `policyEventBus`에 `favoritesChanged` 이벤트 발행

4. **EventBus → FeedControllers**
   - FavoriteFeedController:
     - `favoritesChanged` 수신 → `refresh()` 호출
   - RecommendFeedController:
     - 필요 시 즐겨찾기 표시를 업데이트(리스트 자체는 그대로)

5. **favoriteIdsProvider → UI**
   - PolicyCard:
     - `final favoriteIds = ref.watch(favoriteIdsProvider);`
     - `final isFavorite = favoriteIds.contains(policy.id);`

---

## 7. UI 상태도 (UI State Diagram)

### 7.1 PolicyCard Favorite 상태

- 상태: `isFavorite: true/false`
- 이벤트:
  - `사용자 탭` → toggleFavorite
  - `favoriteIds 변경` → PolicyCard 재빌드
- 전이:
  - false → (toggle) → true
  - true → (toggle) → false
- 가시적 표시:
  - `isFavorite == true` → 채워진 하트 아이콘 (예: Icons.favorite)
  - `isFavorite == false` → 빈 하트 아이콘 (예: Icons.favorite_border)

### 7.2 Favorite 탭 전체 상태

- 상태:
  - `loading`, `data (items)`, `empty`, `error`
- 이벤트:
  - 탭 진입 → loadFirstPage()
  - favoritesChanged 이벤트 → refresh()
  - pull-to-refresh → refresh()
- 전이:
  - initial → loading → data/empty/error
  - data → loading → data/empty/error (refresh)
  - empty → loading → data/empty/error

---

## 8. 이벤트 흐름 (Event Flow)

### 8.1 즐겨찾기 변경 이벤트

1. PolicyCard 하트 탭
2. Service.toggleFavorite → Repository.add/remove
3. LocalDataSource 저장 성공
4. Repository:
   - `favoriteIdsProvider` 상태 업데이트
   - EventBus에 `PolicyEvent(type: favoritesChanged, payload: {policyId})` 발행
5. 구독자:
   - FavoriteFeedController:
     - `favoritesChanged` 수신 → `refresh()`
   - RecommendFeedController 등:
     - 필요시 즐겨찾기 표시만 재렌더 (리스트는 그대로)

### 8.2 캐시 초기화 이벤트 (이미 존재한다면)

- Event: `PolicyEventType.cacheCleared`
- FavoriteFeedController 포함 모든 FeedController:
  - `_resetPaging()` 후 필요 시 refresh()

---

## 9. 파일 구조 (File Structure)

아래 파일들을 `policy_new` 아래에 생성/수정한다.

```txt
lib/
  features/
    policy_new/
      domain/
        entities/
          policy.dart                      # (존재, 수정 X)
          policy_favorite.dart             # NEW: PolicyFavorite 정의
        repositories/
          policy_favorite_repository.dart  # NEW: 인터페이스
      data/
        datasources/
          policy_favorite_local_data_source.dart  # NEW: 로컬 저장소
        repositories/
          policy_favorite_repository_impl.dart    # NEW: 구현체
      application/
        services/
          policy_favorite_service.dart     # NEW: toggleFavorite, isFavorite 등
        controllers/
          favorite_feed_controller.dart    # EXISTING일 수 있음 → TASK 08 기준으로 교체/보완
        providers.dart                     # favorite 관련 provider 등록 (필요 시)
        events/
          policy_event.dart                # favoritesChanged 이벤트 타입 확장/명시
      presentation/
        widgets/
          policy_card.dart                 # 하트 버튼 + isFavorite 표시 추가
        screens/
          policy_feed_home_screen.dart     # Favorite 탭 자체는 job05에서 존재, 동작 검증

규칙:
	•	Domain/Repository/Controller/Presentation 기존 구조를 최대한 존중하고, 추가/확장 위주로 구현한다.
	•	기존 policy_card.dart가 다른 용도로 사용 중이면, policy_card_new.dart로 별도 생성하고 new 화면에서만 사용하도록 한다.

⸻

10. Acceptance Criteria (수용 기준)

다음 체크리스트가 모두 충족되면 TASK 08 완료로 간주한다.
	•	PolicyFavorite 도메인 엔티티가 생성되어, policyId + savedAt 정보를 담을 수 있다.
	•	PolicyFavoriteRepository 인터페이스가 정의되어 있고, 즐겨찾기 추가/삭제/조회 메서드를 제공한다.
	•	PolicyFavoriteRepositoryImpl이 로컬 저장소(LocalDataSource)를 사용하여 즐겨찾기를 영구 저장/조회할 수 있다.
	•	PolicyFavoriteService가 toggleFavorite, isFavorite, getFavoriteIds 등의 메서드를 통해 UI/Controller에서 사용하기 편리한 API를 제공한다.
	•	favoriteIdsProvider가 존재하며, 현재 즐겨찾기된 정책들의 ID 목록(또는 Set)을 상태로 가진다.
	•	PolicyCard가 isFavorite 상태를 받아 하트 아이콘을 올바르게 표시하며, 탭 시 PolicyFavoriteService.toggleFavorite을 호출한다.
	•	즐겨찾기 토글 시, favoriteIdsProvider 상태가 즉시 업데이트되고 하트 아이콘이 재렌더링된다.
	•	즐겨찾기 토글 시, PolicyEventType.favoritesChanged 이벤트가 EventBus에 발행된다.
	•	FavoriteFeedController가 favoritesChanged 이벤트를 구독하고, refresh()를 호출하여 Favorite 탭의 목록이 업데이트된다.
	•	Favorite 탭에서 즐겨찾기한 정책 목록만 표시되며, 즐겨찾기가 없으면 빈 상태 화면이 표시된다.
	•	앱을 재실행해도 즐겨찾기 상태가 유지된다 (로컬 저장소 연동 완료).
	•	전체 프로젝트 빌드 시 타입 에러, Provider 참조 에러, import 에러가 없어야 한다.

⸻




@chatgpt-codex
# TASK 07 — PolicyNew **추천 탭(Recommend Tab)** 단일 기능 E2E 구현 (job01 스타일 설계서)

> 목표:  
> `policy_new` 모듈 안에서 **“추천 탭 하나만”을 믿을 수 없을 정도로 완성도 높게** 끝까지 구현한다.  
> (데이터 로드 → 필터/추천 로직 반영 → 무한스크롤 → 새로고침 → 이벤트 반응 → UI/UX까지)

---

## 1. 시스템 정의 (System Definition)

### 1.1 범위(Scope)

- 이 Task 는 **“추천 탭(Recommend Feed)”라는 단일 탭**에만 집중한다.
- 이미 job01~job06에서 설계된 전체 구조를 사용하되, **그 중 Recommend 탭 하나를 실제로 동작하는 수준까지 구현**하는 것이 목표다.
- Recommend 탭은:
  - 사용자 프로필(나이, 지역, 관심 키워드 등)
  - UI 필터 상태(카테고리, 지역, 정렬, 온라인/모집중 여부)
  - 추천 태그(키워드)
  를 기반으로 한 **맞춤형 정책 목록 피드**다.

### 1.2 적용 모듈

- 네임스페이스: `lib/features/policy_new/**`
- 주요 레이어:
  - `domain/`
  - `data/`
  - `application/`
  - `presentation/`

---

## 2. 문제 정의 (Problem Definition)

현재 상태:

1. 상단 설계(job01~job06)에서 **추천 탭 컨셉과 구조는 정의**되어 있음.
2. 하지만 실제 구현은 아래와 같은 상태일 수 있다:
   - Recommend 탭이 UI에 보이더라도 **실제 데이터 로드/표시가 되지 않거나**,  
     혹은 All 탭과 동일한 데이터를 보여줌.
   - 추천 전용 로직(유저 프로필, 추천 태그 기반 Query 조립)이 적용되지 않음.
   - EventBus(즐겨찾기 변경, 프로필 변경 등)에 따른 자동 새로고침이 미적용.
   - Empty/Loading/Error 상태 UI가 추천 탭에서 제대로 작동하지 않음.

**따라서**:  
> “추천 탭 하나도 제대로 신뢰할 수 없는 상태” →  
> 이번 TASK 07에서 **Recommend 탭 하나만큼은 “완성된 기능”으로 끌어올리는 것이 목표**.

---

## 3. 요구사항 분석 (Requirements)

### 3.1 기능 요구사항 (Functional Requirements)

1. **초기 로드**
   - Recommend 탭이 최초로 활성화될 때, 자동으로 첫 페이지를 로드해야 한다.
   - 로드 기준:
     - 사용자 프로필: `userProfileProvider` (age, region, recommendTags)
     - UI 필터: `policyFilterUiStateProvider` (job06 기준)
     - FeedType: `PolicyFeedType.recommend`

2. **추천 로직**
   - PolicyQuery 생성 시 다음 조건을 반영:
     - 지역: UI에서 선택한 region이 `all`인 경우 → `userProfile.region` 사용
     - 나이: `userProfile.age`
     - 추천 태그:
       - UI에서 선택한 tags가 비어있지 않으면 그 값 사용
       - 비어있으면 `userProfile.recommendTags` 사용
     - 정렬: `PolicySortOption.recommendation` 고정
     - 온라인/모집중 필터: UI 상태(`showOnlyOnline`, `showOnlyOngoing`)가 true일 경우만 값을 세팅

3. **무한 스크롤(Pagination)**
   - List 끝에 도달 시 자동으로 `loadNextPage()` 호출하여 다음 페이지 로드.
   - SWR 캐시/페이지 크기는 job03~06에서 정의된 설정 사용.

4. **새로고침(Refresh)**
   - Pull-to-refresh 또는 필터 변경(EventBus, FilterUiState 변화) 시
     - Recommend 탭은 **페이지 1부터 다시 로드**해야 한다.

5. **이벤트 반응(Event Handling)**
   - 아래 이벤트에 대해 Recommend 탭은 반드시 적절히 반응:
     - `PolicyEventType.profileUpdated` → 추천 기준 변경 → `refresh()`
     - `PolicyEventType.favoritesChanged` → 추천 점수/정렬에 영향 가능 → `refresh()`
     - `PolicyEventType.cacheCleared` → 캐시 초기화 후 다음 로드에서 fresh fetch

6. **UI/UX**
   - Recommend 탭은 `PolicyFeedListView(feedType: PolicyFeedType.recommend)`를 사용.
   - Loading/Empty/Error/Content 상태 전부 올바르게 표시되어야 한다.
   - 정책 카드를 탭하면 `PolicyDetailBottomSheet` 열림.
   - “실제 정책 페이지로 이동” 버튼이 Detail 시트에 존재하고 동작해야 한다.

### 3.2 비기능 요구사항 (Non-Functional)

- 가독성/유지보수성 높은 코드 구조.
- 다른 탭(All/Region/Search 등)에 영향 없이 Recommend 탭만 잘 작동해야 함.
- Null/에러 상황에서 앱 크래시 없이 Failure/Empty UI로 graceful degrade.
- 재사용 가능한 패턴 유지: 다른 탭 구현 시 그대로 복제 가능해야 함.

---

## 4. 아키텍처 설계 (Architecture Design)

### 4.1 레이어 구조

- **Domain**
  - `Policy`, `PolicyFilter`, `PolicyQuery`, `PolicyFeedType`, `PolicySortOption`
- **Data**
  - `PolicyRepository` / `PolicyRepositoryImpl`
  - `PolicyRemoteSource`, `PolicyCache`
- **Application**
  - `PolicyFilterUiState` + `policyFilterUiStateProvider`
  - `PolicyQueryOrchestrator`
  - `PolicyQueryEngine`
  - `RecommendFeedController` (BasePolicyFeedController 상속)
- **Presentation**
  - `PolicyFeedHomeScreen`
  - `PolicyFeedListView`
  - `PolicyCard`
  - `PolicyDetailBottomSheet`
  - (필요 시) Recommend 탭과 관련된 추천 태그 UI (e.g. `PolicyRecommendTagsBar`)

### 4.2 Recommend 탭 전용 규칙

- FeedType: `PolicyFeedType.recommend`
- Query 생성은 `PolicyQueryOrchestrator._buildRecommendQuery()` 하나로 집약한다.
- Controller는 Query 내용을 몰라도 된다.  
  → 단지 `feedType`만 알고 `queryEngine.fetch(feedType, page)` 호출.

---

## 5. 데이터 파이프라인 / 흐름도 (Data Flow)

텍스트 기반 흐름도:

1. 유저가 앱에서 “추천 탭”으로 들어간다.
2. `PolicyFeedHomeScreen` → `TabBarView` → `PolicyFeedListView(feedType: recommend)` 표시.
3. `PolicyFeedListView`:
   - `ref.watch(recommendFeedControllerProvider)`로 상태 구독.
   - 첫 진입 시 Controller가 `loadFirstPage()` 호출(이미 init에서 or 외부에서 호출).
4. `RecommendFeedController.loadFirstPage()`:
   - 내부 `_page = 1`, state = loading
   - `queryEngine.fetch(PolicyFeedType.recommend, page: 1)` 호출
5. `PolicyQueryEngine.fetch()`:
   - `orchestrator.buildQuery(PolicyFeedType.recommend)` 호출
6. `PolicyQueryOrchestrator._buildRecommendQuery()`:
   - `userProfileProvider`에서 age/region/recommendTags 읽음.
   - `policyFilterUiStateProvider`에서 region/category/sort/tags/online/ongoing 읽음.
   - 정책에 맞게 `PolicyFilter` + `PolicyQuery` 생성 후 반환.
7. Repository (`PolicyRepositoryImpl.fetchPoliciesByQuery`) 호출:
   - Query → HTTP queryParameters 빌더 → `remote.fetchPoliciesWithParams(...)`
   - 응답 JSON → `PolicyModel.fromJson` → `Policy.toDomain()`
   - 캐시(SWR) 저장 후 `PolicyResult<List<Policy>>`로 반환.
8. Controller:
   - Success → `PolicyPagingState.data`로 상태 갱신.
   - UI: `PolicyFeedListView`가 이를 구독하여 카드 리스트 렌더링.
9. 사용자가 스크롤 끝까지 내려감:
   - `loadNextPage()` 호출 → page 2, 3… 반복.
10. EventBus 혹은 FilterUiState 변경:
    - Controller가 listen 중 → `refresh()` 호출 → 1~8 과정 반복.

---

## 6. Provider / Controller 상호작용 규칙

### 6.1 관련 Provider 정리

- `userProfileProvider`  
  → age, region, recommendTags

- `policyFilterUiStateProvider`  
  → region, category, sort, keyword, tags, showOnlyOnline, showOnlyOngoing

- `policyQueryOrchestratorProvider`  
  → `PolicyQueryOrchestrator`

- `policyQueryEngineProvider`  
  → `PolicyQueryEngine`

- `recommendFeedControllerProvider`  
  → `RecommendFeedController` + `PolicyPagingState` 반환

- `policyEventBusProvider`  
  → `PolicyEvent?` (favoritesChanged, cacheCleared, profileUpdated 등)

### 6.2 RecommendFeedController 규칙

- BasePolicyFeedController 상속.
- 생성자에서:
  - `feedType: PolicyFeedType.recommend`로 고정.
- Base 클래스에서:
  - `supportsFilterAutoApply == true` 이므로 FilterUiState 변경 시 자동 refresh.
  - EventBus에 대해:
    - `profileUpdated` → refresh
    - `favoritesChanged` → refresh
    - `cacheCleared` → state reset + 다음 load에서 fresh fetch

---

## 7. UI 상태도 (UI State Diagram)

Recommend 탭의 상태는 `PolicyPagingState`로 표현.

- **Initial**
  - `isLoading = false`, `items = []`, `failure = null`, `hasMore = true`
  - 화면: “당긴다 → 새로고침”만 가능, 컨텐츠 없음 (보통 바로 loadFirstPage 호출 예정)

- **Loading**
  - 첫 페이지 로딩:
    - 상단 전체에 로딩 인디케이터 / 스켈레톤 표시 (`PolicyListLoading`)
  - 다음 페이지 로딩:
    - 리스트 하단에 footer 로딩 표시

- **Loaded (With Data)**
  - `items.isNotEmpty == true`
  - `hasMore == true | false`
  - UI: 카드 리스트 스크롤 가능

- **Empty**
  - `items.isEmpty == true` AND `failure == null` AND `isLoading == false`
  - UI: `PolicyListEmpty` 표시
  - 메시지: “현재 조건에 맞는 추천 정책이 없습니다. 필터나 검색 조건을 바꿔보세요.”

- **Error**
  - `failure != null`
  - UI: `PolicyListError(message: failure.message, onRetry: loadFirstPage)`

---

## 8. 이벤트 흐름 (Event Flow)

### 8.1 사용자 이벤트

1. **탭 전환 (다른 탭 → 추천 탭)**
   - TabBarView에서 Recommend 탭 페이지가 활성화됨.
   - 최초 활성화 시 `loadFirstPage()` 호출 (이미 구현되어 있거나, 필요시 onInit에서 호출).

2. **스크롤 끝까지 이동**
   - `PolicyFeedListView`에서 index == items.length 위치에서 `loadNextPage()` 호출.

3. **당겨서 새로고침(Pull-to-Refresh)**
   - `RefreshIndicator` → `controller.refresh()` 호출.

4. **필터/정렬/검색/추천 태그 변경**
   - Filter UI → `policyFilterUiStateProvider` 상태 변경.
   - BasePolicyFeedController가 이를 감지해 `refresh()` 호출.

5. **정책 카드 탭**
   - `PolicyDetailBottomSheet(policyId: ...)` 열기.
   - 상세에서 “실제 정책 페이지로 이동” 버튼 클릭 시 외부 브라우저로 이동.

### 8.2 시스템/도메인 이벤트

- `PolicyEventType.profileUpdated`
  - ex) 온보딩/설정 화면에서 나이/지역/관심 키워드 변경
  - Recommend 탭과 Region 탭은 자동 `refresh()`.

- `PolicyEventType.favoritesChanged`
  - 즐겨찾기 토글 시 발생.
  - Recommend 탭은 즐겨찾기 상태 변화에 따라 추천 순위가 달라질 수 있으므로 `refresh()`.

- `PolicyEventType.cacheCleared`
  - 디버그/설정에서 캐시 초기화 시
  - Recommend 탭은 다음 요청에서 새 데이터 fetch.

---

## 9. 파일 구조 (File Structure)

이 Task에서 관여하는 파일(생성/수정):

1. **이미 존재해야 하는 파일** (필요 시 일부 보완/전체 교체)
   - `lib/features/policy_new/application/filters/policy_filter_ui_state.dart`
   - `lib/features/policy_new/application/controllers/policy_query_orchestrator.dart`
   - `lib/features/policy_new/application/controllers/policy_query_engine.dart`
   - `lib/features/policy_new/application/controllers/base_feed_controller.dart`
   - `lib/features/policy_new/application/controllers/recommend_feed_controller.dart`
   - `lib/features/policy_new/application/providers.dart`
   - `lib/features/policy_new/presentation/screens/policy_feed_home_screen.dart`
   - `lib/features/policy_new/presentation/widgets/policy_feed_list_view.dart`
   - `lib/features/policy_new/presentation/widgets/policy_card.dart`
   - `lib/features/policy_new/presentation/detail/policy_detail_bottom_sheet.dart`

2. **이 Task에서 반드시 확인/보완할 포인트**
   - `PolicyQueryOrchestrator._buildRecommendQuery()` 구현이 요구사항을 정확히 반영하는지 확인/수정.
   - `RecommendFeedController`가 BasePolicyFeedController를 올바르게 상속하고 feedType 설정이 정확한지 확인.
   - `policy_feed_home_screen.dart` 에서 Recommend 탭이 `PolicyFeedType.recommend` 로 연결되어 있는지 확인.
   - `policy_feed_list_view.dart` 에서 Recommend 탭도 다른 탭들과 동일한 로딩/에러/빈 상태 처리 흐름을 따르는지 확인.

---

## 10. 구현 단계 (Step-by-Step Guide)

1. **`PolicyQueryOrchestrator._buildRecommendQuery()` 구현/보완**
   - 사용자 프로필 + FilterUiState를 이용해 위에서 정의한 로직대로 Query 조립.
   - 이미 함수가 있다면 전체 내용을 이 Task 요구사항에 맞게 다시 교체.

2. **`PolicyQueryEngine.fetch(feedType: recommend, page)` 동작 확인**
   - Orchestrator → Repository → Remote → Model → Domain → Result 흐름이 정상인지 확인.
   - 최소한 로그/주석으로 Recommend 경로가 구분되도록 구성.

3. **`RecommendFeedController` 구현**
   - BasePolicyFeedController 상속.
   - feedType = `PolicyFeedType.recommend` 를 생성자에서 전달.
   - 별도의 추가 상태는 가지지 않는다 (모든 Query는 Orchestrator가 책임).

4. **Provider 연결**
   - `providers.dart`에 `recommendFeedControllerProvider`가 올바르게 등록되어 있는지 확인.
   - `PolicyFeedListView`에서 `feedType == recommend`일 때 이 Provider를 사용하도록 되어 있는지 확인.

5. **UI 연동**
   - `PolicyFeedHomeScreen`에서 Recommend 탭이 첫 번째 탭으로 존재하는지 확인.
   - 화면 진입 후, `loadFirstPage()`가 한 번은 호출되도록 구성 (initState or 첫 렌더 시점).

6. **이벤트 연동**
   - BasePolicyFeedController에서 `policyFilterUiStateProvider`와 `policyEventBusProvider`를 listen하는 로직이 Recommend 탭에 적용되어 있는지 확인.
   - 프로필 변경 / 즐겨찾기 변경 / 캐시 초기화 시 Recommend 탭이 자동 새로고침 되는지 테스트.

7. **Empty/Error 상태 UX 점검**
   - API가 빈 리스트, 오류 응답, 네트워크 오류를 반환하는 상황을 가정하고
     - Empty / Error 위젯이 정상 노출되는지 확인.

---

## 11. Acceptance Criteria (완료 기준)

이 TASK 07이 “완료”로 인정되기 위한 조건:

1. Recommend 탭을 선택했을 때:
   - 자동으로 추천 정책 리스트가 로드되고,
   - **사용자 프로필(나이/지역/추천 태그)** + **UI 필터 상태** 기반으로 Query가 조립된다.

2. 무한 스크롤:
   - Recommend 탭에서 아래까지 스크롤하면 `loadNextPage()`가 호출되어
     새 페이지가 정상적으로 이어 붙여져야 한다.

3. 새로고침:
   - Pull-to-refresh 또는 Filter/정렬/추천 태그 변경, 프로필 변경 시
     Recommend 탭이 **페이지 1부터 재로드** 해야 한다.

4. 이벤트 반응:
   - `PolicyEventType.profileUpdated` 발생 시 Recommend 탭 내용이 새로 로드된다.
   - `PolicyEventType.favoritesChanged` 발생 시 Recommend 탭 내용이 새로 로드된다.
   - `PolicyEventType.cacheCleared` 발생 시 다음 로드에서 fresh fetch가 일어난다.

5. 상태 표현:
   - 로딩/빈/에러/컨텐츠 상태가 `PolicyPagingState` 기준으로 모두 올바르게 렌더링된다.

6. 상세 화면:
   - Recommend 탭의 카드 클릭 시 `PolicyDetailBottomSheet`가 열리고,
   - “실제 정책 페이지로 이동” 버튼이 존재하며 올바른 URL로 외부 브라우저를 연다.

7. 안정성:
   - Recommend 탭 관련 코드 수정으로 인해 다른 탭(All/Region/Search/Favorite/Compare)에서 빌드 에러나 런타임 크래시가 발생하지 않는다.

8. 구조 재사용성:
   - 이 구현을 템플릿으로 사용해 다른 탭(All/Region 등)을 구현하더라도
     동일 패턴으로 쉽게 확장할 수 있는 구조여야 한다.

#END OF TASK 07
---



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


