import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_event.dart';

typedef PolicyEventListener = void Function(PolicyEvent? event);

class PolicyEventBus extends StateNotifier<PolicyEvent?> {
  PolicyEventBus() : super(null);

  /// EventBus에 새 이벤트를 발행한다.
  void emit(PolicyEvent event) {
    state = event;
  }
}
