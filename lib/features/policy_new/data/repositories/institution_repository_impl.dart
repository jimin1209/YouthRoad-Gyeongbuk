import '../../domain/entities/institution.dart';
import '../../domain/repositories/institution_repository.dart';
import '../sources/institution_remote_source.dart';

class InstitutionRepositoryImpl implements InstitutionRepository {
  InstitutionRepositoryImpl(this.remoteSource);

  final InstitutionRemoteSource remoteSource;

  @override
  Future<List<Institution>> fetchInstitutions({String? keyword}) async {
    final models = await remoteSource.fetchInstitutions(keyword: keyword);
    return models.map((e) => e.toDomain()).toList();
  }
}
