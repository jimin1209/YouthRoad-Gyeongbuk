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
}
