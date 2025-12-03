import 'package:dio/dio.dart';

import '../models/policy_model.dart';
import 'policy_remote_source.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';

PolicyRegion _parseRegion(String? value) {
  if (value == null) return PolicyRegion.all;

  final normalized = value.toLowerCase();
  switch (normalized) {
    case '전체':
    case 'all':
      return PolicyRegion.all;
    case 'seoul':
    case '서울':
      return PolicyRegion.seoul;
    case 'busan':
    case '부산':
      return PolicyRegion.busan;
    case 'daegu':
    case '대구':
      return PolicyRegion.daegu;
    case 'incheon':
    case '인천':
      return PolicyRegion.incheon;
    case 'gwangju':
    case '광주':
      return PolicyRegion.gwangju;
    case 'daejeon':
    case '대전':
      return PolicyRegion.daejeon;
    case 'ulsan':
    case '울산':
      return PolicyRegion.ulsan;
    case 'gyeongbuk':
    case '경북':
    case '경상북도':
      return PolicyRegion.gyeongbuk;
    default:
      return PolicyRegion.all;
  }
}

PolicyCategory _parseCategory(String? value) {
  if (value == null) return PolicyCategory.other;

  final normalized = value.toLowerCase();
  switch (normalized) {
    case 'employment':
    case '취업':
      return PolicyCategory.employment;
    case 'startup':
    case '창업':
      return PolicyCategory.startup;
    case 'housing':
    case '주거':
      return PolicyCategory.housing;
    case 'life':
    case '생활':
      return PolicyCategory.life;
    case 'education':
    case '교육':
      return PolicyCategory.education;
    case 'welfare':
    case '복지':
      return PolicyCategory.welfare;
    case 'culture':
    case '문화':
      return PolicyCategory.culture;
    default:
      return PolicyCategory.other;
  }
}

class PolicyRemoteSourceMock extends PolicyRemoteSource {
  PolicyRemoteSourceMock() : super(Dio(), apiKey: '', baseUrl: '');

  @override
  Future<List<PolicyModel>> fetchPoliciesWithParams(
    Map<String, dynamic> queryParameters,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final int page = queryParameters['pageIndex'] as int? ??
        queryParameters['page'] as int? ??
        1;
    final int size = queryParameters['pageSize'] as int? ??
        queryParameters['size'] as int? ??
        10;
    final String feedType =
        (queryParameters['feed_type'] as String?) ?? 'all';
    final PolicyRegion region =
        _parseRegion((queryParameters['searchRgnSe'] as String?) ?? 'all');
    final PolicyCategory category = _parseCategory(
        (queryParameters['searchPolicyType'] as String?) ?? 'employment');

    return List.generate(
      size,
      (i) => PolicyModel(
        id: 'mock_${feedType}_${page}_$i',
        name: 'Mock Policy ${page}_$i',
        regionName: region.name,
        typeName: category.name,
        policyScale: 'Mock summary for page $page item $i',
        policyContent: 'Mock description for page $page item $i',
        onlineApply: true,
        applyStart: DateTime.now(),
        applyEnd: DateTime.now().add(const Duration(days: 10)),
        detailUrl: 'https://example.com/apply',
        inquiry: '02-000-0000',
        supervisorName: '청년정책센터',
        operatorName: '정책기획팀',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<PolicyModel> fetchPolicyDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return PolicyModel(
      id: id,
      name: 'Mock Policy Detail $id',
      regionName: PolicyRegion.gyeongbuk.name,
      typeName: PolicyCategory.employment.name,
      policyScale: 'Summary of mock detail $id',
      policyContent: 'Detailed description for $id',
      onlineApply: true,
      applyStart: DateTime.now(),
      applyEnd: DateTime.now().add(const Duration(days: 5)),
      detailUrl: 'https://example.com/apply/$id',
      inquiry: '02-000-0000',
      supervisorName: '청년정책센터',
      operatorName: '정책팀',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
