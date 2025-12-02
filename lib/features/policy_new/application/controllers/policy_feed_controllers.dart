import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_query.dart';
import '../providers.dart';
import 'base_feed_controller.dart';

class RecommendFeedController extends BasePolicyFeedController {
  RecommendFeedController({
    required super.ref,
    required super.queryEngine,
  }) {
    ref.listen(policyEventBusProvider, (prev, next) {
      if (next?.type == PolicyEventType.refreshRequested) {
        refresh();
      }
    });
  }

  @override
  PolicyFeedType get feedType => PolicyFeedType.recommend;

  @override
  PolicyQuery buildBaseQuery() => ref.read(policyQueryProvider(feedType));
}

class AllFeedController extends BasePolicyFeedController {
  AllFeedController({
    required super.ref,
    required super.queryEngine,
  });

  @override
  PolicyFeedType get feedType => PolicyFeedType.all;

  @override
  PolicyQuery buildBaseQuery() => ref.read(policyQueryProvider(feedType));
}

class RegionFeedController extends BasePolicyFeedController {
  RegionFeedController({
    required super.ref,
    required super.queryEngine,
  });

  @override
  PolicyFeedType get feedType => PolicyFeedType.region;

  @override
  PolicyQuery buildBaseQuery() => ref.read(policyQueryProvider(feedType));
}

class SearchFeedController extends BasePolicyFeedController {
  SearchFeedController({
    required super.ref,
    required super.queryEngine,
  });

  @override
  PolicyFeedType get feedType => PolicyFeedType.search;

  @override
  PolicyQuery buildBaseQuery() => ref.read(policyQueryProvider(feedType));
}

class FavoriteFeedController extends BasePolicyFeedController {
  FavoriteFeedController({
    required super.ref,
    required super.queryEngine,
  }) {
    ref.listen(policyEventBusProvider, (prev, next) {
      if (next?.type == PolicyEventType.favoritesChanged) {
        refresh();
      }
    });
  }

  @override
  PolicyFeedType get feedType => PolicyFeedType.favorite;

  @override
  PolicyQuery buildBaseQuery() => ref.read(policyQueryProvider(feedType));
}

class CompareFeedController extends BasePolicyFeedController {
  CompareFeedController({
    required super.ref,
    required super.queryEngine,
  }) {
    ref.listen(policyEventBusProvider, (prev, next) {
      if (next?.type == PolicyEventType.refreshRequested) {
        refresh();
      }
    });
  }

  @override
  PolicyFeedType get feedType => PolicyFeedType.compare;

  @override
  PolicyQuery buildBaseQuery() => ref.read(policyQueryProvider(feedType));
}
