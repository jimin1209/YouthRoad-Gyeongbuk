import 'package:flutter/foundation.dart';

import '../../core/api/models/institution_model.dart';
import '../models/inst_model.dart';
import '../sources/remote/institution_remote_source.dart';
import '../../domain/repositories/inst_repository.dart';

class InstRepositoryImpl implements InstRepository {
  InstRepositoryImpl(this._remoteSource);

  final InstitutionRemoteSource _remoteSource;

  @override
  Future<List<InstModel>> fetchInstList({String? keyword}) async {
    try {
      final institutions = await getInstitutions(keyword: keyword);
      return institutions
          .map(
            (inst) => InstModel(
              id: inst.id,
              name: inst.name,
              tel: null,
              addr: null,
            ),
          )
          .toList();
    } catch (e, st) {
      debugPrint('InstRepositoryImpl.fetchInstList error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  @override
  Future<List<InstitutionModel>> getInstitutions({String? keyword}) async {
    try {
      return await _remoteSource.fetchInstitutions(keyword: keyword);
    } catch (e, st) {
      debugPrint('InstRepositoryImpl.getInstitutions error: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
