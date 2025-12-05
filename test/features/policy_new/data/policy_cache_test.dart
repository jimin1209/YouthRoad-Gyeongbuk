import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/features/policy_new/data/cache/policy_cache.dart';
import 'package:youth_road_app/features/policy_new/domain/entities/policy.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_category.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_region.dart';

Policy buildPolicy(String id) {
  final now = DateTime.now();
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

void main() {
  group('PolicyCache', () {
    test('유효한 TTL에서는 캐시가 그대로 반환된다', () {
      final cache = PolicyCache();
      final policies = [buildPolicy('policy-1')];

      cache.savePage(1, policies);

      final result = cache.getPageWithStatus(
        1,
        const Duration(hours: 1),
      );

      expect(result, isNotNull);
      expect(result!.data, policies);
      expect(result.isStale, isFalse);
    });

    test('TTL이 만료되면 stale로 표시된다', () {
      final cache = PolicyCache();
      final policies = [buildPolicy('policy-2')];

      cache.savePage(1, policies);

      final result = cache.getPageWithStatus(1, Duration.zero);

      expect(result, isNotNull);
      expect(result!.data, policies);
      expect(result.isStale, isTrue);
    });
  });
}
