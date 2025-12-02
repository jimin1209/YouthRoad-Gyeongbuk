import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../../domain/values/policy_failure.dart';
import '../../domain/values/policy_logger.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_result.dart';
import '../../domain/values/policy_settings.dart';
import '../cache/policy_cache.dart';
import '../sources/policy_remote_source.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  final PolicyRemoteSource remote;
  final PolicyCache cache;
  final PolicyLogger logger;
  final PolicySettings settings;

  PolicyRepositoryImpl({
    required this.remote,
    required this.cache,
    required this.logger,
    required this.settings,
  });

  @override
  Future<PolicyResult<List<Policy>>> fetchPoliciesByQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    try {
      final effectivePageSize = pageSize == 0 ? settings.pageSize : pageSize;
      logger.info(
          'fetchPoliciesByQuery(feed: ${query.feedType.name}, page: $page, size: $effectivePageSize)');

      if (settings.enableCache) {
        final cached = cache.getPage(query, page);
        if (cached != null && cached.isNotEmpty) {
          logger.info('캐시된 정책 페이지 사용 (feed: ${query.feedType.name}, page: $page)');
          return PolicyResult.success(cached);
        }
      }

      final models = await remote.fetchPolicies(
        query: query,
        page: page,
        pageSize: effectivePageSize,
      );
      final domainList = models.map((e) => e.toDomain()).toList();

      if (settings.enableCache) {
        cache.savePage(query, page, domainList);
      }

      return PolicyResult.success(domainList);
    } catch (e, st) {
      logger.error('fetchPoliciesByQuery 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  @override
  Future<PolicyResult<Policy>> fetchPolicyDetail(String id) async {
    try {
      logger.info('fetchPolicyDetail(id: $id) 호출');
      final model = await remote.fetchPolicyDetail(id);
      return PolicyResult.success(model.toDomain());
    } catch (e, st) {
      logger.error('fetchPolicyDetail 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }
}
