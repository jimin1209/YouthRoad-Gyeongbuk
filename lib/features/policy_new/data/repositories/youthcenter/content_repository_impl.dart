import 'package:dio/dio.dart';

import '../../../domain/youthcenter/paging_entity.dart';
import '../../../domain/youthcenter/repositories/content_repository.dart';
import '../../../domain/youthcenter/youth_content_entity.dart';
import '../../dto/content_youthcenter_dto.dart';
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
    final items =
        dto.result?.youthPolicyList?.whereType<ContentYouthcenterItemDto>().toList() ??
            <ContentYouthcenterItemDto>[];
    final contents = items.map((item) => item.toDomain()).toList();
    final paging = _mapPaging(dto.result?.pagging);
    return (contents, paging);
  }

  PagingEntity _mapPaging(ContentYouthcenterPaggingDto? dto) {
    if (dto == null) return PagingEntity.empty();
    return PagingEntity(
      totalCount: dto.totCount ?? 0,
      pageNumber: dto.pageNum ?? 1,
      pageSize: dto.pageSize ?? 0,
    );
  }
}
