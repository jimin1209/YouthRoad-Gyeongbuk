import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_event.dart';

class PolicyEventBus extends StateNotifier<PolicyEvent?> {
  PolicyEventBus() : super(null);

  void emit(PolicyEvent event) {
    state = event;
  }
}
