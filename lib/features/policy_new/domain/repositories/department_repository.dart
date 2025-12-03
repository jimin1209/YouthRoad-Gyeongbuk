import '../entities/department.dart';

abstract class DepartmentRepository {
  Future<List<Department>> fetchDepartments({
    required String instNo,
    String? keyword,
  });
}
