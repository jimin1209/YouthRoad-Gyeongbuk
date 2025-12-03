import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_result.dart';
import '../providers.dart';
import 'policy_query_orchestrator.dart';

class PolicyQueryEngine {
  PolicyQueryEngine(this.ref);

  final Ref ref;

  int get pageSize => ref.read(policySettingsProvider).pageSize;

  PolicyQueryOrchestrator get _orchestrator =>
      ref.read(policyQueryOrchestratorProvider);

  Future<PolicyResult<List<Policy>>> fetch(
    PolicyFeedType feedType, {
    required int page,
  }) async {
    final query = _orchestrator.buildQuery(feedType);
    final repo = ref.read(policyRepositoryProvider);

    return repo.fetchPoliciesByQuery(
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }
}

final policyQueryEngineProvider = Provider<PolicyQueryEngine>(
  (ref) => PolicyQueryEngine(ref),
);

final policyQueryOrchestratorProvider = Provider<PolicyQueryOrchestrator>(
  (ref) => PolicyQueryOrchestrator(ref),
);
