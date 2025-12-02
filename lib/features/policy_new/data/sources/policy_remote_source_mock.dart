import 'package:dio/dio.dart';

import '../../domain/values/policy_query.dart';
import '../models/policy_model.dart';
import 'policy_remote_source.dart';

class PolicyRemoteSourceMock extends PolicyRemoteSource {
  PolicyRemoteSourceMock() : super(Dio());

  @override
  Future<List<PolicyModel>> fetchPolicies({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.generate(
      pageSize,
      (i) => PolicyModel(
        id: 'mock_${query.feedType.name}_${page}_$i',
        title: 'Mock Policy ${page}_$i',
        summary: 'Mock summary for page $page item $i',
        description: 'Mock description for page $page item $i',
        region: query.filter.region.name,
        category: query.filter.category?.name ?? 'employment',
        tags: query.tags.isNotEmpty ? query.tags : query.filter.tags,
        keywords: query.tags.isNotEmpty ? query.tags : query.filter.tags,
        applicationStartDate: DateTime.now().toIso8601String(),
        applicationEndDate:
            DateTime.now().add(const Duration(days: 10)).toIso8601String(),
        announceDate: DateTime.now().toIso8601String(),
        isOnline: query.filter.isOnline ?? true,
        isOffline: query.filter.isOffline ?? true,
        minAge: 19,
        maxAge: query.filter.age ?? 39,
        isForYouth: true,
        incomeCondition: '제한 없음',
        educationCondition: '무관',
        employmentCondition: '무관',
        applyUrl: 'https://example.com/apply',
        attachmentUrl: 'https://example.com/attachment',
        institution: '청년정책센터',
        department: '정책기획팀',
        contact: '02-000-0000',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  @override
  Future<PolicyModel> fetchPolicyDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return PolicyModel(
      id: id,
      title: 'Mock Policy Detail $id',
      summary: 'Summary of mock detail $id',
      description: 'Detailed description for $id',
      region: 'gyeongbuk',
      category: 'employment',
      tags: const ['mock', 'sample'],
      keywords: const ['mock', 'sample'],
      applicationStartDate: DateTime.now().toIso8601String(),
      applicationEndDate:
          DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      announceDate: DateTime.now().toIso8601String(),
      isOnline: true,
      isOffline: true,
      minAge: 19,
      maxAge: 39,
      isForYouth: true,
      incomeCondition: '소득 무관',
      educationCondition: '학력 무관',
      employmentCondition: '취업 상태 무관',
      applyUrl: 'https://example.com/apply/$id',
      attachmentUrl: 'https://example.com/attachment/$id',
      institution: '청년정책센터',
      department: '정책팀',
      contact: '02-000-0000',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}
