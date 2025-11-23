import '../../domain/entities/policy.dart';

enum EligibilityResult {
  eligible,
  notEligible,
  unknown,
}

class EligibilityService {
  /// 정책/사용자 조건을 기반으로 지원 가능 여부를 판단한다.
  /// - 정책의 나이/지역 정보가 null이면 EligibilityResult.unknown
  /// - 나이 AND 지역 모두 만족해야 eligible
  EligibilityResult evaluate({
    required Policy policy,
    required int? userAge,
    required String? userRegion,
  }) {
    final policyAge = policy.eligibilityAge;
    final policyRegion = policy.eligibilityRegion?.trim().toLowerCase();

    // 필수 정보 없으면 판단 불가
    if (policyAge == null ||
        policyRegion == null ||
        policyRegion.isEmpty ||
        userAge == null ||
        userRegion == null) {
      return EligibilityResult.unknown;
    }

    final normalizedUserRegion = userRegion.trim().toLowerCase();

    final isRegionMatch = policyRegion == normalizedUserRegion;
    final isAgeMatch = userAge == policyAge;

    if (isRegionMatch && isAgeMatch) {
      return EligibilityResult.eligible;
    } else {
      return EligibilityResult.notEligible;
    }
  }
}
