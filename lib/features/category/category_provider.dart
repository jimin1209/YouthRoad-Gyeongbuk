import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';

const _defaultCategories = <String>[
  '취업',
  '창업',
  '주거',
  '교육',
  '생활안정',
  '기타',
];

class CategoryPoliciesState {
  const CategoryPoliciesState({
    required this.categories,
    required this.fallbackPolicies,
    required this.totalCount,
    this.region,
  });

  final Map<String, List<Policy>> categories;
  final List<Policy> fallbackPolicies;
  final int totalCount;
  final String? region;
}

final categoryPoliciesProvider = AutoDisposeAsyncNotifierProvider<
    CategoryPoliciesNotifier, CategoryPoliciesState>(
  CategoryPoliciesNotifier.new,
);

class CategoryPoliciesNotifier
    extends AutoDisposeAsyncNotifier<CategoryPoliciesState> {
  PolicyRepository get _repository =>
      ref.read(policyRepositoryInterfaceProvider);

  String? get _region => ref.read(regionProvider);

  @override
  FutureOr<CategoryPoliciesState> build() {
    return _load();
  }

  Future<void> refresh({bool includeAllRegions = false}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(
          includeAllRegions: includeAllRegions,
        ));
  }

  Future<CategoryPoliciesState> _load({bool includeAllRegions = false}) async {
    final filter = PolicyFilter(
      searchRgnSe: includeAllRegions ? null : _region,
      recordCount: 300,
      pagingYn: 'N',
      searchDsplyYn: 'all',
    );

    final policies = await _repository.refreshPolicies(filter: filter);
    final grouped = _groupByCategory(policies);
    final flattened = grouped.values.expand((policies) => policies).toList();

    final fallback = flattened
        .toList()
      ..sort(
        (a, b) => (a.dday ?? 9999).compareTo(b.dday ?? 9999),
      );

    return CategoryPoliciesState(
      categories: grouped,
      fallbackPolicies: fallback.take(6).toList(),
      totalCount: flattened.length,
      region: includeAllRegions ? null : _region,
    );
  }

  Map<String, List<Policy>> _groupByCategory(List<Policy> policies) {
    final buckets = <String, List<Policy>>{
      for (final name in _defaultCategories) name: <Policy>[],
    };

    for (final policy in policies) {
      final categories = _extractCategories(policy);
      for (final category in categories) {
        buckets.putIfAbsent(category, () => <Policy>[]);
        buckets[category]!.add(policy);
      }
    }

    return {
      for (final key in _defaultCategories)
        key: List.unmodifiable(buckets[key] ?? const []),
    };
  }

  List<String> _extractCategories(Policy policy) {
    final raw = policy.policyTypeNm ?? '';
    final segments = raw
        .split(RegExp(r'[,/]|\s{2,}'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (segments.isEmpty && policy.tags.isNotEmpty) {
      segments.addAll(policy.tags);
    }

    final mapped = segments
        .map(_normalizeCategory)
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();

    if (mapped.isEmpty) {
      return const ['기타'];
    }

    return mapped;
  }

  String _normalizeCategory(String value) {
    final text = value.replaceAll(' ', '');
    if (text.contains('취업') || text.contains('일자리')) return '취업';
    if (text.contains('창업') || text.contains('스타트업')) return '창업';
    if (text.contains('주거') || text.contains('주택') || text.contains('전월세')) {
      return '주거';
    }
    if (text.contains('교육') || text.contains('훈련') || text.contains('장학')) {
      return '교육';
    }
    if (text.contains('생활') || text.contains('복지') || text.contains('문화')) {
      return '생활안정';
    }
    return '기타';
  }
}
