import '../models/dept_model.dart';
import '../sources/remote/dept_remote_source.dart';
import '../../domain/repositories/dept_repository.dart';

class DeptRepositoryImpl implements DeptRepository {
  DeptRepositoryImpl(this._remoteSource);

  final DeptRemoteSource _remoteSource;

  @override
  Future<List<DeptModel>> fetchDeptList({required String instNo, String? keyword}) {
    return _remoteSource.fetchDeptList(instNo: instNo, keyword: keyword);
  }
}
