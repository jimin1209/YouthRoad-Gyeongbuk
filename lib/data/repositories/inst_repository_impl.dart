import '../models/inst_model.dart';
import '../sources/remote/inst_remote_source.dart';
import '../../domain/repositories/inst_repository.dart';

class InstRepositoryImpl implements InstRepository {
  InstRepositoryImpl(this._remoteSource);

  final InstRemoteSource _remoteSource;

  @override
  Future<List<InstModel>> fetchInstList({String? keyword}) {
    return _remoteSource.fetchInstList(keyword: keyword);
  }
}
