import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/policy_repository.dart';
import '../data/models/policy.dart';
import '../../../providers/global_providers.dart';

/// Family provider to load policy detail by id.
final policyDetailControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<PolicyDetailController, Policy, String>(
        PolicyDetailController.new);

class PolicyDetailController extends AutoDisposeFamilyAsyncNotifier<Policy, String> {
  late final PolicyRepository _repository;

  @override
  Future<Policy> build(String arg) async {
    _repository = ref.watch(policyRepositoryProvider);
    return _repository.getPolicyDetail(arg);
  }
}
