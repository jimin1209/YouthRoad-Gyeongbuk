import '../../data/models/dept_model.dart';

abstract class DeptRepository {
  Future<List<DeptModel>> fetchDeptList({required String instNo, String? keyword});
}
