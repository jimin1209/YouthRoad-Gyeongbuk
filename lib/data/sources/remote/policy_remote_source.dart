import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/env.dart';
import '../../models/policy_filter.dart';
import '../../models/policy_model.dart';

/// 올바른 정책 API 기본 URL
/// 실제 정책 리스트 엔드포인트 예:
///   GET https://www.gbyouth.co.kr/openapi/policy/list.json
const String kPolicyApiBaseUrl = String.fromEnvironment(
  'POLICY_API_BASE_URL',
  defaultValue: 'https://www.gbyouth.co.kr/openapi',
);

class PolicyRemoteSource {
  PolicyRemoteSource(
    this._dio, {
    String? apiKey,
    String? baseUrl,
  })  : _apiKey = apiKey ?? Env.youthApiKey,
        _baseUrl = _normalizeBaseUrl(
          baseUrl ??
              (Env.policyApiBaseUrl.isNotEmpty
                  ? Env.policyApiBaseUrl
                  : kPolicyApiBaseUrl),
        );

  final Dio _dio;
  final String _apiKey;
  final String _baseUrl;

  /// 정책 리스트 불러오기 (GET)
  Future<List<PolicyModel>> fetchPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    final query = _buildQuery(filter);

    if (kDebugMode) {
      debugPrint(
        '[PolicyRemoteSource] fetchPolicies -> URL=$_baseUrl/policy/list.json query=$query',
      );
    }

    final response = await _dio.get<String>(
      '$_baseUrl/policy/list.json',
      queryParameters: query,
      options: Options(responseType: ResponseType.plain),
    );

    final rawJson = response.data;
    if (rawJson == null) {
      throw StateError('Empty response from policy endpoint');
    }

    return compute(parsePoliciesJson, rawJson);
  }

  /// 정책 단일 조회 (전체 리스트 내에서 필터링)
  Future<PolicyModel> fetchPolicyById(String id) async {
    final list = await fetchPolicies(
      filter: const PolicyFilter(
        pagingYn: 'N',
        searchDsplyYn: 'all',
        recordCount: 2000,
      ),
    );

    final match = list.firstWhere(
      (policy) => policy.id == id,
      orElse: () => throw StateError('Policy not found for id: $id'),
    );

    return match;
  }

  /// 유사 정책 조회
  Future<List<PolicyModel>> fetchSimilar(String id) async {
    final base = await fetchPolicyById(id);

    final filter = PolicyFilter(
      searchRgnSe: base.regionName,
      searchPolicyType: base.typeName,
      pageIndex: 1,
      recordCount: 10,
    );

    final list = await fetchPolicies(filter: filter);
    return list.where((item) => item.id != id).toList();
  }

  /// 쿼리 파라미터 생성
  Map<String, dynamic> _buildQuery(PolicyFilter filter) {
    final query = <String, dynamic>{
      'pageIndex': filter.pageIndex ?? 1,
      'recordCount': filter.recordCount ?? 2000,
      'pageSize': filter.pageSize,
      'pagingYn': filter.pagingYn ?? 'N',
      'searchDsplyYn': filter.searchDsplyYn ?? 'all',
    };

    if (_apiKey.isNotEmpty) {
      query['apiKey'] = _apiKey;
    }

    void put(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        query[key] = value;
      }
    }

    put('searchYear', filter.searchYear);

    if (filter.searchRgnSe != null &&
        filter.searchRgnSe!.isNotEmpty &&
        filter.searchRgnSe != '전체' &&
        filter.searchRgnSe != '경북 전체') {
      put('searchRgnSe', filter.searchRgnSe);
    }

    if (filter.availableOnly == true) {
      put('aplyPsbltyYn', 'Y');
    }

    if (filter.category != null && filter.category != '전체') {
      put('searchPolicyType', filter.category);
    }

    put('searchPolicyNm', filter.searchText ?? filter.searchPolicyNm);
    put('instNo', filter.instNo);
    put('deptNo', filter.deptNo);

    if (filter.startDate != null) {
      put('policyBgngYmd', _formatDate(filter.startDate!));
    }
    if (filter.endDate != null) {
      put('policyEndYmd', _formatDate(filter.endDate!));
    }

    return query;
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }

  static String _normalizeBaseUrl(String value) {
    if (value.isEmpty) return value;
    return value.replaceAll(RegExp(r'/+$'), '');
  }
}

List<PolicyModel> parsePoliciesJson(String rawJson) {
  final decoded = json.decode(rawJson);
  if (decoded is! Map<String, dynamic>) {
    throw StateError('Invalid policy list response');
  }

  final resultList = decoded['resultList'];
  if (resultList is! List) {
    throw StateError('Missing resultList in response');
  }

  return resultList
      .map(
        (item) => PolicyModel.fromJson(
          (item as Map).cast<String, dynamic>(),
        ),
      )
      .toList();
}
