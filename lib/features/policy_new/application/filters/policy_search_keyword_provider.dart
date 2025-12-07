import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_feed_type.dart';

class PolicySearchKeywordNotifier extends StateNotifier<String> {
  PolicySearchKeywordNotifier() : super('');

  void set(String value) => state = value.trim();

  void clear() => state = '';
}

final policySearchKeywordProvider = StateNotifierProvider.family<
    PolicySearchKeywordNotifier, String, PolicyFeedType>((ref, _) {
  return PolicySearchKeywordNotifier();
});
