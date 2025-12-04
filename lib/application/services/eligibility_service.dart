import '../../domain/entities/policy.dart';

enum EligibilityResult {
  eligible,
  notEligible,
  unknown,
}

class EligibilityService {
  /// 정책/사용자 조건을 기반으로 지역과 나이를 판단한다.
  /// 정책 지역/연령 정보나 사용자 지역/나이가 없으면 unknown을 반환한다.
  EligibilityResult evaluate({
    required Policy policy,
    required int? userAge,
    required String? userRegion,
  }) {
    final policyRegion = _normalizeRegion(policy.rgnSeNm);
    final targetAge = int.tryParse((policy.policyYr ?? '').trim());
    if (policyRegion == null ||
        policyRegion.isEmpty ||
        userRegion == null ||
        userAge == null ||
        targetAge == null) {
      return EligibilityResult.unknown;
    }

    final normalizedUserRegion = _normalizeRegion(userRegion);
    final isRegionMatch =
        normalizedUserRegion != null && policyRegion == normalizedUserRegion;

    if (!isRegionMatch) return EligibilityResult.notEligible;
    if (userAge < targetAge) return EligibilityResult.notEligible;

    return EligibilityResult.eligible;
  }

  String? _normalizeRegion(String? value) {
    final normalized = value?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) return null;
    if (normalized == '경북') return '경상북도';
    return normalized;
  }
}
