import '../paging_entity.dart';
import '../policy_entity.dart';
import '../policy_search_query.dart';

abstract class PolicyRepository {
  Future<(List<PolicyEntity>, PagingEntity)> getPolicies(
    PolicySearchQuery query,
  );
}
