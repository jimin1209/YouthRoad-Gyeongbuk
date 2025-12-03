import '../../domain/entities/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../sources/department_remote_source.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  DepartmentRepositoryImpl(this.remoteSource);

  final DepartmentRemoteSource remoteSource;

  @override
  Future<List<Department>> fetchDepartments({
    required String instNo,
    String? keyword,
  }) async {
    final models = await remoteSource.fetchDepartments(
      instNo: instNo,
      keyword: keyword,
    );
    return models.map((e) => e.toDomain()).toList();
  }
}
