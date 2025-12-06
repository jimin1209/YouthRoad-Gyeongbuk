import '../../domain/values/policy_feed_type.dart';
import 'policy_paging_state.dart';
import 'policy_query_state.dart';

class PolicyFeedCacheEntry {
  const PolicyFeedCacheEntry({
    required this.query,
    required this.state,
    required this.page,
  });

  final PolicyQueryState query;
  final PolicyPagingState state;
  final int page;
}

class PolicyFeedMemoryCache {
  final Map<PolicyFeedType, Map<String, PolicyFeedCacheEntry>> _store = {};

  PolicyFeedCacheEntry? restore(PolicyFeedType feedType, String hash) {
    final scope = _store[feedType];
    if (scope == null) return null;
    return scope[hash];
  }

  void save(PolicyFeedType feedType, PolicyQueryState query, PolicyPagingState state,
      {required int page}) {
    final scope = _store.putIfAbsent(feedType, () => {});
    scope[query.hash] = PolicyFeedCacheEntry(
      query: query,
      state: state,
      page: page,
    );
  }

  void evictFeed(PolicyFeedType feedType) {
    _store.remove(feedType);
  }

  void clear() {
    _store.clear();
  }
}
