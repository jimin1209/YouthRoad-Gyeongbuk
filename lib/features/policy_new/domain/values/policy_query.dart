import 'policy_feed_type.dart';
import 'policy_filter.dart';
import 'policy_sort.dart';

class PolicyQuery {
  final String? keyword;
  final List<String> tags;
  final PolicyFilter filter;
  final PolicySortOption sort;
  final PolicyFeedType feedType;

  const PolicyQuery({
    this.keyword,
    this.tags = const [],
    required this.filter,
    this.sort = PolicySortOption.latest,
    required this.feedType,
  });

  PolicyQuery copyWith({
    String? keyword,
    List<String>? tags,
    PolicyFilter? filter,
    PolicySortOption? sort,
    PolicyFeedType? feedType,
  }) {
    return PolicyQuery(
      keyword: keyword ?? this.keyword,
      tags: tags ?? this.tags,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      feedType: feedType ?? this.feedType,
    );
  }

  PolicyQuery normalize({bool clearRecommendKeyword = true}) {
    final normalizedKeyword = _normalizeKeyword(keyword);
    final normalizedTags = _normalizeTags(tags);
    final normalizedFilter = filter.normalize();

    final shouldClearKeyword =
        clearRecommendKeyword && feedType == PolicyFeedType.recommend;

    return PolicyQuery(
      keyword: shouldClearKeyword ? null : normalizedKeyword,
      tags: normalizedTags,
      filter: normalizedFilter,
      sort: sort,
      feedType: feedType,
    );
  }

  /// Repository에서 캐시 scope 구분용으로 사용될 키
  String get cacheScopeKey {
    final normalized = normalize();
    final normalizedFilter = normalized.filter;

    final buffer = StringBuffer()
      ..write(normalized.feedType.name)
      ..write('|')
      ..write(normalizedFilter.region.name)
      ..write('|')
      ..write(normalizedFilter.category?.name ?? 'all')
      ..write('|')
      ..write(normalizedFilter.age?.toString() ?? 'any')
      ..write('|')
      ..write(normalizedFilter.isOnline?.toString() ?? 'any')
      ..write('|')
      ..write(normalizedFilter.isOffline?.toString() ?? 'any')
      ..write('|')
      ..write(normalizedFilter.isOngoing?.toString() ?? 'any')
      ..write('|')
      ..write(normalized.sort.name)
      ..write('|')
      ..write(normalized.keyword ?? '')
      ..write('|')
      ..write(normalized.tags.join(','))
      ..write('|')
      ..write(normalizedFilter.institutionId ?? 'any')
      ..write('|')
      ..write(normalizedFilter.departmentId ?? 'any')
      ..write('|')
      ..write(normalizedFilter.tags.join(','));

    return buffer.toString();
  }

  static String? _normalizeKeyword(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed;
  }

  static List<String> _normalizeTags(List<String> values) {
    final normalized = <String>[];
    for (final raw in values) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      if (!normalized.contains(trimmed)) {
        normalized.add(trimmed);
      }
    }
    return normalized;
  }
}
