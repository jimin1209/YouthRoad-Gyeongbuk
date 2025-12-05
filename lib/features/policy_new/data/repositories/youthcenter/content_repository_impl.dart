import 'package:dio/dio.dart';

import '../../../domain/youthcenter/paging_entity.dart';
import '../../../domain/youthcenter/repositories/content_repository.dart';
import '../../../domain/youthcenter/youth_content_entity.dart';
import '../../mappers/youth_content_mapper.dart';
import '../../mappers/youth_policy_mapper.dart';
import '../../sources/youthcenter/youth_content_remote_source.dart';

class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl(this._remoteSource);

  final YouthContentRemoteSource _remoteSource;

  @override
  Future<(List<YouthContentEntity>, PagingEntity?)> getContents(
    int page, {
    CancelToken? cancelToken,
  }) async {
    final dto = await _remoteSource.fetchContents(
      page: page,
      cancelToken: cancelToken,
    );
    final items = dto.result?.youthPolicyList ?? [];
    final contents = items.map((item) => item.toDomain()).toList();
    final paging = dto.result?.pagging.toDomain();
    return (contents, paging);
  }
}
