import 'package:flutter_riverpod/flutter_riverpod.dart';

class PolicyFeedsState {
  const PolicyFeedsState();
}

class PolicyFeedsNotifier extends AutoDisposeNotifier<PolicyFeedsState> {
  @override
  PolicyFeedsState build() {
    return const PolicyFeedsState();
  }
}
