import 'package:flutter/foundation.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart' as domain;
import '../local/isar/isar_service.dart';
import '../local/isar/policy_isar_model.dart';
import '../models/policy_filter.dart';
import '../models/policy_model.dart';
import '../sources/remote/policy_remote_source.dart';

class HybridPolicyRepository implements domain.PolicyRepository {
  HybridPolicyRepository(this._remoteSource, this._isarService);

  final PolicyRemoteSource _remoteSource;
  final IsarService _isarService;

  Future<List<Policy>> loadFromCache() async {
    final cached = await _isarService.getAllPolicies();
    return cached.map((model) => model.toDomain()).toList();
  }

  Future<List<PolicyModel>> fetchAllFromApi({
    PolicyFilter filter = const PolicyFilter(),
  }) {
    return _remoteSource.fetchPolicies(filter: filter);
  }

  Future<void> saveToCache(List<PolicyModel> models) async {
    final isarModels = models.map(PolicyIsarModel.fromApi).toList();
    await _isarService.clearPolicies();
    await _isarService.putAllPolicies(isarModels);
  }

  Future<void> _upsertPolicies(List<PolicyModel> models) async {
    if (models.isEmpty) return;
    final isarModels = models.map(PolicyIsarModel.fromApi).toList();
    await _isarService.putAllPolicies(isarModels);
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
  Future<List<Policy>> fetchPolicies({PolicyFilter filter = const PolicyFilter()}) async {
    final useCache = _isDefaultFilter(filter);

    if (useCache) {
      try {
        final cached = await loadFromCache();
        if (cached.isNotEmpty) {
          return cached;
        }
      } catch (e, st) {
        debugPrint('[HybridPolicyRepository] cache load failed: $e\n$st');
      }
    }

    final remoteModels = await fetchAllFromApi(filter: filter);
    final entities = remoteModels.map((model) => model.toEntity()).toList();

    if (useCache) {
      try {
        await saveToCache(remoteModels);
      } catch (e, st) {
        debugPrint('[HybridPolicyRepository] cache save failed: $e\n$st');
      }
    } else {
      try {
        await _upsertPolicies(remoteModels);
      } catch (e, st) {
        debugPrint('[HybridPolicyRepository] upsert failed: $e\n$st');
      }
    }

    return entities;
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
    await _upsertPolicies([model]);
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
    await _upsertPolicies(models);
    return models.map((model) => model.toEntity()).toList();
  }
}
