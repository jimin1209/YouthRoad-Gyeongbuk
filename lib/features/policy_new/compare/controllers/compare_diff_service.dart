import '../../domain/entities/policy.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/recommendation/user_profile.dart';
import '../models/compare_state.dart';

class CompareFieldDefinition {
  final String key;
  final String label;
  final String Function(Policy) valueBuilder;

  const CompareFieldDefinition({
    required this.key,
    required this.label,
    required this.valueBuilder,
  });
}

class CompareDiffService {
  static const _labelWidth = 120.0;
  static const columnWidth = 240.0;

  double get labelWidth => _labelWidth;

  final List<CompareFieldDefinition> fields = [
    CompareFieldDefinition(
      key: 'summary',
      label: '요약',
      valueBuilder: (p) => p.summary,
    ),
    CompareFieldDefinition(
      key: 'status',
      label: '진행 상태',
      valueBuilder: _statusLabel,
    ),
    CompareFieldDefinition(
      key: 'dday',
      label: '남은 기간',
      valueBuilder: _ddayLabel,
    ),
    CompareFieldDefinition(
      key: 'region',
      label: '지역',
      valueBuilder: _regionLabel,
    ),
    CompareFieldDefinition(
      key: 'category',
      label: '분야',
      valueBuilder: _categoryLabel,
    ),
    CompareFieldDefinition(
      key: 'application',
      label: '신청 기간',
      valueBuilder: _applicationPeriod,
    ),
    CompareFieldDefinition(
      key: 'eligibility',
      label: '자격 요건',
      valueBuilder: _eligibility,
    ),
    CompareFieldDefinition(
      key: 'benefit',
      label: '혜택/지원',
      valueBuilder: (p) => p.description,
    ),
    CompareFieldDefinition(
      key: 'applyMethod',
      label: '신청 방법',
      valueBuilder: _applyMethod,
    ),
    CompareFieldDefinition(
      key: 'tags',
      label: '태그',
      valueBuilder: _tags,
    ),
    CompareFieldDefinition(
      key: 'institution',
      label: '기관/부서',
      valueBuilder: (p) => '${p.institution} / ${p.department}',
    ),
    CompareFieldDefinition(
      key: 'contact',
      label: '문의처',
      valueBuilder: (p) => p.contact?.trim().isNotEmpty == true
          ? p.contact!
          : '-',
    ),
    CompareFieldDefinition(
      key: 'link',
      label: '신청 링크',
      valueBuilder: (p) => p.applyUrl.isNotEmpty ? p.applyUrl : '-',
    ),
  ];

  Map<String, bool> calculateDiffs(List<Policy> policies) {
    final map = <String, bool>{};
    for (final field in fields) {
      final values = policies.map(field.valueBuilder).toSet();
      map[field.key] = values.length > 1;
    }
    return map;
  }

  CompareInsights buildInsights(
    List<Policy> policies, {
    UserProfile? userProfile,
  }) {
    if (policies.isEmpty) return const CompareInsights();

    final now = DateTime.now();
    Policy? nearestDeadline;
    int? nearestDeadlineDays;
    Policy? broadEligibility;

    Policy? recommended;
    var bestScore = -9999;
    var bestNormalizedScore = 0;

    for (final policy in policies) {
      final daysLeft = _daysUntil(policy.applicationEndDate, now);
      if (daysLeft != null && daysLeft >= 0) {
        if (nearestDeadlineDays == null || daysLeft < nearestDeadlineDays) {
          nearestDeadline = policy;
          nearestDeadlineDays = daysLeft;
        }
      }

      if (_isBroadEligibility(policy)) {
        broadEligibility ??= policy;
      }

      final score = _scorePolicy(policy, userProfile, now, daysLeft);
      final normalizedScore = _normalizeScore(score);
      if (score > bestScore) {
        bestScore = score;
        recommended = policy;
        bestNormalizedScore = normalizedScore;
      }
    }

    return CompareInsights(
      recommendedPolicyId: recommended?.id,
      recommendedTitle: recommended?.title,
      recommendedScore: bestNormalizedScore,
      nearestDeadlinePolicyId: nearestDeadline?.id,
      nearestDeadlineTitle: nearestDeadline?.title,
      nearestDeadlineDays: nearestDeadlineDays,
      broadEligibilityPolicyId: broadEligibility?.id,
      broadEligibilityTitle: broadEligibility?.title,
    );
  }

  int _scorePolicy(
    Policy policy,
    UserProfile? profile,
    DateTime now,
    int? daysLeft,
  ) {
    var score = 0;
    if (policy.isOngoing) {
      score += 30;
    } else if (policy.isUpcoming) {
      score += 15;
    }

    if (daysLeft != null) {
      score += (30 - daysLeft).clamp(0, 30);
      if (daysLeft < 0) {
        score -= 30;
      }
    }

    if (profile != null) {
      if (policy.region == profile.region) score += 8;
      if (profile.age != null) {
        final age = profile.age!;
        if ((policy.minAge == null || age >= policy.minAge!) &&
            (policy.maxAge == null || age <= policy.maxAge!)) {
          score += 6;
        }
      }

      if (profile.preferredCategories.contains(policy.category)) {
        score += 6;
      }

      final matchedTags = policy.tags
          .where((tag) => profile.recommendTags.contains(tag))
          .length;
      score += matchedTags * 2;
    }

    score += _eligibilityScore(policy);
    score += policy.tags.length.clamp(0, 5);
    return score;
  }

  int _normalizeScore(int rawScore) {
    const maxScore = 100;
    return rawScore.clamp(0, maxScore);
  }

  int _eligibilityScore(Policy policy) {
    var score = 0;
    if (policy.isForYouth) {
      score += 4;
    }

    final ageOpen = policy.minAge == null && policy.maxAge == null;
    if (ageOpen) {
      score += 4;
    }

    final hasEducation = policy.educationCondition?.trim().isNotEmpty == true;
    final hasEmployment = policy.employmentCondition?.trim().isNotEmpty == true;
    final hasIncome = policy.incomeCondition?.trim().isNotEmpty == true;

    final restrictionCount = [hasEducation, hasEmployment, hasIncome]
        .where((v) => v)
        .length;

    score += (6 - restrictionCount * 2).clamp(0, 6);
    return score;
  }

  bool _isBroadEligibility(Policy policy) {
    final ageOpen = policy.minAge == null && policy.maxAge == null;
    final noEducation = policy.educationCondition == null ||
        policy.educationCondition!.trim().isEmpty;
    final noEmployment = policy.employmentCondition == null ||
        policy.employmentCondition!.trim().isEmpty;
    final noIncome =
        policy.incomeCondition == null || policy.incomeCondition!.trim().isEmpty;
    return ageOpen && noEducation && noEmployment && noIncome;
  }

  int? _daysUntil(DateTime? date, DateTime now) {
    if (date == null) return null;
    return date.toLocal().difference(now).inDays;
  }

  static String _regionLabel(Policy policy) {
    switch (policy.region) {
      case PolicyRegion.seoul:
        return '서울';
      case PolicyRegion.busan:
        return '부산';
      case PolicyRegion.daegu:
        return '대구';
      case PolicyRegion.incheon:
        return '인천';
      case PolicyRegion.gwangju:
        return '광주';
      case PolicyRegion.daejeon:
        return '대전';
      case PolicyRegion.ulsan:
        return '울산';
      case PolicyRegion.gyeongbuk:
        return '경북 전체';
      case PolicyRegion.all:
        return '전국';
    }
  }

  static String _categoryLabel(Policy policy) {
    switch (policy.category) {
      case PolicyCategory.employment:
        return '취업';
      case PolicyCategory.startup:
        return '창업';
      case PolicyCategory.housing:
        return '주거';
      case PolicyCategory.life:
        return '생활';
      case PolicyCategory.education:
        return '교육';
      case PolicyCategory.welfare:
        return '복지';
      case PolicyCategory.culture:
        return '문화';
      case PolicyCategory.other:
        return '기타';
    }
  }

  static String _applicationPeriod(Policy policy) {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;

    String formatDate(DateTime? date) =>
        date?.toLocal().toString().split(' ').first ?? '-';

    if (start == null && end == null) return '미정';
    if (start != null && end == null) return '${formatDate(start)} 시작';
    if (start == null && end != null) return '${formatDate(end)} 마감';
    return '${formatDate(start)} ~ ${formatDate(end)}';
  }

  static String _statusLabel(Policy policy) {
    if (policy.isOngoing) return '모집중';
    if (policy.isUpcoming) return '시작 예정';
    if (policy.isClosed) return '마감됨';
    return '일정 미확인';
  }

  static String _ddayLabel(Policy policy) {
    final now = DateTime.now();
    final end = policy.applicationEndDate;
    if (end == null) return '-';
    final diff = end.toLocal().difference(now).inDays;
    if (diff > 0) return 'D-$diff';
    if (diff == 0) return 'D-DAY';
    return '마감';
  }

  static String _applyMethod(Policy policy) {
    if (policy.isOnline && policy.isOffline) return '온라인 · 오프라인';
    if (policy.isOnline) return '온라인 신청';
    if (policy.isOffline) return '오프라인 신청';
    return '미정';
  }

  static String _tags(Policy policy) {
    if (policy.tags.isEmpty) return '-';
    return policy.tags.take(6).join(', ');
  }

  static String _eligibility(Policy policy) {
    final items = <String>[];
    if (policy.minAge != null || policy.maxAge != null) {
      final min = policy.minAge ?? 0;
      final max = policy.maxAge ?? 0;
      if (policy.minAge != null && policy.maxAge != null) {
        items.add('$min ~ $max세');
      } else if (policy.minAge != null) {
        items.add('$min세 이상');
      } else {
        items.add('$max세 이하');
      }
    }

    if (policy.educationCondition != null &&
        policy.educationCondition!.isNotEmpty) {
      items.add(policy.educationCondition!);
    }

    if (policy.employmentCondition != null &&
        policy.employmentCondition!.isNotEmpty) {
      items.add(policy.employmentCondition!);
    }

    if (policy.incomeCondition != null && policy.incomeCondition!.isNotEmpty) {
      items.add(policy.incomeCondition!);
    }

    if (items.isEmpty) return '제한 없음';
    return items.join(' / ');
  }
}
