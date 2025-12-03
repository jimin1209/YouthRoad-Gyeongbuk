import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/legacy/policy/application/notifiers/policy_paging_notifier.dart';

final policyPagingProvider =
    NotifierProvider.autoDispose<PolicyFeedsNotifier, PolicyFeedsState>(
  PolicyFeedsNotifier.new,
);
