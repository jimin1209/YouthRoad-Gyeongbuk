import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_result.dart';
import '../providers.dart';

class PolicyQueryEngine {
  final Ref ref;

  PolicyQueryEngine(this.ref);

  int get pageSize => ref.read(policySettingsProvider).pageSize;

  Future<PolicyResult<List<Policy>>> fetch(
    PolicyQuery query, {
    required int page,
  }) async {
    final repo = ref.read(policyRepositoryProvider);
    return repo.fetchPoliciesByQuery(
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }
}
