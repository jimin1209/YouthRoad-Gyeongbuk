import 'package:flutter/foundation.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../models/policy_filter.dart';
import '../sources/remote/policy_remote_source.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  PolicyRepositoryImpl(this._remoteSource);

  final PolicyRemoteSource _remoteSource;
  final Map<String, Policy> _cache = {};

  @override
  Future<List<Policy>> fetchPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    final models = await _remoteSource.fetchPolicies(filter: filter);
    final entities = models.map((m) => m.toEntity()).toList();
    for (final policy in entities) {
      _cache[policy.id] = policy;
    }
    return entities;
  }

  @override
  Future<Policy> fetchPolicyById(String id) async {
    if (_cache.containsKey(id)) {
      return _cache[id]!;
    }

    final model = await _remoteSource.fetchPolicyById(id);
    final entity = model.toEntity();
    _cache[id] = entity;
    return entity;
  }

  @override
  Future<List<Policy>> fetchSimilarPolicies(String id) async {
    try {
      final models = await _remoteSource.fetchSimilar(id);
      final entities = models.map((m) => m.toEntity()).toList();
      for (final policy in entities) {
        _cache[policy.id] = policy;
      }
      return entities;
    } catch (e, st) {
      debugPrint('Failed to fetch similar policies: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
