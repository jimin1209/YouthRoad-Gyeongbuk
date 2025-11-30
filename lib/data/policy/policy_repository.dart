// FILE: lib/data/policy/policy_repository.dart
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../models/policy_filter.dart';
import 'policy_cache_source.dart';
import 'policy_remote_source.dart';

class PolicyFetchResult {
  const PolicyFetchResult({
    required this.policies,
    this.remoteRefresh,
  });

  final List<Policy> policies;
  final Future<List<Policy>>? remoteRefresh;
}

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
    debugPrint('[PolicyRepository] returning cached policies count=${cached.length}');

    debugPrint('[PolicyRepository] refreshing policies from remote...');
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
    return _cacheSource.loadCachedPolicies(filter: filter);
  }

  @override
  Future<List<Policy>> refreshPolicies({
    PolicyFilter filter = const PolicyFilter(),
    bool replaceExisting = false,
  }) {
    debugPrint('[PolicyRepository] refreshing policies from remote...');
    return _refreshFromRemote(
      filter: filter,
      replaceExisting: replaceExisting || _isDefaultFilter(filter),
    );
  }

  Future<List<Policy>> _safeLoadCache(PolicyFilter filter) async {
    try {
      return await _cacheSource.loadCachedPolicies(filter: filter);
    } catch (e, st) {
      debugPrint('[PolicyRepository] cache load failed: $e\n$st');
      return const [];
    }
  }

  Future<List<Policy>> _refreshFromRemote({
    required PolicyFilter filter,
    bool replaceExisting = false,
  }) async {
    final remoteModels = await _remoteSource.fetchPolicies(filter: filter);
    final policies = remoteModels.map((model) => model.toEntity()).toList();
    await _cacheSource.savePolicies(policies, replaceExisting: replaceExisting);
    return policies;
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

  @override
  Future<List<Policy>> fetchPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
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

    final list = await _remoteSource.fetchPolicies(
      filter: const PolicyFilter(
        pagingYn: 'N',
        searchDsplyYn: 'all',
        recordCount: 2000,
      ),
    );

    final match = list.firstWhere(
      (policy) => policy.id == id,
      orElse: () => throw StateError('Policy not found for id: $id'),
    );

    await _cacheSource.savePolicies([
      match.toEntity(),
    ]);
    return match.toEntity();
  }

  @override
  Future<List<Policy>> fetchSimilarPolicies(String id) async {
    try {
      final cached = await _cacheSource.loadAllPolicies();
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
    await _cacheSource.savePolicies(policies);
    return policies;
  }
}
