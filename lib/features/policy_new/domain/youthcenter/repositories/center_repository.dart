import 'package:dio/dio.dart';

import '../youth_center_entity.dart';

abstract class CenterRepository {
  Future<List<YouthCenterEntity>> getCenters({CancelToken? cancelToken});
}
