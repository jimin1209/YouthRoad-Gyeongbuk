import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filters/policy_filter_ui_state.dart';
import '../filters/policy_search_keyword_provider.dart';
import '../../domain/values/policy_feed_type.dart';

class GlobalFilterController {
  GlobalFilterController(this.ref);

  final Ref ref;

  PolicyFilterUiState get state => ref.read(globalFilterProvider);

  void resetAll() {
    ref.read(globalFilterProvider.notifier).resetAll();
    for (final type in PolicyFeedType.values) {
      ref.read(policySearchKeywordProvider(type).notifier).clear();
    }
  }

  void setKeyword(PolicyFeedType feedType, String keyword) {
    ref.read(policySearchKeywordProvider(feedType).notifier).set(keyword);
  }

  String keywordOf(PolicyFeedType feedType) {
    return ref.read(policySearchKeywordProvider(feedType));
  }
}

final globalFilterControllerProvider = Provider<GlobalFilterController>((ref) {
  return GlobalFilterController(ref);
});
