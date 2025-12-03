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
  PolicyRemoteSourceMock() : super(Dio());

  Map<String, dynamic> _sanitizeParameters(Map<String, dynamic> source) {
    final sanitized = Map<String, dynamic>.from(source);
    sanitized.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    });
    return sanitized;
  }

  @override
  Future<List<PolicyModel>> fetchPolicies(int page, int pageSize) {
    return fetchPoliciesWithParams({
      'page': page,
      'size': pageSize,
    });
  }

  @override
  Future<List<PolicyModel>> fetchPolicies(int page, int pageSize) {
    return fetchPoliciesWithParams({
      'page': page,
      'size': pageSize,
    });
  }

  @override
  Future<List<PolicyModel>> fetchPoliciesWithParams(
    Map<String, dynamic> queryParameters,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final params = _sanitizeParameters(queryParameters);

    final int page = params['page'] as int? ?? 1;
    final int size = params['size'] as int? ?? 10;
    final String feedType = (params['feed_type'] as String?) ?? 'all';
    final String sort = (params['sort'] as String?) ?? 'latest';
    final String? keyword = (params['keyword'] as String?)?.trim();
    final PolicyRegion region = _parseRegion((params['region'] as String?) ?? 'all');
    final PolicyCategory category =
        _parseCategory((params['category'] as String?) ?? 'employment');
    final List<String> selectedTags = (params['tags'] as String?)
            ?.split(',')
            .where((tag) => tag.isNotEmpty)
            .toList() ??
        const [];
    final List<String> filterTags = (params['tag_filters'] as String?)
            ?.split(',')
            .where((tag) => tag.isNotEmpty)
            .toList() ??
        const [];
    final List<String> mergedTags = {
      ...filterTags,
      ...selectedTags,
    }.toList();
    final List<String> tags = mergedTags.isNotEmpty ? mergedTags : const ['sample'];
    final List<String> keywords = tags.isNotEmpty ? tags : const ['sample'];

    final now = DateTime.now();

    final items = List.generate(
      size,
      (i) => PolicyModel(
        id: 'mock_${feedType}_${sort}_${page}_$i',
        title: keyword == null || keyword.isEmpty
            ? 'Mock Policy ${page}_$i'
            : '[${keyword}] Mock Policy ${page}_$i',
        summary: 'feed=$feedType, sort=$sort, page=$page item $i',
        description: 'Mock description for page $page item $i',
        region: region,
        category: category,
        tags: tags,
        keywords: keywords,
        applicationStartDate: now.toIso8601String(),
        applicationEndDate: now.add(const Duration(days: 10)).toIso8601String(),
        announceDate: now.toIso8601String(),
        isOnline: true,
        isOffline: true,
        minAge: 19,
        maxAge: 39,
        isForYouth: true,
        incomeCondition: '제한 없음',
        educationCondition: '무관',
        employmentCondition: '무관',
        applyUrl: 'https://example.com/apply',
        attachmentUrl: 'https://example.com/attachment',
        institution: '청년정책센터',
        department: '정책기획팀',
        contact: '02-000-0000',
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
      ),
    );

    if (sort == 'deadline') {
      return items.reversed.toList();
    }

    return items;
  }

  @override
  Future<PolicyModel> fetchPolicyDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return PolicyModel(
      id: id,
      title: 'Mock Policy Detail $id',
      summary: 'Summary of mock detail $id',
      description: 'Detailed description for $id',
      region: PolicyRegion.gyeongbuk,
      category: PolicyCategory.employment,
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
