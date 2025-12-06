import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_feed_memory_cache.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_paging_state.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_query_state.dart';
import 'package:youth_road_app/features/policy_new/domain/entities/policy.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_feed_type.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_filter.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_query.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_sort.dart';

PolicyQueryState _buildQueryState(String hash, {PolicyFeedType feedType = PolicyFeedType.all}) {
  return PolicyQueryState(
    query: PolicyQuery(
      filter: const PolicyFilter(),
      feedType: feedType,
      sort: PolicySortOption.latest,
    ),
    hash: hash,
    summary: '요약',
    conditionSummary: '조건',
  );
}

void main() {
  group('PolicyFeedMemoryCache', () {
    test('동일한 해시로 저장된 상태를 복원한다', () {
      final cache = PolicyFeedMemoryCache();
      final state = PolicyPagingState.data(
        items: const <Policy>[],
        hasMore: true,
      );
      final queryState = _buildQueryState('q1');

      cache.save(PolicyFeedType.all, queryState, state, page: 2);

      final restored = cache.restore(PolicyFeedType.all, 'q1');

      expect(restored, isNotNull);
      expect(restored!.page, 2);
      expect(restored.state.items, isEmpty);
      expect(restored.query.hash, 'q1');
    });

    test('피드 단위로 캐시를 개별 삭제할 수 있다', () {
      final cache = PolicyFeedMemoryCache();
      final state = PolicyPagingState.data(
        items: const <Policy>[],
        hasMore: false,
      );

      cache.save(
        PolicyFeedType.all,
        _buildQueryState('first'),
        state,
        page: 1,
      );
      cache.save(
        PolicyFeedType.search,
        _buildQueryState('second', feedType: PolicyFeedType.search),
        state,
        page: 1,
      );

      cache.evictFeed(PolicyFeedType.all);

      expect(cache.restore(PolicyFeedType.all, 'first'), isNull);
      expect(cache.restore(PolicyFeedType.search, 'second'), isNotNull);
    });
  });
}
