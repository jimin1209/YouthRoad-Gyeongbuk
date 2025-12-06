TASK 21 – ExploreScreen 하나로 전체/지역/검색 통합 (탐색 탭 고도화)

[전제]
- TASK 20에서 상단 탭이 "추천 / 탐색 / 보관함" 3개 구조로 정리되어 있고,
  "탐색" 탭을 눌렀을 때 현재는 기존 "전체 정책" 화면(ALL 탭)이 임시로 연결되어 있다고 가정한다.
- 이 TASK의 목표는 기존 "전체 / 지역 / 검색" 세 탭의 기능을
  하나의 ExploreScreen 안에서 모드 전환으로 처리하는 것이다.
- 이 TASK에서는 "탐색" 탭 내부만 수정하며, 추천/보관함 탭, 다른 화면의 비즈니스 로직은 수정하지 않는다.

────────────────────────────────────
[1. Scope (수정/추가 범위)]
────────────────────────────────────
아래 파일(또는 동일 역할 파일)만 수정/추가 대상으로 삼는다.

1) 새로운 탐색 화면(ExploreScreen) 파일
   - 위치(예시):
     - lib/features/policy_new/presentation/explore/policy_explore_screen.dart
   - 이 파일은 **전체 파일 교체/생성** 방식으로 구현해도 된다.

2) 탐색 탭 → 화면 매핑부
   - 예시:
     - lib/features/policy_new/presentation/policy_tab_screen.dart
     - lib/navigation/app_router.dart
   - 탐색 탭을 눌렀을 때 새 ExploreScreen 을 사용하도록 연결을 변경한다.

3) (선택) Explore 전용 상태/Provider 정의부
   - 예시:
     - lib/features/policy_new/application/explore/explore_providers.dart
     - lib/features/policy_new/application/explore/explore_state.dart
   - 별도 파일로 분리해도 되고, 기존 Provider 파일 내에 정의해도 된다.
   - 단, 기존 ALL/REGION/SEARCH 탭이 사용하던 Provider/Repository를 최대한 재사용할 것.

※ 이 TASK에서는 기존 ALL/REGION/SEARCH 화면 파일을 삭제하지 말고, 참조만 끊어둔다.
   (후속 TASK에서 완전 삭제/정리 예정)

────────────────────────────────────
[2. 현재 코드 파악 지시]
────────────────────────────────────
아래 순서로 기존 구조를 파악한 후, ExploreScreen 설계에 반영한다.

1) 기존 "전체 정책" 화면 찾기
   - 예시 키워드:
     - "전체 정책", "전체 탭", "AllPolicyScreen", "PolicyAllScreen"
   - 이 화면의 역할:
     - 경북 전체 정책 리스트 보여주는 기본 카탈로그.

2) 기존 "지역별 정책" 화면 찾기
   - 예시 키워드:
     - "지역", "RegionTab", "지역별", "내 지역 정책"
   - 이 화면이 있다면:
     - 어떤 방식으로 region 파라미터를 받아서 리스트를 가져오는지 확인.
     - 없으면, ALL 화면에서 region 필터만 다른 변형일 수 있으니 그 방식을 확인.

3) 기존 "검색" 화면 찾기
   - 예시 키워드:
     - "검색", "SearchPolicyScreen", "PolicySearchScreen"
   - 검색어/태그/필터를 어떻게 받아서 Provider/Repository에 전달하는지 확인.

4) Provider/Repository 파악
   - 위 세 화면이 공통으로 사용하는 Provider/Repository 확인:
     - 예: policyLocalFeedProvider, policySearchProvider, policyRepository.getPolicies(query)
   - 사용 중인 쿼리/파라미터 구조를 파악해서, 공통 Query 모델(PolicyFeedQuery)로 묶을 수 있는지 확인.

────────────────────────────────────
[3. Explore 내부 개념 정의]
────────────────────────────────────
ExploreScreen 내부에서 사용할 모드/쿼리 모델을 정의한다.

1) ExploreSubMode enum (탐색 내부 모드)
   - enum ExploreSubMode { all, region, search }
   - 의미:
     - all    : 경북 전체 정책 카탈로그
     - region : 내 지역/선택 지역 정책
     - search : 키워드/태그/필터 기반 검색 결과

2) PolicyFeedQuery (탐색 쿼리 모델)
   - 새로운 데이터 클래스/모델 정의:
     - regionScope  : 전체 / 내 지역 / 특정 시군 코드 등
     - status       : 진행중만 / 마감 포함 / 마감만
     - keywords     : String (검색어) 또는 List<String>
     - tags         : List<String> (관심 분야 태그)
     - sort         : 정렬 기준 (추천순, 최신등록순, 마감임박순, 관련도순 등)
   - ExploreSubMode 와 PolicyFeedQuery 를 조합해서 실제 Provider 호출에 사용한다.

3) Explore 전용 Provider
   - 가능한 구현 방향:
     - A) exploreFeedProvider(PolicyFeedQuery query)를 새로 만들고,
          내부에서 기존 policyLocalFeedProvider / policySearchProvider 등을 호출.
     - B) 기존 provider 가 유연하게 설계되어 있다면,
          ExploreScreen 에서 기존 provider 를 직접 사용해도 됨.
   - 어떤 방식을 선택하든, 아래 인터페이스를 맞춰야 한다:
     - input : PolicyFeedQuery or (mode + 필터/검색어)
     - output: AsyncValue<List<Policy>> 또는 페이징 가능한 state

────────────────────────────────────
[4. ExploreScreen UI/동작 설계]
────────────────────────────────────
ExploreScreen의 전체 레이아웃과 모드별 동작을 아래와 같이 구현한다.

[4-1] 상단 공통 UI

1) 검색 바
   - 화면 최상단에 고정.
   - placeholder: "검색어를 입력하거나 태그를 선택해보세요."
   - 동작:
     - 탭하거나 입력 시작 시 ExploreSubMode.search 로 진입.
     - 입력 중에는 디바운스(예: 300~500ms) 후 Provider에 검색어 전달.

2) 모드 칩(1줄)
   - [전체] [내 지역] [다른 지역 선택]
   - 클릭 시 ExploreSubMode 및 PolicyFeedQuery.regionScope 변경:
     - 전체: subMode = all, regionScope = 전체
     - 내 지역: subMode = region, regionScope = profile의 기본 지역
     - 다른 지역 선택: 지역 선택 시트/페이지로 이동 후, 선택된 지역으로 regionScope 업데이트

3) 필터 칩(2줄, 옵션)
   - [진행중만] [분야] [지원 형태] [기관] 등
   - 상태는 PolicyFeedQuery의 필드에 반영.

4) 현재 상태 텍스트
   - 모드/쿼리 상태를 요약한 한 줄 텍스트:
     - 전체 + 필터 없음: "경상북도 전체 정책 · N건"
     - 내 지역: "울진군 정책 · N건"
     - 검색: "\"창업\" 검색 결과 · N건"
   - N은 Provider가 반환하는 totalCount 가 있으면 사용, 없으면 생략.

[4-2] 모드별 리스트 동작

1) ExploreSubMode.all
   - 조건: 검색어 없음 AND [전체] 칩 선택.
   - Query:
     - regionScope = 전체
     - status      = 진행중+마감 포함 (필터에 따라 변경)
     - sort        = 최신 등록순
   - UI:
     - "전체 정책" 타이틀 또는 상태 텍스트만 변경.
     - 기존 ALL 탭 리스트 UI 재사용(가능하면 위젯 추출해서 재활용).

2) ExploreSubMode.region
   - 조건: [내 지역] 또는 [다른 지역 선택] 칩 선택 AND 검색어 없음.
   - Query:
     - regionScope = 선택된 지역
     - default sort = 마감임박순
   - UI:
     - 상태 텍스트: "울진군 정책 · N건"
     - 상단에 "지역 변경" 텍스트 버튼 노출 (지역 선택 시트로 이동).

3) ExploreSubMode.search
   - 조건: 검색어가 비어있지 않거나, 추천 태그를 탭한 경우.
   - Query:
     - keywords = 검색어
     - tags     = 선택 태그
     - regionScope/status 는 필터 칩 상태에 따라 설정.
     - sort     = 관련도순 (또는 기존 검색 정렬 로직 재사용)
   - UI:
     - 상태 텍스트: "\"창업\" 검색 결과 · N건"
     - 검색어를 지우면:
       - 직전 모드(all 또는 region)로 복귀.

[4-3] Empty 상태 처리

1) 전체 모드 – 정책 없음
   - 메시지: "아직 불러올 정책이 없어요. 잠시 후 다시 시도해 주세요."
   - (보통 발생하지 않겠지만, API 에러/빈 리스트 대비)

2) 지역 모드 – 지역 정책 없음
   - 메시지: "현재 {지역명}에는 등록된 청년 정책이 없어요."
   - 버튼: "경상북도 전체 정책 보기" → ExploreSubMode.all 로 전환.

3) 검색 모드 – 검색 결과 없음
   - 메시지: "\"{검색어}\"에 대한 정책을 찾지 못했어요."
   - 서브텍스트: "필터를 넓히거나 다른 키워드를 시도해보세요."
   - 버튼: "필터 초기화" → status/tags/regionScope 초기화.

────────────────────────────────────
[5. 구현 세부 지시]
────────────────────────────────────
1) ExploreScreen 구현 방식
   - ConsumerWidget 또는 ConsumerStatefulWidget 으로 구현.
   - ref.listen 사용 시:
     - 반드시 build 메서드 안에서만 사용하거나,
     - ref.listenManual + ProviderSubscription 패턴 사용.
     - initState 에서 ref.listen 호출하지 말 것.

2) 상태 관리
   - ExploreScreen 내부에서 현재 ExploreSubMode, PolicyFeedQuery 를 관리하는 방법:
     - A) StateNotifier + StateNotifierProvider (권장)
     - B) StateProvider<ExploreSubMode>, StateProvider<PolicyFeedQuery> 조합
   - 어떤 방식을 선택하든, 다음이 가능해야 함:
     - 모드/필터/검색어 변경 시, 자동으로 Provider(정책 리스트)가 다시 로딩된다.
     - 탭 간 전환 후 다시 탐색 탭으로 돌아와도, 최근 모드/검색어/필터 상태가 유지된다(가능하면).

3) 정책 리스트 UI
   - 기존 ALL/REGION/SEARCH 탭에서 사용하던 리스트/카드 위젯을 재사용한다.
   - 리스트 바디는 mode/쿼리를 제외하고 동일하도록 구성해 중복 코드를 줄인다.
   - 페이징/무한 스크롤 로직이 이미 있다면 그대로 재사용.

4) 기존 화면 의존성 정리
   - 기존 ALL/REGION/SEARCH 화면 파일은 이 TASK에서 삭제하지 말고:
     - 더 이상 라우터/탭에서 직접 사용하지 않도록 참조를 끊는다.
     - 파일 상단에 TODO 주석:
       - // TODO(TASK 530): ExploreScreen 안정화 후 legacy ALL/REGION/SEARCH 화면 제거 검토

5) 탐색 탭 연결 변경
   - TASK 511에서 "탐색" 탭을 임시로 ALL 화면에 연결해 두었다면:
     - 그 연결을 ExploreScreen() 으로 변경한다.
   - "탐색" 탭을 눌렀을 때 항상 ExploreScreen 하나만 사용해야 하며,
     - 서브탭/슬라이딩으로 ALL/REGION/SEARCH 화면으로 직접 이동하는 구조를 남기지 않는다.

────────────────────────────────────
[6. Acceptance Criteria]
────────────────────────────────────
다음 조건을 모두 만족해야 한다.

1) 빌드/런타임
   - flutter analyze / flutter build 기준 컴파일 에러가 없어야 한다.
   - 탐색 탭 진입/검색/필터/지역 변경 플로우에서 런타임 에러가 없어야 한다.
   - Riverpod 관련 assertion (ref.listen 위치 오류 등)이 새로 발생하지 않아야 한다.

2) UI/동작
   - 탐색 탭에 들어가면 상단에:
     - 검색 바
     - [전체] [내 지역] [다른 지역 선택] 칩
     - 필터 칩들이 보여야 한다.
   - [전체] 선택 + 검색어 없음:
     - 기존 "전체 탭"과 유사한 전체 정책 리스트가 보인다.
   - [내 지역] 또는 [다른 지역 선택] 사용:
     - 선택한 지역에 해당하는 정책 리스트가 보이고,
     - 상단 상태 텍스트에 해당 지역명이 반영된다.
   - 검색어 입력:
     - ExploreSubMode.search 로 전환되고,
     - 검색 결과 리스트가 표시된다.
   - 검색어 삭제:
     - 직전 모드(all/region)로 자연스럽게 돌아간다.

3) Empty 상태
   - 정책이 없는 상황에서 위에서 정의한 메시지/CTA 가 적절히 표시된다.

4) 레거시 탭
   - UI 상단/하단에 "전체 / 지역 / 검색" 이라는 별도 탭이 다시 나타나지 않아야 한다.
   - ALL/REGION/SEARCH 화면으로 직접 라우팅하는 경로는 남아 있지 않아야 한다
     (단, 파일 자체는 삭제하지 않고 TODO 주석으로 남겨둔다).

────────────────────────────────────
[7. 제약사항]
────────────────────────────────────
- 이 TASK에서는 다음을 하지 말 것:
  - 추천 탭/보관함 탭의 기존 동작 변경
  - 정책 상세/즐겨찾기/비교/알림 로직 변경
  - Repository/UseCase 레이어에서 API 스펙 변경
- 오직:
  - ExploreScreen 을 새로 만들고,
  - 기존 "전체/지역/검색" 기능을 ExploreScreen 내부 모드로 통합하며,
  - 탐색 탭이 ExploreScreen 하나만 사용하도록 네비게이션을 수정하는 데에만 집중한다.
