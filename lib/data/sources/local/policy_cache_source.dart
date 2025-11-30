import 'package:flutter/foundation.dart';

import '../../../domain/entities/policy.dart';
import '../../local/isar/isar_service.dart';
import '../../local/isar/policy_isar_model.dart';
import '../../models/policy_filter.dart';

class PolicyCacheSource {
  PolicyCacheSource(this._isarService);

  final IsarService _isarService;

  Future<List<Policy>> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    debugPrint('[PolicyCacheSource] getPolicies called');
    final cached = await _isarService.getPolicies(filter: filter);
    final policies = cached.map((model) => model.toDomain()).toList();
    debugPrint('[PolicyCacheSource] loaded ${policies.length} policies from cache');
    return policies;
  }

  Future<List<Policy>> getAllPolicies() async {
    final cached = await _isarService.getAllPolicies();
    return cached.map((model) => model.toDomain()).toList();
  }

  Future<Policy?> getPolicyById(String id) async {
    final cached = await _isarService.getPolicyById(id);
    return cached?.toDomain();
  }

  Future<void> putAllPolicies(
    List<Policy> policies, {
    bool replaceExisting = false,
  }) async {
    if (policies.isEmpty) return;
    final isarModels = policies.map(PolicyIsarModel.fromDomain).toList();
    if (replaceExisting) {
      await _isarService.clearPolicies();
    }
    await _isarService.putAllPolicies(isarModels);
  }

  Future<void> clearPolicies() => _isarService.clearPolicies();
}
