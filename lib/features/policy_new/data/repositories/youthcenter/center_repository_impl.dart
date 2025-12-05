import 'package:dio/dio.dart';

import '../../../domain/youthcenter/repositories/center_repository.dart';
import '../../../domain/youthcenter/youth_center_entity.dart';
import '../../mappers/youth_center_mapper.dart';
import '../../sources/youthcenter/youth_center_remote_source.dart';

class CenterRepositoryImpl implements CenterRepository {
  CenterRepositoryImpl(this._remoteSource);

  final YouthCenterRemoteSource _remoteSource;

  @override
  Future<List<YouthCenterEntity>> getCenters({CancelToken? cancelToken}) async {
    final dto = await _remoteSource.fetchCenters(cancelToken: cancelToken);
    final items = dto.result?.youthPolicyList ?? [];
    return items.map((item) => item.toDomain()).toList();
  }
}
