import '../../domain/entities/policy.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';

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

  double get labelWidth => _labelWidth;

  final List<CompareFieldDefinition> fields = [
    CompareFieldDefinition(
      key: 'summary',
      label: '요약',
      valueBuilder: (p) => p.summary,
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
