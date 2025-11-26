import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../../debug/debug_log_collector.dart';
import '../di.dart';
import '../../data/sources/local/search_history_source.dart';
import 'region_notifier.dart';

class PolicyListNotifier extends AsyncNotifier<List<Policy>> {
  static const String errorMessage = '정책을 불러오지 못했습니다.';
  String? _lastQuery;

  PolicyRepository get _repo => ref.read(policyRepositoryProvider);
  SearchHistorySource get _historySource => ref.read(searchHistorySourceProvider);

  @override
  Future<List<Policy>> build() async {
    final selectedRegion = ref.watch(regionProvider);
    try {
      return await _fetchPolicies(selectedRegion);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('PolicyListNotifier.build failed: $error');
        debugPrint('$stackTrace');
        DebugLogCollector.instance
            .add('PolicyListNotifier.build failed: $error\n$stackTrace');
      }
      throw Exception(errorMessage);
    }
  }

  Future<List<Policy>> _fetchPolicies(String? region) async {
    try {
      if (kDebugMode) {
        debugPrint('[PolicyListNotifier] loading policy list...');
      }
      final policies = await _repo.fetchPolicies(
        filter: PolicyFilter(
          searchRgnSe: region,
          searchText: _lastQuery,
          availableOnly: true,
        ),
      );
      if (kDebugMode) {
        debugPrint('[PolicyListNotifier] fetched ${policies.length} policies');
      }
      return policies;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Failed to fetch policies: $e');
        debugPrint('$st');
        DebugLogCollector.instance
            .add('Failed to fetch policies: $e\n$st');
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> refreshPolicies() async {
    final selectedRegion = ref.read(regionProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPolicies(selectedRegion));
  }

  Future<void> search(String query) async {
    final normalized = query.trim();
    _lastQuery = normalized.isEmpty ? null : normalized;
    if (_lastQuery != null) {
      await _historySource.saveQuery(_lastQuery!);
    }
    ref.invalidate(searchHistoryListProvider);
    await refreshPolicies();
  }
}
