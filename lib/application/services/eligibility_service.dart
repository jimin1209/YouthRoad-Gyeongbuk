import '../../domain/entities/policy.dart';

enum EligibilityResult {
  eligible,
  notEligible,
  unknown,
}

class EligibilityService {
  /// 정책/사용자 조건을 기반으로 지원 가능 여부를 판단한다.
  /// 정책의 지역 정보가 없거나 사용자의 지역 정보가 없으면 EligibilityResult.unknown
  EligibilityResult evaluate({
    required Policy policy,
    required int? userAge,
    required String? userRegion,
  }) {
    final policyRegion = policy.rgnSeNm?.trim().toLowerCase();
    if (policyRegion == null || policyRegion.isEmpty || userRegion == null) {
      return EligibilityResult.unknown;
    }

    final normalizedUserRegion = userRegion.trim().toLowerCase();
    if (policyRegion == normalizedUserRegion) {
      return EligibilityResult.eligible;
    }
    return EligibilityResult.notEligible;
  }
}
