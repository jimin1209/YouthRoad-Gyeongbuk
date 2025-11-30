import 'package:flutter/foundation.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../local/isar/isar_service.dart';
import '../local/isar/policy_isar_model.dart';
import '../models/policy_filter.dart';
import '../models/policy_model.dart';
import '../policy/policy_remote_source.dart';
import '../policy/policy_repository.dart';

class HybridPolicyRepository implements PolicyRepository {
  HybridPolicyRepository(this._remoteSource, this._isarService);

  final PolicyRemoteSource _remoteSource;
  final IsarService _isarService;

  @override
  Future<PolicyFetchResult> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
    bool forceRefresh = false,
  }) async {
    final cached = await _safeLoadCache(filter);
    debugPrint(
      '[HybridPolicyRepository] returning cached policies count=${cached.length}',
    );

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
    return _safeLoadCache(filter);
  }

  @override
  Future<List<Policy>> refreshPolicies({
    PolicyFilter filter = const PolicyFilter(),
    bool replaceExisting = false,
  }) {
    return _refreshFromRemote(
      filter: filter,
      replaceExisting: replaceExisting || _isDefaultFilter(filter),
    );
  }

  @override
  Future<List<Policy>> fetchPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) {
    return refreshPolicies(
      filter: filter,
      replaceExisting: _isDefaultFilter(filter),
    );
  }

  @override
  Future<Policy> fetchPolicyById(String id) async {
    try {
      final cached = await _isarService.getPolicyById(id);
      if (cached != null) {
        return cached.toDomain();
      }
    } catch (e, st) {
      debugPrint('[HybridPolicyRepository] cache lookup failed for $id: $e\n$st');
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
          orElse: () => PolicyIsarModel(policyId: '', policyNm: ''),
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

  Future<List<Policy>> _refreshFromRemote({
    required PolicyFilter filter,
    bool replaceExisting = false,
  }) async {
    final remoteModels = await _remoteSource.fetchPolicies(filter: filter);
    await _persistPolicies(remoteModels, replaceExisting: replaceExisting);
    return remoteModels.map((model) => model.toEntity()).toList();
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
