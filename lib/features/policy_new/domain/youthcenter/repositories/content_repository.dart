import '../paging_entity.dart';
import '../youth_content_entity.dart';

abstract class ContentRepository {
  Future<(List<YouthContentEntity>, PagingEntity?)> getContents(int page);
}
