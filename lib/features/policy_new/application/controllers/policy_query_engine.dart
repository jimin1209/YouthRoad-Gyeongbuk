import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/policy_state_utils.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_result.dart';
import '../../domain/values/policy_status_filter.dart';
import '../providers.dart';
import 'policy_query_state.dart';
import 'policy_query_orchestrator.dart';

class PolicyQueryEngine {
  PolicyQueryEngine(this.ref);

  final Ref ref;

  int get pageSize => ref.read(policySettingsProvider).pageSize;

  PolicyQueryState buildQueryState(PolicyFeedType feedType) {
    return ref.read(policyQueryProvider(feedType));
  }

  Future<PolicyResult<List<Policy>>> fetch(
    PolicyFeedType feedType, {
    required int page,
    PolicyQueryState? queryState,
  }) async {
    final state = queryState ?? buildQueryState(feedType);
    final query = state.query.normalize();
    final repo = ref.read(policyRepositoryProvider);

    final logBuffer = StringBuffer()
      ..write('[Policy][INFO] fetchPoliciesByQuery(')
      ..write('feed: ${feedType.name}, ')
      ..write('page: $page, ')
      ..write('sort: ${query.sort.name}, ')
      ..write('keyword: ${query.keyword ?? '-'}, ')
      ..write(
          'region: ${query.filter.region.name}/${query.filter.province}/${query.filter.city ?? '-'} ')
      ..write('(${query.filter.district ?? '-'}), ')
      ..write('category: ${query.filter.category?.name ?? 'all'}, ')
      ..write('status: ${_statusLabel(query.filter.status)}, ')
      ..write('online: ${query.filter.isOnline?.toString() ?? 'any'}, ')
      ..write('offline: ${query.filter.isOffline?.toString() ?? 'any'}, ')
      ..write('institution: ${query.filter.institutionId ?? '-'}, ')
      ..write('department: ${query.filter.departmentId ?? '-'}, ')
      ..write('tags: ${query.tags.isEmpty ? '-' : query.tags.join(',')})');

    debugPrint(logBuffer.toString());

    final result = await repo.fetchPoliciesByQuery(
      query: query,
      page: page,
      pageSize: pageSize,
    );

    return result.fold(
      onSuccess: (policies) {
        final filtered = _filterByStatus(policies, query.filter.status);
        return PolicyResult.success(filtered);
      },
      onFailure: PolicyResult.failure,
    );
  }

  String _statusLabel(PolicyStatusFilter status) => status.queryValue;

  List<Policy> _filterByStatus(
    List<Policy> policies,
    PolicyStatusFilter status,
  ) {
    switch (status) {
      case PolicyStatusFilter.inProgressOnly:
        return policies
            .where((policy) =>
                policy.activeState == PolicyActiveState.active ||
                policy.activeState == PolicyActiveState.closingSoon)
            .toList();
      case PolicyStatusFilter.closedOnly:
        return policies
            .where((policy) => policy.activeState == PolicyActiveState.closed)
            .toList();
      case PolicyStatusFilter.includeClosed:
        return policies;
    }
  }
}

final policyQueryEngineProvider = Provider<PolicyQueryEngine>(
  (ref) => PolicyQueryEngine(ref),
);

final policyQueryOrchestratorProvider = Provider<PolicyQueryOrchestrator>(
  (ref) => PolicyQueryOrchestrator(ref),
);
