import '../../core/api/models/institution_model.dart';
import '../../data/models/inst_model.dart';

abstract class InstRepository {
  Future<List<InstModel>> fetchInstList({String? keyword});
  Future<List<InstitutionModel>> getInstitutions({String? keyword});
}
