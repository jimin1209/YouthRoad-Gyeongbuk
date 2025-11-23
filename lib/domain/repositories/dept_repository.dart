import '../../core/api/models/department_model.dart';
import '../../data/models/dept_model.dart';

abstract class DeptRepository {
  Future<List<DeptModel>> fetchDeptList({required String instNo, String? keyword});
  Future<List<DepartmentModel>> getDepartments({
    required String instId,
    String? keyword,
  });
}
