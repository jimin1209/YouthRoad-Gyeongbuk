// FILE: lib/data/search/repositories/search_repository_impl.dart

import 'package:flutter/foundation.dart';

import '../../local/isar/isar_service.dart';
import '../../models/policy_filter.dart';
import '../models/search_result_item_model.dart';
import '../sources/remote/search_remote_source.dart';
import '../../../domain/search/entities/search_category.dart';
import '../../../domain/search/entities/search_query.dart';
import '../../../domain/search/entities/search_result.dart';
import '../../../domain/search/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(
    this._remoteSource,
    this._isarService,
  );

  final SearchRemoteSource _remoteSource;
  final IsarService _isarService;

  @override
  Future<SearchResult> search(SearchQuery query) async {
    final trimmedQuery = query.text.trim();
    final effectiveQuery = query.copyWith(text: trimmedQuery, page: query.page);

    final remoteResponse = await _remoteSource.search(effectiveQuery);
    final mergedItems = List<SearchResultItemModel>.from(remoteResponse.items);

    if (effectiveQuery.useLocalIndex &&
        (effectiveQuery.category == SearchCategory.all ||
            effectiveQuery.category == SearchCategory.policy)) {
      final localPolicies = await _loadLocalPolicies(effectiveQuery);
      mergedItems.addAll(localPolicies);
    }

    final deduped = _deduplicate(mergedItems);
    return SearchResult(
      query: effectiveQuery,
      items: deduped.map((item) => item.toDomain()).toList(),
      hasMore: remoteResponse.hasMore,
    );
  }

  Future<List<SearchResultItemModel>> _loadLocalPolicies(SearchQuery query) async {
    try {
      final filter = PolicyFilter(
        searchText: query.text,
        searchRgnSe: query.region,
        pageIndex: query.page,
        recordCount: query.pageSize,
        pagingYn: 'N',
      );
      final cached = await _isarService.getPolicies(filter: filter);
      return cached
          .map((policy) => SearchResultItemModel.fromPolicyEntity(policy.toDomain()))
          .toList();
    } catch (e, st) {
      debugPrint('[SearchRepositoryImpl] local load failed: $e\n$st');
      return const [];
    }
  }

  List<SearchResultItemModel> _deduplicate(
    List<SearchResultItemModel> items,
  ) {
    final seen = <String>{};
    final result = <SearchResultItemModel>[];
    for (final item in items) {
      if (seen.add('${item.category.name}-${item.id}')) {
        result.add(item);
      }
    }
    return result;
  }
}
