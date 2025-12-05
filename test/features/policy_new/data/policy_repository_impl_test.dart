import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/features/policy_new/data/cache/policy_cache.dart';
import 'package:youth_road_app/features/policy_new/data/models/policy_model.dart';
import 'package:youth_road_app/features/policy_new/data/repositories/policy_repository_impl.dart';
import 'package:youth_road_app/features/policy_new/data/sources/policy_remote_source.dart';
import 'package:youth_road_app/features/policy_new/domain/entities/policy.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_category.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_logger.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_region.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_settings.dart';

class CountingPolicyRemoteSource extends PolicyRemoteSource {
  CountingPolicyRemoteSource({
    required this.models,
  }) : super(Dio(), apiKey: '', baseUrl: '');

  final List<PolicyModel> models;
  int fetchCount = 0;

  @override
  Future<List<PolicyModel>> fetchPoliciesWithParams(
    Map<String, dynamic> queryParameters,
  ) async {
    fetchCount++;
    return models;
  }

  @override
  Future<PolicyModel> fetchPolicyDetail(String id) async {
    fetchCount++;
    return models.firstWhere((element) => element.id == id);
  }
}

class SilentPolicyLogger implements PolicyLogger {
  @override
  void error(String msg, [Object? err, StackTrace? stackTrace]) {}

  @override
  void info(String msg) {}

  @override
  void warn(String msg) {}
}

Policy buildPolicy(String id, DateTime now) {
  return Policy(
    id: id,
    title: 'title',
    summary: 'summary',
    description: 'description',
    region: PolicyRegion.seoul,
    category: PolicyCategory.education,
    tags: const [],
    keywords: const [],
    applicationStartDate: now,
    applicationEndDate: now.add(const Duration(days: 1)),
    announceDate: now.add(const Duration(days: 2)),
    isOnline: true,
    isOffline: false,
    minAge: 0,
    maxAge: 100,
    isForYouth: true,
    incomeCondition: null,
    educationCondition: null,
    employmentCondition: null,
    applyUrl: 'https://example.com',
    attachmentUrl: null,
    institution: 'inst',
    department: 'dept',
    contact: null,
    institutionId: null,
    departmentId: null,
    detailUrl: null,
    createdAt: now,
    updatedAt: now,
  );
}

PolicyModel buildPolicyModel(String id) {
  final now = DateTime.now();
  return PolicyModel(
    id: id,
    name: '정책 $id',
    policyYear: '2024',
    regionName: '서울',
    typeName: '교육',
    instName: 'inst',
    deptName: 'dept',
    supervisorName: null,
    operatorName: null,
    instNo: '1',
    deptNo: '2',
    policyScale: 'summary',
    policyContent: 'content',
    inquiry: null,
    onlineApply: true,
    applyStart: now,
    applyEnd: now.add(const Duration(days: 1)),
    applyPossible: true,
    detailUrl: 'https://example.com',
    displayYn: 'Y',
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PolicyRepositoryImpl 캐시 동작', () {
    test('캐시 HIT 시 원격 호출 없이 데이터를 반환한다', () async {
      final cache = PolicyCache();
      final now = DateTime.now();
      final cachedPolicies = [buildPolicy('cached-1', now)];
      final remote = CountingPolicyRemoteSource(models: [buildPolicyModel('remote-1')]);
      final repository = PolicyRepositoryImpl(
        remote: remote,
        cache: cache,
        logger: SilentPolicyLogger(),
        settings: const PolicySettings(cacheTtl: Duration(hours: 1)),
      );

      cache.savePage(1, cachedPolicies);

      final result = await repository.fetchPolicies(page: 1, pageSize: 10);

      expect(result.isSuccess, isTrue);
      expect(result.data, cachedPolicies);
      expect(remote.fetchCount, 0);
    });

    test('stale 캐시는 즉시 반환되고 비동기 새로고침이 실행된다', () async {
      final cache = PolicyCache();
      final now = DateTime.now();
      final cachedPolicies = [buildPolicy('cached-2', now)];
      final remote = CountingPolicyRemoteSource(models: [buildPolicyModel('remote-2')]);
      final repository = PolicyRepositoryImpl(
        remote: remote,
        cache: cache,
        logger: SilentPolicyLogger(),
        settings: const PolicySettings(cacheTtl: Duration.zero),
      );

      cache.savePage(1, cachedPolicies);

      final result = await repository.fetchPolicies(page: 1, pageSize: 10);

      expect(result.isSuccess, isTrue);
      expect(result.data, cachedPolicies);
      expect(remote.fetchCount, 0);

      await pumpEventQueue(times: 5);

      expect(remote.fetchCount, 1);

      final refreshed = cache.getPageWithStatus(1, const Duration(minutes: 1));
      expect(refreshed?.data.first.id, 'remote-2');
    });
  });
}
