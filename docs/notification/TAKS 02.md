Codex,

아래 요구사항에 따라 YouthCenter API 기반 Domain, Repository, Provider 구조를 구축하라.
이미 청년정책·청년콘텐츠·청년센터 API의 Freezed DTO는 정의되어 있다고 가정하고 작업을 시작하라.

────────────────────────
[1. Domain Entity 생성]
────────────────────────
각 API별 응답 DTO를 기반으로 아래 구조의 Domain Model을 생성하라.

① PolicyEntity
필수 필드:
- title
- period
- organization
- region
선택 필드:
- ageCondition
- jobCondition
- educationCondition
- benefit
- applyMethod
- detailsUrl

② YouthContentEntity
필수 필드:
- title
선택 필드:
- thumbnailUrl
- datePublished
- linkUrl

③ YouthCenterEntity
필수 필드:
- centerName
- address
선택 필드:
- phoneNumber
- websiteUrl
- openHour

규칙:
- Domain은 immutable 구조로 작성할 것.
- DTO의 JSON 키 이름은 Domain에서 사용하지 않는다.

────────────────────────
[2. DTO → Domain Mapper 작성]
────────────────────────
각 Row DTO에 다음과 같은 Mapper를 생성하라.

예시 형태:
extension PolicyDtoMapper on PolicyResponseRowDto {
  PolicyEntity toDomain();
}

Mapper 규칙:
- null-safe 형태로 처리
- 변환 실패 시 default fallback 제공
- string → date 혹은 numeric 변환 필요 시 이곳에서 처리

산출물 예시:
- youth_policy_mapper.dart
- youth_content_mapper.dart
- youth_center_mapper.dart

────────────────────────
[3. Repository 구조 생성]
────────────────────────
아래 파일을 생성하고 Domain 반환형으로 구성하라.

lib/data/repositories/policy_repository.dart
lib/data/repositories/content_repository.dart
lib/data/repositories/center_repository.dart

각 Repository는 아래 책임을 가진다.

PolicyRepository:
Future<(List<PolicyEntity>, PagingEntity)> getPolicies(PolicySearchQuery query);

ContentRepository:
Future<(List<YouthContentEntity>, PagingEntity?)> getContents(int page);

CenterRepository:
Future<List<YouthCenterEntity>> getCenters();

요구사항:
- DTO 반환 금지
- Domain만 반환
- paging 정보 유지

────────────────────────
[4. Remote Source / Repository 구현]
────────────────────────
아래 Remote Source를 생성하고 실제 네트워크 호출을 수행하도록 구성하라.

예시:
youth_policy_remote_source.dart  
youth_content_remote_source.dart  
youth_center_remote_source.dart  

규칙:
- Dio 기반 요청
- DTO 파싱
→ Domain 변환
→ Repository에서 반환

────────────────────────
[5. Local Cache 구축(정책 필수)]
────────────────────────
정책에는 캐시 기능을 반드시 적용하라.

구조 요구사항:
save(List<PolicyEntity>)  
load() → List<PolicyEntity>  
exists() → bool  
invalidate()  

추천 파일명:
policy_local_cache.dart

캐시 조건:
- 앱 재시작 시 데이터 유지
- 정책 조회 전 캐시 우선 조회
- 캐시 만료 조건 제공

────────────────────────
[6. Provider 연결]
────────────────────────
아래 Provider를 생성하라.

policyListProvider  
contentFeedProvider  
centerProvider  

provider 규칙:
- autoDispose 붙일 것
- data refresh flow 제공

예시:
final policyListProvider =
  FutureProvider.autoDispose((ref) async {
    final repo = ref.watch(policyRepositoryProvider);
    final filter = ref.watch(userFilterProvider);
    final result = await repo.getPolicies(filter);
    return result.$1;
  });

────────────────────────
[7. 검증 조건]
────────────────────────
아래 항목 충족 시 본 Task는 완료된 것으로 판단한다.

조건:
✔ Domain Entity만 UI에서 사용됨
✔ Repository 계층이 Domain만 반환함
✔ API 호출 → DTO 변환 → Domain 변환 → Provider 공급까지 연결됨
✔ null crash 없이 동작
✔ 정책 Local Cache 동작
✔ 필터 변경 시 데이터 재조회 확인됨

────────────────────────

위 요구사항을 충족하라.
각 기능은 독립된 파일로 작성하고, 코드 간 의존 관계는 export 형태로 관리하라.
완료 시 변경된 모든 파일 목록을 제공하라.
