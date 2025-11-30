import 'package:flutter/foundation.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../models/policy_filter.dart';
import '../models/policy_model.dart';
import '../sources/local/policy_cache_source.dart';
import '../sources/remote/policy_remote_source.dart';

class SwrPolicyRepository implements PolicyRepository {
  SwrPolicyRepository(this._remoteSource, this._cacheSource);

  final PolicyRemoteSource _remoteSource;
  final PolicyCacheSource _cacheSource;

  @override
  Future<PolicyFetchResult> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
    bool forceRefresh = false,
  }) async {
    final cached = await _safeLoadCache(filter);

    final remoteFuture = _refreshFromRemote(
      filter: filter,
      replaceExisting: forceRefresh || _isDefaultFilter(filter),
    );

    return PolicyFetchResult(
      policies: cached,
      remoteRefresh: remoteFuture,
    );
  }

  @override
  Future<List<Policy>> loadCachedPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) {
    return _cacheSource.getPolicies(filter: filter);
  }

  @override
  Future<List<Policy>> refreshPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) {
    return _refreshFromRemote(
      filter: filter,
      replaceExisting: _isDefaultFilter(filter),
    );
  }

  @override
  Future<Policy> fetchPolicyById(String id) async {
    final cached = await _cacheSource.getPolicyById(id);
    if (cached != null) {
      return cached;
    }

    final model = await _remoteSource.fetchPolicyById(id);
    final entity = model.toEntity();
    await _cacheSource.putAllPolicies([entity]);
    return entity;
  }

  @override
  Future<List<Policy>> fetchSimilarPolicies(String id) async {
    try {
      final cached = await _cacheSource.getAllPolicies();
      if (cached.isNotEmpty) {
        final base = cached.firstWhere(
          (item) => item.id == id,
          orElse: () => const Policy(id: '', policyNm: ''),
        );

        if (base.id.isNotEmpty) {
          final similar = cached
              .where(
                (item) =>
                    item.id != id &&
                    ((base.policyTypeNm != null &&
                            item.policyTypeNm == base.policyTypeNm) ||
                        (base.rgnSeNm != null && item.rgnSeNm == base.rgnSeNm)),
              )
              .take(10)
              .toList();

          if (similar.isNotEmpty) {
            return similar;
          }
        }
      }
    } catch (e, st) {
      debugPrint('[PolicyRepository] similar cache failed: $e\n$st');
    }

    final models = await _remoteSource.fetchSimilar(id);
    final policies = models.map((model) => model.toEntity()).toList();
    await _cacheSource.putAllPolicies(policies);
    return policies;
  }

  Future<List<Policy>> _refreshFromRemote({
    required PolicyFilter filter,
    required bool replaceExisting,
  }) async {
    final remoteModels = await _remoteSource.fetchPolicies(filter: filter);
    final policies = remoteModels.map((model) => model.toEntity()).toList();

    await _cacheSource.putAllPolicies(
      policies,
      replaceExisting: replaceExisting,
    );

    return policies;
  }

  Future<List<Policy>> _safeLoadCache(PolicyFilter filter) async {
    try {
      return await _cacheSource.getPolicies(filter: filter);
    } catch (e, st) {
      debugPrint('[PolicyRepository] cache load failed: $e\n$st');
      return const [];
    }
  }

  bool _isDefaultFilter(PolicyFilter filter) {
    return filter.searchRgnSe == null &&
        filter.searchPolicyType == null &&
        filter.searchPolicyNm == null &&
        filter.searchText == null &&
        filter.category == null &&
        filter.searchYear == null &&
        filter.instNo == null &&
        filter.deptNo == null &&
        filter.startDate == null &&
        filter.endDate == null &&
        filter.availableOnly == null &&
        (filter.pageIndex == null || filter.pageIndex == 1) &&
        (filter.recordCount == null || filter.recordCount == 2000) &&
        (filter.pagingYn == null || filter.pagingYn == 'N') &&
        (filter.searchDsplyYn == null || filter.searchDsplyYn == 'all');
  }
}
