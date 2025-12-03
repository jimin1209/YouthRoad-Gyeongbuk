import '../entities/institution.dart';

abstract class InstitutionRepository {
  Future<List<Institution>> fetchInstitutions({String? keyword});
}
