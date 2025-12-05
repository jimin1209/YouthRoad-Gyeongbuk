import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/youthcenter/paging_entity.dart';
import '../../domain/youthcenter/policy_entity.dart';

class PolicyLocalCache {
  PolicyLocalCache(this._prefs);

  final SharedPreferences _prefs;

  static const _policyCacheKey = 'youthcenter_policy_cache_data';
  static const _policyPagingKey = 'youthcenter_policy_cache_paging';
  static const _updatedAtKey = 'youthcenter_policy_cache_updated_at';

  Future<void> save(
    List<PolicyEntity> policies,
    PagingEntity paging,
  ) async {
    await _prefs.setString(
      _policyCacheKey,
      jsonEncode(policies.map((e) => e.toJson()).toList()),
    );
    await _prefs.setString(_policyPagingKey, jsonEncode(paging.toJson()));
    await _prefs.setString(_updatedAtKey, DateTime.now().toIso8601String());
  }

  List<PolicyEntity>? loadPolicies() {
    final cached = _prefs.getString(_policyCacheKey);
    if (cached == null) return null;

    try {
      final decoded = jsonDecode(cached) as List<dynamic>;
      return decoded
          .map((item) => PolicyEntity.fromJson((item as Map).cast<String, dynamic>()))
          .toList();
    } catch (_) {
      return null;
    }
  }

  PagingEntity? loadPaging() {
    final cached = _prefs.getString(_policyPagingKey);
    if (cached == null) return null;

    try {
      return PagingEntity.fromJson(
        (jsonDecode(cached) as Map).cast<String, dynamic>(),
      );
    } catch (_) {
      return null;
    }
  }

  bool exists() => _prefs.containsKey(_policyCacheKey);

  bool isExpired(Duration ttl) {
    final updated = _prefs.getString(_updatedAtKey);
    if (updated == null) {
      return true;
    }

    try {
      final updatedAt = DateTime.parse(updated);
      return DateTime.now().difference(updatedAt) > ttl;
    } catch (_) {
      return true;
    }
  }

  Future<void> invalidate() async {
    await _prefs.remove(_policyCacheKey);
    await _prefs.remove(_policyPagingKey);
    await _prefs.remove(_updatedAtKey);
  }
}
