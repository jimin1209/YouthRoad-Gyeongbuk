import '../../data/models/inst_model.dart';

abstract class InstRepository {
  Future<List<InstModel>> fetchInstList({String? keyword});
}
