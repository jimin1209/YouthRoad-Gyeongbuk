import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_sort.dart';
import 'policy_filter_ui_state.dart';

String buildPolicyFilterSummary(
  PolicyFilterUiState filter, {
  String keyword = '',
}) {
  final buffer = StringBuffer(filter.regionSummary);

  final trimmedKeyword = keyword.trim();
  if (trimmedKeyword.isNotEmpty) {
    buffer.write(' · 검색어 "$trimmedKeyword"');
  }

  if (filter.tags.isNotEmpty) {
    buffer.write(' · 태그(${filter.tags.join(', ')})');
  }

  if (filter.category != null) {
    buffer.write(' · ${_categoryLabel(filter.category!)}');
  }

  if ((filter.institutionName ?? '').isNotEmpty) {
    buffer.write(' · ${filter.institutionName}');
  } else if ((filter.institutionId ?? '').isNotEmpty) {
    buffer.write(' · 기관 필터 적용');
  }

  if (filter.showOnlyOngoing) {
    buffer.write(' · 모집중만');
  }

  if (filter.showOnlyOnline) {
    buffer.write(' · 온라인 참여');
  }

  buffer.write(' · ${_sortLabel(filter.sort)}');

  return buffer.toString();
}

String buildPolicyFilterConditionSummary(
  PolicyFilterUiState filter, {
  String keyword = '',
}) {
  final parts = <String>[
    filter.regionSummary,
  ];

  final trimmedKeyword = keyword.trim();
  if (trimmedKeyword.isNotEmpty) {
    parts.add('검색어 "$trimmedKeyword"');
  }

  if (filter.tags.isNotEmpty) {
    parts.add('태그(${filter.tags.join(', ')})');
  }

  if (filter.category != null) {
    parts.add(_categoryLabel(filter.category!));
  }

  if ((filter.institutionName ?? '').isNotEmpty) {
    parts.add(filter.institutionName!);
  } else if ((filter.institutionId ?? '').isNotEmpty) {
    parts.add('기관 필터 적용');
  }

  if (filter.showOnlyOngoing) {
    parts.add('모집중만');
  }

  if (filter.showOnlyOnline) {
    parts.add('온라인 참여');
  }

  parts.add(_sortLabel(filter.sort));

  return parts.join(' · ');
}

String _categoryLabel(PolicyCategory category) {
  switch (category) {
    case PolicyCategory.employment:
      return '취업';
    case PolicyCategory.startup:
      return '창업';
    case PolicyCategory.housing:
      return '주거';
    case PolicyCategory.education:
      return '교육';
    case PolicyCategory.life:
      return '생활';
    case PolicyCategory.welfare:
      return '복지';
    case PolicyCategory.culture:
      return '문화';
    case PolicyCategory.other:
      return '기타';
  }
}

String _sortLabel(PolicySortOption sort) {
  switch (sort) {
    case PolicySortOption.recommendation:
      return '추천순';
    case PolicySortOption.latest:
      return '최신순';
    case PolicySortOption.deadline:
      return '마감임박';
    case PolicySortOption.popularity:
      return '인기순';
  }
}
