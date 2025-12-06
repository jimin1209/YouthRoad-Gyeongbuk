import '../../domain/values/policy_feed_type.dart';
import 'base_feed_controller.dart';

class RecommendFeedController extends BasePolicyFeedController {
  RecommendFeedController({
    required super.ref,
    required super.queryEngine,
    required super.memoryCache,
  }) : super(feedType: PolicyFeedType.recommend);
}

class AllFeedController extends BasePolicyFeedController {
  AllFeedController({
    required super.ref,
    required super.queryEngine,
    required super.memoryCache,
  }) : super(feedType: PolicyFeedType.all);
}

class RegionFeedController extends BasePolicyFeedController {
  RegionFeedController({
    required super.ref,
    required super.queryEngine,
    required super.memoryCache,
  }) : super(feedType: PolicyFeedType.region);
}

class SearchFeedController extends BasePolicyFeedController {
  SearchFeedController({
    required super.ref,
    required super.queryEngine,
    required super.memoryCache,
  }) : super(feedType: PolicyFeedType.search);
}

class FavoriteFeedController extends BasePolicyFeedController {
  FavoriteFeedController({
    required super.ref,
    required super.queryEngine,
    required super.memoryCache,
  }) : super(feedType: PolicyFeedType.favorite);
}
