// FILE: lib/data/search/sources/remote/search_remote_source.dart

import 'package:flutter/foundation.dart';

import '../../../../domain/search/entities/search_category.dart';
import '../../../../domain/search/entities/search_query.dart';
import '../../models/search_result_item_model.dart';
import '../../../models/policy_filter.dart';
import '../../../models/policy_model.dart';
import '../../../models/inst_model.dart';
import '../../../sources/remote/policy_remote_source.dart';
import '../../../sources/remote/inst_remote_source.dart';

class SearchRemoteResponse {
  const SearchRemoteResponse({
    required this.items,
    required this.hasMore,
  });

  final List<SearchResultItemModel> items;
  final bool hasMore;
}

class SearchRemoteSource {
  SearchRemoteSource(
    this._policyRemoteSource,
    this._instRemoteSource,
  );

  final PolicyRemoteSource _policyRemoteSource;
  final InstRemoteSource _instRemoteSource;

  Future<SearchRemoteResponse> searchPolicies(SearchQuery query) async {
    final filter = PolicyFilter(
      searchText: query.text,
      searchRgnSe: query.region,
      pageIndex: query.page,
      recordCount: query.pageSize,
      pagingYn: 'Y',
      searchDsplyYn: 'all',
    );

    final List<PolicyModel> policies;
    try {
      policies = await _policyRemoteSource.fetchPolicies(filter: filter);
    } catch (e, st) {
      debugPrint('[SearchRemoteSource] policy fetch failed: $e\n$st');
      rethrow;
    }

    final items = policies.map(SearchResultItemModel.fromPolicy).toList();
    final hasMore = policies.length >= (query.pageSize);

    return SearchRemoteResponse(items: items, hasMore: hasMore);
  }

  Future<SearchRemoteResponse> searchInstitutions(SearchQuery query) async {
    final List<InstModel> institutions;
    try {
      institutions = await _instRemoteSource.fetchInstList(keyword: query.text);
    } catch (e, st) {
      debugPrint('[SearchRemoteSource] institution fetch failed: $e\n$st');
      rethrow;
    }

    final start = (query.page - 1) * query.pageSize;
    final sliced = start >= institutions.length
        ? <InstModel>[]
        : institutions.skip(start).take(query.pageSize).toList();

    final items = sliced.map(SearchResultItemModel.fromInstitution).toList();
    final hasMore = institutions.length > start + sliced.length;

    return SearchRemoteResponse(items: items, hasMore: hasMore);
  }

  Future<SearchRemoteResponse> search(SearchQuery query) async {
    final tasks = <Future<SearchRemoteResponse>>[];
    if (query.category == SearchCategory.all ||
        query.category == SearchCategory.policy) {
      tasks.add(searchPolicies(query));
    }
    if (query.category == SearchCategory.all ||
        query.category == SearchCategory.institution) {
      tasks.add(searchInstitutions(query));
    }

    final results = await Future.wait(tasks);
    final merged = <SearchResultItemModel>[];
    var hasMore = false;
    for (final res in results) {
      merged.addAll(res.items);
      hasMore = hasMore || res.hasMore;
    }

    return SearchRemoteResponse(items: merged, hasMore: hasMore);
  }
}
