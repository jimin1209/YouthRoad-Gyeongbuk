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
    final isar = await _isarService.instance;
    final models = await isar.policyIsarModels.where().findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  Future<List<PolicyModel>> fetchAllFromApi() async {
    final models = await _remoteSource.fetchPolicies();
    return models;
  }

  Future<void> saveToCache(List<PolicyModel> models) async {
    final isar = await _isarService.instance;
    final isarModels = models.map(PolicyIsarModel.fromApi).toList();
    await isar.writeTxn(() async {
      await isar.policyIsarModels.clear();
      await isar.policyIsarModels.putAll(isarModels);
    });
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
    try {
      if (_isDefaultFilter(filter)) {
        final cached = await loadFromCache();
        if (cached.isNotEmpty) {
          return cached;
        }
      }
    } catch (e, st) {
      debugPrint('[HybridPolicyRepository] Failed to load cache: $e\n$st');
    }

    final models = await _remoteSource.fetchPolicies(filter: filter);
    final entities = models.map((m) => m.toEntity()).toList();

    if (_isDefaultFilter(filter)) {
      await saveToCache(models);
    }

    return entities;
  }

  @override
  Future<Policy> fetchPolicyById(String id) async {
    try {
      final isar = await _isarService.instance;
      final cachedList = await isar.policyIsarModels.where().findAll();
      for (final item in cachedList) {
        if (item.policyId == id) {
          return item.toDomain();
        }
      }
    } catch (e) {
      debugPrint('[HybridPolicyRepository] cache miss for $id: $e');
    }

    final model = await _remoteSource.fetchPolicyById(id);
    final domainModel = model.toEntity();
    await saveToCache([model]);
    return domainModel;
  }

  @override
  Future<List<Policy>> fetchSimilarPolicies(String id) async {
    final models = await _remoteSource.fetchSimilar(id);
    return models.map((m) => m.toEntity()).toList();
  }
}
