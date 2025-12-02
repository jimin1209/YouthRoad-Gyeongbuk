import '../../domain/entities/policy.dart';
import '../../domain/values/policy_query.dart';

class PolicyCache {
  final Map<String, List<Policy>> _pageCache = {};

  String _key(PolicyQuery query, int page) {
    final keyword = query.keyword ?? '';
    final tags = query.tags.join(',');
    final filterTags = query.filter.tags.join(',');
    final category = query.filter.category?.name ?? 'none';
    final online = query.filter.isOnline?.toString() ?? 'any';
    final offline = query.filter.isOffline?.toString() ?? 'any';
    final ongoing = query.filter.isOngoing?.toString() ?? 'any';
    final age = query.filter.age?.toString() ?? 'any';
    final sort = query.sort.name;

    return [
      query.feedType.name,
      page,
      keyword,
      tags,
      query.filter.region.name,
      category,
      filterTags,
      online,
      offline,
      ongoing,
      age,
      sort,
    ].join('|');
  }

  List<Policy>? getPage(PolicyQuery query, int page) => _pageCache[_key(query, page)];

  void savePage(PolicyQuery query, int page, List<Policy> policies) {
    _pageCache[_key(query, page)] = policies;
  }

  void clear() {
    _pageCache.clear();
  }
}
