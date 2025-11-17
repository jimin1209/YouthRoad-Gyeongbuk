import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/policy_repository_impl.dart';
import '../data/sources/local/local_policy_source.dart';
import '../domain/repositories/policy_repository.dart';

final localPolicySourceProvider = Provider<LocalPolicySource>((_) {
  return LocalPolicySource();
});

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  final source = ref.watch(localPolicySourceProvider);
  return PolicyRepositoryImpl(source);
});
