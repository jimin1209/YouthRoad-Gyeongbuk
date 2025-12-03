import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/policy_paging_notifier.dart';

final policyPagingProvider =
    NotifierProvider.autoDispose<PolicyFeedsNotifier, PolicyFeedsState>(
  PolicyFeedsNotifier.new,
);
