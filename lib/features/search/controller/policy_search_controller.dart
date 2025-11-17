import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../policy/data/policy_repository.dart';
import '../../policy/data/models/policy.dart';
import '../../../providers/global_providers.dart';

class PolicySearchParams {
  final String? query;
  final String? region;
  final List<String> categories;
  final String? status;

  const PolicySearchParams({
    this.query,
    this.region,
    this.categories = const [],
    this.status,
  });
}

final policySearchControllerProvider =
    AutoDisposeAsyncNotifierProvider<PolicySearchController, List<Policy>>(
        PolicySearchController.new);

class PolicySearchController extends AutoDisposeAsyncNotifier<List<Policy>> {
  late final PolicyRepository _repository;
  PolicySearchParams _params = const PolicySearchParams();

  void setParams(PolicySearchParams params) {
    _params = params;
    ref.invalidateSelf();
  }

  @override
  Future<List<Policy>> build() async {
    _repository = ref.watch(policyRepositoryProvider);
    final results = await _repository.getPolicies(
      region: _params.region,
      categories: _params.categories,
      status: _params.status,
    );
    if (_params.query == null || _params.query!.isEmpty) {
      return results;
    }
    return results
        .where((p) =>
            p.title.toLowerCase().contains(_params.query!.toLowerCase()) ||
            p.summary.toLowerCase().contains(_params.query!.toLowerCase()))
        .toList();
  }
}
