import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/policy.dart';
import 'notifiers/policy_list_notifier.dart';

export 'di.dart';

final policyListNotifierProvider =
    AsyncNotifierProvider<PolicyListNotifier, List<Policy>>(
  PolicyListNotifier.new,
);
