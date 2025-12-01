import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../local/isar/isar_service.dart';
import '../local/isar/policy_isar_model.dart';
import '../models/policy_filter.dart';
import '../models/policy_model.dart';
import '../sources/remote/policy_remote_source.dart';

/// Repository that prioritizes locally cached policies first and then refreshes
/// from the remote API in the background (Stale-While-Revalidate).
class HybridPolicyRepository implements PolicyRepository {
  HybridPolicyRepository(this._remoteSource, this._isarService);

  final PolicyRemoteSource _remoteSource;
  final IsarService _isarService;

  @override
  Future<PolicyFetchResult> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
    bool forceRefresh = false,
  }) async {
    // 1) Always return cached data immediately for instant UI rendering.
    final cached = await _safeLoadCache(filter);
    debugPrint(
      '[HybridPolicyRepository] cached policies count=${cached.length}',
    );

    // 2) Trigger remote refresh in the background without awaiting.
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
  }) async {
    return _safeLoadCache(filter);
  }

  @override
  Future<List<Policy>> refreshPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    // Caller explicitly requested a refresh, so return the remote result.
    return _refreshFromRemote(
      filter: filter,
      replaceExisting: _isDefaultFilter(filter),
    );
  }

  @override
  Future<List<Policy>> fetchPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    return refreshPolicies(filter: filter);
  }

  @override
  Future<Policy> fetchPolicyById(String id) async {
    try {
      final cached = await _isarService.getPolicyById(id);
      if (cached != null) {
        return cached.toDomain();
      }
    } catch (e, st) {
      debugPrint(
        '[HybridPolicyRepository] cache lookup failed for $id: $e\n$st',
      );
    }

    final model = await _remoteSource.fetchPolicyById(id);
    await _persistPolicies([model]);
    return model.toEntity();
  }

  @override
  Future<List<Policy>> fetchSimilarPolicies(String id) async {
    try {
      final cached = await _isarService.getAllPolicies();
      if (cached.isNotEmpty) {
        final base = cached.firstWhere(
          (item) => item.policyId == id,
          orElse: () => PolicyIsarModel(
            policyId: '',
            policyNm: '',
          ),
        );

        if (base.policyId.isNotEmpty) {
          final similar = cached
              .where(
                (item) =>
                    item.policyId != id &&
                    ((base.policyTypeNm != null &&
                            item.policyTypeNm == base.policyTypeNm) ||
                        (base.rgnSeNm != null && item.rgnSeNm == base.rgnSeNm)),
              )
              .take(10)
              .map((item) => item.toDomain())
              .toList();

          if (similar.isNotEmpty) {
            return similar;
          }
        }
      }
    } catch (e, st) {
      debugPrint('[HybridPolicyRepository] similar cache failed: $e\n$st');
    }

    final models = await _remoteSource.fetchSimilar(id);
    await _persistPolicies(models);
    return models.map((model) => model.toEntity()).toList();
  }

  /// Loads cached policies safely, swallowing cache errors so UI is not blocked.
  Future<List<Policy>> _safeLoadCache(PolicyFilter filter) async {
    try {
      final cached = await _isarService.getPolicies(filter: filter);
      return cached.map((model) => model.toDomain()).toList();
    } catch (e, st) {
      debugPrint('[HybridPolicyRepository] cache load failed: $e\n$st');
      return const [];
    }
  }

  Future<void> _persistPolicies(
    List<PolicyModel> models, {
    bool replaceExisting = false,
  }) async {
    if (models.isEmpty) return;
    final isarModels = models.map(PolicyIsarModel.fromApi).toList();
    if (replaceExisting) {
      await _isarService.clearPolicies();
    }
    await _isarService.putAllPolicies(isarModels);
  }

  /// Refreshes from the remote API and saves results to Isar.
  ///
  /// The returned [Future] resolves with the freshly fetched domain models but
  /// must not be awaited by UI callers. Errors are propagated so that the
  /// optional listeners (e.g., notifiers) can surface them without blocking the
  /// initial cached render.
  Future<List<Policy>> _refreshFromRemote({
    required PolicyFilter filter,
    bool replaceExisting = false,
  }) async {
    try {
      final remoteModels = await _remoteSource.fetchPolicies(filter: filter);
      await _persistPolicies(remoteModels, replaceExisting: replaceExisting);

      // Reload from cache to keep filtering logic consistent with local-first
      // behavior and to ensure Isar-derived fields are reflected.
      final hydrated = await _safeLoadCache(filter);
      return hydrated;
    } catch (e, st) {
      debugPrint('[HybridPolicyRepository] remote refresh failed: $e\n$st');
      rethrow;
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
