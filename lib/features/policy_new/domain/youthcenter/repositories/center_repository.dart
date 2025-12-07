import 'package:dio/dio.dart';

import '../youth_center_entity.dart';

abstract class CenterRepository {
  Future<List<YouthCenterEntity>> getCenters({CancelToken? cancelToken});
  Future<List<YouthCenterEntity>> getCentersV2({
    String? ctpvCd,
    String? sggCd,
    int pageNum = 1,
    int pageSize = 300,
    CancelToken? cancelToken,
  });
}
